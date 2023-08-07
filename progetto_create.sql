--DA VEDERE TIPI CODICI/CHIAVI

CREATE TABLE Persona
(CodP INTEGER PRIMARY KEY,
 Nome VARCHAR(20) NOT NULL,
 Cognome VARCHAR(20) NOT NULL,
 Email VARCHAR(32) NOT NULL,
 Telefono VARCHAR(16),
 Ruolo VARCHAR(32) NOT NULL,
 ReferenteProg BOOLEAN NOT NULL,
 PartecipaProgFin BOOLEAN NOT NULL,
 FOREIGN KEY (CodMec) REFERENCES Scuola
)

CREATE TABLE Scuola
(CodMec INTEGER PRIMARY KEY,
 Nome VARCHAR(20) NOT NULL,
 Prov CHAR(2) NOT NULL,
 CicloIstruz VARCHAR(32) NOT NULL,
 Finanziamento BOOLEAN NOT NULL,
 TipoFin VARCHAR(32),
 Collabora BOOLEAN NOT NULL,
 FOREIGN KEY (CodP) REFERENCES Persona
)

CREATE TABLE Classe
(CodC INTEGER PRIMARY KEY,
 Ordine VARCHAR(32) NOT NULL,
 TipoScuola VARCHAR(48) NOT NULL,
 FOREIGN KEY (CodP) REFERENCES Persona,
 FOREIGN KEY (CodMec) REFERENCES Scuola
)
--DA FINIRE
CREATE TABLE Responsabile
(CodResp INTEGER PRIMARY KEY,
 
)
--DA FINIRE
CREATE TABLE Rilevazione
(CodR INTEGER PRIMARY KEY,
 DataRilev TIMESTAMP NOT NULL,
 DataIns TIMESTAMP NOT NULL,
 RespRilev 
 
 FOREIGN KEY (CodInfo) REFERENCES InfoAmbientali,
 FOREIGN KEY (IDDisp) REFERENCES Dispositivo
)

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
 SuperfDann INTEGER NOT NULL,
 pH DOUBLE NOT NULL,
 Umidità INTEGER NOT NULL,
 Temperatura REAL NOT NULL,
)