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
-per fare in modo che il responsabile dell'inserimento di una rilevazione sia un individuo o una classe possiamo fare in modo che i valori dell'attributo 'RespRilev' debbano essere contenuti nell'entità Classe oppure nell'entità Persona (trigger); stessa cosa per 'RespIns' quando bisogna inserirlo. In questo caso però le chiavi esterne diventano inutili.
-ritoccati i vincoli nel word

modifiche di Massimo 14/08:
-nell'ER ristrutturato:
  modificata la cardinalità della associazione tra Persona e Scuola dalla parte di Persona (da 1,1 a 0,N): 0 come minima perché possiamo avere persone che non sono per forza referenti per la scuola e N come massima perché così facendo (quindi ammettendo che una persona possa essere referente per più scuole) in fase di traduzione avremo un entità 'Referente' e risolviamo il problema dell'altra volta delle chiavi esterne 'cicliche'.
- nello schema logico:
  inserita la tabella Referente di conseguenza a quanto scritto prima
- nel word del progetto: da capire se vogliamo fare in modo che email e telefono non possano essere condivisi da due o più persone diverse, il che è sensato ma bisogna fare un vincolo apposito.
  
Nota: molto probabilmente riusciamo tramite trigger a gestire il fatto che i responsabili delle rilevazioni e degli inserimenti siano o classi o persone (perciò potremmo fare a meno dell'entità Responsabile)
