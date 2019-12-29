//
//  BaseHandler.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 28/12/2019.
//  Copyright © 2019 Matteo Conti. All rights reserved.
//

import Foundation


// here i handle that "a player x play a card y".
public class GameHandler {
    
    //
    // MARK: Variables
    private var mode: GameType = .singleplayer;
    private let virtualDecisionMaker = VirtualDecisionMaker();
    
    public var players: Array<PlayerModel> = [];
    public var playerTurn: Int = CONSTANTS.STARTER_PLAYER_INDEX;
    public var initialCards: Array<CardModel> = [];
    public var deckCards: Array<CardModel> = [];
    public var cardsOnTable: Array<CardModel> = [];
    
    public var trumpCard: CardModel? {
        get { return initialCards.last; }
    };
    
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
        
        /// cards
        initialCards = _loadCards();
        deckCards = initialCards;
        
        /// players
        _initializePlayers(numberOfPlayers: numberOfPlayers, playersType: playersType)
    }
    
    public func playOneCard(playerIndex: Int, card: CardModel) -> Bool {
        var somethingIsChanged: Bool = false;
        
        if (playerIndex == playerTurn) {
            /// remove this card from list of availables cards.
            cardPlayed(card: card);
            /// move this card into the table.
            players[playerIndex].playCard(card: card);
            
            /// calculare next player turn.
            playerTurn = (playerTurn + 1) % CONSTANTS.NUMBER_OF_PLAYERS;
            
            somethingIsChanged = true;
        }
        
        return somethingIsChanged;
    }
    
    public func cardPlayed(card: CardModel) {
        cardsOnTable.append(card);
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
}




public enum GameType {
    case singleplayer;
    case multiplayer;
}
