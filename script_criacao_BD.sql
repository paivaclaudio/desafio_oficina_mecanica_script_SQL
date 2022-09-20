-- -----------------------------------------------------
-- Script para criar Banco de dados da oficina mecânica
-- Padrão da linguagme SQL para SQL-Server
-- -----------------------------------------------------

CREATE DATABASE oficina
GO
USE oficina


-- -----------------------------------------------------
-- Table cliente
-- -----------------------------------------------------
CREATE TABLE cliente (
  idcliente INT CONSTRAINT pkCli PRIMARY KEY identity(1,1),
  nome VARCHAR(80) NOT NULL,
  identificacao VARCHAR(50) NOT NULL,
  rua VARCHAR(50),
  nroResidencia varchar(10),
  complementoEndereco varchar(50),
  bairro VARCHAR(45),
  cep VARCHAR(15),
  cidade VARCHAR(45),
  UF CHAR(2),
  email VARCHAR(45),
  fone VARCHAR(20)
);


-- -----------------------------------------------------
-- Table veiculo
-- -----------------------------------------------------
CREATE TABLE veiculo (
  idveiculo INT CONSTRAINT pkVei PRIMARY KEY identity(1,1),
  modelo VARCHAR(45) NOT NULL,
  ano INT NOT NULL,
  placa VARCHAR(45) NOT NULL,
  km_atual INT,
  renavam VARCHAR(45)
);


-- -----------------------------------------------------
-- Table ordem_servico
-- -----------------------------------------------------
CREATE TABLE ordem_servico (
  idOs INT CONSTRAINT pkOs PRIMARY KEY identity(1,1),
  numero_os VARCHAR(10) NOT NULL,
  data_emissao DATETIME NOT NULL,
  data_autorizacao_cliente DATETIME,
  data_prevista_entrega DATETIME,
  data_conclusao DATETIME,
  valor FLOAT,
  statusOs VARCHAR(25),
  idveiculo INT CONSTRAINT fk_os_vei FOREIGN KEY REFERENCES veiculo (idveiculo) NOT NULL,
  idcliente INT CONSTRAINT fk_os_cli FOREIGN KEY REFERENCES cliente (idcliente) NOT NULL
);

-- altera a tabela para criação de constraint para valor padrao da data de emissão da OS:
alter table ordem_servico
  add CONSTRAINT dfDataEmi default(getdate()) for data_emissao

-- -----------------------------------------------------
-- Table peca
-- -----------------------------------------------------
CREATE TABLE peca (
  idpeca INT CONSTRAINT pkPec PRIMARY KEY identity(1,1),
  descricao VARCHAR(45) NOT NULL,
  preco_padrao FLOAT NOT NULL
);


-- -----------------------------------------------------
-- Table equipe
-- -----------------------------------------------------
CREATE TABLE equipe (
  idequipe INT CONSTRAINT pkEqu PRIMARY KEY identity(1,1),
  nome VARCHAR(45) NOT NULL
);


-- -----------------------------------------------------
-- Table funcionario
-- -----------------------------------------------------
CREATE TABLE funcionario (
  idfuncionario INT CONSTRAINT pkFun PRIMARY KEY identity(1,1),
  nome VARCHAR(45) NULL,
  rua VARCHAR(50),
  nroResidencia varchar(10),
  complementoEndereco varchar(50),
  bairro VARCHAR(45),
  cep VARCHAR(15),
  cidade VARCHAR(45),
  UF CHAR(2),
  especialidade VARCHAR(45) NULL,
  idequipe INT CONSTRAINT fk_fun_equi FOREIGN KEY REFERENCES equipe (idequipe) NOT NULL
);

-- -----------------------------------------------------
-- Table servico
-- -----------------------------------------------------
CREATE TABLE servico (
  idservico INT CONSTRAINT pkSer PRIMARY KEY identity(1,1),
  descricao_mao_de_obra VARCHAR(45) NOT NULL,
  preco_padrao FLOAT,
  horas_estimadas INT 
);


