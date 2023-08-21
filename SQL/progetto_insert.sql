set search_path to "Progetto_BD2023";

INSERT INTO Persona(codp,nome,cognome,email,telefono,ruolo,referenteprog,partecipaprogfin,scuola)
VALUES(3,'geo','reo','georeo@gmail.com','3365987984','docente','true','true',2);
VALUES(2,'marco','verdi','marcoverdi@gmail.com','3362587984','docente','true','false',NULL);
VALUES(1,'marco','rossi','marcorossi@gmail.com','3362857984','docente','true','false',NULL);

INSERT INTO Scuola(codmec,nome,prov,cicloistruz,finanziamento,tipofin,collabora,referente)
VALUES(2,'Tizia', 'GE', 'Primaria', 'true', 'abcdefu', 'false', 1);
VALUES(1,'Caia', 'GE', 'Primaria', 'false', NULL, 'true', 1);

INSERT INTO Classe(codc,ordine,tiposcuola,docrif,scuola)
VALUES(2,'secondario','superiore',2,2);
VALUES(1,'secondario','superiore',1,1);

INSERT INTO Responsabile
VALUES(3, 'Persona',3,NULL);
VALUES(2,'Persona',2,NULL);
VALUES(1,'Classe',NULL,1);

INSERT INTO infoambientali(codinfo,largchioma,lungchioma,pesofrescochioma,pesoseccochioma,altpianta,lungradici,pesofrescoradici,pesoseccoradici,numfiori,numfrutti,numfogliedann,superfdann,ph,umidità,temperatura)
VALUES(2,12.5,21.7,0.5,0.3,11.2,31.3,1.3,1.1,0,0,0,0,7,21,23);
VALUES(1,12.5,21.7,0.5,0.3,11.2,31.3,1.3,1.1,0,0,0,0,7,21,23);

INSERT INTO Specie(nomescientifico,nomecomune,scopo)
VALUES('Clus Nimphus', 'Clo ninfeo', 'Biomonitoraggio');
VALUES('Culus Nimphus', 'Culo ninfeo', 'Fitobotanica');

INSERT INTO orto(codorto,nome,tipo,gps,superf,pulito,adattocontrollo,scuola)
VALUES(20,'sturla','Pieno Campo','42.34, 9.56',30,'true','true',2);
VALUES(10,'boccadasse','Vaso','44.34, 8.56',30,'true','true',1);

INSERT INTO dispositivo(coddisp,tipo)
VALUES(2,'Arduino');
VALUES(1,'Sensore');

INSERT INTO replica(codrepl,gruppo,datadimora,esposizione,speciepianta,classedimora,orto,dispositivo)
VALUES(2,2,'2023/03/12','Sole/MezzOmbra','Clus Nimphus',2,20,2);
VALUES(1,1,'2023/04/12','Ombra','Culus Nimphus',1,10,1);

INSERT INTO rilevazione(codril,datarilev,datains,modacquisizione,infoamb,dispositivo,resprilev,respins)
VALUES(3, '2023/04/30', '2023/04/30', 'App', 2,2,3,1);
VALUES(2, '2023/04/30', '2023/04/30', 'App', 2,2,2,1);
VALUES(1, '2023/04/20', '2023/04/20', 'App', 1,1,1,1);