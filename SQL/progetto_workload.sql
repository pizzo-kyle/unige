set search_path to 'Progetto_BD2023';


--W1
--Determinare il numero totale di piante per ogni orto
SELECT O.CodOrto, COUNT(CodRepl)
FROM Replica R JOIN Orto O ON R.Orto = O.CodOrto
GROUP BY O.CodOrto
;


--W2
--Determinare le repliche messe a dimora nell'anno scolastico corrente
SELECT R.CodRepl, O.CodOrto
FROM Replica R
JOIN Orto O ON R.Orto = O.CodOrto
WHERE DataDimora BETWEEN '2022/09/01' AND '2023/06/30'
;


--W3
--Per ogni rilevazione, determinare l'entità che l'ha effettuata
SELECT Ril.CodRil, R.CodResp, R.Tipo
FROM Rilevazione Ril
JOIN Responsabile R ON Ril.RespRil = R.CodResp
;