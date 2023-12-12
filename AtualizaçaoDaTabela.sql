CREATE DATABASE Tela_Cadastro
GO
USE Tela_Cadastro
GO
CREATE TABLE EMPRESA(
ID_EMPRESA INT PRIMARY KEY IDENTITY NOT NULL,
Nome_Empresa VARCHAR(150) NOT NULL
)

CREATE TABLE UF(
ID_UF INT PRIMARY KEY IDENTITY NOT NULL,
Sigla CHAR(2) 
)

CREATE TABLE CARGO 
(ID_CARGO INT PRIMARY KEY IDENTITY NOT NULL,
Nome_cargo VARCHAR(150) NOT NULL
)

CREATE TABLE CIDADE(
ID_CIDADE INT PRIMARY KEY IDENTITY NOT NULL,
ID_UF INT NOT NULL,
FOREIGN KEY (ID_UF) REFERENCES UF (ID_UF),
Nome_Cidade VARCHAR(150) NOT NULL
)

CREATE TABLE COLABORADOR(
ID_COLABORADOR INT PRIMARY KEY IDENTITY NOT NULL,
ID_CARGO INT NOT NULL,
FOREIGN KEY (ID_CARGO) REFERENCES CARGO (ID_CARGO),
ID_CIDADE INT NOT NULL,
FOREIGN KEY (ID_CIDADE) REFERENCES CIDADE (ID_CIDADE),
ID_Empresa int not NULL,
FOREIGN KEY (ID_Empresa) REFERENCES Empresa (ID_Empresa),
Nome_colaborador VARCHAR(200),
Email VARCHAR(100)
)

CREATE TABLE CONTATO(
ID_CONTATO INT PRIMARY KEY IDENTITY NOT NULL,
ID_COLABORADOR INT NOT NULL,
FOREIGN KEY (ID_COLABORADOR) REFERENCES COLABORADOR (ID_COLABORADOR),
DDD TINYINT NOT NULL,
Numero_Colaborador BIGINT NOT NULL,
Whatsapp BIT NOT NULL
)

INSERT INTO EMPRESA (Nome_Empresa) VALUES 
('SMN INGÁ'),
('SMN JOÃO PESSOA'),
('SMN FRANCA'),
('SMN PASSOS');


INSERT INTO CARGO (Nome_cargo) VALUES 
('Analista de Negócio'),
('Desenvolvedor'),
('Analista de Negócio'),
('Desenvolvedor'),
('Analista de Negócio'),
('Desenvolvedor'),
('Analista de Negócio'),
('Desenvolvedor');

INSERT INTO UF (Sigla) VALUES 
('PB'),
('SP'),
('RJ'),
('SC');

INSERT INTO CIDADE (ID_UF, Nome_Cidade) VALUES 
(1, 'INGÁ'),
(3, 'RIO DE JANEIRO'),
(1, 'JOÃO PESSOA'),
(2, 'FRANCA'),
(4, 'CHAPECÓ');

GO
CREATE PROC Inserir_Dados_Colaborador (@IdCargo INT, @IdCidade INT, @IDEmpresa INT, @NomeColaborador VARCHAR(150), @EmailColaborador VARCHAR(100), @DDDColaborador TINYINT, @NumeroColaborador BIGINT, @Whatasapp BIT)
AS
	/*
	Documentação
	Arquivo Fonte.....: Tela_Cadastro3.sql
	Objetivo..........: Inserir dados do colaborador
	Autor.............: SMN - Natanael de Araújo Sousa
	Data..............: 12/12/2023
	Ex................: DECLARE @resultado TINYINT
						EXEC @resultado = [dbo].[Inserir_Dados] 1, 1, 1, 'Emanuel', 'teste@12345.com', 83, 994252525, 1
						SELECT @resultado
	Retornos..........: 0 - OK
						1 - Inclusão apenas do número
						2 - Já possui whatsapp
	*/
BEGIN
-- Verificando se o colaborador não existe
	DECLARE @UltimoIDColaborador INT
		SELECT @UltimoIDColaborador = ID_COLABORADOR FROM COLABORADOR WHERE Email = @EmailColaborador
	
	IF (@UltimoIDColaborador IS NOT NULL)
		IF (EXISTS(SELECT Whatsapp FROM CONTATO WHERE ID_COLABORADOR = @UltimoIDColaborador AND Whatsapp = 1) AND @Whatasapp = 1)
			RETURN 2
		ELSE 
			BEGIN 
				INSERT INTO CONTATO (ID_COLABORADOR, DDD, Numero_Colaborador, Whatsapp) VALUES (@UltimoIDColaborador, @DDDColaborador, @NumeroColaborador, @Whatasapp)
				RETURN 1
			END
	ELSE
		-- Inserindo os dados na tabela colaborador
		BEGIN
			INSERT INTO COLABORADOR (ID_CARGO, ID_CIDADE, ID_Empresa, Nome_colaborador, Email) VALUES (@IdCargo, @IdCidade, @IDEmpresa, @NomeColaborador, @EmailColaborador)
		
			-- Buscando ID_COLABORADOR para inserção na tabela contato
			SELECT TOP 1 @UltimoIDColaborador = ID_COLABORADOR FROM COLABORADOR ORDER BY ID_COLABORADOR DESC

			-- Inserindo os dados na tabela contato
			INSERT INTO CONTATO (ID_COLABORADOR, DDD, Numero_Colaborador, Whatsapp) VALUES (@UltimoIDColaborador, @DDDColaborador, @NumeroColaborador, @Whatasapp)
		
			RETURN 0
		END
END
-- 