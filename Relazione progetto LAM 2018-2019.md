**INDICE**

{{TOC}}

\
\

**INFORMAZIONI GENERALI**

- Studente: *Matteo Conti*
- Matricola: *0000802576*
- Corso: *laboratorio di applicazioni mobile*
- Anno Accademico: *2018/2019*
- Data: *1 Febbraio 2020*


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

### Carta (Modello Dati) (TODO)
.. .. ..
Gli attributi principali sono il tipo e il numero.
.. .. ..

### Giocatore (Modello Dati) (TODO)
.. .. ..
contiene una variabile che identifica le carte che ha in mano e altre informazioni come il tipo (locale, emulatore), il nome e le carte conquistate presenti nel suo mazzo.
.. .. ..

### Gestore Gioco (TODO)
.. .. ..

### Gestore Database (CoreData) (TODO)
.. .. ..

### Gestore Sessione (MultiPeer) (TODO)
.. .. ..

### Gestore Social (Facebook) (TODO)
.. .. ..

### Emulatore
Questa classe si occupa di simulare la presenza (in modalità single-player) di un giocatore reale con cui giocare. È stata realizzata, infatti, come una macchina a stati che in base alla configurazione delle carte in tavola e quelle in mano (dell’emulatore) elabora uno stato finale, che si traduce nella scelta di una carta da giocare (chiaramente tra quelle che ha in mano).
Sono stati individuati due macro stati: il primo è quello nel quale l’emulatore si trova a dover giocare per primo, mentre il secondo è quando si trova a giocare per secondo (e abbiamo quindi già una carta in tavola).
Di seguito riportiamo la sequenza di scelte dalla macchina a stati, dove quest’ultima si bloccherà al primo stato di match trovato nella sequenza di scelte disponibili.

#### Nessuna carta in tavola
L’emulatore è il primo a giocare.
1. gioco il liscio più basso che ho
2. gioca il carico più basso che ho.
3. gioca la briscola più bassa che ho.
4. gioca il carico più basso che ho.
5. gioco la briscola più bassa che ho

#### C’è già una carta in tavola
L’emulatore è il secondo a giocatore. La sequenza di scelte varia in base al tipo della carta giocata:

##### Briscola
1. gioca il liscio più alto che ho.
2. gioco il carico più basso che ho sotto i 10 punti.
3. gioco la briscola più bassa che ho (solo se non vale dei punti).
4. gioco la briscola più bassa che ho (solo se la carta in tavola vale dei punti e la mia supera quella in tavola).
5. gioco il carico più basso che ho.
6. gioco la briscola più bassa che ho.

##### Carico
1. gioco il carico più alto che ho di questo tipo ma solo se supera la carta in tavola.
2. gioco la briscola più bassa che ho.
3. gioco il liscio più alto che ho
4. gioco il carico più basso che ho.

##### Liscio
1. gioco il carico più alto che ho di questo tipo (solo se è un re, un tre on un asso).
2. gioco il liscio più alto che ho non di questo tipo.
3. gioco il liscio più basso che ho di questo tipo, a patto di non superare la carta in tavola.
4. gioco il carico più alto che ho di questo tipo.
5. gioco il liscio più basso che ho.
6. gioca il carico più basso che ho  (fante o cavallo o re)
7. gioca la briscola più bassa che ho senza punti.
8. gioco il carico più basso che ho.
9. gioco la briscola più bassa che ho.

## Funzionalità (TODO)
.. .. ..

### Interfaccia Grafica (TODO)
.. .. ..
La Figura sottostante mostra ciò che l’utente vede nel momento in cui viene avviata la partita. Notiamo come le nostre carte sono scoperte (al contrario di quelle dell’avversario) e per poter giocare una carta è necessario toccarla. Una volta che anche il nostro avversario (emulatore/giocatore remoto) avrà giocato una carta, il vincente della mano si aggiudicherà le carte, ed esse verranno aggiunte al suo mazzo (non visibile), e automaticamente verrà distribuita una nuova carta (ad ogni giocatore) e la mano sarà pronta per iniziare (partirà il giocatore che ha vinto quella precedente)

FLUSSO IMMAGINI: gioco da iniziare, gioco iniziato, una carta giocata, due carte giocate.
.. .. ..

