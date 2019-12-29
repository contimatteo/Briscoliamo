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
    
    private var gameLoader: GameLoader;
    private var mode: GameType = .singleplayer;
    
    public var game: GameModel;
    public var players: Array<PlayerModel>;
    
    //
    // MARK: Initializers
    
    init() {
        game = GameModel.init();
        gameLoader = GameLoader.init();
        
        players = [];
    }
    
    //
    // MARK: Methods
    
    public func getCardFromDeck() -> CardModel? {
        return game.extractCardFromDeck();
    }
    
    public func initializeGame(mode: GameType, numberOfPlayers: Int, playersType: Array<PlayerType>) {
        /// game settings
        self.mode = mode;
        
        /// cards
        game.initialCards = gameLoader.loadCards();
        game.deckCards = game.initialCards;
        
        /// players
        _initializePlayers(numberOfPlayers: numberOfPlayers, playersType: playersType)
    }
    
    private func _initializePlayers(numberOfPlayers: Int, playersType: Array<PlayerType>) {
        for playerIndex in 0...(numberOfPlayers-1) {
            let card1 = getCardFromDeck()!;
            let card2 = getCardFromDeck()!;
            let card3 = getCardFromDeck()!;
            let initialHand: PlayerCardHand = (card1, card2, card3);
            let player = PlayerModel.init(playerName: "player-\(playerIndex)", initialHand: initialHand, type: playersType[playerIndex]);
            
            players.append(player);
        }
    }
}
