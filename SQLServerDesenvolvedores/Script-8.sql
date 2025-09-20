-- Criando banco de dados
CREATE DATABASE MedicodeIO;
DROP DATABASE MedicodeIO;
ALTER DATABASE MedicodeIO SET SINGLE_USER WITH ROLLBACK IMMEDIATE;


-- Exemplo de como criar logs.
CREATE DATABASE MedicodeIO 
	ON (Name = 'Dev_mdf', FILENAME = 'D:\teste.mdf') 
	LOG ON (Name = 'Dev_log', FILENAME = 'D:\teste.ldf')

	
-- Criando tabelas
CREATE TABLE alunos(
	id int PRIMARY KEY IDENTITY, 
	nome VARCHAR(80) NOT NULL, 
	cpf CHAR(11) NOT NULL,
	cidade VARCHAR(60) NOT NULL,
	estado CHAR(2) NOT NULL,
	data_nascimento DATE,
	ativo bit DEFAULT 1
)

CREATE TABLE categorias(
	id int PRIMARY KEY IDENTITY,
	descricao VARCHAR(80) NOT NULL,
	cadastrado_em DATETIME DEFAULT GETDATE()
)

CREATE TABLE cursos(
	id int PRIMARY KEY IDENTITY,
	categoria_id INT NOT NULL,
	descricao VARCHAR(80) NOT NULL,
	total_horas INT NOT NULL,
	valor DECIMAL(12,2) NOT NULL DEFAULT 0,
	cadastrado_em DATETIME DEFAULT GETDATE(),
	ativo bit DEFAULT 1,
	CONSTRAINT fk_categoria_id FOREIGN KEY (categoria_id) REFERENCES categorias(id)
)

CREATE TABLE alunos_cursos(
	aluno_id INT NOT NULL,
	curso_id INT NOT NULL,
	cadastrado_em DATETIME DEFAULT GETDATE(),
	CONSTRAINT pk_alunos_cursos PRIMARY KEY (aluno_id, curso_id),
	CONSTRAINT fk_aluno_id FOREIGN KEY (aluno_id) REFERENCES alunos(id),
	CONSTRAINT fk_curso_id FOREIGN KEY (curso_id) REFERENCES cursos(id)
)


-- Inserindo dados
INSERT INTO alunos(nome, cpf, cidade, estado, data_nascimento) VALUES 
	('Rafael',	'00000000001',	'Aracaju',			'SE',	'2025-09-15'),
	('Edudaro',	'00000000002',	'São Paulo',		'SE',	'2025-09-16'),
	('Bruno',	'00000000003',	'São Paulo',		'SE',	'2025-09-17'),
	('Tiago',	'00000000004',	'Rio de Janeiro',	'SE',	'2025-09-18'),
	('Heloysa',	'00000000005',	'Aracaju',			'SE',	'2025-09-19');

INSERT INTO categorias(descricao) VALUES 
	('Acesso a dados'), 
	('Seguranca'), 
	('WEB');

INSERT INTO cursos(descricao, categoria_id, total_horas, valor) VALUES
	('EF Core',							1, 17, 300),
	('SQL Server',						1,  5, 200),
	('ASP.NET Core Enterprise',			3,  5, 200),
	('Fundamentos de IdentityServer4',	2,  5, 200);

INSERT INTO alunos_cursos(aluno_id, curso_id) VALUES
	(1, 1),
	(1, 2),
	(2, 3),
	(3, 1),
	(4, 4),
	(5, 1),
	(5, 2),
	(5, 3);

INSERT INTO categorias(descricao) VALUES('Categoria Test');


-- Consultando dados
SELECT * FROM alunos;
SELECT * FROM categorias;
SELECT * FROM cursos;
SELECT * FROM alunos_cursos;
SELECT nome, cpf FROM alunos;
SELECT nome as nome_aluno, cpf FROM alunos;
SELECT cidade, estado FROM alunos;


-- Atualizando registros
UPDATE alunos SET data_nascimento=GETDATE(), ativo=1;


-- Apagando registros
DELETE FROM alunos;
TRUNCATE TABLE alunos;
DELETE TOP (1) FROM alunos;
DELETE TOP (10) PERCENT FROM alunos;


-- Apagando tabelas
DROP TABLE alunos;


