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
    public var turnEnded: Bool = false;
    public var gameEnded: Bool = true;
    
    private var aiPlayerEmulator: AIPlayerEmulator? = nil;
    
    public var players: Array<PlayerModel> = [];
    public var playerTurn: Int = CONSTANTS.STARTER_PLAYER_INDEX;
    public var initialCards: Array<CardModel> = [];
    public var deckCards: Array<CardModel> = [];
    public var cardsOnTable: Array<CardModel> = [];
    public var trumpCard: CardModel?;
    
    //
    // MARK: Public Methods
    
    public func extractCardFromDeck() -> CardModel? {
        guard let card = deckCards.first else { return nil; }
        self.deckCards.remove(at: 0);
        
        return card;
    }
    
    public func initializeGame(mode: GameType, numberOfPlayers: Int, playersType: Array<PlayerType>) {
        /// game settings
        self.mode = mode;
        gameEnded = false;
        turnEnded = true;
        
        /// cards
        let cards = _loadCards();
        initialCards = cards;
        deckCards = cards;
        trumpCard = cards.last!;
        
        /// players
        _initializePlayers(numberOfPlayers: numberOfPlayers, playersType: playersType);
        
        /// virtual AI assistant
        aiPlayerEmulator = AIPlayerEmulator.init(trumpCard: trumpCard!);
    }
    
    public func playCard(playerIndex: Int, card: CardModel) {
        if (playerIndex != playerTurn || !turnEnded || gameEnded) { return; }
        
        turnEnded = false;
        
        /// human player play a card.
        _humanPlayCard(playerIndex: playerIndex, card: card);
        
        /// ai will generate a choice foreach fake player.
        for pIndex in players.indices {
            if (pIndex != playerIndex) {
                _aiPlayCard(playerIndex: pIndex);
            }
        }
    }
    
    public func nextTurn() {
        playerTurn = (playerTurn + 1) % CONSTANTS.NUMBER_OF_PLAYERS;
    }
    
    public func endTurn() {
        var newCard: CardModel? = nil;
        for player in players {
            newCard = extractCardFromDeck();
            if newCard != nil {
                player.cardsHand.append(newCard!);
            }
        }
        
        /// move each card into the winner deck.
        let playerIndexWhoWinTheTurn = 0;
        for card in cardsOnTable {
            players[playerIndexWhoWinTheTurn].currentDeck.append(card);
        }
        
        /// empty the cards on table.
        cardsOnTable.removeAll();
        
        /// end the turn.
        turnEnded = true;
        
        if (_isGameEnded()) { gameEnded = true; }
    }
    
    //
    // MARK: Private Methods
    
    private func _loadCards() -> Array<CardModel> {
        var initialCards: Array<CardModel> = [];
        var cards: Array<CardModel> = [];
        let types: Array<CardType> = [.bastoni, .denari, .coppe, .spade];
        
        /// load all cards images
        for type: CardType in types {
            for index in 0..<10 {
                initialCards.append(CardModel.init(type: type, number: index + 1));
            }
        }
        
        /// shuffle the cards
        while (!initialCards.isEmpty) {
            let card = initialCards.randomElement()!;
            
            initialCards.remove(at: initialCards.firstIndex(of: card)!);
            cards.append(card);
        }
        
        return cards;
    }
    
    private func _initializePlayers(numberOfPlayers: Int, playersType: Array<PlayerType>) {
        /// foreach player: create the first hand and instance the model.
        for playerIndex in 0..<numberOfPlayers {
            /// create an array with the initial cards (this will be the first cards hand).
            var initialHand: Array<CardModel> = [];
            for _ in 0..<CONSTANTS.PLAYER_CARDS_HAND_SISZE {
                let newCard: CardModel = extractCardFromDeck()!;
                initialHand.append(newCard);
            }
            
            /// instance a new Player Model.
            let player = PlayerModel.init(index: playerIndex, initialHand: initialHand, type: playersType[playerIndex]);
            /// add the player into {players} array.
            players.append(player);
        }
    }
    
    private func _humanPlayCard(playerIndex: Int, card: CardModel) {
        /// move this card into the table.
        /// cardsOnTable[playerIndex] = card;
        cardsOnTable.insert(card, at: playerIndex);
        
        /// remove this card from player hand.
        players[playerIndex].playCard(card: card);
        
        /// calculare next player turn.
        nextTurn();
    }
    
    private func _aiPlayCard(playerIndex: Int) {
        /// prepare array with the hand cards of each player.
        let playersHands:Array<Array<CardModel>> = _getAllPlayersHands();
        
        /// aks to AI the card to play;
        let cardToPlayIndex: Int = aiPlayerEmulator!.playCard(playerIndex: playerIndex, playersHands: playersHands, cardsOnTable: cardsOnTable);
        print("PLAYER \(playerIndex) play the card \(cardToPlayIndex) \n");
        let cardToPlay = players[playerIndex].cardsHand[cardToPlayIndex];
        
        /// move this card into the table.
        cardsOnTable.insert(cardToPlay, at: playerIndex);
        
        /// remove this card from player hand.
        players[playerIndex].playCard(card: cardToPlay);
        
        /// calculare next player turn.
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
}



public enum GameType {
    case singleplayer;
    case multiplayer;
}
