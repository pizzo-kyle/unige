set search_path to 'Progetto_BD2023';

--DA VEDERE TIPI CODICI/CHIAVI

CREATE TABLE Persona
(CodP INTEGER PRIMARY KEY,
 Nome VARCHAR(20) NOT NULL,
 Cognome VARCHAR(20) NOT NULL,
 Email VARCHAR(32) NOT NULL,
 Telefono VARCHAR(16),
 Ruolo VARCHAR(32) NOT NULL,
 ReferenteProg BOOLEAN NOT NULL,
 PartecipaProgFin BOOLEAN NOT NULL
 --,FOREIGN KEY (CodMec) REFERENCES Scuola
);

CREATE TABLE Scuola
(CodMec INTEGER PRIMARY KEY,
 Nome VARCHAR(20) NOT NULL,
 Prov CHAR(2) NOT NULL,
 CicloIstruz VARCHAR(32) NOT NULL,
 Finanziamento BOOLEAN NOT NULL,
 TipoFin VARCHAR(32),
 Collabora BOOLEAN NOT NULL,
 Referente INTEGER NOT NULL,
 FOREIGN KEY (Referente) REFERENCES Persona(CodP)
);

CREATE TABLE Classe
(CodC INTEGER PRIMARY KEY,
 Ordine VARCHAR(32) NOT NULL,
 TipoScuola VARCHAR(48) NOT NULL,
 DocRif INTEGER NOT NULL,
 Scuola INTEGER NOT NULL,
 FOREIGN KEY (DocRif) REFERENCES Persona(CodP),
 FOREIGN KEY (Scuola) REFERENCES Scuola(CodMec)
);

CREATE TABLE Responsabile
(CodResp INTEGER PRIMARY KEY,
 Tipo VARCHAR(16) NOT NULL CHECK (Tipo IN ('Persona', 'Classe')),
 IndividuoResp INTEGER NOT NULL,
 ClasseResp INTEGER NOT NULL,
 FOREIGN KEY (IndividuoResp) REFERENCES Persona(CodP),
 FOREIGN KEY (ClasseResp) REFERENCES Classe(CodC)
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
 Scopo VARCHAR(16) NOT NULL CHECK (Scopo IN ('Biomonitoraggio', 'Fitobotanica')),
 TotRepliche INTEGER NOT NULL
);

CREATE TABLE Orto
(CodOrto INTEGER PRIMARY KEY,
 Nome VARCHAR(20) NOT NULL,
 Tipo VARCHAR(16) NOT NULL CHECK (Tipo IN ('Vaso', 'Pieno Campo')),
 GPS FLOAT(10) NOT NULL,
 Superf DOUBLE PRECISION NOT NULL,
 Pulito BOOLEAN NOT NULL,
 AdattoControllo BOOLEAN NOT NULL,
 NumSensori INTEGER NOT NULL,
 TipoSensori VARCHAR(16) NOT NULL CHECK (TipoSensori IN ('Sensore', 'Arduino')),
 Scuola INTEGER NOT NULL,
 --FOREIGN KEY (IDReplica) REFERENCES Replica(IDReplica),
 FOREIGN KEY (Scuola) REFERENCES Scuola(CodMec)
);

CREATE TABLE Replica
(IDReplica INTEGER PRIMARY KEY,
 Gruppo VARCHAR(40) NOT NULL,
 DataDimora DATE NOT NULL,
 Esposizione VARCHAR(16) NOT NULL CHECK (Esposizione IN ('Sole', 'Ombra', 'MezzOmbra')),
 SpeciePianta VARCHAR(40) NOT NULL,
 ClasseDimora INTEGER NOT NULL,
 Orto INTEGER NOT NULL,
 Dispositivo INTEGER NOT NULL,
 FOREIGN KEY (SpeciePianta) REFERENCES Specie(NomeScientifico),
 FOREIGN KEY (ClasseDimora) REFERENCES Classe(CodC),
 FOREIGN KEY (Orto) REFERENCES Orto(CodOrto)
 --, FOREIGN KEY (Dispositivo) REFERENCES Dispositivo(IDDisp)
);

CREATE TABLE Dispositivo
(IDDisp INTEGER PRIMARY KEY,
 Tipo VARCHAR(16) NOT NULL CHECK (Tipo IN ('Sensore', 'Arduino')),
 IDReplica INTEGER NOT NULL,
 FOREIGN KEY (IDReplica) REFERENCES Replica(IDReplica)
);

CREATE TABLE Rilevazione
(CodR INTEGER PRIMARY KEY,
 DataRilev TIMESTAMP NOT NULL,
 DataIns TIMESTAMP NOT NULL,
 RespIns VARCHAR(40),
 ModAcquisizione VARCHAR(16) NOT NULL CHECK (ModAcquisizione IN ('App', 'Base di Dati')),
 InfoAmb INTEGER NOT NULL,
 Dispositivo INTEGER NOT NULL,
 RespRilev INTEGER NOT NULL,
 FOREIGN KEY (InfoAmb) REFERENCES InfoAmbientali(CodInfo),
 FOREIGN KEY (Dispositivo) REFERENCES Dispositivo(IDDisp),
 FOREIGN KEY (RespRilev) REFERENCES Responsabile(CodResp)
);