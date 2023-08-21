set search_path to 'Progetto_BD2023';

--DA VEDERE TIPI CODICI/CHIAVI

CREATE TABLE Persona
(CodP INTEGER PRIMARY KEY,
 Nome VARCHAR(20) NOT NULL,
 Cognome VARCHAR(20) NOT NULL,
 Email VARCHAR(48) NOT NULL,
 Telefono VARCHAR(16),
 Ruolo VARCHAR(32) NOT NULL,
 ReferenteProg BOOLEAN NOT NULL,
 PartecipaProgFin BOOLEAN NOT NULL,
);

CREATE TABLE Scuola
(CodMec INTEGER PRIMARY KEY,
 Nome VARCHAR(20) NOT NULL,
 Prov CHAR(2) NOT NULL,
 CicloIstruz VARCHAR(32) NOT NULL,
 Finanziamento BOOLEAN NOT NULL,
 TipoFin VARCHAR(32),
 Collabora BOOLEAN NOT NULL,
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

--ALTER TABLE Classe
--ADD COLUMN Nome VARCHAR(4) NOT NULL;

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
 	ON UPDATE CASCADE ON DELETE CASCADE
);

--A XOR B
--(A AND NOT B) OR (NOT A AND B)
ALTER TABLE Responsabile
 ADD CONSTRAINT ck_xor_resp --not both initialized
 CHECK ((IndividuoResp IS NOT NULL AND ClasseResp IS NULL) OR (IndividuoResp IS NULL AND ClasseResp IS NOT NULL))
;

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
 Scopo VARCHAR(16) NOT NULL CHECK (Scopo IN ('Biomonitoraggio', 'Fitobotanica'))
);

CREATE TABLE Orto
(CodOrto INTEGER PRIMARY KEY,
 Nome VARCHAR(20) NOT NULL,
 Tipo VARCHAR(16) NOT NULL CHECK (Tipo IN ('Vaso', 'Pieno Campo')),
 GPS VARCHAR(40)) NOT NULL,
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

CREATE TABLE Replica
(CodRepl INTEGER PRIMARY KEY,
 Gruppo VARCHAR(16) NOT NULL CHECK (Gruppo IN ('Di controllo', 'Da monitorare', 'Fitobotanica')),
 DataDimora DATE NOT NULL,
 Esposizione VARCHAR(16) NOT NULL CHECK (Esposizione IN ('Sole', 'Ombra', 'MezzOmbra', 'Sole/MezzOmbra', 'MezzOmbra/Sole')),
 SpeciePianta VARCHAR(40),
 ClasseDimora INTEGER,
 Orto INTEGER,
 Dispositivo INTEGER,
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
	 ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Rilevazione
(CodRil INTEGER PRIMARY KEY,
 DataRilev TIMESTAMP NOT NULL,
 DataIns TIMESTAMP NOT NULL,
 ModAcquisizione VARCHAR(16) NOT NULL CHECK (ModAcquisizione IN ('App', 'Base di Dati')),
 InfoAmb INTEGER,
 Dispositivo INTEGER,
 RespRilev INTEGER,
 RespIns INTEGER,
 CONSTRAINT rilevazione_infoambientali_fkey
	 FOREIGN KEY (InfoAmb) REFERENCES InfoAmbientali(CodInfo)
	 ON UPDATE CASCADE ON DELETE CASCADE,
 CONSTRAINT rilevazione_dispositivo_fkey
	 FOREIGN KEY (Dispositivo) REFERENCES Dispositivo(CodDisp)
	 ON UPDATE CASCADE ON DELETE CASCADE,
 CONSTRAINT rilevazione_responsabile_p_fkey
	 FOREIGN KEY (RespRilev) REFERENCES Responsabile(CodResp)
	 ON UPDATE CASCADE ON DELETE NO ACTION,
 CONSTRAINT rilevazione_responsabile_c_fkey
	 FOREIGN KEY (RespIns) REFERENCES Responsabile(CodResp)
	 ON UPDATE CASCADE ON DELETE NO ACTION
);