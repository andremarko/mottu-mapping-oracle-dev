CREATE OR REPLACE PACKAGE mottu_mapping_pkg AS
      
       -- FUNÇÃO QUE RETORNA TABELA EM FORMATO JSON    
       FUNCTION table_to_json (
           p_table_name IN VARCHAR2
       )
       RETURN CLOB;    


    -- FUNÇÃO QUE UTILIZA LIB JAVA BCRYPT PARA CRIPTOGRAFAR SENHA DIGITADA
    FUNCTION bcrypt_hash (
        p_password IN VARCHAR2
    ) RETURN VARCHAR2;

    -- FUNÇÃO QUE VERIFICA SENHA DIGITADA COM SENHA ARMAZENADA E RETORNA TRUE OU FALSE
    FUNCTION bcrypt_verify (
        p_password IN VARCHAR2,
        p_hash     IN VARCHAR2
    ) RETURN BOOLEAN;

    -- FUNÇÃO QUE VALIDA USUÁRIO E RETORNA TRUE OU FALSE
    FUNCTION validate_user (
        p_username IN VARCHAR2,
        p_password  IN VARCHAR2
    ) RETURN BOOLEAN;
    
    
    -- SOMA DE MOTOS POR YARD
    PROCEDURE sum_motorcycles_by_yard_sector;
    
    
    --PROCEDURE sum_fatos;
    
END mottu_mapping_pkg;
/


CREATE OR REPLACE PACKAGE BODY mottu_mapping_pkg AS

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
            
        WHEN JAVA_EXCEPTION THEN
            RAISE_APPLICATION_ERROR(-20011, SQLERRM);
        
        WHEN OTHERS THEN
            RETURN FALSE; 
    END validate_user;
    
    
    PROCEDURE sum_motorcycles_by_yard_sector
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
        -- Cabeçalho
        DBMS_OUTPUT.PUT_LINE('YARD_ID SECTOR_ID QTY');
        DBMS_OUTPUT.PUT_LINE('------- -------- ---');
    
        FOR r IN c_motos LOOP
            -- Mudou de yard
            IF v_prev_yard IS NOT NULL AND r.yard_id <> v_prev_yard THEN
                -- Imprime último setor da yard anterior
                IF v_prev_sector IS NOT NULL THEN
                    DBMS_OUTPUT.PUT_LINE(
                        RPAD(v_prev_yard,7) || ' ' ||
                        RPAD(v_prev_sector,8) || ' ' ||
                        v_qty
                    );
                    v_subtotal := v_subtotal + v_qty;
                    v_qty := 0;
                END IF;
    
                -- Imprime subtotal da yard anterior
                DBMS_OUTPUT.PUT_LINE(
                    RPAD('Sub Total',9) || ' ' ||
                    RPAD(' ', 6) || ' ' ||
                    v_subtotal
                );
                v_total := v_total + v_subtotal;
                v_subtotal := 0;
                v_prev_sector := NULL;
            END IF;
    
            -- Mudou de setor
            IF v_prev_sector IS NOT NULL AND r.sector_id <> v_prev_sector THEN
                DBMS_OUTPUT.PUT_LINE(
                    RPAD(v_prev_yard,7) || ' ' ||
                    RPAD(v_prev_sector,8) || ' ' ||
                    v_qty
                );
                v_subtotal := v_subtotal + v_qty;
                v_qty := 0;
            END IF;
    
            -- Contagem manual do setor
            v_qty := v_qty + 1;
    
            v_prev_yard := r.yard_id;
            v_prev_sector := r.sector_id;
        END LOOP;
    
        -- Imprime último setor da última yard
        IF v_prev_sector IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE(
                RPAD(v_prev_yard,7) || ' ' ||
                RPAD(v_prev_sector,8) || ' ' ||
                v_qty
            );
            v_subtotal := v_subtotal + v_qty;
        END IF;
    
        -- Imprime subtotal da última yard
        IF v_prev_yard IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE(
                RPAD('Sub Total',9) || ' ' ||
                RPAD(' ', 6) || ' ' ||
                v_subtotal
            );
            v_total := v_total + v_subtotal;
        END IF;
    
        -- Imprime total geral
        DBMS_OUTPUT.PUT_LINE(
            RPAD('Total Geral', 12) || ' ' ||
            RPAD(' ', 2) || ' ' ||
            v_total
        );
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No motorcycles found.');
        WHEN VALUE_ERROR THEN
            DBMS_OUTPUT.PUT_LINE('Invalid value encountered.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Unknown error: ' || SQLERRM);
    
    END sum_motorcycles_by_yard_sector;
END mottu_mapping_pkg;
/




select * from tb_auditoria;

CREATE TABLE TB_AUDITORIA ( 
    audit_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY, 
    table_name VARCHAR2(50) NOT NULL, 
    operation_type VARCHAR2(10) NOT NULL, 
    username VARCHAR2(50) DEFAULT USER, 
    operation_date TIMESTAMP DEFAULT SYSTIMESTAMP, 
    old_values CLOB, 
    new_values CLOB 
);



CREATE OR REPLACE TRIGGER afi_auditoria_tb_motorcycle
AFTER INSERT OR UPDATE OR DELETE ON tb_motorcycle
FOR EACH ROW
DECLARE
    v_old CLOB;
    v_new CLOB;
    v_op_type VARCHAR2(10);
