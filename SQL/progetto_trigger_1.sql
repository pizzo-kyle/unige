set search_path to 'Progetto_BD2023';

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

CREATE OR REPLACE FUNCTION CheckParametri() RETURNS trigger AS
$$
DECLARE 
 CheckLargChioma REAL;
 CheckLungChioma REAL;
 CheckPesoFrescoChioma FLOAT(3);
 CheckPesoSeccoChioma FLOAT(3);
 CheckAltPianta REAL;
 CheckLungRadici REAL;
BEGIN
	SELECT largchioma,lungchioma,pesofrescochioma,pesoseccochioma,altpianta,lungradici 
	INTO CheckLargChioma, CheckLungChioma, CheckPesoFrescoChioma, CheckPesoSeccoChioma, CheckAltPianta, CheckLungRadici
	FROM InfoAmbientali
	ORDER BY largchioma,lungchioma,pesofrescochioma,pesoseccochioma,altpianta,lungradici
	LIMIT 1;
	
	IF (NEW.largchioma < CheckLargChioma OR NEW.lungchioma < CheckLungChioma OR NEW.pesofrescochioma < CheckPesoFrescoChioma
	   OR NEW.pesoseccochioma < CheckPesoSeccoChioma OR NEW.altpianta < CheckAltPianta OR  NEW.lungradici < CheckLungRadici)
	THEN
		RAISE NOTICE 'Rilevato un valore decrescente per un parametro di biomassa!';
	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER warning_parametri
AFTER INSERT ON InfoAmbientali
FOR EACH ROW
EXECUTE PROCEDURE CheckParametri();