-- -----------------------------------------------------
-- Table avaliacao_excucao_OS
-- -----------------------------------------------------
CREATE TABLE avalia_exec_OS (
  idAvaExec INT CONSTRAINT pkAvaExec PRIMARY KEY identity(1,1),
  idOs INT CONSTRAINT fk_ava_exec_os FOREIGN KEY REFERENCES ordem_servico (idOs) NOT NULL,
  idEquipe INT CONSTRAINT fk_ava_exec_equi FOREIGN KEY REFERENCES equipe (idequipe) NOT NULL,
  dtAvaliacao DATETIME,
  dtInicioExec DATETIME,
  dtFimExec DATETIME,
  observacoes VARCHAR(100)
);


-- -----------------------------------------------------
-- Table necessidade_de_pecas
-- -----------------------------------------------------
CREATE TABLE necessidade_de_pecas (
  idNecPeca INT CONSTRAINT pkNPec PRIMARY KEY identity(1,1),
  idpeca INT CONSTRAINT fk_nec_pec FOREIGN KEY REFERENCES peca (idpeca) NOT NULL,
  idOs INT CONSTRAINT fk_nec_os FOREIGN KEY REFERENCES ordem_servico (idOs) NOT NULL,
  quantidade INT,
  valor_unitario FLOAT
);



-- -----------------------------------------------------
-- Table servicos_a_executar
-- -----------------------------------------------------
CREATE TABLE servicos_a_executar (
  idSerExec INT CONSTRAINT pkSerExe PRIMARY KEY identity(1,1),
  idOs INT CONSTRAINT fk_serv_exec FOREIGN KEY REFERENCES ordem_servico (idOs) NOT NULL,
  idservico INT CONSTRAINT fk_serv_exec_serv FOREIGN KEY REFERENCES servico (idservico) NOT NULL,
  quantidade INT,
  horas_efetivas INT,
  preco_efetivo FLOAT,
  observacoes VARCHAR(100)
);

-- -----------------------------------------------------
-- Inserção de dados para testes
-- -----------------------------------------------------

-- -----------------------------------------------------
-- CLIENTES:
-- -----------------------------------------------------

insert into cliente
values
  ('Ana Aparecida do Nascimento', 'ana.silva', 'Rua Voluntário Umburana', '1500', null, 'Pimenta', '14781-370', 'Barretos', 'SP', 'anasilva1507@gmail.com', '1422445226'),
  ('Pedro Henrique Malta', 'pedromalta', 'Rua Comandante Ferraz', '17', 'Fundos', 'Betânia', '69073-060', 'Manaus', 'AM', 'pedromalta@hotmail.com', '87562325412')

insert into cliente(nome, identificacao, rua, nroResidencia, cidade, UF, email)
values
  ('Marco Antônio José', 'marcojose', 'Praça das bandeiras', 's/n', 'Sobral', 'CE', 'marcomarco@gmail.com'),
  ('Séfora Dias Santos', 'seforasantos', 'Rua Francisco Caro Dias', '840', 'Caieiras', 'SP', 'seforasantos198@gmail.com'),
  ('Gabriel de Souza Louveira', 'gabriel.s.louveira', 'Rua Médio São Francisco', '1980', 'Guarulhos', 'SP', 'gabslouveira@gmail.com')


select * from cliente

-- -----------------------------------------------------
-- VEÍCULOS:
-- -----------------------------------------------------
insert into veiculo
values
  ('Ford EcoSport FREESTYLE', 2018, 'FKH-1980', 33000, '42585632'),
  ('Chevrolet Celta', 2012, 'BDA-5563', 137000, '86321452'),
  ('VolksWagen FOX', 2011, 'DDA-6688', 150000, '86532574'),
  ('Citroen C4 Pallas Exclusive', 2011, 'FZZ-2025', 113580, '75632000'),
  ('Fiat Palio 1.8', 2008, 'DRA-5580', 111000, '87563202'),
  ('Citroen C4 Cactus Feel', 2019, 'FBA-8873', 45600, '58963023'),
  ('VolksWagen Parati', 1999, 'ZZF-2030', 216000, '44755236')

