set search_path to 'progetto_bd2023';

--DELETE FROM Persona;
INSERT INTO Persona(codp,nome,cognome,email,telefono,ruolo,referenteprog,partecipaprogfin)
VALUES(4,'ert', 'cgbhf', 'djsghbjhdf', '463u345','docente','true','true'),
	  (1,'mgeo','reo','georeo@gmail.com','3365987984','docente','true','true'),
	  (2,'marco','verdi','marcoverdi@gmail.com','3362587984','docente','true','false'),
	  (3,'marco','rossi','marcorossi@gmail.com','3362857984','docente','true','false');

--DELETE FROM Scuola;
INSERT INTO Scuola(codmec,nome,prov,cicloistruz,finanziamento,tipofin,collabora)
VALUES(4,'Mea', 'PI', 'Secondaria', 'true', 'gret', 'false'),
	  (1,'S5empronia', 'GE', 'Secondaria', 'true', 'geg', 'true'),
	  (2,'Tizia', 'GE', 'Primaria', 'true', 'abcdefu', 'false'),
	  (3,'Caia', 'GE', 'Primaria', 'false', NULL, 'true');

--DELETE FROM referente;
INSERT INTO Referente(CodP,CodMec)
VALUES(1,2),(2,1),(1,1),(3,2),(3,1),(1,3),(1,4);

--DELETE FROM Classe;
INSERT INTO Classe(codc,nome,ordine,tiposcuola,docrif,scuola)
VALUES(1,'3E','secondario','superiore',2,2),
	  (2,'2F','secondario','superiore',1,1)
	  (3,'2B', 'secondaria', 'agrario',3,3);

--DELETE FROM responsabile;
INSERT INTO Responsabile
VALUES(4, 'Persona',4,NULL),
	  (1, 'Persona',3,NULL),
	  (2,'Persona',2,NULL),
	  (3,'Classe',NULL,1);

--DELETE FROM infoambientali;
INSERT INTO infoambientali(codinfo,largchioma,lungchioma,pesofrescochioma,pesoseccochioma,altpianta,lungradici,pesofrescoradici,pesoseccoradici,numfiori,numfrutti,numfogliedann,superfdann,ph,umidità,temperatura)
VALUES(2,10.2,18.0,1.7,0.9,8.7,15.2,4.7,2.8,3,0,0,0,7,19,26),
	  (1,12.5,21.7,0.5,0.3,11.2,31.3,1.3,1.1,0,0,0,0,7,21,23),
	  (3,15.0,21.8,2.3,1.5,14.2,22.6,5.9,3.9,12,5,3,0.1,6,24,20),
	  (4,19.0,11.8,5.7,2.2,13.2,15.9,6.4,4.9,10,0,19,1.1,6,22,43),
	  (5,10.1,11.8,0.6,0.4,4.2,7.9,2.4,1.9,2,1,8,4.1,4,15,37);

--DELETE FROM Specie;
INSERT INTO Specie(nomescientifico,nomecomune,scopo)
VALUES('Solanum lycopersicum', 'Pomodoro', 'Biomonitoraggio'),
	  ('Ocimum basilicum', 'Basilico', 'Fitobonifica'),
	  ('Tulipa', 'Tulipano', 'Biomonitoraggio'),
	  ('Hyacinthus', 'Giacinto', 'Biomonitoraggio'),
	  ('Narcissus', 'Narciso', 'Fitobonifica');

--DELETE FROM orto;
INSERT INTO orto(codorto,nome,tipo,gps,superf,pulito,adattocontrollo,scuola)
VALUES(1,'sturla','Pieno Campo','42.34, 9.56',30,'true','false',2),
	  (2,'boccadasse','Vaso','44.34, 8.56',30,'false','false',1),
	  (3, 'Timbuctu', 'Vaso', '12.23, 32.89',15.34,'false','false',4)
	  (4,'Tikitaka', 'Vaso', '02.13, 11.69',09.24,'true','true',3);

--DELETE FROM dispositivo;
INSERT INTO dispositivo(coddisp,tipo)
VALUES(2,'Arduino'),
	  (1,'Sensore'),
	  (3,'Sensore'),
	  (4,'Sensore'),
	  (5,'Arduino');

--DELETE FROM gruppo;
INSERT INTO gruppo(codgruppo,tipogruppo,abbinatoa,orto)
VALUES(1,'Di controllo',4,4),
	  (2,'Da monitorare',NULL,3),
	  (3,'Di controllo',NULL,4),
	  (4,'Da monitorare',1,2)
	  (5,'Da monitorare',NULL,3),
	  (6,'Di controllo',NULL,1);
	  

--DELETE FROM replica;
INSERT INTO replica(codrepl,datadimora,esposizione,speciepianta,classedimora,orto,dispositivo,gruppo)
VALUES(2,'2023/03/12','Sole/MezzOmbra','Solanum lycopersicum',2,2,2,1),
	  (1,'2023/04/12','Ombra','Ocimum basilicum',1,1,1,2),
	  (3,'2022/10/04','Sole','Hyacinthus',2,1,4,3),
	  (4,'2021/04/07','MezzOmbra','Hyacinthus',1,2,3,1),
	  (5,'2021/04/07','MezzOmbra','Tulipa',1,1,3,1),
	  (6,'2022/10/04','Sole','Tulipa',1,2,3,4),
	  (7,'2023/04/12','MezzOmbra/Sole','Tulipa',2,3,5,3),
	  (8,'2021/04/07','Sole','Ocimum basilicum',1,3,2,2),
	  (9,'2021/04/07','MezzOmbra','Hyacinthus',1,3,3,3) ,
	  (10,'2023/09/03','MezzOmbra','Tulipa',3,4,3,5) ,
	  (11,'2023/09/03','MezzOmbra','Narcissus',3,4,3,5);
	  --(12,'2021/04/07','MezzOmbra','Narcissus',1,3,3,1);

	   
--DELETE FROM rilevazione;
INSERT INTO rilevazione(codril,dataril,datains,infoAmb,respril,respins,replica)
VALUES(3, '2023/04/30 11:53:29', '2023/04/30 22:34:56', 2,3,1,3),
	  (2, '2023/09/01 23:01:13', '2023/09/02 05:39:19', 2,2,3,4),
	  (1, '2023/04/20 03:45:06', '2023/04/25 00:12:59', 1,1,4,1),
	  (4, '2020/02/27 00:00:03', '2020/02/28 23:45:12', 2,4,4,7),
	  (5, '2010/12/23 00:00:00', '2015/10/24 21:45:11', 2,3,3,2),
	  (6, '2015/07/03 23:56:23', '2016/02/01 10:34:12', 1,4,4,3),
	  (7, '2023/09/02 10:01:13', '2023/09/02 10:39:19', 1,3,3,4),
	  (8, '2023/08/15 10:01:13', '2023/08/22 10:39:19', 4,3,3,4);



