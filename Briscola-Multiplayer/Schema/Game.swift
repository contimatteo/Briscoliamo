//
//  Game.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 28/12/2019.
//  Copyright © 2019 Matteo Conti. All rights reserved.
//

import Foundation

class GameModel {
    
    public var cards: Array<CardModel>;

    init() {
        self.cards = [];
    }
}


public enum GameType: String {
    case multiplayer;
    case singleplayer;
}
