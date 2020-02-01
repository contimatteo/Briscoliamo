**INDICE**

{{TOC}}

\
\
\
\

**INFORMAZIONI GENERALI**

Studente: *Matteo Conti*
Matricola: *0000802576*
Corso: *laboratorio di applicazioni mobile*
Anno Accademico: *2018/2019*
Data: *1 Febbraio 2020*


+++


# Introduzione
Il progetto consiste nell’applicazione pratica delle conoscenze acquisite durante lo svolgimento del corso “Laboratorio di Applicazioni Mobile” presso l’Università di Bologna.
Lo scopo dell’applicazione è la riproduzione del funzionamento del gioco di carte italiano, chiamato Briscola, su dispositivi aventi sistema operativo iOS (piattaforma Apple). La versione attuale del gioco prevede la presenza di due giocatori e di due modalità di gioco. Nella prima modalità (single-player) un giocatore viene controllato da un emulatore basato su un semplice algoritmo a stati che determina la carta da giocare in base allo stato attuale del gioco. Sono state pienamente implementate tutte le regole e caratteristiche della Briscola, e quindi il comportamento dell’emulatore seguirà una strategia di gioco che rispecchia la logica dello stesso gioco. Inizieremo discutendo le caratteristiche e l’architettura generale del progetto, illustrando le funzionalità e l’implementazione alla base di ciascuna di esse. Proseguiremo illustrando le scelte attuate durante la fase di progettazione, i problemi e le difficoltà incontrate, evidenzieremo alcuni dettagli che hanno inciso sulle tempistiche di consegna e mostreremo i flussi di dati presenti all’interno dell’applicazione. Infine termineremo proponendo alcune possibili implementazioni, aggiungendo alcuni commenti relativi alla curva di apprendimento e le tecnologie a disposizione.

## Scopo dell’Applicazione
Lo scopo era quello di creare due ambienti di gioco: il primo (con la presenza di un giocatore simulato) serviva per simulare una sorta di fase iniziale di “training” (anche se non c’è un vero trainer che corregge le mosse fatte dall’utilizzatore dell’applicazione), mentre il secondo serviva per testare i propri progressi confrontandosi con altri giocatori.


+++


# Architettura generale (TODO)
Il pattern utilizzato nella realizzazione di questa applicazione è il Model-View-Controller (MVC). L’importanza di questo pattern consiste nella separazione della logica di presentazione dei dati rispetto alla logica di gestione di questi. Per questo progetto infatti, sono stati creati diversi modelli di dati corrispondenti alle varie entità in gioco (Carte, Giocatori, ..), tutti gestiti da diverse librerie di “gestione” (Handlers), le quali astraggono completamente il flusso di creazione/modifica dei dati rispetto alla loro presentazione (gestita all’interno dei Controllers).

## MVC
All’interno dell’applicazione esiste un `NavigationController` attraverso il quale  è possibile muoversi attraverso la varie view che compongono l’applicazione. Esistono infatti 4 schermate:
1. **Menù**: da qui è possibile impostare le varie opzioni di gioco e passare sia alla schermata di gioco, sia a quella “Social”.
2. **Gioco**: in questa schermata è possibile avviare il gioco e passare alla schermata dei ”Risultati”
3. **Risultati**: qui è possibile vedere il risultato della partita una volta terminata e decidere di salvarla.
4. **Social**: da qui è possible vedere la lista di tutte le partite salvate e, per ognuna, decidere se condividerla su Facebook.

Di seguito verranno riportati i principali modelli di dati utilizzati e le librerie a supporto di questi.

### Carta (TODO)
.. .. ..
Gli attributi principali sono il tipo e il numero.
.. .. ..

### Giocatore (TODO)
.. .. ..
contiene una variabile che identifica le carte che ha in mano e altre informazioni come il tipo (locale, emulatore), il nome e le carte conquistate presenti nel suo mazzo.
.. .. ..

### Gestore Gioco (TODO)
.. .. ..

### Gestore Database (TODO)
.. .. ..

### Gestore Sessione (Multipeer) (TODO)
.. .. ..

### Gestore Social (Facebook) (TODO)
.. .. ..

## Funzionalità (TODO)
.. .. ..

## Tecnologie Utilizzate (TODO)
.. .. ..
1. MultiPeer connectivity
2. CoreData
3. Facebook SDK
.. .. ..

## Requisiti Tecnici (TODO)
.. .. ..


+++


# Progettazione  (TODO)
.. .. ..

## Difficoltà e Soluzioni (TODO)
.. .. ..

## Aspetti Rilevanti per lo Sviluppo (TODO)
.. .. ..

## Use Case  (TODO)
.. .. ..

## Idee per Estensioni (TODO)
.. .. ..


+++


# Conclusione e Commenti Finali (TODO)
.. .. ..





[^Footnote1]: Danhof includes “Delaware, Maryland, all states north of the Potomac and Ohio rivers, Missouri, and states to its north” when referring to the northern states (11). 
[^Footnote2]: For the purposes of this paper, “science” is defined as it was in nineteenth century agriculture: conducting experiments and engaging in research.
[^Footnote3]: Please note that any direct quotes from the nineteenth century texts are written in their original form, which may contain grammar mistakes according to twenty-first century grammar rules.



[#Danhof]: Danhof, Clarence H. *Change in Agriculture: The Northern United States, 1820-1870*. Cambridge: Harvard UP, 1969. Print.
[#Allen]: Allen, R.L. *The American Farm Book; or Compend of American Agriculture; Being a Practical Treatise on Soils, Manures, Draining, Irrigation, Grasses, Grain, Roots, Fruits, Cotton, Tobacco, Sugar Cane, Rice, and Every Staple Product of the United States with the Best Methods of Planting, Cultivating, and Preparation for Market*. New York: Saxton, 1849. Print.

[#Baker]: Baker, Gladys L., Wayne D. Rasmussen, Vivian Wiser, and Jane M. Porter. *Century of Service: The First 100 Years of the United States Department of Agriculture*. [Federal Government], 1996. Print.

[#Demaree]: Demaree, Albert Lowther. *The American Agricultural Press 1819-1860*. New York: Columbia UP, 1941. Print.

[#Drown]: Drown, William and Solomon Drown. *Compendium of Agriculture or the Farmer’s Guide, in the Most Essential Parts of Husbandry and Gardening; Compiled from the Best American and European Publications, and the Unwritten Opinions of Experienced Cultivators*. Providence: Field, 1824. Print.

[#Census]: “Historical Census Browser.” *University of Virginia Library*. 2007. Web. 6 Dec. 2008.

[#Hurt]: Hurt, R. Douglas. *American Agriculture: A Brief History*. Ames: Iowa State UP, 1994. Print.

[#Lorain]: Lorain, John. *Nature and Reason Harmonized in the Practice of Husbandry*. Philadelphia: Carey, 1825. Print.

[#Morrill]: *Morrill Land Grant Act of 1862*. Prairie View A&M. 2003. Web. 6 Dec. 2008.

[#Nicholson]: Nicholson, John. *The Farmer’s Assistant; Being a Digest of All That Relates to Agriculture and the Conducting of Rural Affairs; Alphabetically Arranged and Adapted for the United States*. [Philadelphia]: Warner, 1820. Print.