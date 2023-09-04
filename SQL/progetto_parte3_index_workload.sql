set search_path to 'Progetto_BD2023';
--CARICO DI LAVORO 

--Determinare il numero totale di piante per ogni orto pulito
SELECT O.CodOrto, COUNT(R.CodRepl)
FROM Replica R 
  JOIN Orto O ON R.Orto = O.CodOrto
WHERE O.Pulito = TRUE  
GROUP BY O.CodOrto;

--Determinare le repliche messe a dimora in vaso in data odierna
SELECT R.CodRepl, O.CodOrto
FROM Replica R 
  JOIN Orto O ON R.Orto = O.CodOrto
WHERE DataDimora = CURRENT_DATE AND Tipo = 'Vaso';

--Per ogni rilevazione antecedente alla data odierna, determinare da chi è stata effettuata
SELECT Ril.CodRil, R.CodResp, R.Tipo
FROM Rilevazione Ril 
  JOIN Responsabile R ON Ril.RespRil = R.CodResp
WHERE DataRil < CURRENT_DATE;

--INDICI
CREATE INDEX idx_orto_codorto
ON Orto(CodOrto);
CLUSTER Orto
USING idx_orto_codorto;

CREATE INDEX idx_replica_orto
ON Replica(Orto);
CLUSTER Replica
USING idx_repliche_orto;

CREATE INDEX idx_replica_datadimora
ON Replica USING HASH (DataDimora);

CREATE INDEX idx_orto_tipo
ON Orto USING HASH (Tipo);

CREATE INDEX idx_rilevazione_dataril
ON Rilevazione(DataRil);
CLUSTER Rilevazione
USING idx_rilevazione_dataril;
