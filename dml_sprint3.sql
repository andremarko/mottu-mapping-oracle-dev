SELECT * FROM TB_SECTORS;
SELECT * FROM TB_MOTO_YARDS;
SELECT * FROM TB_MOTORCYCLE;
SELECT * FROM TB_MODEL;

drop table tb_moto_yard;
drop table tb_sector;
drop table tb_motorcycle;
drop table tb_model;


INSERT INTO tb_model (model_name) VALUES ('Mottu Pop');
INSERT INTO tb_model (model_name) VALUES ('Mottu Sport');
INSERT INTO tb_model (model_name) VALUES ('Mottu-E');

INSERT INTO TB_MOTO_YARD (branch_name, address, city, state, capacity)
VALUES ('Unidade São Paulo', 'Av. Paulista, 1000', 'São Paulo', 'SP', 150);

INSERT INTO TB_MOTO_YARD (branch_name, address, city, state, capacity)
VALUES ('Unidade Rio de Janeiro', 'Av. Atlântica, 2000', 'Rio de Janeiro', 'RJ', 120);

INSERT INTO TB_MOTO_YARD (branch_name, address, city, state, capacity)
VALUES ('Unidade Belo Horizonte', 'Av. Afonso Pena, 3000', 'Belo Horizonte', 'MG', 100);

INSERT INTO TB_MOTO_YARD (branch_name, address, city, state, capacity)
VALUES ('Unidade Curitiba', 'Rua XV de Novembro, 400', 'Curitiba', 'PR', 80);

INSERT INTO TB_MOTO_YARD (branch_name, address, city, state, capacity)
VALUES ('Unidade Porto Alegre', 'Av. Borges de Medeiros, 500', 'Porto Alegre', 'RS', 90);


DECLARE
    v_yard_id NUMBER := 1;
BEGIN
    FOR v_yard_id IN 1..4 LOOP
        INSERT INTO TB_SECTOR (yard_id, name, description, color_rgb, color_name)
        VALUES (v_yard_id, 'Manutenção', 'Motos em manutenção preventiva', '#FFFF00', 'Amarelo');

        INSERT INTO TB_SECTOR (yard_id, name, description, color_rgb, color_name)
        VALUES (v_yard_id, 'Chegada', 'Motos recém-chegadas aguardando conferência', '#00FF00', 'Green');

        INSERT INTO TB_SECTOR (yard_id, name, description, color_rgb, color_name)
        VALUES (v_yard_id, 'Estoque', 'Motos armazenadas, aguardando expedição', '#0000FF', 'Blue');

        INSERT INTO TB_SECTOR (yard_id, name, description, color_rgb, color_name)
        VALUES (v_yard_id, 'Expedição', 'Motos prontas para retirada', '#FF00FF', 'Magenta');
    END LOOP;
END;
/

INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO001', '10.101,-20.101', 1, 5);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO002', '10.102,-20.105', 2, 12);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO003', '10.103,-20.108', 3, 1);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO004', '10.104,-20.112', 2, 8);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO005', '10.105,-20.115', 1, 14);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO006', '10.106,-20.118', 3, 2);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO007', '10.107,-20.120', 1, 11);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO008', '10.108,-20.123', 2, 6);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO009', '10.109,-20.126', 3, 3);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO010', '10.110,-20.129', 1, 9);

INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO011', '10.111,-20.132', 2, 16);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO012', '10.112,-20.135', 3, 7);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO013', '10.113,-20.138', 1, 4);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO014', '10.114,-20.141', 2, 13);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO015', '10.115,-20.144', 3, 10);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO016', '10.116,-20.147', 1, 15);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO017', '10.117,-20.150', 2, 1);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO018', '10.118,-20.153', 3, 5);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO019', '10.119,-20.156', 1, 8);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO020', '10.120,-20.159', 2, 12);

INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO021', '10.121,-20.162', 3, 6);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO022', '10.122,-20.165', 1, 14);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO023', '10.123,-20.168', 2, 3);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO024', '10.124,-20.171', 3, 11);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO025', '10.125,-20.174', 1, 2);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO026', '10.126,-20.177', 2, 7);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO027', '10.127,-20.180', 3, 9);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO028', '10.128,-20.183', 1, 13);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO029', '10.129,-20.186', 2, 16);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO030', '10.130,-20.189', 3, 4);

INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO031', '10.131,-20.192', 1, 15);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO032', '10.132,-20.195', 2, 10);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO033', '10.133,-20.198', 3, 5);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO034', '10.134,-20.201', 1, 12);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO035', '10.135,-20.204', 2, 6);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO036', '10.136,-20.207', 3, 1);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO037', '10.137,-20.210', 1, 9);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO038', '10.138,-20.213', 2, 14);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO039', '10.139,-20.216', 3, 8);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO040', '10.140,-20.219', 1, 7);

INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MOTO041', '10.140,-20.220', 1, 7);
UPDATE TB_MOTORCYCLE
SET coordinates = '10.150,-20.230',
    sector_id   = 8
WHERE plate = 'MOTO041';

DELETE FROM TB_MOTORCYCLE
WHERE plate = 'MOTO041';



select * from tb_sector;
SELECT * FROM tb_moto_yard;
select * from tb_motorcycle;