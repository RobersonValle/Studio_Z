
--------------------------- NUMEROS PARA O COMPARATIVO MENSAL COM OS DADOS DE RECEITA INFLUENCIADA ---------------------------
IF OBJECT_ID('tempDB..#COMPARATIVO_MES', 'U') IS NOT NULL DROP TABLE #COMPARATIVO_MES

SELECT DISTINCT
		LEFT(CAST(DATA_COMPRA AS date),7) AS MES_ANO   --(YEAR(DATA_COMPRA),'-',MONTH(DATA_COMPRA)) AS MES_ANO
		,ID_LOJA
		,ID_COMPRA
		,CPF_CNPJ
		,CASE WHEN CPF_CNPJ IS NOT NULL THEN 1 ELSE 0 END AS COMPRA_IND
		,QUANTIDADE_TOTAL_PRODUTO
		,CAST(TOTAL_VALOR_LIQUIDO AS float) AS TOTAL_VALOR_LIQUIDO INTO #COMPARATIVO_MES
	FROM CRM_DATALAKE.CRM.TRANSACIONAL_VENDA
	WHERE OPERACAO_PRODUTO LIKE '%COMPRA%' 
		AND ID_LOJA IS NOT NULL
		AND CAST(DATA_COMPRA AS DATE) >= '2021-01-01'

SELECT MES_ANO
	,ID_LOJA
	,COUNT(DISTINCT ID_COMPRA) AS QTD_CUPONS
	,SUM(COMPRA_IND) AS QTD_CUPONS_IND
	,SUM(TOTAL_VALOR_LIQUIDO) / CASE WHEN COUNT(DISTINCT ID_COMPRA) > 0 THEN COUNT(DISTINCT ID_COMPRA) ELSE 1 END AS TICKET_MEDIO
	,SUM(CAST(QUANTIDADE_TOTAL_PRODUTO AS float)) / CASE WHEN COUNT(DISTINCT ID_COMPRA) > 0 THEN COUNT(DISTINCT ID_COMPRA) ELSE 1 END AS PA
	,SUM(CAST(COMPRA_IND AS float)) / CASE WHEN COUNT(DISTINCT CPF_CNPJ) > 0 THEN COUNT(DISTINCT CPF_CNPJ) ELSE 1 END AS FCC
	FROM #COMPARATIVO_MES
GROUP BY MES_ANO, ID_LOJA

--------------------------- NUMEROS PARA O COMPARATIVO DIARIO COM OS DADOS DE RECEITA INFLUENCIADA ---------------------------
IF OBJECT_ID('tempDB..#COMPARATIVO_DIA', 'U') IS NOT NULL DROP TABLE #COMPARATIVO_DIA

SELECT DISTINCT
		CAST(DATA_COMPRA AS date) AS DATA_COMPRA
		,ID_LOJA
		,ID_COMPRA
		,CASE WHEN CPF_CNPJ IS NOT NULL THEN 1 ELSE 0 END AS COMPRAS_INDENTIFICADAS
		,TOTAL_VALOR_LIQUIDO
		,TOTAL_PRECO_PRODUTO_RATEADO INTO #COMPRARTIVO_DIA
	FROM CRM_DATALAKE.CRM.TRANSACIONAL_VENDA
	WHERE OPERACAO_PRODUTO LIKE '%COMPRA%' 
		AND ID_LOJA IS NOT NULL
		AND CAST(DATA_COMPRA AS DATE) >= '2021-01-01'

SELECT
		ID_LOJA
		,DATA_COMPRA
		,COMPRAS_INDENTIFICADAS
		,SUM(CAST(TOTAL_VALOR_LIQUIDO AS numeric(10,2))) AS TOTAL_VALOR_LIQUIDO
		,SUM(CAST(TOTAL_PRECO_PRODUTO_RATEADO AS numeric(10,2))) AS TOTAL_PRECO_PRODUTO_RATEADO
	FROM #COMPRARTIVO_DIA
	GROUP BY 
		ID_LOJA
		,DATA_COMPRA
		,COMPRAS_INDENTIFICADAS


