//
//  BaseHandler.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 28/12/2019.
//  Copyright © 2019 Matteo Conti. All rights reserved.
//

import Foundation


public class GameHandler {
    //
    // MARK: Variables
    private var mode: GameType = .singleplayer;
    public var gameEnded: Bool = true;
    
    private var aiPlayerEmulator: AIPlayerEmulator? = nil;
    
    public var players: Array<PlayerModel> = [];
    public var playerTurn: Int = 0;
    public var initialCards: Array<CardModel> = [];
    public var deckCards: Array<CardModel> = [];
    public var cardsOnTable: Array<CardModel?> = [];
    public var trumpCard: CardModel?;
    
    //
    // MARK: Public Methods
    
    public func initSinglePlayer(numberOfPlayers: Int, localPlayerIndex: Int, playersType: [PlayerType]) {
        self.mode = .singleplayer;
        gameEnded = false;
        
        // cards
        let cards = loadCards();
        initialCards = cards;
        deckCards = cards;
        trumpCard = cards.last!;
        
        // players
        var playersType: [PlayerType] = []
        for i in 0..<numberOfPlayers {
            if (i == localPlayerIndex) {
                playersType.insert(.local, at: i);
            } else {
                playersType.insert(.emulator, at: i);
            }
        }
        _initializePlayers(numberOfPlayers: numberOfPlayers, playersType: playersType);
        
        // virtual AI assistant
        aiPlayerEmulator = AIPlayerEmulator.init(trumpCard: trumpCard!);
        
        // intialize the cards hands: this avoid error on setting specific array index.
        _initializeCardsHands()
        
        // check if the ai emulator player should start playing.
        if (players[playerTurn].type == .emulator) {
            let _ = playCard(playerIndex: playerTurn);
        }
    }
    
    public func initMultiPlayer(numberOfPlayers: Int, localPlayerIndex: Int, playersType: [PlayerType], deckCards: [CardModel]? = nil) {
        self.mode = .multiplayer;
        gameEnded = false;
        
        // cards
        var cards: [CardModel] = [];
        if (deckCards != nil) {
            cards = deckCards!; // use the share deck.
        } else {
            cards = loadCards(); // generare the deck
        }
        self.deckCards = cards;
        self.initialCards = cards;
        trumpCard = cards.last!;
        
        // players
        _initializePlayers(numberOfPlayers: numberOfPlayers, playersType: playersType);
        
        // check if i should instance the virtual AI assistant.
        if (playersType.firstIndex(where: { $0 == .emulator }) != nil) {
            aiPlayerEmulator = AIPlayerEmulator.init(trumpCard: trumpCard!);
        }
        
        // intialize the cards hands: this avoid error on setting specific array index.
        _initializeCardsHands()
        
        // check if the ai emulator player should start playing.
        // if (players[playerTurn].type == .emulator) {
        //    let _ = playCard(playerIndex: playerTurn);
        // }
    }
    
    public func playCard(playerIndex: Int, card: CardModel? = nil) -> Bool {
        if (playerIndex != playerTurn || gameEnded) { return false; }
        
        // HUMAN
        if (players[playerIndex].type != .emulator) {
            // human player play a card.
            _humanPlayCard(playerIndex: playerIndex, card: card!);
        }
        
        // EMULATOR
        //        while players[playerTurn].type == .emulator && !_hasPlayerAlreadyPlayACard(playerIndex: playerTurn) {
        //            // AI player will be play a card.
        //            _aiPlayCard(playerIndex: playerTurn);
        //        }
        
        return true;
    }
    
    public func loadCards() -> Array<CardModel> {
        var initialCards: Array<CardModel> = [];
        var cards: Array<CardModel> = [];
        let types: Array<CardType> = [.bastoni, .denari, .coppe, .spade];
        
        // load all cards images
        for type: CardType in types {
            for index in 0..<10 {
                initialCards.append(CardModel.init(type: type, number: index + 1));
            }
        }
        
        // shuffle the cards
        while (!initialCards.isEmpty) {
            let card = initialCards.randomElement()!;
            
            initialCards.remove(at: initialCards.firstIndex(of: card)!);
            cards.append(card);
        }
        
        return cards;
    }
    
    public func nextTurn() {
        playerTurn = (playerTurn + 1) % players.count;
    }
    
