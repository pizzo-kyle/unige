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


--Q3
--Determinare per ogni scuola l’individuo/la classe della scuola che ha effettuato più rilevazioni
SELECT S.CodMec, COUNT(DISTINCT Ril.CodRil) AS QtdRilevazione
FROM Scuola S
    LEFT JOIN Orto O ON O.Scuola = S.CodMec
    LEFT JOIN Replica Rep ON Rep.Orto = O.codorto
    LEFT JOIN Dispositivo D ON D.CodDisp = Rep.Dispositivo
    LEFT JOIN Rilevazione Ril ON Ril.Dispositivo = D.CodDisp
GROUP BY  1
ORDER BY  2 DESC;

SELECT CodRil
FROM Rilevazione Ril
JOIN Dispositivo D ON Ril.Dispositivo = D.CodDisp

SELECT RespRilev, COUNT(*)
FROM Rilevazione Ril
GROUP BY 1
ORDER BY COUNT(*) DESC;

SELECT CONCAT(coalesce(P.nome,''),' ',coalesce(P.cognome,'')) as fullName, C.Nome, COUNT(Ril.resprilev) AS QtdRilevazione
FROM Responsabile Resp 
LEFT JOIN Rilevazione Ril ON Resp.codresp = Ril.resprilev
LEFT JOIN Persona P ON Resp.individuoresp = P.codp
LEFT JOIN Classe C ON Resp.classeresp = C.codc
GROUP BY 1, 2
ORDER BY 3 DESC;
--LIMIT 1

SELECT S.CodMec, COUNT(Ril.resprilev) AS QtdRilevazione
FROM Scuola S
JOIN Referente Ref ON Ref.CodMec = S.CodMec
JOIN Persona P ON P.CodP = Ref.CodP
LEFT JOIN Responsabile Resp ON Resp.IndividuoResp = P.CodP
LEFT JOIN Classe C ON C.CodC = Resp.ClasseResp
LEFT JOIN Rilevazione Ril ON Ril.RespRilev = Resp.CodResp
GROUP BY  1
ORDER BY  2 DESC;