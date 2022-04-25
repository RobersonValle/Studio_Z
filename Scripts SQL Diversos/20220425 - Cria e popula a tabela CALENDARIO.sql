SET LANGUAGE 'Portuguese'
CREATE TABLE CRM_DATALAKE.CRM.CALENDARIO
(
  [DATA] DATETIME PRIMARY KEY,
  [ANO] AS DATEPART(YEAR,[DATA]),
  [MES] AS DATEPART(MONTH,[DATA]),
  [DIA]  AS DATEPART(DAY,[DATA]), 
  [DIA_ANO]  AS DATEPART(DAYOFYEAR,[DATA]), 
  [TRIMESTRE] AS DATEPART(QUARTER,[DATA]),
  [SEMANA_ANO]AS DATEPART(WK,[DATA]),
  [MES_NOME] AS DATENAME(MONTH, [DATA]),
  [DIA_NOME] AS DATENAME(WEEKDAY, [DATA]),
  [ANO_TRIMESTRE_NOME] AS CONCAT(DATEPART(YEAR,[DATA]),' - ',DATEPART(QUARTER,[DATA]),'� Trimestre') 
);


DECLARE @DATA_INICIAL DATE;
DECLARE @DATA_FINAL DATE;

SELECT @DATA_INICIAL = '20210101';
SELECT @DATA_FINAL = '20251231';

WITH DATAS AS
(
  SELECT DT = @DATA_INICIAL
  WHERE @DATA_INICIAL < @DATA_FINAL
  UNION ALL
  SELECT DATEADD(DD, 1, DT)
  FROM DATAS
  WHERE DATEADD(DD, 1, DT) <= @DATA_FINAL
)
INSERT INTO CRM_DATALAKE.CRM.CALENDARIO ([DATA])
SELECT DT FROM DATAS
OPTION (MAXRECURSION 0)


SELECT * FROM CRM_DATALAKE.CRM.CALENDARIO