select * from veiculo

-- -----------------------------------------------------
-- ORDENS DE SERVIÇO:
-- -----------------------------------------------------
insert into ordem_servico(numero_os, valor, statusOs, idveiculo, idcliente)
values
  ('130', 500, 'ABERTA', 5, 2)

insert into ordem_servico(numero_os, data_emissao, data_autorizacao_cliente, data_prevista_entrega, valor, statusOs, idveiculo, idcliente)
values
  ('130', '2021/11/15', '2021/11/17', '2021/12/20', 850, 'FINALIZADO', 7, 3),
  ('145', '2021/11/30', '2022/01/15', '2022/02/20', 3450, 'FINALIZADO', 5, 2),
  ('158', '2021/12/08', '2021/12/20', '2022/01/10', 1230, 'CANCELADO', 2, 5),
  ('202', '2021/12/13', '2021/12/13', '2021/12/27', 990, 'FINALIZADO', 1, 4)

insert into ordem_servico(numero_os, data_autorizacao_cliente, valor, statusOs, idveiculo, idcliente)
values
  ('235', '2022/01/07', 750, 'AGUARDANDO', 3, 1),
  ('240', null, 100, 'CANCELADO', 6, 5),
  ('257', '2022/02/23', 1300, 'FINALIZADO', 4, 2)
  
select * from ordem_servico

-- -----------------------------------------------------
-- PEÇAS:
-- -----------------------------------------------------
insert into peca
values
  ('Jogo De Capas', 178.40),
  ('Protetor Magnético de Porta', 110),
  ('Injetores de combustível', 78),
  ('Alavanca Câmbio', 94.37),
  ('Reservatorio Oleo Da Direcao', 299),
  ('Braco Limitador Da Porta', 69.80),
  ('Kit Bucha Reparo Dobradiça Tampa Traseira', 29.90),
  ('Polia Comando Admissao', 844),
  ('Mola Das Valvulas', 33.10),
  ('Tampa Externa Tanque Combustivel', 47)

select * from peca

-- -----------------------------------------------------
-- EQUIPES:
-- -----------------------------------------------------
insert into equipe
values
  ('Equipe montagem'),
  ('Mecanica em geral'),
  ('Turma manhã')

-- -----------------------------------------------------
-- FUNCIONÁRIOS:
-- -----------------------------------------------------
insert into funcionario
values
  ('JOÃO SILVA', 'Rua Bauru', '15A', 'Loja 02', 'Engenheiro Taveira', '16087-013', 'Araçatuba', 'SP', 'freios', 2),
  ('MARCOS GUSTAVO', 'Rua Paulo Lasmar', '800', null, 'Da Paz', '69049-11 0', 'Manaus', 'AM', 'direção hidráulica', 1),
  ('PAMELA SOARES', 'Travessa Comandante Almeida', '205', 'Loja 01', 'Coité', '61765-320', 'Eusébio', 'CE', 'motor', 1)

insert into funcionario(nome, especialidade, idequipe)
values
  ('AUGUSTO SOUZA', 'freios', 3),
  ('MANOELA DIAS', 'motor', 1),
  ('JEFERSON COSTA', 'motor', 3),
  ('PEDRO MARQUES', 'direção hidráulica', 2),
  ('RAFAELA DON', 'motor', 2),
  ('PIETRO MENDES', 'motor', 2)

select * from funcionario

-- -----------------------------------------------------
-- SERVIÇOS:
-- -----------------------------------------------------
insert into servico
values
  ('Reparos automotivos', 350, 6),
  ('Troca de óleo', 280, 2),
  ('Alinhamento e balanceamento', 130, 2),
  ('Manutenção de embreagem', 440, 5),
  ('Revisão dos componentes de freio', 850, 8),
  ('Checagem do nível de água no radiador', 60, 1),
  ('Atendimento personalizado', 200, 1),
  ('Revisão para garantia de veículo', 650, 7)

