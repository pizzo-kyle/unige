/*vista che fornisca alcune informazioni riassuntive per ogni attività di biomonitoraggio: per
ogni gruppo e per il corrispondente gruppo di controllo mostrare il numero di piante, la specie, l’orto in cui è
posizionato il gruppo e, su base mensile, il valore medio dei parametri ambientali e di crescita delle piante (selezionare
almeno tre parametri, quelli che si ritengono più significativi)*/
set search_path to "Progetto_BD2023";

CREATE VIEW InfoRiassuntive AS 
	SELECT COUNT(Repl.CodRepl),G.CodGruppo,G.TipoGruppo, Repl.SpeciePianta, Repl.Orto, InfoAmb.pH, InfoAmb.Temperatura, InfoAmb.Umidità
	FROM Replica Repl JOIN Specie S ON Repl.SpeciePianta = S.NomeScientifico
		JOIN Gruppo G ON G.CodGruppo = Repl.Gruppo
		JOIN Rilevazione Ril ON Ril.Replica = Repl.CodRepl
		JOIN InfoAmbientali InfoAmb ON InfoAmb.CodInfo = Ril.InfoAmb
	WHERE Scopo = 'Biomonitoraggio' AND Ril.DataRil BETWEEN '30/04/2021 23:59:59'   AND '31/08/2023 23:59:59'
	GROUP BY G.CodGruppo,G.TipoGruppo, Repl.SpeciePianta, Repl.Orto, InfoAmb.pH, InfoAmb.Temperatura, InfoAmb.Umidità;