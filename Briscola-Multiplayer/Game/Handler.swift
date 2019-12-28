//
//  BaseHandler.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 28/12/2019.
//  Copyright © 2019 Matteo Conti. All rights reserved.
//

import Foundation


public class GameHandler {
    private var gameLoader: GameLoader;
    private var mode: GameType;
    
    //
    
    public var game: GameModel;
    public var players: Array<PlayerModel>;
    
    ///
    
    init(mode: GameType = .singleplayer) {
        self.mode = mode;
        self.game = GameModel.init();
        self.gameLoader = GameLoader.init();
        
        self.players = [];
    }
    
    //
    
    public func loadCards()  {
        self.game.deckCards = gameLoader.loadCards();
    }
    
    public func initializePlayers(numberOfPlayers: Int) {
        for playerIndex in 1...numberOfPlayers {
            let name = "player-\(playerIndex)";
                   
            let card1 = self.getCardFromDeck()!;
            let card2 = self.getCardFromDeck()!;
            let card3 = self.getCardFromDeck()!;
            let initialHand: PlayerCardHand = (card1, card2, card3);
            let player = PlayerModel.init(playerName: name, initialHand: initialHand);
            
            self.players.append(player);
        }
    }
    
    public func getCardFromDeck() -> CardModel? {
        return self.game.extractCardFromDeck();
    }
}
