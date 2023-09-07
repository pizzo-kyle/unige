set search_path to 'progetto_bd2023';
--CARICO DI LAVORO 

--Determinare il numero totale di piante per ogni orto pulito
SELECT O.CodOrto, COUNT(R.CodRepl)
FROM Pianta R 
  JOIN Orto O ON R.Orto = O.CodOrto
WHERE O.Pulito = TRUE  
GROUP BY O.CodOrto;

--Determinare le repliche messe a dimora in vaso in data odierna
SELECT R.CodRepl, O.CodOrto
FROM Pianta R 
  JOIN Orto O ON R.Orto = O.CodOrto
WHERE DataDimora = CURRENT_DATE AND Tipo = 'Vaso';

--Per ogni rilevazione antecedente alla data odierna, determinare da chi è stata effettuata
SELECT Ril.CodRil, R.CodResp, R.Tipo
FROM Rilevazione Ril 
  JOIN Responsabile R ON Ril.RespRil = R.CodResp
WHERE DataRil < CURRENT_DATE;

--INDICI

--Indici per query 1 del workload
CREATE INDEX idx_orto_codorto
ON Orto(CodOrto);
CLUSTER Orto
USING idx_orto_codorto;

CREATE INDEX idx_pianta_orto
ON Pianta(Orto);
CLUSTER Pianta
USING idx_pianta_orto;

--Indici per query 2 del workload
CREATE INDEX idx_pianta_datadimora
ON Pianta USING HASH (DataDimora);

CREATE INDEX idx_orto_tipo
ON Orto USING HASH (Tipo);

--Indice per query 3 del workload
CREATE INDEX idx_rilevazione_dataril
ON Rilevazione(DataRil);
CLUSTER Rilevazione
USING idx_rilevazione_dataril;

CREATE INDEX idx_responsabile_codresp
ON Responsabile (CodResp);
CLUSTER Responsabile
USING idx_responsabile_codresp;

--GESTIONE ACCESSO
CREATE USER ProfRossi PASSWORD 'ProfRossi';
CREATE USER PresideBianchi PASSWORD 'PresideBianchi';
CREATE USER Gestore PASSWORD 'Gestore';
CREATE USER StudenteVerdi PASSWORD 'StudenteVerdi';

CREATE ROLE Insegnante; 
CREATE ROLE ReferenteScuola;
CREATE ROLE Gestoreprogetto;
CREATE ROLE Studente;

GRANT ALL PRIVILEGES 
ON Persona TO Gestoreprogetto
WITH GRANT OPTION;
GRANT ALL PRIVILEGES 
ON Scuola TO Gestoreprogetto
WITH GRANT OPTION;
GRANT ALL PRIVILEGES 
ON Referente TO Gestoreprogetto
WITH GRANT OPTION;
GRANT ALL PRIVILEGES 
ON Classe TO Gestoreprogetto
WITH GRANT OPTION;
GRANT ALL PRIVILEGES 
ON Responsabile TO Gestoreprogetto
WITH GRANT OPTION;
GRANT ALL PRIVILEGES 
ON Rilevazione TO Gestoreprogetto
WITH GRANT OPTION;GRANT ALL PRIVILEGES 
ON InfoAmbientali TO Gestoreprogetto
WITH GRANT OPTION;
GRANT ALL PRIVILEGES 
ON Dispositivo TO Gestoreprogetto
WITH GRANT OPTION;
GRANT ALL PRIVILEGES 
ON Pianta TO Gestoreprogetto
WITH GRANT OPTION;
GRANT ALL PRIVILEGES 
ON Gruppo TO Gestoreprogetto
WITH GRANT OPTION;
GRANT ALL PRIVILEGES 
ON Specie TO Gestoreprogetto
WITH GRANT OPTION;
GRANT ALL PRIVILEGES 
ON Orto TO Gestoreprogetto
WITH GRANT OPTION;


GRANT select,insert,update 
	ON Persona
	TO Insegnante,ReferenteScuola,Studente;

GRANT select
	ON Scuola
	TO Insegnante,ReferenteScuola,Studente;
GRANT insert,update
	ON Scuola
	TO ReferenteScuola;	
	
GRANT select
	ON Referente
	TO Insegnante,ReferenteScuola;
GRANT insert,update
	ON Referente
	TO ReferenteScuola;	
	
GRANT select
	ON Classe
	TO Insegnante,ReferenteScuola,Studente;
GRANT insert,update
	ON Classe
	TO Insegnante;	

GRANT select,insert,update
	ON Responsabile
	TO Insegnante,Studente;	
	
GRANT select,insert,update
	ON Rilevazione
	TO Insegnante,Studente;	

GRANT select,insert,update
	ON InfoAmbientali
	TO Insegnante,Studente;	
	
GRANT select
	ON Dispositivo
	TO Insegnante,Studente;

GRANT select
	ON Pianta
	TO Insegnante,Studente;
GRANT insert,update
	ON Pianta
	TO Studente;
	
GRANT select
	ON Gruppo
	TO Insegnante,Studente;
GRANT insert,update
	ON Gruppo
	TO Studente;

GRANT select
	ON Specie
	TO Insegnante,Studente;
GRANT insert,update
	ON Specie
	TO Studente;

GRANT select
	ON Orto
	TO Insegnante,Studente;

GRANT Insegnante TO ProfRossi;
GRANT ReferenteScuola TO PresideBianchi;
GRANT Gestoreprogetto TO Gestore;
GRANT Studente TO StudenteVerdi;

GRANT USAGE ON SCHEMA Progetto_BD2023 TO ProfRossi;
GRANT USAGE ON SCHEMA Progetto_BD2023 TO PresideBianchi;
GRANT USAGE ON SCHEMA Progetto_BD2023 TO Gestore;
GRANT USAGE ON SCHEMA progetto_bd2023 TO Studente;