    public func endTurn() {
        // some player hasn't been played the card yet.
        let isTurnReadyToEnd: Bool = cardsOnTable.first(where: {$0 == nil}) == nil;
        if (!isTurnReadyToEnd) {
            return;
        }
        
        // find the winner card index (this is also the index of the winner player).
        let playerIndexWhoWinTheTurn: Int = _findWinnerCardOnTable();
        // move each card into the winner deck.
        for card in cardsOnTable {
            players[playerIndexWhoWinTheTurn].currentDeck.append(card!);
        }
        
        // set the turn to current winner player index.
        playerTurn = playerIndexWhoWinTheTurn;
        // empty the cards on table.
        cardsOnTable.removeAll();
        
        // get new card from deck.
        var newCard: CardModel? = nil;
        for player in players {
            newCard = extractCardFromDeck();
            if newCard != nil { player.cardsHand.append(newCard!); }
        }
        
        // is the game ended ?
        if (_isGameEnded()) { gameEnded = true; }
        
        // intialize the cards hands: this avoid error on setting specific array index.
        _initializeCardsHands();
        
        // play a card if the winner is a {.virtual} player
        if (players[playerIndexWhoWinTheTurn].type == .emulator) {
            let _ = playCard(playerIndex: playerTurn);
        }
    }
    
    //
    // MARK: Private Methods
    
    private func extractCardFromDeck() -> CardModel? {
        guard let card = deckCards.first else { return nil; }
        self.deckCards.remove(at: 0);
        
        return card;
    }
    
    private func _initializePlayers(numberOfPlayers: Int, playersType: Array<PlayerType>) {
        // foreach player: create the first hand and instance the model.
        for playerIndex in 0..<numberOfPlayers {
            // create an array with the initial cards (this will be the first cards hand).
            var initialHand: Array<CardModel> = [];
            for _ in 0..<CONSTANTS.PLAYER_CARDS_HAND_SISZE {
                let newCard: CardModel = extractCardFromDeck()!;
                initialHand.append(newCard);
            }
            
            // instance a new Player Model.
            let player = PlayerModel.init(index: playerIndex, initialHand: initialHand, type: playersType[playerIndex]);
            // add the player into {players} array.
            players.append(player);
        }
    }
    
    private func _humanPlayCard(playerIndex: Int, card: CardModel) {
        // move this card into the table.
        cardsOnTable[playerIndex] = card;
        
        // remove this card from player hand.
        players[playerIndex].playCard(card: card);
        
        // calculare next player turn.
        nextTurn();
    }
    
    private func _aiPlayCard(playerIndex: Int) {
        // prepare array with the hand cards of each player.
        let playersHands:Array<Array<CardModel>> = _getAllPlayersHands();
        
        // aks to AI the card to play;
        let cardToPlayIndex: Int = aiPlayerEmulator!.playCard(playerIndex: playerIndex, playersHands: playersHands, cardsOnTable: cardsOnTable);
        let cardToPlay = players[playerIndex].cardsHand[cardToPlayIndex];
        
        // move this card into the table.
        cardsOnTable[playerIndex] = cardToPlay;
        
        // remove this card from player hand.
        players[playerIndex].playCard(card: cardToPlay);
        
        // calculare next player turn.
        nextTurn();
    }
    
    private func _getAllPlayersHands() -> Array<Array<CardModel>> {
        var playersHands: Array<Array<CardModel>> = [[]];
        
        for (pIndex, player) in players.enumerated() {
            playersHands.append([]);
            for card in player.cardsHand {
                playersHands[pIndex].append(card);
            }
        }
        
        return playersHands;
    }
    
    private func _isGameEnded() -> Bool {
        let deckEmpty: Bool = deckCards.count == 0;
        
        var allPlayersHandsAreEmpty: Bool = true;
        for player in players {
            if (player.cardsHand.count > 0) {
                allPlayersHandsAreEmpty = false;
                continue;
            }
        }
        
        return deckEmpty && allPlayersHandsAreEmpty;
    }
    
    private func _findWinnerCardOnTable() -> Int {
        var winnerCardIndex: Int = cardsOnTable.firstIndex(where: {$0 != nil})!;
        let winnerCard: CardModel = cardsOnTable[winnerCardIndex]!;
        
        for (cIndex, card) in cardsOnTable.enumerated() {
            if (card != nil) {
                if (trumpCard!.type == card!.type && trumpCard!.type != winnerCard.type) { winnerCardIndex = cIndex; }
                
                if (card!.type == winnerCard.type) {
                    if (card!.points > winnerCard.points) { winnerCardIndex = cIndex; }
                    if (card!.points == winnerCard.points && card!.number > winnerCard.number) { winnerCardIndex = cIndex; }
                }
            }
        }
        
        return winnerCardIndex;
    }
    
    private func _initializeCardsHands() {
        for pIndex in players.indices { cardsOnTable.insert(nil, at: pIndex); }
    }
    
    private func _hasPlayerAlreadyPlayACard(playerIndex: Int) -> Bool {
        return players[playerIndex].cardsHand.count < CONSTANTS.PLAYER_CARDS_HAND_SISZE;
    }
    
}