-- Consulta com Distinct
SELECT DISTINCT cidade, estado FROM alunos;


-- Consulta com Order By
SELECT * FROM alunos ORDER BY nome ASC;
SELECT * FROM alunos ORDER BY nome DESC;
SELECT * FROM alunos ORDER BY 1 ASC;
SELECT * FROM alunos ORDER BY nome ASC, cpf DESC, estado ASC;


-- Consulta com Top/Fech
SELECT TOP 4 * FROM alunos ORDER BY id;
SELECT TOP 10 PERCENT * FROM alunos ORDER BY id;
SELECT * FROM alunos ORDER BY id 
	OFFSET 2 ROWS 
	FETCH FIRST 2 ROWS ONLY;


-- Consulta com Where
SELECT * FROM alunos WHERE nome = 'Rafael';
SELECT * FROM alunos WHERE id >= 3;


-- Consulta com And/Or
SELECT * FROM alunos WHERE id >= 3 AND nome = 'Bruno';
SELECT * FROM alunos WHERE id >= 3 AND (nome = 'Bruno' OR nome = 'Heloysa');


-- Consulta com Like
SELECT * FROM alunos WHERE nome LIKE 'Rafael';
SELECT * FROM alunos WHERE nome LIKE 'Ra%';
SELECT * FROM alunos WHERE nome LIKE '%o';
SELECT * FROM alunos WHERE nome LIKE '%a%';
SELECT * FROM alunos WHERE nome LIKE 'R%l';


-- Consulta com agregação Max/Min
SELECT MAX(id) FROM alunos;
SELECT MIN(id) FROM alunos;
SELECT * FROM alunos WHERE id = (SELECT MAX(id) FROM alunos);
SELECT * FROM alunos WHERE id = (SELECT MIN(id) FROM alunos);


-- Consulta com agregação Count/Sum
SELECT COUNT(*) FROM cursos;
SELECT COUNT(*), SUM(total_horas) FROM cursos;
SELECT COUNT(*), SUM(total_horas), SUM(valor) FROM cursos;


-- Consulta com Group By
SELECT cidade, estado FROM alunos GROUP BY cidade, estado;
SELECT cidade, estado, COUNT(*) Total FROM alunos GROUP BY cidade, estado;


-- Consulta com Having
SELECT cidade, estado, COUNT(*) Total FROM alunos 
	GROUP BY cidade, estado 
	HAVING COUNT(*) > 1;


-- Consulta com In
SELECT * FROM alunos WHERE id IN(2, 4);
SELECT * FROM alunos WHERE id IN(SELECT id FROM alunos);


-- Consulta com Between
SELECT * FROM alunos WHERE id BETWEEN 2 AND 4;


-- Consulta com Inner Join
SELECT * FROM cursos cr INNER JOIN categorias ca ON ca.id = cr.categoria_id;
SELECT cr.descricao Curso, ca.descricao Categoria  FROM cursos cr 
	INNER JOIN categorias ca ON ca.id = cr.categoria_id;


-- Consulta com Left Join
SELECT cr.descricao Categoria, ca.descricao Curso FROM categorias cr 
	LEFT JOIN cursos ca ON ca.categoria_id = cr.id;


-- Consulta com Right Join
SELECT cr.descricao Curso, ca.descricao Categoria  FROM cursos cr 
	RIGHT JOIN categorias ca ON ca.id = cr.categoria_id;


-- Consulta com Full Join
SELECT cr.descricao Curso, ca.descricao Categoria  FROM cursos cr 
	FULL JOIN categorias ca ON ca.id = (cr.categoria_id);

SELECT cr.descricao Curso, ca.descricao Categoria  FROM cursos cr 
	FULL JOIN categorias ca ON ca.id = (cr.categoria_id + 4);


-- Consulta com Union/Union All
SELECT * FROM cursos WHERE id = 1 
	UNION SELECT * FROM cursos WHERE id = 2;

SELECT descricao FROM cursos WHERE id = 1 
	UNION SELECT descricao FROM categorias WHERE id = 2
	UNION SELECT 'Valor dinamico';

SELECT descricao FROM cursos WHERE id = 1 
	UNION SELECT descricao FROM categorias WHERE id = 2
	UNION SELECT 'Valor dinamico'
	UNION SELECT 'Valor dinamico';

