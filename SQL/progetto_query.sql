set search_path to "Progetto_BD2023";

--Determinare le scuole che pur avendo un finanziamento per il progetto non hanno inserito rilevazioni in quest'anno scolastico

SELECT S.CodMec, S.Nome
FROM Scuola S
WHERE S.Finanziamento='true' AND
	  NOT EXISTS (SELECT CodRil 
        		  FROM Rilevazione Ril
        		  JOIN Responsabile R ON Ril.RespIns = R.CodResp
				  JOIN Persona P ON R.IndividuoResp = P.CodP
        		  LEFT JOIN Classe C ON R.ClasseResp = C.CodC
				  JOIN Referente Ref ON Ref.CodP = P.CodP
        		  WHERE (S.CodMec = Ref.CodMec OR C.Scuola = S.CodMec) AND
				  Ril.DataIns BETWEEN '2022/09/01 00:00:00' AND '2023/06/30 23:59:59');

SELECT Ril.CodRil
FROM Rilevazione Ril
JOIN Responsabile R ON Ril.RespIns = R.CodResp
JOIN Classe C ON R.ClasseResp = C.CodC
JOIN Persona P ON R.IndividuoResp = P.CodP
WHERE C.CodC = 1 AND Ril.DataIns BETWEEN '2022/09/01 00:00:00' AND '2023/06/30 23:59:59';

--Determinare le specie utilizzate in tutti i comuni in cui ci sono scuole aderenti al progetto

SELECT SpeciePianta
FROM Replica as R
JOIN Orto as O ON O.CodOrto = R.Orto
JOIN Scuola as S ON S.CodMec = O.Scuola
WHERE 