set search_path to 'Progetto_BD2023';

INSERT INTO Persona(codp,nome,cognome,email,telefono,ruolo,referenteprog,partecipaprogfin)
VALUES(4,'ert', 'cgbhf', 'djsghbjhdf', '463u345','docente','true','true'),
	  (1,'mgeo','reo','georeo@gmail.com','3365987984','docente','true','true'),
	  (2,'marco','verdi','marcoverdi@gmail.com','3362587984','docente','true','false'),
	  (3,'marco','rossi','marcorossi@gmail.com','3362857984','docente','true','false');

--DELETE FROM Persona;
--DELETE FROM Scuola;

INSERT INTO Scuola(codmec,nome,prov,cicloistruz,finanziamento,tipofin,collabora)
VALUES(4,'Mea', 'PI', 'Secondaria', 'true', 'gret', 'false'),
	  (1,'S5empronia', 'GE', 'Secondaria', 'true', 'geg', 'true'),
	  (2,'Tizia', 'GE', 'Primaria', 'true', 'abcdefu', 'false'),
	  (3,'Caia', 'GE', 'Primaria', 'false', NULL, 'true');
	  
--DELETE FROM referente;
INSERT INTO Referente(CodP,CodMec)
VALUES(1,2),(2,1),(1,1),(3,2),(3,1),(1,3),(1,4);--,(4,2),(4,4);

--DELETE FROM Classe;
INSERT INTO Classe(codc,nome,ordine,tiposcuola,docrif,scuola)
VALUES(1,'3E','secondario','superiore',2,2),
	  (2,'2F','secondario','superiore',1,1);
	  
--DELETE FROM responsabile;
INSERT INTO Responsabile
VALUES(4, 'Persona',4,NULL),
	  (1, 'Persona',3,NULL),
	  (2,'Persona',2,NULL),
	  (3,'Classe',NULL,1);

--DELETE FROM infoambientali;
INSERT INTO infoambientali(codinfo,largchioma,lungchioma,pesofrescochioma,pesoseccochioma,altpianta,lungradici,pesofrescoradici,pesoseccoradici,numfiori,numfrutti,numfogliedann,superfdann,ph,umidità,temperatura)
VALUES(2,12.5,21.7,0.5,0.3,11.2,31.3,1.3,1.1,0,0,0,0,7,21,23),
	  (1,12.5,21.7,0.5,0.3,11.2,31.3,1.3,1.1,0,0,0,0,7,21,23);

--DELETE FROM Specie;
INSERT INTO Specie(nomescientifico,nomecomune,scopo)
VALUES('Qlus Nimus', 'Qlo nimeo', 'Biomonitoraggio'),
	  ('Culus Nimphus', 'Culo ninfeo', 'Fitobonifica'),
	  ('Kadabra', 'Miciomiao', 'Biomonitoraggio'),
	  ('Alakazam', 'Miaomicio', 'Biomonitoraggio');

--DELETE FROM orto;
INSERT INTO orto(codorto,nome,tipo,gps,superf,pulito,adattocontrollo,scuola)
VALUES(1,'sturla','Pieno Campo','42.34, 9.56',30,'true','true',2),
	  (2,'boccadasse','Vaso','44.34, 8.56',30,'true','true',1),
	  (3, 'Timbuctu', 'Vaso', '12.23, 32.89',15.34,'false','false',4);

--DELETE FROM dispositivo;
INSERT INTO dispositivo(coddisp,tipo)
VALUES(2,'Arduino'),
	  (1,'Sensore'),
	  (3,'Sensore'),
	  (4,'Sensore'),
	  (5,'Arduino');

INSERT INTO gruppo(codgruppo,tipogruppo,abbinatoa,orto)
VALUES(1,'Di controllo',4,2),
	  (2,'Da monitorare',NULL,1),
	  (3,'Di controllo',NULL,3),
	  (4,'Da monitorare',1,2);

--DELETE FROM replica;
INSERT INTO replica(codrepl,datadimora,esposizione,speciepianta,classedimora,orto,dispositivo,gruppo)
VALUES(2,'2023/03/12','Sole/MezzOmbra','Qlus Nimus',2,2,2,1),
	  (1,'2023/04/12','Ombra','Culus Nimphus',1,1,1,2),
	  (3,'2022/10/04','Sole','Alakazam',2,3,4,3),
	  (4,'2021/04/07','MezzOmbra','Alakazam',1,2,3,1),
	  (6,'2022/10/04','Sole','Kadabra',1,2,3,4),
	  (7,'2023/04/12','MezzOmbra/Sole','Kadabra',2,3,5,3);

--DELETE FROM rilevazione;
INSERT INTO rilevazione(codril,dataril,datains,infoAmb,respril,respins,replica)
VALUES(3, '2023/04/30 11:53:29', '2023/04/30 22:34:56', 2,3,1,3),
	  (2, '2023/04/30 23:01:13', '2023/05/20 15:39:19', 2,2,3,4),
	  (1, '2023/04/20 03:45:06', '2023/04/25 00:12:59', 1,1,4,1),
	  (4, '2020/02/27 00:00:03', '2020/02/28 23:45:12', 2,4,4,7),
	  (5, '2010/12/23 00:00:00', '2015/10/24 21:45:11', 2,3,3,2),
	  (6, '2015/07/03 23:56:23', '2016/02/01 10:34:12', 1,4,4,3);
	  
	  
	  
	  