SELECT descricao FROM cursos WHERE id = 1 
	UNION ALL SELECT descricao FROM categorias WHERE id = 2
	UNION ALL SELECT 'Valor dinamico';

SELECT descricao FROM cursos WHERE id = 1 
	UNION ALL SELECT descricao FROM categorias WHERE id = 2
	UNION ALL SELECT 'Valor dinamico'
	UNION ALL SELECT 'Valor dinamico';


-- Transaction
SELECT * FROM categorias;

BEGIN TRANSACTION 
	UPDATE categorias set descricao=UPPER(descricao) WHERE id>0 
	GO 
	DELETE categorias WHERE id=4 
	GO

ROLLBACK;
COMMIT;


-- Save Point
SELECT * FROM categorias;

BEGIN TRANSACTION 
	INSERT INTO categorias(descricao, cadastrado_em) VALUES ('Categoria Nova 1', GETDATE())
	INSERT INTO categorias(descricao, cadastrado_em) VALUES ('Categoria Nova 2', GETDATE())
	GO
	SAVE TRANSACTION AtualizacaoPoint
	UPDATE categorias SET descricao='Aplicacao WEB' WHERE descricao='WEB'
	GO

ROLLBACK TRANSACTION AtualizacaoPoint;
COMMIT;
	

-- Conhecento funções
SELECT left(descricao, 4), descricao FROM categorias;
SELECT right(descricao, 4), descricao FROM categorias;

SELECT substring(descricao, 2, 5), descricao FROM categorias;
SELECT 'RAFAEL' + ' ALMEIDA' + NULL;

SELECT CONCAT('RAFAEL', ' ALMEIDA', ' SANTOS');
SELECT CONCAT(descricao, ' TESTE') FROM categorias;

SELECT ISNULL(null, 'DEFAULT');
SELECT ISNULL(descricao, 'SEM DESCRICAO') FROM categorias;

SELECT COALESCE(null, null, null, 'PRIMEIRO', 'SEGUNDO');
SELECT 2 * COALESCE(null, 1);

SELECT IIF (1 > 0, 'MAIOR QUE ZERO', 'MENOR QUE ZERO');
SELECT IIF (-1 > 0, 'MAIOR QUE ZERO', 'MENOR QUE ZERO');
SELECT IIF (LEN(descricao) > 5, 'MAIOR QUE 5', 'MENOR QUE 5'), descricao FROM categorias;
SELECT IIF (LEN(descricao) < 5, 'MAIOR QUE 5', 'MENOR QUE 5'), descricao FROM categorias;

SELECT CAST(GETDATE() AS DATE), CAST(GETDATE() AS TIME);


-- Criando funções
CREATE FUNCTION Mascarar(@data VARCHAR(255), @quantidadeCarecteres int)
RETURNS VARCHAR(255)
AS
BEGIN
	RETURN LEFT(@data, @quantidadeCarecteres)+'**** ****'
END

CREATE FUNCTION ContarRegistros()
RETURNS int
AS
BEGIN
	RETURN (SELECT COUNT(*) FROM categorias)
END

CREATE FUNCTION GetCategoriaById(@id int)
RETURNS TABLE
AS
RETURN (SELECT * FROM categorias WHERE id=@id)

SELECT dbo.Mascarar('RAFAEL ALMEIDA', 4);
SELECT dbo.ContarRegistros();
SELECT * FROM dbo.GetCategoriaById(1);
SELECT * FROM dbo.GetCategoriaById(2);


-- Criando Stored Procedure
CREATE PROCEDURE PesquisarCategoriaPorId(@id int)
AS BEGIN
	SELECT * FROM categorias WHERE id=@id
END

CREATE PROCEDURE PersistirDadosEmCategorias(@descricao VARCHAR(255))
AS BEGIN
	INSERT INTO categorias(descricao, cadastrado_em) VALUES(@descricao, GETDATE())
END

DROP PROCEDURE PersistirDadosEmCategorias;

CREATE PROCEDURE PersistirDadosEmCategorias(@descricao VARCHAR(255))
AS BEGIN
	IF(@descricao IS NULL)
	BEGIN
		RAISERROR('Descricao não é valida', 16, 1)
		RETURN
	END	
	INSERT INTO categorias(descricao, cadastrado_em) VALUES(@descricao, GETDATE())
