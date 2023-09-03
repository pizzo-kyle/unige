set search_path to 'Progetto_BD2023';

--W1
--Determinare il numero totale di piante per ogni orto pulito
SELECT O.CodOrto, COUNT(R.CodRepl)
FROM Replica R 
  JOIN Orto O ON R.Orto = O.CodOrto
WHERE O.Pulito = TRUE  
GROUP BY O.CodOrto;


--W2
--Determinare le repliche messe a dimora in vaso in data odierna
SELECT R.CodRepl, O.CodOrto
FROM Replica R 
  JOIN Orto O ON R.Orto = O.CodOrto
WHERE DataDimora = CURRENT_DATE AND Tipo = 'Vaso';


--W3
--Per ogni rilevazione antecedente alla data odierna, determinare da chi è stata effettuata
SELECT Ril.CodRil, R.CodResp, R.Tipo
FROM Rilevazione Ril 
  JOIN Responsabile R ON Ril.RespRil = R.CodResp
WHERE DataRil < CURRENT_DATE;