select * from servico

-- -----------------------------------------------------
-- AVALIAÇÕES DE ORDENS DE SERVIÇO PELAS EQUIPES:
-- -----------------------------------------------------
insert into avalia_exec_OS
values
  ( 2, 2, '2022/02/23', '2022/02/23', '2022/03/10', 'Ligar para agendar entrega'),
  ( 3, 2, '2021/09/25', '2021/09/28', '2021/10/03', 'Buscar cliente na loja'),
  ( 5, 3, '2022/04/17', '2022/04/18', '2022/04/18', 'Pagamento a vista'),
  ( 6, 1, null, null, null, 'Cliente vem buscar'),
  ( 8, 1, '2022/07/25', '2022/07/26', '2022/07/30', 'Desconto concedido: 7% AV')

select * from ordem_servico


-- -----------------------------------------------------
-- NECESSIDADES DE PEÇAS:
-- -----------------------------------------------------
insert into necessidade_de_pecas (idOs, idpeca, quantidade, valor_unitario)
values
  ( 1, 3, 2, 0),
  ( 2, 3, 3, 0),
  ( 3, 5, 1, 0),
  ( 5, 6, 1, 0),
  ( 6, 2, 1, 0),
  ( 8, 1, 2, 0),
  ( 2, 7, 6, 0),
  ( 3, 8, 3, 0),
  ( 1, 6, 2, 0),
  ( 6, 5, 1, 0),
  ( 4, 5, 2, 0),
  ( 5, 7, 2, 0),
  ( 8, 8, 1, 0)

-- -----------------------------------------------------
-- SERVIÇOS A EXECUTAR:
-- -----------------------------------------------------
insert into servicos_a_executar
values
  ( 2, 3, 2, 4, 0, 'Iniciar de manhã'),
  ( 1, 3, 1, 6, 0, null),
  ( 5, 1, 1, 7, 0, null),
  ( 4, 5, 1, 2, 0, null),
  ( 3, 5, 3, 7, 0, 'Valor a vista'),
  ( 2, 4, 4, 8, 0, null),
  ( 3, 6, 1, 3, 0, 'Vai buscar carro a tarde'),
  ( 1, 3, 2, 5, 0, 'Parcelado sem juros'),
  ( 5, 1, 1, 8, 0, null),
  ( 6, 1, 1, 7, 0, 'Revisão geral'),
  ( 8, 3, 2, 9, 0, 'Rodízio pneus'),
  ( 7, 7, 1, 1, 0, null),
  ( 7, 8, 3, 3, 0, null)

select * from servicos_a_executar


-- -----------------------------------------------------
-- Crie queries SQL com as cláusulas abaixo:
     -- Recuperações simples com SELECT Statement;
     -- Filtros com WHERE Statement;
     -- Crie expressões para gerar atributos derivados;
     -- Defina ordenações dos dados com ORDER BY;
     -- Condições de filtros aos grupos – HAVING Statement;
     -- Crie junções entre tabelas para fornecer uma perspectiva mais complexa dos dados;
-- -----------------------------------------------------

--1. Selecionar todos os clientes da oficina:
select idcliente, nome, identificacao, email, fone
from cliente

--2. Selecionar todas as ordens de serviço já finalizadas:
select *
from ordem_servico
where statusOs = 'FINALIZADO'

--3. Selecionar todas as ordens de serviço que foram canceladas ou estão aguardando aprovação:
select *
from ordem_servico
where statusOs IN ('CANCELADO', 'AGUARDANDO')

--4. Calcular desconto para pagamento a vista da ordem de serviço:
select numero_os, data_autorizacao_cliente, valor, round(valor*0.1, 2) as ValorDesconto, statusOs
from ordem_servico
where statusOs in ('FINALIZADO', 'ABERTA')

--5. Liste os clientes ordenados pela sua identificação:
select nome, identificacao, email, fone
from cliente
order by identificacao

