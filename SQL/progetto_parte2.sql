set search_path to 'progetto_bd2023';

--CREAZIONE TABELLE

CREATE TABLE Persona
(CodP INTEGER PRIMARY KEY,
 Nome VARCHAR(20) NOT NULL,
 Cognome VARCHAR(20) NOT NULL,
 Email VARCHAR(48) NOT NULL,
 Telefono VARCHAR(16),
 Ruolo VARCHAR(32) NOT NULL,
 ReferenteProg BOOLEAN NOT NULL,
 PartecipaProgFin BOOLEAN NOT NULL
);

CREATE TABLE Scuola
(CodMec INTEGER PRIMARY KEY,
 Nome VARCHAR(20) NOT NULL,
 Prov CHAR(2) NOT NULL,
 CicloIstruz VARCHAR(32) NOT NULL,
 Finanziamento BOOLEAN NOT NULL,
 TipoFin VARCHAR(32),
 Collabora BOOLEAN NOT NULL
);

CREATE TABLE Referente
(CodP INTEGER,
 CONSTRAINT referente_persona_fkey
 	FOREIGN KEY (CodP) REFERENCES Persona(CodP)
 	ON UPDATE CASCADE,
 CodMec INTEGER,
 CONSTRAINT referente_scuola_fkey
 	FOREIGN KEY (CodMec) REFERENCES Scuola(CodMec)
 	ON UPDATE CASCADE,
 PRIMARY KEY(CodP, CodMec)
);

