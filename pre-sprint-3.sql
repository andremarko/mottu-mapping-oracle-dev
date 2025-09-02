CREATE OR REPLACE FUNCTION convert_json(p_tabela IN VARCHAR2)
RETURN CLOB 
AS
       v_json_body CLOB;
       
       -- A FUNÇÃO PEGA O NOME DA TABELA E DINANICAMENTE RETORNA O NOME DAS COLUNAS
       -- COM O NOME DAS COLUNAS E POSSIVEL GUARDAR EM UMA RECORD O NOME DAS COLUNAS E ATRIBUIR OS SEUS RESPECTIVOS TIPOS
       -- OU É POSSIVEL COM UM CURSOR DAR FETCH
       --
       
       
       
        


BEGIN





CREATE FUNCTION convert_to_json(p_table_name IN VARCHAR2, p_pk_id IN NUMBER DEFAULT NULL, p_pk_col_name IN VARCHAR2 DEFAULT NULL)
RETURN CLOB
AS
            -- 1D OF THE SAME TYPE
    TYPE t_cols IS TABLE OF VARCHAR2(100);
    v_cols t_cols;
    v_json_body CLOB;
    v_sql VARCHAR2(100);
BEGIN

    SELECT column_name INTO v_cols FROM user_tab_columns WHERE table_name := UPPER(p_table_name) ORDER BY column_id;
      
    IF p_pk_id IS NOT NULL AND p_pk_col_name IS NOT NULL THEN
        FOR i in 1 .. v_cols.COUNT LOOP
            v_sql := 'SELECT ' || v_cols(i) || ' FROM ' || p_table_name WHERE UPPER(p_pk_ool_name) = p_pk_id
        END LOOP;
     ELSE
        FOR i in 1 .. v_cols.COUNT LOOP
            v_sql := 'SELECT ' || v_cols(i) || ', ' || ' FROM ' || p_table_name 
        END LOOP
    END IF;
    
    
    
    -- IMPLICIT CURSOR 
  
    
EXCEPTION


END;
    
    
-- FLUXO: NOME_TABELA -> SELECT 



select column_name from user_tab_columns where table_name = 'ESTADO';

