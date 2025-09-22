
-- A FUNÇÃO PEGA O NOME DA TABELA E DINANICAMENTE RETORNA O NOME DAS COLUNAS
-- COM O NOME DAS COLUNAS E POSSIVEL GUARDAR EM UMA RECORD O NOME DAS COLUNAS E ATRIBUIR OS SEUS RESPECTIVOS TIPOS
-- OU É POSSIVEL COM UM CURSOR DAR FETCH
--
       


CREATE OR REPLACE FUNCTION convert_to_json(
    p_table_name IN VARCHAR2,
    p_pk_col_name IN VARCHAR2 DEFAULT NULL,
    p_pk_val IN VARCHAR2 DEFAULT NULL
) RETURN CLOB
AS
    v_json      CLOB := '[';
    v_sql       VARCHAR2(4000);
    c           INTEGER;
    col_cnt     INTEGER;
    desc_t      DBMS_SQL.DESC_TAB;
    val         VARCHAR2(4000);
    first_row   BOOLEAN := TRUE;
BEGIN
    -- Monta SQL dinâmico
    v_sql := 'SELECT * FROM ' || p_table_name;
    IF p_pk_col_name IS NOT NULL AND p_pk_val IS NOT NULL THEN
        v_sql := v_sql || ' WHERE ' || p_pk_col_name || ' = ''' || p_pk_val || '''';
    END IF;

    -- Abre cursor dinâmico
    c := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(c, v_sql, DBMS_SQL.NATIVE);

    -- Descobre colunas
    DBMS_SQL.DESCRIBE_COLUMNS(c, col_cnt, desc_t);
    FOR i IN 1..col_cnt LOOP
        DBMS_SQL.DEFINE_COLUMN(c, i, val, 4000);
    END LOOP;

    -- Executa e percorre linhas
    DBMS_SQL.EXECUTE(c);
    WHILE DBMS_SQL.FETCH_ROWS(c) > 0 LOOP
        IF NOT first_row THEN v_json := v_json || ','; ELSE first_row := FALSE; END IF;
        v_json := v_json || '{';
        FOR i IN 1..col_cnt LOOP
            IF i > 1 THEN v_json := v_json || ','; END IF;
            DBMS_SQL.COLUMN_VALUE(c,i,val);
            v_json := v_json || '"' || desc_t(i).col_name || '":"' || NVL(val,'') || '"';
        END LOOP;
        v_json := v_json || '}';
    END LOOP;

    DBMS_SQL.CLOSE_CURSOR(c);
    RETURN v_json || ']';

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        IF DBMS_SQL.IS_OPEN(c) THEN DBMS_SQL.CLOSE_CURSOR(c); END IF;
        RETURN '{"erro":"Nenhum dado encontrado"}';
    WHEN INVALID_CURSOR THEN
        RETURN '{"erro":"Cursor inválido"}';
    WHEN OTHERS THEN
        IF DBMS_SQL.IS_OPEN(c) THEN DBMS_SQL.CLOSE_CURSOR(c); END IF;
        RETURN '{"erro":"Erro genérico: ' || SQLERRM || '"}';
END;
/

--

CREATE OR REPLACE FUNCTION convert_table_to_json_simple(
    p_table_name IN VARCHAR2
) RETURN CLOB
AS
    v_json  CLOB := '[';
    v_sql   VARCHAR2(4000);
BEGIN
    -- Monta SQL dinâmico que transforma cada coluna em chave:valor
    SELECT 'SELECT ''{'' || ' ||
           LISTAGG(''''' || column_name || '''' || ' : '' || TO_CHAR(' || column_name || ')', ' || '','' || ') 
           WITHIN GROUP (ORDER BY column_id) || ''}'' FROM ' || p_table_name
    INTO v_sql
    FROM user_tab_columns
    WHERE table_name = UPPER(p_table_name);

    -- Executa SQL dinâmico e concatena em JSON
    FOR r IN (EXECUTE IMMEDIATE v_sql) LOOP
        IF v_json <> '[' THEN
            v_json := v_json || ',';
        END IF;
        v_json := v_json || r.col;  -- r.col é cada linha transformada em JSON
    END LOOP;

    RETURN v_json || ']';
EXCEPTION
    WHEN OTHERS THEN
        RETURN '{"erro":"' || SQLERRM || '"}';
END;
/





    