BEGIN
    -- Determina o tipo de operação
    IF INSERTING THEN
        v_op_type := 'INSERT';
    ELSIF UPDATING THEN
        v_op_type := 'UPDATE';
    ELSIF DELETING THEN
        v_op_type := 'DELETE';
    END IF;

    -- Monta string com valores antigos
    IF DELETING OR UPDATING THEN
        v_old := 'motorcycle_id: ' || :OLD.motorcycle_id ||
                 ', plate: ' || :OLD.plate ||
                 ', coordinates: ' || :OLD.coordinates ||
                 ', model_id: ' || :OLD.model_id ||
                 ', sector_id: ' || :OLD.sector_id;
    END IF;

    -- Monta string com valores novos
    IF INSERTING OR UPDATING THEN
        v_new := 'motorcycle_id: ' || :NEW.motorcycle_id ||
                 ', plate: ' || :NEW.plate ||
                 ', coordinates: ' || :NEW.coordinates ||
                 ', model_id: ' || :NEW.model_id ||
                 ', sector_id: ' || :NEW.sector_id;
    END IF;

    -- Insere na tabela de auditoria
    INSERT INTO TB_AUDITORIA (
        table_name,
        operation_type,
        username,
        operation_date,
        old_values,
        new_values
    ) VALUES (
        'TB_MOTORCYCLE',
        v_op_type,
        USER,
        SYSTIMESTAMP,
        v_old,
        v_new
    );

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro na auditoria: ' || SQLERRM);
END;
/















set serveroutput on;
BEGIN
    mottu_mapping_pkg.sum_motorcycles_by_yard_sector;
END;
/



SET SERVEROUTPUT ON;
DECLARE
    v_result BOOLEAN;
BEGIN
    v_result := mottu_mapping_pkg.validate_user('admin', 'admin123');
    IF v_result THEN
        DBMS_OUTPUT.PUT_LINE('Senha correta!');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Senha incorreta ou usuário não encontrado!');
    END IF;
END;




BEGIN
    FOR r IN (SELECT user_id, username, pass_hash FROM tb_user) LOOP
        UPDATE tb_user
           SET pass_hash = mottu_mapping_pkg.bcrypt_hash('admin123')
         WHERE user_id = r.user_id;
    END LOOP;

    COMMIT;
END;
/


select * from tb_user;

INSERT INTO tb_user (username, pass_hash, role) VALUES ('admin', '$2b$12$D2Y5FFudE/vyv.3sti56puJH/5sOgApmmuUnxTki2A8Si.o7jsohu', 'ROLE_ADMIN');

-- senha: oper123
INSERT INTO tb_user (username, pass_hash, role) VALUES ('operator', '$2b$12$uNSi53Foe.BXvb2r3mR1..Mc.cZ8ip5SIAuyZin028qAFR5FGQrQ6', 'ROLE_OPERATOR');

commit;

-- UTILITÁRIO JAVA
CREATE OR REPLACE AND RESOLVE JAVA SOURCE NAMED "BCryptUtil" AS
-- IMPORTA .JAR CARREGADO NO SCHEMA
-- 12 SALTOS, RETORNA SENHA EM HASH
-- VERIFICA SENHA PASSADA COMO PARAMETRO E O HASH (SENHA) ARMAZENADO NO BANCO
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





CREATE OR REPLACE FUNCTION rel_to_json(p_table_name IN VARCHAR2)
RETURN CLOB
IS
    v_json      CLOB := '[';
    v_first_row BOOLEAN := TRUE;

    v_cursor    INTEGER;
    v_col_cnt   INTEGER;
    v_desc_t    DBMS_SQL.DESC_TAB;
    v_col_val   VARCHAR2(4000);
    v_status    INTEGER;
BEGIN
    v_cursor := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(v_cursor, 'SELECT * FROM ' || p_table_name, DBMS_SQL.NATIVE);

    DBMS_SQL.DESCRIBE_COLUMNS(v_cursor, v_col_cnt, v_desc_t);

    FOR i IN 1..v_col_cnt LOOP
        DBMS_SQL.DEFINE_COLUMN(v_cursor, i, v_col_val, 4000);
    END LOOP;

    v_status := DBMS_SQL.EXECUTE(v_cursor);

    LOOP
        EXIT WHEN DBMS_SQL.FETCH_ROWS(v_cursor) = 0;

        IF NOT v_first_row THEN
            v_json := v_json || ',';
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

    DBMS_SQL.CLOSE_CURSOR(v_cursor);

    v_json := v_json || ']';

    RETURN v_json;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '[]';
    WHEN TOO_MANY_ROWS THEN
        RETURN '{"error":"Mais de uma linha encontrada onde não era esperado"}';
    WHEN OTHERS THEN
        IF DBMS_SQL.IS_OPEN(v_cursor) THEN
            DBMS_SQL.CLOSE_CURSOR(v_cursor);
        END IF;
        RETURN '{"error":"Erro desconhecido: ' || SQLERRM || '"}';
END rel_to_json;
/


SET SERVEROUTPUT ON;

DECLARE
    v_json CLOB;
BEGIN
    v_json := rel_to_json('TB_MOTORCYCLE');
    DBMS_OUTPUT.PUT_LINE(v_json);
END;