--6. Selecione a quantidade de ordens de serviços anuais nos anos que tiveram mais que 3 ordens de serviço:
select year(data_emissao) as ano_OS, count(*) as qtde_OS_por_ano
from ordem_servico
group by year(data_emissao)
having count(*) > 3

--7. Selecione os dados dos carros, clientes e serviços executados:
select c.nome, c.email, c.cidade, os.numero_os, os.data_emissao, os.valor, os.statusOs, 
       v.modelo, v.placa, se.observacoes, s.descricao_mao_de_obra, s.horas_estimadas
from cliente as c inner join ordem_servico as os ON c.idcliente = os.idcliente
                  inner join veiculo as v ON os.idveiculo = v.idveiculo
				  inner join servicos_a_executar as se ON os.idOs = se.idOs
				  inner join servico as s ON se.idservico = s.idservico

--8. Quais serviços foram executados em carros com kilometragem acima de 100 mil kilometros:
select s.descricao_mao_de_obra, v.placa, v.km_atual, v.modelo, os.statusOs
from ordem_servico as os inner join veiculo as v ON os.idveiculo = v.idveiculo
				         inner join servicos_a_executar as se ON os.idOs = se.idOs
				         inner join servico as s ON se.idservico = s.idservico
where v.km_atual >= 100000
order by v.placa, s.descricao_mao_de_obra

--9. Quantos serviços já foram executados nos veiculos cadastrados?
select v.modelo, count(*) as qtde_servicos
from ordem_servico as os inner join veiculo as v ON os.idveiculo = v.idveiculo
				         inner join servicos_a_executar as se ON os.idOs = se.idOs
				         inner join servico as s ON se.idservico = s.idservico
group by v.modelo

--10. Quais são os carros que fizeram serviços e não tiveram necessidade de peças:
select v.modelo, v.placa, s.descricao_mao_de_obra
from ordem_servico as os inner join veiculo as v ON os.idveiculo = v.idveiculo
				         inner join servicos_a_executar as se ON os.idOs = se.idOs
				         inner join servico as s ON se.idservico = s.idservico
where os.idOs not in (select idOs from servicos_a_executar)
order by v.modelo

--11. Quantos funcionários existem por equipe:
select e.nome as NomeEquipe, count(*) as qtde_func_por_equipe
from equipe e inner join funcionario f ON e.idequipe = f.idequipe
group by e.nome

--12. Quais clientes contrataram ordens de serviço com preço acima da média geral de preços de OS:
select c.nome, c.identificacao, os.numero_os, os.valor
from cliente as c inner join ordem_servico as os ON c.idcliente = os.idcliente
where 
  os.valor > (select avg(valor) from ordem_servico)
order by os.valor

--13. Liste as peças, o valor e quantidade de cada uma das que foram usadas nas ordens de serviço finalizadas:
select p.descricao, p.preco_padrao, np.quantidade, np.valor_unitario, os.statusOs
from peca as p inner join necessidade_de_pecas as np ON p.idpeca = np.idpeca
               inner join ordem_servico as os ON np.idOs = os.idOs
where os.statusOs = 'FINALIZADO'

--14. Liste a diferença de valor entre o preço padrão das peças e o preço praticado em cada ordem de serviço:
select p.descricao, p.preco_padrao, np.valor_unitario, p.preco_padrao - np.valor_unitario as diferenca_de_valor
from peca as p inner join necessidade_de_pecas as np ON p.idpeca = np.idpeca
               inner join ordem_servico as os ON np.idOs = os.idOs

--15. Liste a quantidade de ordens de serviço contratadas e a soma das horas efetivamente usadas nas ordens de serviço de cada veículo:
select v.modelo, count(*) as qtde_os, sum(horas_efetivas) as total_horas
from servico as s inner join servicos_a_executar as se ON s.idservico = se.idservico
                  inner join ordem_servico as os ON os.idOs = se.idOs
				  inner join veiculo as v ON os.idveiculo = v.idveiculo
group by v.modelo


