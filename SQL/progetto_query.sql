set search_path to 'Progetto_BD2023';


--Q1
--Determinare le scuole che pur avendo un finanziamento per il progetto non hanno inserito rilevazioni in quest'anno scolastico

SELECT S.CodMec, S.Nome
FROM Scuola S
WHERE S.Finanziamento = 'true' AND
	  NOT EXISTS (SELECT CodRil 
        		  FROM Rilevazione Ril
        		  JOIN Responsabile R ON Ril.RespIns = R.CodResp
				  JOIN Persona P ON R.IndividuoResp = P.CodP
				  JOIN Referente Ref ON Ref.CodP = P.CodP
        		  LEFT JOIN Classe C ON R.ClasseResp = C.CodC
        		  WHERE (S.CodMec = Ref.CodMec OR C.Scuola = S.CodMec) AND
				  Ril.DataIns BETWEEN '2022/09/01 00:00:00' AND '2023/06/30 23:59:59')
;


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

--Perfetta
SELECT CodMec, RespRil, no_ril
FROM (SELECT CodMec, RespRil, no_ril, RANK() OVER (PARTITION BY CodMec ORDER BY no_ril DESC) as rn --Or ROW_NUMBER for listing only one
	  FROM (SELECT S.CodMec, Ril.RespRil, COUNT(Ril.CodRil) as no_ril
			FROM Scuola S
			  JOIN Orto O ON O.Scuola = S.CodMec
			  JOIN Replica Repl ON Repl.Orto = O.CodOrto
			  JOIN Rilevazione Ril ON Ril.Replica = Repl.CodRepl
			GROUP BY S.CodMec, Ril.RespRil
		   ) t
	 ) s
WHERE s.rn = 1
ORDER BY no_ril DESC
;

--Giusta
SELECT S.*
FROM (SELECT DISTINCT ON (S.CodMec) S.*, Ril.RespRil, COUNT(Ril.CodRil) as n_rilperresp
	  FROM Scuola S
	  LEFT JOIN Orto O ON O.Scuola = S.CodMec
	  LEFT JOIN Replica Rep ON Rep.Orto = O.CodOrto
	  LEFT JOIN Rilevazione Ril ON Ril.Replica = Rep.CodRepl
	  GROUP BY S.CodMec, Ril.RespRil
	  ORDER BY S.CodMec, 3 DESC
	 ) S
;

--Risultati giusti, manca scuola
SELECT Ril.RespRil, COUNT(DISTINCT Ril.CodRil) AS QtdRilevazione
FROM Scuola S
    LEFT JOIN Orto O ON O.Scuola = S.CodMec
    LEFT JOIN Replica Rep ON Rep.Orto = O.CodOrto
    LEFT JOIN Dispositivo D ON D.CodDisp = Rep.Dispositivo
    LEFT JOIN Rilevazione Ril ON Ril.Dispositivo = D.CodDisp
GROUP BY  1
ORDER BY  2 DESC
;

--test
SELECT Ril.RespRil, COUNT(DISTINCT Ril.CodRil) AS QtdRilevazione
FROM Rilevazione Ril
GROUP BY  1
ORDER BY  2 DESC
;

--test
SELECT RespRil, Dispositivo, COUNT(RespRil) as no_ril
FROM Rilevazione
GROUP BY 1, 2;