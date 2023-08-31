set search_path to 'Progetto_BD2023';

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


CREATE TRIGGER SPECIE3
BEFORE INSERT OR UPDATE ON REPLICA
FOR EACH ROW EXECUTE PROCEDURE ContaSpecie();

