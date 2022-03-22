--------------------------- QUANTIDADE DE ABERTOS ---------------------------
SELECT DISTINCT TOP 10
		LEFT(CAST(DATA_ENVIO AS DATE),7)+'-01' as DATA_ENVIO
		,ID_CAMPANHA
		,CONCAT(CPF, EMAIL,TELEFONE) AS CLIENTE_QUE_ABRIU
	FROM CRM_DATALAKE.CRM.ABERTOS_STZ
	WHERE CAST(DATA_ENVIO AS date)>='2021-03-01'