CREATE TABLE tb_vagas (
    cd_vaga            NUMBER NOT NULL,
    cd_estacionamento  NUMBER NOT NULL,
    ds_localizacao     VARCHAR2(10) NOT NULL,
    ds_andar           VARCHAR2(10) NOT NULL,
    ds_disponivel      CHAR(1) NOT NULL
);

ALTER TABLE tb_vagas ADD CONSTRAINT tb_vagas_pk PRIMARY KEY ( cd_vaga );

CREATE SEQUENCE SQ_TB_VAGAS
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;
 
 INSERT INTO tb_vagas(cd_vaga, cd_estacionamento, ds_localizacao, ds_andar, ds_disponivel ) 
VALUES (SQ_TB_VAGAS.nextval,1, 'A01', 'T', '0'); -- Não está disponível

INSERT INTO tb_vagas(cd_vaga, cd_estacionamento, ds_localizacao, ds_andar, ds_disponivel ) 
VALUES (SQ_TB_VAGAS.nextval,1, 'A02', 'T', '1'); -- Disponível

commit;


select * from tb_moto_yard;
select * from tb_sector;
select * from tb_model;
select * from tb_motorcycle;


SELECT * FROM tb_user;

drop table tb_moto_yard;
drop table tb_sector;
drop table tb_motorcycle;
drop table tb_model;
DROP TABLE TB_MOTORCYCLE CASCADE CONSTRAINTS PURGE;


INSERT INTO tb_model (model_name) VALUES ('Mottu Pop');
INSERT INTO tb_model (model_name) VALUES ('Mottu Sport');
INSERT INTO tb_model (model_name) VALUES ('Mottu-E');


INSERT INTO TB_MOTO_YARD (branch_name, address, city, state, capacity)
VALUES ('Unidade São Paulo', 'Av. Paulista, 1000', 'São Paulo', 'SP', 150);


INSERT INTO TB_SECTOR (yard_id, name, description, color_rgb, color_name)
VALUES (1, 'Manutenção', 'Motos em manutenção preventiva', '#FFFF00', 'Amarelo');

INSERT INTO TB_SECTOR (yard_id, name, description, color_rgb, color_name)
VALUES (1, 'Chegada', 'Motos recém-chegadas aguardando conferência', '#00FF00', 'Green');

INSERT INTO TB_SECTOR (yard_id, name, description, color_rgb, color_name)
VALUES (1, 'Estoque', 'Motos armazenadas, aguardando expedição', '#0000FF', 'Blue');

INSERT INTO TB_SECTOR (yard_id, name, description, color_rgb, color_name)
VALUES (1, 'Expedição', 'Motos prontas para retirada', '#FF00FF', 'Magenta');


INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MNT1001', '10.101,-20.101', 1, 1);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MNT1002', '10.102,-20.102', 2, 1);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MNT1003', '10.103,-20.103', 3, 1);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MNT1004', '10.104,-20.104', 1, 1);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MNT1005', '10.105,-20.105', 2, 1);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MNT1006', '10.106,-20.106', 3, 1);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MNT1007', '10.107,-20.107', 1, 1);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MNT1008', '10.108,-20.108', 2, 1);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MNT1009', '10.109,-20.109', 3, 1);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('MNT1010', '10.110,-20.110', 1, 1);

INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('CHG2001', '10.201,-20.201', 1, 2);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('CHG2002', '10.202,-20.202', 2, 2);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('CHG2003', '10.203,-20.203', 3, 2);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('CHG2004', '10.204,-20.204', 1, 2);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('CHG2005', '10.205,-20.205', 2, 2);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('CHG2006', '10.206,-20.206', 3, 2);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('CHG2007', '10.207,-20.207', 1, 2);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('CHG2008', '10.208,-20.208', 2, 2);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('CHG2009', '10.209,-20.209', 3, 2);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('CHG2010', '10.210,-20.210', 1, 2);

INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('EST3001', '10.301,-20.301', 1, 3);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('EST3002', '10.302,-20.302', 2, 3);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('EST3003', '10.303,-20.303', 3, 3);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('EST3004', '10.304,-20.304', 1, 3);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('EST3005', '10.305,-20.305', 2, 3);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('EST3006', '10.306,-20.306', 3, 3);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('EST3007', '10.307,-20.307', 1, 3);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('EST3008', '10.308,-20.308', 2, 3);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('EST3009', '10.309,-20.309', 3, 3);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('EST3010', '10.310,-20.310', 1, 3);

INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('EXP4001', '10.401,-20.401', 1, 4);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('EXP4002', '10.402,-20.402', 2, 4);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('EXP4003', '10.403,-20.403', 3, 4);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('EXP4004', '10.404,-20.404', 1, 4);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('EXP4005', '10.405,-20.405', 2, 4);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('EXP4006', '10.406,-20.406', 3, 4);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('EXP4007', '10.407,-20.407', 1, 4);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('EXP4008', '10.408,-20.408', 2, 4);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('EXP4009', '10.409,-20.409', 3, 4);
INSERT INTO TB_MOTORCYCLE (plate, coordinates, model_id, sector_id) VALUES ('EXP4010', '10.410,-20.410', 1, 4);


select * from tb_motorcycle;

select * from tb_moto_yard;

