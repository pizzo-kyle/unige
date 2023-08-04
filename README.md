# unige

modifiche di Massimo 29/07:
-aggiunto nello schema logico la chiave esterna ClasseDimora a Replica (ce l'eravamo scordata)
-modificato il nome della chiave esterna da Specie a Replica, da 'NomePianta' a 'SpeciePianta' (un po' più intuitivo)
-aggiunte le chiavi esterne di alcune associazioni 1 a molti

modifiche di Massimo 01/08:
-modificate alcune cardinalità di relazione nell'ER ristrutturato e rinominata un associazione(modifiche in rosso)
-bisogna capire se è giusta la rappresentazione attuale delle relazioni tra Classe, Persona e Rilevazione 


modifiche di Massimo 04/08:
-rimosso nell'ER ristrutturato l'indentificatore esterno tra Specie e Replica in quanto la chiave esterna verrà poi presa in fase di traduzione (tutte le modifiche dell'ER ristruttarato vanno portate nell'ER)
-aggiunte nello schema logico le chiavi esterne 'ClasseRilev' e 'IndividuoRilev'
-per fare in modo che il responsabile dell'inserimento di una rilevazione sia un individuo o una classe possiamo fare in modo che i valori dell'attributo 'RespRilev' debbano essere contenuti nell'entità Classe oppure nell'entità Persona. Oppure ancora potremmo eliminare l'attributo 'RespRilev' e utilizzare 'ClasseRilev' e 'IndividuoRilev'
