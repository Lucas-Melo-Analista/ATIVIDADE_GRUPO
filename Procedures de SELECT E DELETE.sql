
USE smningatreinamentogrupo4

CREATE OR ALTER PROCEDURE SP_SELECTCOLABORADOR
    @Nome_Empresa VARCHAR(150) = NULL,
    @DDD TINYINT = NULL,
    @Numero_Colaborador BIGINT = NULL,
    @Whatsapp BIT = NULL,
    @Nome_colaborador VARCHAR(200) = NULL,
    @Nome_cargo VARCHAR(150) = NULL,
    @Email VARCHAR(100) = NULL,
    @Nome_Cidade VARCHAR(150) = NULL,
    @Sigla CHAR(2) = NULL
	AS
	
	/*
	Documentação
	Arquivo Fonte......: Projeto.sql
	Objetivo...........: Selecionando dados do colaborador
	Autor..............: SMN - Juan
	Data...............: 11/12/2023
	Ex.................: EXEC [dbo].[SP_SelectColaborador]
	*/

	--Selecionando dados 


	BEGIN
		SELECT 
			Nome_Empresa,
			CONCAT('(', CT.DDD , ')', ' ', CT.Numero_Colaborador) AS NumeroColaborador,
			CT.Whatsapp,
			C.Nome_colaborador,
			CG.Nome_cargo,
			C.Email,
			CONCAT(CDD.Nome_Cidade, '-', UF.Sigla) AS CidadeColaborador
        
    
		FROM COLABORADOR C
    
		INNER JOIN Empresa E
		ON E.ID_EMPRESA = C.ID_EMPRESA
		INNER JOIN CONTATO CT
		ON CT.ID_COLABORADOR = C.ID_COLABORADOR
		INNER JOIN CARGO CG
		ON CG.ID_CARGO = C.ID_CARGO
		INNER JOIN CIDADE CDD
		ON CDD.ID_CIDADE = C.ID_CIDADE
		INNER JOIN UF UF
		ON UF.ID_UF = CDD.ID_CIDADE


		WHERE 
			(@Nome_Empresa = E.Nome_Empresa OR @Nome_Empresa IS NULL) AND
			(@DDD = CT.DDD OR @DDD IS NULL) AND
			(@Numero_Colaborador = CT.Numero_Colaborador OR @Numero_colaborador IS NULL) AND
			(@Whatsapp = CT.Whatsapp  OR @Whatsapp IS NULL) AND
			(@Nome_colaborador = C.Nome_colaborador OR @Nome_colaborador IS NULL) AND
			(@Nome_cargo = CG.Nome_cargo OR @Nome_cargo IS NULL) AND
			(@Email = C.Email OR @Email IS NULL) AND
			(@Nome_Cidade = CDD.Nome_Cidade OR @Nome_Cidade IS NULL) AND
			(@Sigla = UF.Sigla  OR @Sigla IS NULL)
	END

GO

EXEC [dbo].[SP_SELECTCOLABORADOR] 

CREATE PROCEDURE SP_DeletarColaboradores(
	@ID_COLABORADOR INT 
)	
	AS	
	/*
	Documentação
	Arquivo fonte.....: Projeto.sql
	Objetivo..........: Deletar dados do colaborador
	Autor.............: SMN - Juan
	Data..............: 12/12/2023
	Ex................: EXEC [dbo].[SP_UPDATECOLABORADOR] 
	*/

	BEGIN 
		DELETE FROM CONTATO
			WHERE ID_COLABORADOR = @ID_COLABORADOR
	END

	BEGIN
		DELETE FROM COLABORADOR
			WHERE ID_COLABORADOR = @ID_COLABORADOR
	END
GO
EXEC SP_DeletarColaboradores 