### Flusso Dati (TODO)
.. .. ..

## Tecnologie Utilizzate
1. MultiPeer Connectivity [#swift-multipeer]: questa libreria supporta la scoperta di servizi forniti da dispositivi vicini e supporta la comunicazione con tali servizi attraverso dati basati su messaggi. In iOS, il framework utilizza reti Wi-Fi infrastrutturali, Wi-Fi peer-to-peer e reti personali Bluetooth per il trasporto sottostante. 
2. CoreData [#swift-coredata]: questa libreria consente di salvare i dati permanenti di un’applicazione per l'utilizzo offline e di memorizzare nella cache i dati temporanei (database in locale).
3. Facebook SDK [#swift-facebook-sdk]: questa libreria consente di utilizzare tutte le principali SDK di Facebook per applicazioni iOS. In particolare in questo progetto sono state utilizzare le API per la condivisione di link e testo.


## Requisiti Tecnici
- Piattaforma: *Apple*
- Sistema *Operativo: iOS (versione 13.2)*
- Editor: *Xcode (versione 11.2.1)*
- Linguaggio di Programmazione: *Swift (versione 5.0)*


+++


# Progettazione  (TODO)
.. .. ..

## Difficoltà e Soluzioni (TODO)
.. .. ..

## Aspetti Rilevanti per lo Sviluppo (TODO)
.. .. ..

## Use Case  (TODO)
.. .. ..

## Possibili Estensioni e Miglioramenti (TODO)
Lista di alcuni possibili miglioramenti:
1. Rendere ancora più intelligente l’emulatore.
2. Aggiungere la possibilità di scegliere il dispositivo con cui giocare (all’interno della sessione).
3. Aggiungere diversi livelli di difficoltà e rendere questa opzione configurabile (ad esempio nel menù iniziale).
4. Migliorare la grafica e aggiungere le animazioni.
5. Aggiungere i constraint per tablet e landscape mode. 

Lista di alcune possibili estensioni:
1. Disegnare le carte in AR (tramite ARKit).
2. Aggiungere anche le modalità con 3, 4 e 5 giocatori.
3. Sincronizzare il database in locale con uno remoto in modo da non perdere i progressi (es: Realm, ..)


+++


# Conclusione e Commenti Finali (TODO)
.. .. ..
Questo progetto ha dato l’opportunità di approfondire meglio le tecniche di sviluppo nel campo di iOS e le strategie di programmazione di questo campo, in oltre la scelta di progettare un gioco ha permesso una trattazione di alcuni aspetti molto importanti dal punto di vista grafico e di come integrare scenari animati all’interno di una applicazione. Un’altro aspetto molto importante e intrigante è stato quello di creare un avversario che possa comportarsi autonomamente, una specie di intelligenza artificiale. La realizzazione di un ente intelligente di questo genere è un procedimento che cerca di simulare un comportamento razionale in grado di percepire ed arricchire le proprie conoscenze e di agire di conseguenza con lo scopo di raggiungere il suo obbiettivo, ovvero vincere la partita di briscola. Affinché esso possa raggiungere il suo scopo è stata definita una strategia di gioco che esso seguirà per raggiungere il suo scopo .
.. .. ..



[#swift-multipeer]: [The MultiPeer Connectivity framework](https://developer.apple.com/documentation/multipeerconnectivity) supports the discovery of services provided by nearby devices and supports communicating with those services through message-based data, streaming data, and resources (such as files). In iOS, the framework uses infrastructure Wi-Fi networks, peer-to-peer Wi-Fi, and Bluetooth personal area networks for the underlying transport. In macOS and tvOS, it uses infrastructure Wi-Fi, peer-to-peer Wi-Fi, and Ethernet. 
[#swift-coredata]: Use [Core Data](https://developer.apple.com/documentation/coredata) to save your application’s permanent data for offline use, to cache temporary data, and to add undo functionality to your app on a single device.Through Core Data’s Data Model editor, you define your data’s types and relationships, and generate respective class definitions. Core Data can then manage object instances at runtime to provide the following features.
[#swift-facebook-sdk]: The [Facebook SDK](https://developers.facebook.com/docs/swift/) for Swift allows you to use all of the core Facebook SDK for iOS APIs which includes: Facebook Login, Share and Send App Events and Graph API.
