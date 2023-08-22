set search_path to "Progetto_BD2023";


--Q1
--Determinare le scuole che pur avendo un finanziamento per il progetto non hanno inserito rilevazioni in quest'anno scolastico

SELECT S.CodMec, S.Nome
FROM Scuola S
WHERE S.Finanziamento = 'true' AND
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


--Q2
--Determinare le specie utilizzate in tutti i comuni (province) in cui ci sono scuole aderenti al progetto
--RIMODELLATA:
--Determinare le specie per cui non è possibile determinare province in cui non sono utilizzate (tutte le scuole sono aderenti al progetto)

SELECT R.SpeciePianta
FROM Replica R
WHERE NOT EXISTS (SELECT *
				  FROM Scuola S
				  WHERE NOT EXISTS (SELECT *
									FROM Scuola S1
									JOIN Orto O ON S1.CodMec = O.Scuola
									JOIN Replica R1 ON O.CodOrto = R1.Orto
									WHERE R1.SpeciePianta = R.SpeciePianta 
									AND S1.Prov = S.Prov)
				 )
GROUP BY R.SpeciePianta
;