END

EXECUTE dbo.PesquisarCategoriaPorId 1;
EXECUTE dbo.PesquisarCategoriaPorId @id=2;
EXECUTE dbo.PersistirDadosEmCategorias @descricao='Categoria Procedure';
EXECUTE dbo.PersistirDadosEmCategorias @descricao=null;

SELECT * FROM categorias;


-- Criando View
SELECT * FROM cursos;
SELECT * FROM categorias;

CREATE VIEW vwCursos
AS
SELECT c.descricao, ca.descricao categoria 
	FROM cursos c 
	INNER JOIN categorias ca 
	ON c.categoria_id=ca.id;

ALTER VIEW vwCursos
AS
SELECT c.descricao, ca.descricao categoria, c.cadastrado_em 
	FROM cursos c 
	INNER JOIN categorias ca 
	ON c.categoria_id=ca.id;

SELECT * FROM vwCursos;


-- Criando Sequências
CREATE SEQUENCE MinhaSequencia
AS INT
START WITH 6
INCREMENT BY 1
MINVALUE 6
MAXVALUE 1000
NO CYCLE

SELECT NEXT VALUE FOR MinhaSequencia;

CREATE TABLE TableTeste
(
	id int DEFAULT NEXT VALUE FOR MinhaSequencia,
	descricao VARCHAR(20)
)

INSERT INTO TableTeste(descricao) VALUES ('Teste 01');
INSERT INTO TableTeste(descricao) VALUES ('Teste 02');

SELECT * FROM TableTeste;


-- Adicionando novo campo na tabela
ALTER TABLE categorias ADD Teste VARCHAR(100) DEFAULT 'Teste';

SELECT * FROM categorias;


-- Removendo coluna da tabela
ALTER TABLE categorias DROP CONSTRAINT DF__categoria__Teste__778AC167;
ALTER TABLE categorias DROP COLUMN Teste;

SELECT * FROM categorias;


-- Renomeando nome coluna na tabela
ALTER TABLE categorias ADD Teste VARCHAR(100);

EXECUTE sp_rename 'dbo.categorias.Teste', 'Observacao', 'COLUMN';
EXECUTE sp_rename 'dbo.TableTeste', 'TabelaAlterada';

SELECT * FROM categorias;
SELECT * FROM TabelaAlterada;


-- Gerando backup do banco de dados
Use MedicodeIO;

BACKUP DATABASE MedicodeIO
TO DISK = '/var/opt/mssql/data/AulaBackup.bak'
WITH INIT,
	NAME='Backup do bando de dados';
	
BACKUP DATABASE MedicodeIO
TO DISK = '/var/opt/mssql/data/AulaBackup.bak'
WITH DIFFERENTIAL,
	NAME='Backup do bando de dados - Diferencial';
	

-- Restaurando backup do bando de dados
Use master;

RESTORE DATABASE MedicodeIO
FROM DISK = '/var/opt/mssql/data/AulaBackup.bak'
WITH REPLACE;


-- Hint NoLOCK
SELECT * FROM categorias;

BEGIN TRANSACTION
UPDATE categorias SET descricao='Teste com NoLOCK' WHERE id=1004;

SELECT * FROM categorias WITH (NoLOCK);


-- Plano de execução de consultas no banco de dados
Use MedicodeIO;

CREATE TABLE Tabela_Teste
(
	id INT,
	descricao VARCHAR(80)
)

CREATE INDEX idx_tabela_teste_descricao ON Tabela_Teste(descricao);

DECLARE @id INT = 1
DECLARE @p1 INT, @p2 INT, @p3 INT, @p4 INT
WHILE @id <= 200000
BEGIN
	SET @p1=@id+200000
	SET @p2=@id+400000
	SET @p3=@id+600000
	SET @p4=@id+800000
	INSERT INTO Tabela_Teste(id, descricao)
		VALUES	(@id, 'Descricao '+CAST(@id AS VARCHAR(7))),
				(@p1, 'Descricao '+CAST(@p1 AS VARCHAR(7))),
				(@p2, 'Descricao '+CAST(@p2 AS VARCHAR(7))),
				(@p3, 'Descricao '+CAST(@p3 AS VARCHAR(7))),
				(@p4, 'Descricao '+CAST(@p4 AS VARCHAR(7)));
	SET @id = @id+1	
