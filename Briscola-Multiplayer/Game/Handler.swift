//
//  BaseHandler.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 28/12/2019.
//  Copyright © 2019 Matteo Conti. All rights reserved.
//

import Foundation


public class GameHandler {
    
    private var mode: GameType;
    public var game: GameModel;
    private var gameLoader: GameLoader;
    
    
    init(mode: GameType = .singleplayer) {
        self.mode = mode;
        self.game = GameModel.init();
        self.gameLoader = GameLoader.init();
    }
    
    public func loadCards()  {
        self.game.deckCards = gameLoader.loadCards();
    }
    
    public func getCardFromDeck() -> CardModel? {
        return self.game.extractCardFromDeck();
    }
}
