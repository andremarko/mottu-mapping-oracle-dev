/* 
=====================
Mottu Mapping - Package and Java Source
ANDRE GERALDI MARCOLONGO, RM555285 - 2TDSPV
FELIPE GABRIEL LOPES CLARINDO, RM554547 - 2TDSP

---

1 - ANTES DE RODAR AS FUNÇÕES E PROCEDURES DESSA PACKAGE, CERTIFIQUE-SE DE QUE AS REFERIDAS TABELAS ESTEJAM CRIADAS E POPULADAS NO SCHEMA;
    - PARA TAL, RODE DDL_MOTTU_MAPPING.SQL E DML_MOTTU_MAPPING.SQL;

2 - TAMBÉM, IMPORTE A REFERIDA BIBLIOTECA JAVA jbcrypt-0.4.jar PARA O SEU SCHEMA EXECUTANDO:

    loadjava -u <username>@<host>:<port>/<service> -p -v -r -f jbcrypt-0.4.jar

3 - COM A BIBLIOTECA IMPORTADA, PRIMEIRAMENTE CRIE A CLASSE UTILITÁRIA QUE IMPLEMENTA AS FUNÇÕES DE HASH E VERIFICAÇÃO DE SENHA;

4 - APÓS ISSO, CRIE A PACKAGE SPECIFICATION E O PACKAGE BODY;

5 - POR ÚLTIMO, CRIE O TRIGGER DE AUDITORIA. CERTIFIQUE-SE QUE NO SCRIPT DDL VOCÊ TENHA CRIADO A TABELA DE AUDITORIA.
=====================
*/


-- UTILITÁRIO JAVA

CREATE OR REPLACE AND RESOLVE JAVA SOURCE NAMED "BCryptUtil" AS
-- APÓS CARREGAR .JAR NO SCHEMA ATUAL, CRIE O UTILITÁRIO JAVA COM OS SEGUINTES MÉTODOS
-- hashPassword RETORNA SENHA EM HASH
-- verifyPassword VERIFICA SENHA PASSADA COMO PARAMETRO E O HASH (SENHA) ARMAZENADO NO BANCO
import org.mindrot.jbcrypt.BCrypt;

public class BCryptUtil {
    
    public static String hashPassword(String plain) throws IllegalArgumentException {
        if (plain == null || plain.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }
        return BCrypt.hashpw(plain, BCrypt.gensalt(12));
    }

    public static boolean verifyPassword(String password, String hash) {
        if (password == null || hash == null) {
            throw new IllegalArgumentException("Invalid password or hash");
        } 
        return BCrypt.checkpw(password, hash);
    }
};
/


-- PACKAGE mottu_mapping_pkg --
-- SPECIFICATION 
CREATE OR REPLACE PACKAGE mottu_mapping_pkg AS
      
    -- FUNÇÃO QUE RETORNA TABELA EM FORMATO JSON    
    FUNCTION query_to_json(p_query IN VARCHAR2) RETURN CLOB;    

    -- WRAPPERS PL/SQL PARA MÉTODOS JAVA
    FUNCTION bcrypt_hash(p_password IN VARCHAR2) RETURN VARCHAR2;
    FUNCTION bcrypt_verify(p_password IN VARCHAR2, p_hash IN VARCHAR2) RETURN BOOLEAN;

    -- FUNÇÃO QUE VALIDA USUÁRIO E RETORNA TRUE OU FALSE
    FUNCTION validate_user(p_username IN VARCHAR2, p_password IN VARCHAR2) RETURN BOOLEAN;
    
    -- RETORNA JOIN ENTRE TB_MOTORCYCLE, TB_MOTO_YARD E TB_SECTOR
    PROCEDURE proc_join_json(p_result OUT CLOB);
    
    -- SOMA DE MOTOS POR YARD
    PROCEDURE proc_sum_motorcycles_by_yard_sector;
     
END mottu_mapping_pkg;
/