CREATE TABLE Classe
(CodC INTEGER PRIMARY KEY,
 Nome VARCHAR(4) NOT NULL,
 Ordine VARCHAR(32) NOT NULL,
 TipoScuola VARCHAR(48) NOT NULL,
 DocRif INTEGER,
 Scuola INTEGER,
 CONSTRAINT classe_persona_fkey
 	FOREIGN KEY (DocRif) REFERENCES Persona(CodP)
 	ON UPDATE CASCADE ON DELETE CASCADE,
 CONSTRAINT classe_scuola_fkey
 	FOREIGN KEY (Scuola) REFERENCES Scuola(CodMec)
 	ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Responsabile
(CodResp INTEGER PRIMARY KEY,
 Tipo VARCHAR(16) NOT NULL CHECK (Tipo IN ('Persona', 'Classe')),
 IndividuoResp INTEGER,
 ClasseResp INTEGER,
 CONSTRAINT responsabile_persona_fkey
 	FOREIGN KEY (IndividuoResp) REFERENCES Persona(CodP)
 	ON UPDATE CASCADE ON DELETE CASCADE,
 CONSTRAINT responsabile_classe_fkey
 	FOREIGN KEY (ClasseResp) REFERENCES Classe(CodC)
 	ON UPDATE CASCADE ON DELETE CASCADE,
 CONSTRAINT xor_resp_check --IndividuoResp e ClasseResp non possono essere entrambi inizializzati
 CHECK ((IndividuoResp IS NOT NULL AND ClasseResp IS NULL) OR (IndividuoResp IS NULL AND ClasseResp IS NOT NULL))
);

CREATE TABLE InfoAmbientali
(CodInfo INTEGER PRIMARY KEY,
 LargChioma REAL NOT NULL,
 LungChioma REAL NOT NULL,
 PesoFrescoChioma FLOAT(3) NOT NULL,
 PesoSeccoChioma FLOAT(3) NOT NULL,
 AltPianta REAL NOT NULL,
 LungRadici REAL NOT NULL,
 PesoFrescoRadici FLOAT(3) NOT NULL,
 PesoSeccoRadici FLOAT(3) NOT NULL,
 NumFiori INTEGER NOT NULL,
 NumFrutti INTEGER NOT NULL,
 NumFoglieDann INTEGER NOT NULL,
 SuperfDann DOUBLE PRECISION NOT NULL,
 pH DOUBLE PRECISION NOT NULL,
 Umidità INTEGER NOT NULL,
 Temperatura REAL NOT NULL
);

CREATE TABLE Specie
(NomeScientifico VARCHAR(40) PRIMARY KEY,
 NomeComune VARCHAR(30) NOT NULL,
 Scopo VARCHAR(16) NOT NULL CHECK (Scopo IN ('Biomonitoraggio', 'Fitobonifica'))
);

CREATE TABLE Orto
(CodOrto INTEGER PRIMARY KEY,
 Nome VARCHAR(20) NOT NULL,
 Tipo VARCHAR(16) NOT NULL CHECK (Tipo IN ('Vaso', 'Pieno Campo')),
 GPS VARCHAR(40) NOT NULL,
 Superf DOUBLE PRECISION NOT NULL,
 Pulito BOOLEAN NOT NULL,
 AdattoControllo BOOLEAN NOT NULL,
 Scuola INTEGER,
 CONSTRAINT orto_scuola_fkey
	 FOREIGN KEY (Scuola) REFERENCES Scuola(CodMec)
	 ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Dispositivo
(CodDisp INTEGER PRIMARY KEY,
 Tipo VARCHAR(8) NOT NULL CHECK (Tipo IN ('Sensore', 'Arduino'))
);

CREATE TABLE Gruppo
(CodGruppo INTEGER PRIMARY KEY,
 TipoGruppo VARCHAR(16) NOT NULL CHECK (TipoGruppo IN ('Di controllo', 'Da monitorare')),
 AbbinatoA INTEGER DEFAULT NULL,
 Orto INTEGER,
 CONSTRAINT gruppo_orto_fkey
 	FOREIGN KEY (Orto) REFERENCES Orto(CodOrto)
 	ON UPDATE CASCADE ON DELETE CASCADE,
 CONSTRAINT bind_group_check
	CHECK (CodGruppo <> AbbinatoA)
);

CREATE TABLE Pianta
(CodRepl INTEGER PRIMARY KEY,
 DataDimora DATE NOT NULL,
 Esposizione VARCHAR(16) NOT NULL CHECK (Esposizione IN ('Sole', 'Ombra', 'MezzOmbra', 'Sole/MezzOmbra', 'MezzOmbra/Sole')),
 SpeciePianta VARCHAR(40),
 ClasseDimora INTEGER,
 Orto INTEGER,
 Dispositivo INTEGER,
 Gruppo INTEGER,
 CONSTRAINT pianta_specie_fkey
 	FOREIGN KEY (SpeciePianta) REFERENCES Specie(NomeScientifico)
 	ON UPDATE CASCADE ON DELETE CASCADE,
 CONSTRAINT pianta_classe_fkey
 	FOREIGN KEY (ClasseDimora) REFERENCES Classe(CodC)
 	ON UPDATE CASCADE ON DELETE CASCADE,
 CONSTRAINT pianta_orto_fkey
 	FOREIGN KEY (Orto) REFERENCES Orto(CodOrto)
 	ON UPDATE CASCADE ON DELETE CASCADE,
 CONSTRAINT pianta_dispositivo_fkey
	 FOREIGN KEY (Dispositivo) REFERENCES Dispositivo(CodDisp)
	 ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT pianta_gruppo_fkey
 	FOREIGN KEY (Gruppo) REFERENCES Gruppo(CodGruppo)
 	ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE Rilevazione
(CodRil INTEGER PRIMARY KEY,
 DataRil TIMESTAMP NOT NULL,
 DataIns TIMESTAMP NOT NULL,
 InfoAmb INTEGER,
 RespRil INTEGER,
 RespIns INTEGER,
 Pianta INTEGER,
 CONSTRAINT rilevazione_infoambientali_fkey
	 FOREIGN KEY (InfoAmb) REFERENCES InfoAmbientali(CodInfo)
	 ON UPDATE CASCADE ON DELETE CASCADE,
 CONSTRAINT rilevazione_responsabile_ril_fkey
	 FOREIGN KEY (RespRil) REFERENCES Responsabile(CodResp)
	 ON UPDATE CASCADE ON DELETE NO ACTION,
 CONSTRAINT rilevazione_responsabile_ins_fkey
	 FOREIGN KEY (RespIns) REFERENCES Responsabile(CodResp)
	 ON UPDATE CASCADE ON DELETE NO ACTION,
 CONSTRAINT rilevazione_pianta_fkey
 	 FOREIGN KEY (Pianta) REFERENCES Pianta(CodRepl)
	 ON UPDATE CASCADE ON DELETE CASCADE,
 CONSTRAINT dataril_ins_check
 	 CHECK (DataIns >= DataRil)
);

--POPOLAZIONE TABELLE

--DELETE FROM Persona;
INSERT INTO Persona(codp,nome,cognome,email,telefono,ruolo,referenteprog,partecipaprogfin)
VALUES(4,'ert', 'cgbhf', 'djsghbjhdf', '463u345','docente','true','true'),
	  (1,'mgeo','reo','georeo@gmail.com','3365987984','docente','true','true'),
	  (2,'marco','verdi','marcoverdi@gmail.com','3362587984','docente','true','false'),
	  (3,'marco','rossi','marcorossi@gmail.com','3362857984','docente','true','false');

--DELETE FROM Scuola;
INSERT INTO Scuola(codmec,nome,prov,cicloistruz,finanziamento,tipofin,collabora)
VALUES(4,'Mea', 'PI', 'Secondaria', 'true', 'gret', 'false'),
	  (1,'S5empronia', 'GE', 'Secondaria', 'true', 'geg', 'true'),
	  (2,'Tizia', 'GE', 'Primaria', 'true', 'abcdefu', 'false'),
	  (3,'Caia', 'GE', 'Primaria', 'false', NULL, 'true');

--DELETE FROM referente;
INSERT INTO Referente(CodP,CodMec)
VALUES(1,2),(2,1),(1,1),(3,2),(3,1),(1,3),(1,4);

--DELETE FROM Classe;
INSERT INTO Classe(codc,nome,ordine,tiposcuola,docrif,scuola)
VALUES(1,'3E','secondario','superiore',2,2),
	  (2,'2F','secondario','superiore',1,1),
	  (3,'2B', 'secondaria', 'agrario',3,3);

--DELETE FROM responsabile;
INSERT INTO Responsabile
VALUES(4, 'Persona',4,NULL),
	  (1, 'Persona',3,NULL),
	  (2,'Persona',2,NULL),
	  (3,'Classe',NULL,1);

--DELETE FROM infoambientali;
INSERT INTO infoambientali(codinfo,largchioma,lungchioma,pesofrescochioma,pesoseccochioma,altpianta,lungradici,pesofrescoradici,pesoseccoradici,numfiori,numfrutti,numfogliedann,superfdann,ph,umidità,temperatura)
VALUES(2,10.2,18.0,1.7,0.9,8.7,15.2,4.7,2.8,3,0,0,0,7,19,26),
	  (1,12.5,21.7,0.5,0.3,11.2,31.3,1.3,1.1,0,0,0,0,7,21,23),
	  (3,15.0,21.8,2.3,1.5,14.2,22.6,5.9,3.9,12,5,3,0.1,6,24,20),
	  (4,19.0,11.8,5.7,2.2,13.2,15.9,6.4,4.9,10,0,19,1.1,6,22,43),
	  (5,10.1,11.8,0.6,0.4,4.2,7.9,2.4,1.9,2,1,8,4.1,4,15,37);

--DELETE FROM Specie;
INSERT INTO Specie(nomescientifico,nomecomune,scopo)
VALUES('Solanum lycopersicum', 'Pomodoro', 'Biomonitoraggio'),
	  ('Ocimum basilicum', 'Basilico', 'Fitobonifica'),
	  ('Tulipa', 'Tulipano', 'Biomonitoraggio'),
	  ('Hyacinthus', 'Giacinto', 'Biomonitoraggio'),
	  ('Narcissus', 'Narciso', 'Fitobonifica');

--DELETE FROM orto;
INSERT INTO orto(codorto,nome,tipo,gps,superf,pulito,adattocontrollo,scuola)
VALUES(1,'sturla','Pieno Campo','42.34, 9.56',30,'true','false',2),
	  (2,'boccadasse','Vaso','44.34, 8.56',30,'false','false',1),
	  (3, 'Timbuctu', 'Vaso', '12.23, 32.89',15.34,'false','false',4),
	  (4,'Tikitaka', 'Vaso', '02.13, 11.69',09.24,'true','true',3);

--DELETE FROM dispositivo;
INSERT INTO dispositivo(coddisp,tipo)
VALUES(2,'Arduino'),
	  (1,'Sensore'),
	  (3,'Sensore'),
	  (4,'Sensore'),
	  (5,'Arduino');

--DELETE FROM gruppo;
INSERT INTO gruppo(codgruppo,tipogruppo,abbinatoa,orto)
VALUES(1,'Di controllo',4,4),
	  (2,'Da monitorare',NULL,3),
	  (3,'Di controllo',NULL,4),
	  (4,'Da monitorare',1,2),
	  (5,'Da monitorare',NULL,3),
	  (6,'Di controllo',NULL,1);
	  

--DELETE FROM Pianta;
INSERT INTO Pianta(codrepl,datadimora,esposizione,speciepianta,classedimora,orto,dispositivo,gruppo)
VALUES(2,'2023/03/12','Sole/MezzOmbra','Solanum lycopersicum',2,2,2,1),
	  (1,'2023/04/12','Ombra','Ocimum basilicum',1,1,1,2),
	  (3,'2022/10/04','Sole','Hyacinthus',2,1,4,3),
	  (4,'2021/04/07','MezzOmbra','Hyacinthus',1,2,3,1),
	  (5,'2021/04/07','MezzOmbra','Tulipa',1,1,3,1),
	  (6,'2022/10/04','Sole','Tulipa',1,2,3,4),
	  (7,'2023/04/12','MezzOmbra/Sole','Tulipa',2,3,5,3),
	  (8,'2021/04/07','Sole','Ocimum basilicum',1,3,2,2),
	  (9,'2021/04/07','MezzOmbra','Hyacinthus',1,3,3,3) ,
	  (10,'2023/09/03','MezzOmbra','Tulipa',3,4,3,5) ,
	  (11,'2023/09/03','MezzOmbra','Narcissus',3,4,3,5);
	  --(12,'2021/04/07','MezzOmbra','Narcissus',1,3,3,1);

	   
--DELETE FROM rilevazione;
INSERT INTO rilevazione(codril,dataril,datains,infoAmb,respril,respins,pianta)
VALUES(3, '2023/04/30 11:53:29', '2023/04/30 22:34:56', 2,3,1,3),
	  (2, '2023/09/01 23:01:13', '2023/09/02 05:39:19', 2,2,3,4),
	  (1, '2023/04/20 03:45:06', '2023/04/25 00:12:59', 1,1,4,1),
	  (4, '2020/02/27 00:00:03', '2020/02/28 23:45:12', 2,4,4,7),
	  (5, '2010/12/23 00:00:00', '2015/10/24 21:45:11', 2,3,3,2),
	  (6, '2015/07/03 23:56:23', '2016/02/01 10:34:12', 1,4,4,3),
	  (7, '2023/09/02 10:01:13', '2023/09/02 10:39:19', 1,3,3,4),
	  (8, '2023/08/15 10:01:13', '2023/08/22 10:39:19', 4,3,3,4);

--VISTA
/*vista che fornisca alcune informazioni riassuntive per ogni attività di biomonitoraggio: per
ogni gruppo e per il corrispondente gruppo di controllo mostrare il numero di piante, la specie, l’orto in cui è
posizionato il gruppo e, su base mensile, il valore medio dei parametri ambientali e di crescita delle piante (selezionare
almeno tre parametri, quelli che si ritengono più significativi)*/

CREATE VIEW InfoRiassuntive AS 
	SELECT EXTRACT (MONTH FROM Ril.DataRil) mese, COUNT(Repl.CodRepl) as NumRepl,G.CodGruppo,G.TipoGruppo, Repl.SpeciePianta, Repl.Orto,
		AVG(InfoAmb.pH) as pH, AVG(InfoAmb.Temperatura)as Temperatura, AVG(InfoAmb.Umidità) as Umidita
	FROM Pianta Repl JOIN Specie S ON Repl.SpeciePianta = S.NomeScientifico
		JOIN Gruppo G ON G.CodGruppo = Repl.Gruppo
		JOIN Rilevazione Ril ON Ril.Pianta = Repl.CodRepl
		JOIN InfoAmbientali InfoAmb ON InfoAmb.CodInfo = Ril.InfoAmb
	WHERE Scopo = 'Biomonitoraggio' AND EXTRACT (YEAR FROM Ril.DataRil) = 2023
	GROUP BY mese,G.CodGruppo,G.TipoGruppo, Repl.SpeciePianta, Repl.Orto; 
	
	
--INTERROGAZIONI
--Q1:Determinare le scuole che pur avendo un finanziamento per il progetto non hanno inserito rilevazioni in quest'anno scolastico

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


--Q2: Determinare le specie utilizzate in tutti i comuni (province) in cui ci sono scuole aderenti al progetto
--RE-INTERPRETAZIONE:
--Determinare le specie per cui non è possibile determinare province in cui non sono utilizzate (tutte le scuole sono aderenti al progetto)

SELECT R.SpeciePianta
FROM Pianta R
WHERE NOT EXISTS (SELECT *
				  FROM Scuola S
				  WHERE NOT EXISTS (SELECT *
									FROM Scuola S1
									JOIN Orto O ON S1.CodMec = O.Scuola
									JOIN Pianta R1 ON O.CodOrto = R1.Orto
									WHERE R1.SpeciePianta = R.SpeciePianta 
									AND S1.Prov = S.Prov)
				 )
GROUP BY R.SpeciePianta
;

--Q3:Determinare per ogni scuola l’individuo/la classe della scuola che ha effettuato più rilevazioni

SELECT CodMec, RespRil, no_ril
FROM (SELECT CodMec, RespRil, no_ril, RANK() OVER (PARTITION BY CodMec ORDER BY no_ril DESC) as rn --Or ROW_NUMBER for listing only one
	  FROM (SELECT S.CodMec, Ril.RespRil, COUNT(Ril.CodRil) as no_ril
			FROM Scuola S
			  JOIN Orto O ON O.Scuola = S.CodMec
			  JOIN Pianta Repl ON Repl.Orto = O.CodOrto
			  JOIN Rilevazione Ril ON Ril.Pianta = Repl.CodRepl
			GROUP BY S.CodMec, Ril.RespRil
		   ) t
	 ) s
WHERE s.rn = 1
ORDER BY no_ril DESC
;

--FUNZIONI
-- F1:funzione che realizza l’abbinamento tra gruppo e gruppo di controllo nel caso di operazioni di biomonitoraggio

CREATE OR REPLACE FUNCTION AbbinaGruppi() RETURNS void AS
$$
DECLARE
	CheckCodGruppo INTEGER;
	CheckTipoGruppo VARCHAR(16);
	CheckAbbinamento INTEGER;
	TempAbbinamento INTEGER;
	ContaGruppi INTEGER;
	TotGruppi REAL;
	CursoreGruppi CURSOR FOR 
		SELECT CodGruppo,TipoGruppo,AbbinatoA 
		FROM Gruppo;
BEGIN
	SELECT COUNT(*) INTO ContaGruppi FROM GRUPPO WHERE TipoGruppo='Di controllo';
	SELECT COUNT(*) INTO TotGruppi FROM GRUPPO;
	IF( ContaGruppi != (TotGruppi/2) )
	THEN
		RAISE NOTICE 'Deve esserci lo stesso numero di gruppi di controllo e da monitorare per realizzare l abbinamento!';
		RETURN;
	END IF;	
	OPEN CursoreGruppi;	
	WHILE FOUND LOOP
		BEGIN
			FETCH CursoreGruppi INTO CheckCodGruppo, CheckTipoGruppo , CheckAbbinamento;
			IF(CheckAbbinamento IS NOT NULL)
			THEN 
				CONTINUE;
			END IF;
			
			IF (CheckTipoGruppo = 'Da monitorare') THEN
					SELECT MIN(CodGruppo) INTO TempAbbinamento
									 FROM GRUPPO 
									 WHERE TipoGruppo = 'Di controllo' AND AbbinatoA IS NULL;
					IF(TempAbbinamento IS NOT NULL) THEN
						UPDATE Gruppo
						SET AbbinatoA = TempAbbinamento
						WHERE CodGruppo = CheckCodGruppo; 

						UPDATE Gruppo
						SET AbbinatoA = CheckCodGruppo
						WHERE CodGruppo = TempAbbinamento;
					END IF;	
					
			ELSEIF(CheckTipoGruppo = 'Di controllo') THEN
					SELECT MIN(CodGruppo) INTO TempAbbinamento
									 FROM GRUPPO 
									 WHERE TipoGruppo = 'Da monitorare' AND AbbinatoA IS NULL;
					IF(TempAbbinamento IS NOT NULL) THEN
						UPDATE Gruppo
						SET AbbinatoA = TempAbbinamento
						WHERE CodGruppo = CheckCodGruppo; 

						UPDATE Gruppo
						SET AbbinatoA = CheckCodGruppo
						WHERE CodGruppo = TempAbbinamento;
					END IF;					
			END IF;
			FETCH CursoreGruppi INTO CheckCodGruppo, CheckTipoGruppo , CheckAbbinamento;
		END;
	END LOOP;	
	CLOSE CursoreGruppi;
END; 
$$ LANGUAGE plpgsql; 	

SELECT AbbinaGruppi(); 

/*F2: funzione che corrisponde alla seguente query parametrica: data una replica con finalità di fitobonifica
 e due date, determina i valori medi dei parametri rilevati per tale replica nel periodo compreso tra le due date*/

CREATE OR REPLACE FUNCTION 
	ControlloParametri (IN CodiceReplica Pianta.CodRepl%TYPE, IN DataInizio TIMESTAMP, IN DataFine TIMESTAMP)
RETURNS TABLE(
	MediaLargChioma double precision,
	MediaLungChioma double precision,
	MediaPesoFrescoChioma double precision,
	MediaPesoSeccoChioma double precision,
	MediaAltPianta double precision, 
	MediaLungRadici double precision, 
	MediaPesoFrescoRadici double precision, 
	MediaPesoSeccoRadici double precision, 
	MediaNumFiori numeric, 
	MediaNumFrutti numeric,
	MediaNumFoglieDann numeric, 
	MediaSuperfDann double precision, 
	MediapH double precision, 
	MediaUmidità numeric, 
	MediaTemperatura double precision) 
AS
$$
DECLARE 
	CheckScopo VARCHAR(16);
BEGIN
	SELECT Scopo INTO STRICT CheckScopo
	FROM Specie JOIN Pianta ON NomeScientifico = SpeciePianta
	WHERE CodRepl = CodiceReplica;
	
	IF (CheckScopo = 'Fitobonifica')
	THEN
	RETURN QUERY
		SELECT AVG(LargChioma), AVG(LungChioma), AVG(PesoFrescoChioma), AVG(PesoSeccoChioma), AVG(AltPianta), AVG(LungRadici), AVG(PesoFrescoRadici), AVG(PesoSeccoRadici), AVG(NumFiori), AVG(NumFrutti), AVG(NumFoglieDann), AVG(SuperfDann), AVG(pH), AVG(Umidità), AVG(Temperatura)
		FROM InfoAmbientali
		JOIN Rilevazione Ril ON CodInfo = Ril.InfoAmb
			JOIN Pianta Repl ON Repl.CodRepl = Ril.Pianta
		WHERE Repl.CodRepl = CodiceReplica AND Ril.DataRil BETWEEN DataInizio AND DataFine;
	ELSE RAISE NOTICE 'La replica considerata non è a scopo di Fitobonifica!';
	END IF;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM ControlloParametri(1,'2022/01/10 11:53:29','2023/05/30 11:53:29');

--TRIGGER
--T1: verifica del vincolo che ogni scuola dovrebbe concentrarsi su tre specie
CREATE OR REPLACE FUNCTION ContaSpecie() RETURNS trigger AS
$$
DECLARE TempScuola VARCHAR(30);
BEGIN
	IF ((SELECT COUNT (DISTINCT SpeciePianta)
	FROM Pianta R
	JOIN Orto O ON O.CodOrto=R.Orto
	JOIN Scuola S ON O.Scuola=S.CodMec
	WHERE NEW.SpeciePianta <> R.SpeciePianta AND (SELECT S1.CodMec
													FROM Orto O1 
												  JOIN Scuola S1 ON S1.CodMec = O1.Scuola
												  WHERE NEW.Orto = O1.CodOrto) = S.CodMec 
	GROUP BY S.CodMec
	HAVING COUNT(SpeciePianta) >=3
	)>=3)
	THEN
	SELECT S.Nome INTO TempScuola
		FROM Scuola S JOIN Orto ON Scuola = CodMec
		WHERE CodOrto = NEW.Orto;
		RAISE EXCEPTION 'La Scuola % sta già monitorando 3 specie', TempScuola;
	RETURN NULL;
	ELSE
	RETURN NEW;
	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER non_piu_di_tre
BEFORE INSERT OR UPDATE ON Pianta
FOR EACH ROW
EXECUTE PROCEDURE ContaSpecie();


--T1: verifica del vincolo che ogni gruppo dovrebbe contenere 20 repliche;
CREATE OR REPLACE FUNCTION ContaRepliche() RETURNS trigger AS
$$
DECLARE
	TempGruppo INTEGER;
BEGIN
	IF ((SELECT COUNT(R.CodRepl)
		FROM Pianta R
		WHERE NEW.Gruppo = R.Gruppo
		GROUP BY R.Gruppo
		HAVING COUNT(R.CodRepl) >=20
	)>=20)
	THEN
		SELECT R.Gruppo INTO TempGruppo
		FROM Pianta R JOIN Gruppo G ON R.Gruppo = G.CodGruppo
		WHERE R.Gruppo = NEW.Gruppo;
		RAISE EXCEPTION 'Il Gruppo % contiene già 20 repliche', TempGruppo;
	ELSE
		RETURN NEW;
	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER non_piu_di_venti
BEFORE INSERT OR UPDATE ON Pianta
FOR EACH ROW
EXECUTE PROCEDURE ContaRepliche();


/*T2: generazione di un messaggio (o inserimento di una informazione di warning in qualche tabella)
quando viene rilevato un valore decrescente per un parametro di biomassa.*/

/*Abbiamo avuto problemi con i confronti nella trigger function (da riga 102):
in particolare inserendo nel campo 'larghezzachioma' valori minori di 10.1, il trigger non parte*/

CREATE OR REPLACE FUNCTION CheckParametri() RETURNS trigger AS
$$
DECLARE  
 CheckLargChioma REAL;
 CheckLungChioma REAL;
 CheckPesoFrescoChioma FLOAT(3);
 CheckPesoSeccoChioma FLOAT(3);
 CheckAltPianta REAL;
 CheckLungRadici REAL;
 NewLargChioma REAL;
 NewLungChioma REAL;
 NewPesoFrescoChioma FLOAT(3);
 NewPesoSeccoChioma FLOAT(3);
 NewAltPianta REAL;
 NewLungRadici REAL;
 
BEGIN
	SELECT largchioma,lungchioma,pesofrescochioma,pesoseccochioma,altpianta,lungradici 
	INTO CheckLargChioma, CheckLungChioma, CheckPesoFrescoChioma, CheckPesoSeccoChioma, CheckAltPianta, CheckLungRadici
	FROM InfoAmbientali JOIN Rilevazione R ON R.InfoAmb = CodInfo 
	WHERE R.Pianta = NEW.Pianta
	ORDER BY largchioma,lungchioma,pesofrescochioma,pesoseccochioma,altpianta,lungradici
	LIMIT 1;
	
	SELECT largchioma,lungchioma,pesofrescochioma,pesoseccochioma,altpianta,lungradici 
	INTO NewLargChioma, NewLungChioma, NewPesoFrescoChioma, NewPesoSeccoChioma, NewAltPianta, NewLungRadici
	FROM InfoAmbientali JOIN Rilevazione R ON NEW.InfoAmb = CodInfo
	WHERE R.Pianta = NEW.Pianta;
	
	IF (NewLargChioma < CheckLargChioma OR NewLungChioma < CheckLungChioma OR NewPesoFrescoChioma < CheckPesoFrescoChioma
	   OR NewPesoSeccoChioma < CheckPesoSeccoChioma OR NewAltPianta < CheckAltPianta OR NewLungRadici < CheckLungRadici)
	THEN
		RAISE NOTICE 'Rilevato un valore decrescente per un parametro di biomassa!';
	END IF;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER warning_parametri
AFTER INSERT ON Rilevazione
FOR EACH ROW
EXECUTE PROCEDURE CheckParametri();

