set search_path to "Progetto_BD2023";

--Determinare le scuole che pur avendo un finanziamento per il progetto non hanno inserito rilevazioni in quest'anno scolastico

SELECT S.Nome, S.CodMec
FROM Scuola AS S
WHERE S.Finanziamento = 'TRUE' AND
		EXISTS (SELECT CodRil
        		FROM Rilevazione Ril
        		JOIN Responsabile R ON Ril.RespRilev = R.CodResp
        		JOIN Classe C ON R.ClasseResp = C.CodC
        		JOIN Persona P ON R.IndividuoResp = P.CodP
        		WHERE P.Scuola = S.CodMec OR C.Scuola = S.CodMec
        		AND Ril.DataIns Between '2022/09/01 00:00:00' AND '2023/06/30 23:59:59');

--Determinare le specie utilizzate in tutti i comuni in cui ci sono scuole aderenti al progetto

SELECT SpeciePianta
FROM Replica as R
JOIN Orto as O ON O.CodOrto = R.Orto
JOIN Scuola as S ON S.CodMec = O.Scuola
WHERE 