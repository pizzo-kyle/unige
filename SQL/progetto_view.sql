/*vista che fornisca alcune informazioni riassuntive per ogni attività di biomonitoraggio: per
ogni gruppo e per il corrispondente gruppo di controllo mostrare il numero di piante, la specie, l’orto in cui è
posizionato il gruppo e, su base mensile, il valore medio dei parametri ambientali e di crescita delle piante (selezionare
almeno tre parametri, quelli che si ritengono più significativi)*/
set search_path to "Progetto_BD2023";

CREATE VIEW InfoRiassuntive AS 
	SELECT EXTRACT (MONTH FROM Ril.DataRil) mese, COUNT(Repl.CodRepl) as NumRepl,G.CodGruppo,G.TipoGruppo, Repl.SpeciePianta, Repl.Orto,
		AVG(InfoAmb.pH) as pH, AVG(InfoAmb.Temperatura)as Temperatura, AVG(InfoAmb.Umidità) as Umidita
	FROM Replica Repl JOIN Specie S ON Repl.SpeciePianta = S.NomeScientifico
		JOIN Gruppo G ON G.CodGruppo = Repl.Gruppo
		JOIN Rilevazione Ril ON Ril.Replica = Repl.CodRepl
		JOIN InfoAmbientali InfoAmb ON InfoAmb.CodInfo = Ril.InfoAmb
	WHERE Scopo = 'Biomonitoraggio' AND EXTRACT (YEAR FROM Ril.DataRil) = 2023
	GROUP BY mese,G.CodGruppo,G.TipoGruppo, Repl.SpeciePianta, Repl.Orto; 
