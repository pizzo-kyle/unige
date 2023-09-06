set search_path to 'progetto_bd2023';

-- f1 funzione che realizza l’abbinamento tra gruppo e gruppo di controllo nel caso di operazioni di biomonitoraggio

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

-- f2 funzione che corrisponde alla seguente query parametrica: data una replica con finalità di fitobonifica
-- e due date, determina i valori medi dei parametri rilevati per tale replica nel periodo compreso tra le due date

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

