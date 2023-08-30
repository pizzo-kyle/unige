set search_path to "Progetto_BD2023";

-- f1 funzione che realizza l’abbinamento tra gruppo e gruppo di controllo nel caso di operazioni di biomonitoraggio

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
			IF (CheckTipoGruppo = 'Da monitorare' /*AND CheckAbbinamento IS NULL*/) THEN
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
					
			/*ELSEIF (CheckTipoGruppo = 'Da monitorare' AND CheckAbbinamento IS NOT NULL) THEN
					UPDATE Gruppo
					SET AbbinatoA = (SELECT CodGruppo
									 FROM Gruppo 
									 WHERE AbbinatoA = CheckCodGruppo)
					WHERE CodGruppo = CheckAbbinamento;
			END IF;		*/
			ELSEIF(CheckTipoGruppo = 'Di controllo' /*AND CheckAbbinamento IS NULL*/) THEN
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
					/*UPDATE Gruppo
					SET AbbinatoA = (SELECT MIN(CodGruppo)
									 FROM GRUPPO 
									 WHERE TipoGruppo = 'Da monitorare' AND AbbinatoA IS NULL)/* AND CodGruppo NOT IN (SELECT AbbinatoA FROM Gruppo)CodGruppo <> CheckCodGruppo AND CodGruppo NOT IN (SELECT AbbinatoA FROM Gruppo WHERE AbbinatoA <> CodGruppo))*/
					WHERE CodGruppo = CheckCodGruppo;	*/		 				
			/*ELSEIF (CheckTipoGruppo = 'Di controllo' AND CheckAbbinamento IS NOT NULL) THEN
					UPDATE Gruppo
					SET AbbinatoA = CodGruppo
					WHERE CodGruppo = CheckAbbinamento;*/
				
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