-- BODY
CREATE OR REPLACE PACKAGE BODY mottu_mapping_pkg AS

    -- EXCEPTION
    JAVA_EXCEPTION EXCEPTION;
    PRAGMA EXCEPTION_INIT(JAVA_EXCEPTION, -6502);

    -- TRANSFORMA TABLE PARA JSON
    FUNCTION query_to_json(p_query IN VARCHAR2) 
        RETURN CLOB IS
        v_json      CLOB := '[';
        v_first_row BOOLEAN := TRUE;
    
        v_cursor    INTEGER;
        v_col_cnt   INTEGER;
        v_desc_t    DBMS_SQL.DESC_TAB;
        v_col_val   VARCHAR2(4000);
        v_status    INTEGER;
    BEGIN
        -- ABRE CURSOOR DINÂMICO
        v_cursor := DBMS_SQL.OPEN_CURSOR;
        DBMS_SQL.PARSE(v_cursor, p_query, DBMS_SQL.NATIVE);
    
        -- DESCRIBE COLUNAS
        DBMS_SQL.DESCRIBE_COLUMNS(v_cursor, v_col_cnt, v_desc_t);
        FOR i IN 1..v_col_cnt LOOP
            DBMS_SQL.DEFINE_COLUMN(v_cursor, i, v_col_val, 4000);
        END LOOP;
    
        -- EXECUTA QUERY
        v_status := DBMS_SQL.EXECUTE(v_cursor);
    
        -- Lê TODAS AS LINHAS
        LOOP
            EXIT WHEN DBMS_SQL.FETCH_ROWS(v_cursor) = 0;
    
            IF NOT v_first_row THEN
                v_json := v_json || ','; -- SEPARADOR
            ELSE
                v_first_row := FALSE;
            END IF;
    
            v_json := v_json || '{';
            FOR i IN 1..v_col_cnt LOOP
                DBMS_SQL.COLUMN_VALUE(v_cursor, i, v_col_val);
                v_json := v_json || '"' || v_desc_t(i).col_name || '":"' || NVL(v_col_val,'NULL') || '"';
                IF i < v_col_cnt THEN
                    v_json := v_json || ',';
                END IF;
            END LOOP;
            v_json := v_json || '}';
        END LOOP;
    
        -- FECHA O CURSOR
        DBMS_SQL.CLOSE_CURSOR(v_cursor);
    
        -- FECHAR O ARRAY
        v_json := v_json || ']';
        RETURN v_json;
    
    EXCEPTION
        WHEN INVALID_CURSOR THEN
            IF DBMS_SQL.IS_OPEN(v_cursor) THEN
                DBMS_SQL.CLOSE_CURSOR(v_cursor);
            END IF;
            RETURN '{"error":"INVALID CURSOR"}';
        WHEN VALUE_ERROR THEN
            IF DBMS_SQL.IS_OPEN(v_cursor) THEN
                DBMS_SQL.CLOSE_CURSOR(v_cursor);
            END IF;
            RETURN '{"error":"VALUE ERROR"}';
        WHEN OTHERS THEN
            IF DBMS_SQL.IS_OPEN(v_cursor) THEN
                DBMS_SQL.CLOSE_CURSOR(v_cursor);
            END IF;
            RETURN '{"error":"UNKNOWN ERROR: ' || SQLERRM || '"}';
    END query_to_json;


    -- WRAPPERS PL/SQL PARA MÉTODOS JAVA
    -- UTILIZA LIB BCRYPT PARA TRANSFORMAR SENHA DIGITADA EM BCRYPT
    FUNCTION bcrypt_hash (p_password IN VARCHAR2)
        -- RETORNA STRING. ESSA FUNÇÃO GERA UM HASH DA SENHA PASSADA COMO PARAM
        RETURN VARCHAR2 
        AS LANGUAGE JAVA 
        NAME 'BCryptUtil.hashPassword(java.lang.String) return java.lang.String';


    -- FUNÇÃO QUE VERIFICA HASHES
    FUNCTION bcrypt_verify (p_password IN VARCHAR2, p_hash IN VARCHAR2)
        -- RETORNA BOOL - TRUE OU FALSE
        RETURN BOOLEAN
        AS LANGUAGE JAVA
        NAME 'BCryptUtil.verifyPassword(java.lang.String, java.lang.String) return boolean';


    -- FUNÇÃO VALIDADORA -> VALIDA USUÁRIO. RECEBE NOME E SENHA DO USUÁRIO
    FUNCTION validate_user(p_username IN VARCHAR2, p_password IN VARCHAR2)
        RETURN BOOLEAN IS
        v_stored_hash VARCHAR2(200);  -- HASH ARMAZENADO NA TABELA TB_USER -> COL PASS_HASH
    BEGIN
        -- SELECIONA E SALVA NA VARIAVEL A HASH DO USUARIO DIGITADO
        SELECT pass_hash
        INTO v_stored_hash
        FROM tb_user
        WHERE username = p_username;

        -- VALIDA SENHA 
        RETURN bcrypt_verify(p_password, v_stored_hash);

    -- LANÇA EXCEÇÃO QUANDO NÃO HÁ DADOS INPUTADOS ENCONTRADOS
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN FALSE; 
        -- EXCEÇÃO DO JAVA
        WHEN JAVA_EXCEPTION THEN
            RAISE_APPLICATION_ERROR(-20011, SQLERRM);
        -- OUTRAS
        WHEN OTHERS THEN
            RETURN FALSE; 
    END validate_user;


    PROCEDURE proc_join_json(p_result OUT CLOB) AS
    BEGIN
        -- JOIN 
        p_result := query_to_json(
        'SELECT m.motorcycle_id, m.plate, m.coordinates, ' ||
        's.name AS sector_name, s.color_name, s.description AS sector_description, ' ||
        'y.branch_name, y.address, y.city, y.state ' ||
        'FROM tb_motorcycle m ' ||
        'JOIN tb_sector s ON m.sector_id = s.sector_id ' ||
        'JOIN tb_moto_yard y ON s.yard_id = y.yard_id ' ||
        'ORDER BY y.yard_id, s.sector_id, m.motorcycle_id'
    );

    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_result := '{"error":"NO DATA FOUND IN JOIN RESULT"}';
        WHEN INVALID_CURSOR THEN
            p_result := '{"error":"INVALID CURSOR"}';
        WHEN OTHERS THEN
            p_result := '{"error":"UNKNOWN ERROR: ' || SQLERRM || '"}';
    END proc_join_json;


    PROCEDURE proc_sum_motorcycles_by_yard_sector
    AS
        CURSOR c_motos IS
            SELECT s.yard_id,
                   m.sector_id,
                   m.motorcycle_id
            FROM tb_motorcycle m
            JOIN tb_sector s ON m.sector_id = s.sector_id
            ORDER BY s.yard_id, m.sector_id;

        v_prev_yard   tb_sector.yard_id%TYPE := NULL;
        v_prev_sector tb_motorcycle.sector_id%TYPE := NULL;
        v_qty         NUMBER := 0;
        v_subtotal    NUMBER := 0;
        v_total       NUMBER := 0;
    BEGIN
        -- CABEÇALHO
        DBMS_OUTPUT.PUT_LINE('YARD_ID SECTOR_ID QTY');
        DBMS_OUTPUT.PUT_LINE('------- -------- ---');

        -- CURSOR
        FOR r IN c_motos LOOP
            -- MUDOU DE YARD
            IF v_prev_yard IS NOT NULL AND r.yard_id <> v_prev_yard THEN
                -- IMPRIME ULTIMO SETOR DO PÁTIO ANTERIOR
                IF v_prev_sector IS NOT NULL THEN
                    DBMS_OUTPUT.PUT_LINE(
                        RPAD(v_prev_yard,7) || ' ' ||
                        RPAD(v_prev_sector,8) || ' ' ||
                        v_qty
                    );
                    v_subtotal := v_subtotal + v_qty;
                    v_qty := 0;
                END IF;

                -- SUBTOTAL DO YARD ANTERIOR
                DBMS_OUTPUT.PUT_LINE(
                    RPAD('Sub Total',9) || ' ' ||
                    RPAD(' ', 6) || ' ' ||
                    v_subtotal
                );
                v_total := v_total + v_subtotal;
                v_subtotal := 0;
                v_prev_sector := NULL;
            END IF;

            -- MUDOU DE SETOR
            IF v_prev_sector IS NOT NULL AND r.sector_id <> v_prev_sector THEN
                DBMS_OUTPUT.PUT_LINE(
                    RPAD(v_prev_yard,7) || ' ' ||
                    RPAD(v_prev_sector,8) || ' ' ||
                    v_qty
                );
                v_subtotal := v_subtotal + v_qty;
                v_qty := 0;
            END IF;

            -- CONTAGEM MANUAL DO SETOR
            v_qty := v_qty + 1;

            v_prev_yard := r.yard_id;
            v_prev_sector := r.sector_id;
        END LOOP;

        -- IMPRIME ULTIMO SETOR DO ULTIMO PATIO
        IF v_prev_sector IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE(
                RPAD(v_prev_yard,7) || ' ' ||
                RPAD(v_prev_sector,8) || ' ' ||
                v_qty
            );
            v_subtotal := v_subtotal + v_qty;
        END IF;

        -- IMPRIME SUBTOTAL DO ULTIMO PATIO
        IF v_prev_yard IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE(
                RPAD('Sub Total',9) || ' ' ||
                RPAD(' ', 6) || ' ' ||
                v_subtotal
            );
            v_total := v_total + v_subtotal;
        END IF;

        -- TOTAL GERAL
        DBMS_OUTPUT.PUT_LINE(
            RPAD('Total Geral', 12) || ' ' ||
            RPAD(' ', 2) || ' ' ||
            v_total
        );

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('NO MOTORCYCLES FOUND.');
        WHEN VALUE_ERROR THEN
            DBMS_OUTPUT.PUT_LINE('INVALID VALUE ENCOUNTERED.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('UNKNOWN ERROR: ' || SQLERRM);

    END proc_sum_motorcycles_by_yard_sector;

END mottu_mapping_pkg;
/

-- END PACKAGE --












