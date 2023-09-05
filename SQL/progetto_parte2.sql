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

CREATE TABLE Replica
(CodRepl INTEGER PRIMARY KEY,
 DataDimora DATE NOT NULL,
 Esposizione VARCHAR(16) NOT NULL CHECK (Esposizione IN ('Sole', 'Ombra', 'MezzOmbra', 'Sole/MezzOmbra', 'MezzOmbra/Sole')),
 SpeciePianta VARCHAR(40),
 ClasseDimora INTEGER,
 Orto INTEGER,
 Dispositivo INTEGER,
 Gruppo INTEGER,
 CONSTRAINT replica_specie_fkey
 	FOREIGN KEY (SpeciePianta) REFERENCES Specie(NomeScientifico)
 	ON UPDATE CASCADE ON DELETE CASCADE,
 CONSTRAINT replica_classe_fkey
 	FOREIGN KEY (ClasseDimora) REFERENCES Classe(CodC)
 	ON UPDATE CASCADE ON DELETE CASCADE,
 CONSTRAINT replica_orto_fkey
 	FOREIGN KEY (Orto) REFERENCES Orto(CodOrto)
 	ON UPDATE CASCADE ON DELETE CASCADE,
 CONSTRAINT replica_dispositivo_fkey
	 FOREIGN KEY (Dispositivo) REFERENCES Dispositivo(CodDisp)
	 ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT replica_gruppo_fkey
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
 Replica INTEGER,
 CONSTRAINT rilevazione_infoambientali_fkey
	 FOREIGN KEY (InfoAmb) REFERENCES InfoAmbientali(CodInfo)
	 ON UPDATE CASCADE ON DELETE CASCADE,
 CONSTRAINT rilevazione_responsabile_ril_fkey
	 FOREIGN KEY (RespRil) REFERENCES Responsabile(CodResp)
	 ON UPDATE CASCADE ON DELETE NO ACTION,
 CONSTRAINT rilevazione_responsabile_ins_fkey
	 FOREIGN KEY (RespIns) REFERENCES Responsabile(CodResp)
	 ON UPDATE CASCADE ON DELETE NO ACTION,
 CONSTRAINT rilevazione_replica_fkey
 	 FOREIGN KEY (Replica) REFERENCES Replica(CodRepl)
	 ON UPDATE CASCADE ON DELETE CASCADE,
 CONSTRAINT dataril_ins_check
 	 CHECK (DataIns >= DataRil)
);

--VISTA
/*vista che fornisca alcune informazioni riassuntive per ogni attività di biomonitoraggio: per
ogni gruppo e per il corrispondente gruppo di controllo mostrare il numero di piante, la specie, l’orto in cui è
posizionato il gruppo e, su base mensile, il valore medio dei parametri ambientali e di crescita delle piante (selezionare
almeno tre parametri, quelli che si ritengono più significativi)*/

CREATE VIEW InfoRiassuntive AS 
	SELECT EXTRACT (MONTH FROM Ril.DataRil) mese, COUNT(Repl.CodRepl) as NumRepl,G.CodGruppo,G.TipoGruppo, Repl.SpeciePianta, Repl.Orto,
		AVG(InfoAmb.pH) as pH, AVG(InfoAmb.Temperatura)as Temperatura, AVG(InfoAmb.Umidità) as Umidita
	FROM Replica Repl JOIN Specie S ON Repl.SpeciePianta = S.NomeScientifico
		JOIN Gruppo G ON G.CodGruppo = Repl.Gruppo
		JOIN Rilevazione Ril ON Ril.Replica = Repl.CodRepl
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

--Q3:Determinare per ogni scuola l’individuo/la classe della scuola che ha effettuato più rilevazioni

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

--FUNZIONI
-- F1:funzione che realizza l’abbinamento tra gruppo e gruppo di controllo nel caso di operazioni di biomonitoraggio

CREATE OR REPLACE FUNCTION AbbinaGruppi() RETURNS void AS
$$
DECLARE
	CheckCodGruppo INTEGER;
	CheckTipoGruppo VARCHAR(16);
	CheckAbbinamento INTEGER;
	TempAbbinamento INTEGER = ;
	CursoreGruppi CURSOR FOR 
		SELECT CodGruppo,TipoGruppo,AbbinatoA 
		FROM Gruppo;
BEGIN
	OPEN CursoreGruppi;
	FETCH CursoreGruppi INTO CheckCodGruppo, CheckTipoGruppo , CheckAbbinamento;
	WHILE FOUND LOOP
		BEGIN
			IF (CheckTipoGruppo = 'Da monitorare' ) THEN
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
					
			ELSEIF(CheckTipoGruppo = 'Di controllo' ) THEN
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
	ControlloParametri (IN CodiceReplica Replica.CodRepl%TYPE, IN DataInizio TIMESTAMP, IN DataFine TIMESTAMP)
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
	FROM Specie JOIN Replica ON NomeScientifico = SpeciePianta
	WHERE CodRepl = CodiceReplica;
	
	IF (CheckScopo = 'Fitobonifica')
	THEN
	RETURN QUERY
		SELECT AVG(LargChioma), AVG(LungChioma), AVG(PesoFrescoChioma), AVG(PesoSeccoChioma), AVG(AltPianta), AVG(LungRadici), AVG(PesoFrescoRadici), AVG(PesoSeccoRadici), AVG(NumFiori), AVG(NumFrutti), AVG(NumFoglieDann), AVG(SuperfDann), AVG(pH), AVG(Umidità), AVG(Temperatura)
		FROM InfoAmbientali
		JOIN Rilevazione Ril ON CodInfo = Ril.InfoAmb
			JOIN Replica Repl ON Repl.CodRepl = Ril.Replica
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
	FROM REPLICA R
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
BEFORE INSERT OR UPDATE ON Replica
FOR EACH ROW
EXECUTE PROCEDURE ContaSpecie();


--T1: verifica del vincolo che ogni gruppo dovrebbe contenere 20 repliche;
CREATE OR REPLACE FUNCTION ContaRepliche() RETURNS trigger AS
$$
DECLARE
	TempGruppo INTEGER;
BEGIN
	IF ((SELECT COUNT(R.CodRepl)
		FROM REPLICA R
		WHERE NEW.Gruppo = R.Gruppo
		GROUP BY R.Gruppo
		HAVING COUNT(R.CodRepl) >=20
	)>=20)
	THEN
		SELECT R.Gruppo INTO TempGruppo
		FROM Replica R JOIN Gruppo G ON R.Gruppo = G.CodGruppo
		WHERE R.Gruppo = NEW.Gruppo;
		RAISE EXCEPTION 'Il Gruppo % contiene già 20 repliche', TempGruppo;
	ELSE
		RETURN NEW;
	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER non_piu_di_venti
BEFORE INSERT OR UPDATE ON Replica
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
	WHERE R.Replica = NEW.Replica
	ORDER BY largchioma,lungchioma,pesofrescochioma,pesoseccochioma,altpianta,lungradici
	LIMIT 1;
	
	SELECT largchioma,lungchioma,pesofrescochioma,pesoseccochioma,altpianta,lungradici 
	INTO NewLargChioma, NewLungChioma, NewPesoFrescoChioma, NewPesoSeccoChioma, NewAltPianta, NewLungRadici
	FROM InfoAmbientali JOIN Rilevazione R ON NEW.InfoAmb = CodInfo
	WHERE R.Replica = NEW.Replica;
	
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