END

SELECT descricao FROM Tabela_Teste WHERE descricao='DESCRICAO 900000';


-- Usando corretamente o índice
--- Forma errada (Gera uma Table Scan)
SELECT descricao FROM Tabela_Teste WHERE LEFT(descricao, 16)='DESCRICAO 900000';
--- Forma correta (Gera uma Index Seek)
SELECT descricao FROM Tabela_Teste WHERE descricao LIKE 'DESCRICAO 900000%';


-- Desfragmentando índices
SELECT OBJECT_NAME(ips.object_id) AS object_name,
	i.name AS index_name,
	ips.avg_fragmentation_in_percent,
	ips.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), DEFAULT, DEFAULT, DEFAULT, 'SAMPLED') AS ips
INNER JOIN sys.indexes AS i
ON ips.object_id = i.object_id
	AND ips.index_id = i.index_id
	AND i.name IS NOT NULL
ORDER BY page_count DESC;

ALTER INDEX idx_tabela_teste_descricao ON Tabela_Teste REORGANIZE;
ALTER INDEX ALL ON Tabela_Teste REORGANIZE;

ALTER INDEX idx_tabela_teste_descricao ON Tabela_Teste REBUILD;
ALTER INDEX ALL ON Tabela_Teste REBUILD;


-- Contando registros da tabela
SET STATISTICS IO, TIME ON;

SELECT COUNT(*) FROM Tabela_Teste WITH (NoLOCK);

SELECT * FROM sys.dm_db_partition_stats s 
WHERE OBJECT_NAME(object_id) = 'Tabela_Teste'
AND s.index_id IN(0,1);


-- CTE-Common Table Expression
Use MedicodeIO;

CREATE TABLE produtos
(
	id INT IDENTITY PRIMARY KEY,
	descricao VARCHAR(100)
)
GO

CREATE TABLE pedidos
(
	id INT IDENTITY PRIMARY KEY,
	data DATE,
	observacao VARCHAR(100)
)
GO


CREATE TABLE pedido_itens
(
	id INT IDENTITY PRIMARY KEY,
	pedido_id INT,
	produto_id INT,
	quantidade INT,
	valor DECIMAL(12, 2),
	FOREIGN KEY(pedido_id) REFERENCES pedidos(id),
	FOREIGN KEY(produto_id) REFERENCES produtos(id),
)
GO


DECLARE @produtos INT = 1 
WHILE @produtos <= 50
BEGIN  
  INSERT INTO produtos(descricao)  VALUES ('PRODUTO '+cast(@produtos as varchar));
  SET @produtos = @produtos+1
END 

DECLARE @pedidos INT = 1 
DECLARE @itens INT = 1 
WHILE @pedidos <= 1000
BEGIN  
  INSERT INTO pedidos(data, observacao)  VALUES (GETDATE(), 'OBSERVACAO '+cast(@pedidos as varchar));
  WHILE @itens <= 50
  BEGIN
	INSERT INTO pedido_itens(pedido_id,produto_id,quantidade,valor)
	VALUES  (@pedidos, @itens, 1, 1);
	SET @itens = @itens + 1;
  END
  SET @itens = 1;
  SET @pedidos = @pedidos+1
END 
GO

CREATE NONCLUSTERED INDEX idx_pedido_itens_pedido_id
ON  pedido_itens (pedido_id)
INCLUDE (produto_id,quantidade)
GO

SELECT prod.descricao, i.produto_id, SUM(i.quantidade) total
FROM pedido_itens i
INNER JOIN pedidos p ON i.pedido_id = p.id
INNER JOIN produtos prod ON prod.id = i.produto_id
GROUP BY prod.descricao, i.produto_id
ORDER BY i.produto_id;
GO

WITH Consulta (codigo, quantidade) AS (
	SELECT i.produto_id, SUM(i.quantidade) total
	FROM pedido_itens i
	INNER JOIN pedidos p ON i.pedido_id = p.id	
	GROUP BY i.produto_id	
)
SELECT prod.descricao, c.codigo, c.quantidade FROM Consulta c
INNER JOIN produtos prod ON prod.id = c.codigo
ORDER BY c.codigo;


