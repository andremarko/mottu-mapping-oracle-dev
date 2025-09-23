-- TESTES --

SET SERVEROUTPUT ON;

-- CENÁRIO 1
-- PROCEDURE 1 JOIN TO JSON 
DECLARE
    v_result CLOB;
BEGIN
    -- chama o procedimento que gera JSON do JOIN
    mottu_mapping_pkg.proc_join_json(v_result);
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/

-- CENÁRIO 2
-- PROCEDURE 2 SOMA -> QUANTIDADE DE MOTOS POR SETORES DE UM PÁTIO.
BEGIN
    mottu_mapping_pkg.proc_sum_motorcycles_by_yard_sector;
END;
/

-- CENÁRIO 3
-- FUNÇÃO DE VALIDAÇÃO DE USUÁRIO UTILIZANDO BIBLIOTECA JAVA (Bcrypt) - WRAPPER EM PL/SQL
DECLARE
    v_result BOOLEAN;
BEGIN
                                                -- USUÁRIO JÁ CADASTRADO
    v_result := mottu_mapping_pkg.validate_user('operator', 'oper123');
    IF v_result THEN
        DBMS_OUTPUT.PUT_LINE('SENHA CORRETA');
    ELSE
        DBMS_OUTPUT.PUT_LINE('SENHA INCORRETA OU USUÁRIO NÃO CADASTRADO');
    END IF;
    
END;

-- CENÁRIO 4
-- CADASTRANDO USUÁRIO COM SENHA CRIPTOGRAFADA - UTILIZANDO WRAPPER JAVA

INSERT INTO tb_user (username, pass_hash, role) VALUES ('admin2', mottu_mapping_pkg.bcrypt_hash('senha123'), 'ROLE_ADMIN');

SELECT * FROM tb_user WHERE username = 'admin2';


-- CENÁRIO 5
-- CHECANDO AUDITORIA CRIADA NO DDL_MOTTU_MAPPING.SQL

-- CHECAGEM DE INSERÇÃO DE AUDITORIA
SELECT * FROM tb_auditoria;

-- VERIFIQUE ANTES E DEPOIS DE ATUALIZAR A MOTO
SELECT * FROM tb_motorcycle;
SELECT * FROM tb_motorcycle WHERE motorcycle_id = 41;

--

INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO041', '10.141,-20.222', 2, 6);

UPDATE tb_motorcycle SET plate = 'MOTO042' WHERE motorcycle_id = 41;

DELETE FROM tb_motorcycle WHERE motorcycle_id = 41; 

--