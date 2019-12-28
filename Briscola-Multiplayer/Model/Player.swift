//
//  Player.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 28/12/2019.
//  Copyright © 2019 Matteo Conti. All rights reserved.
//

import Foundation


public class PlayerModel {
    
    private var key: String;
    public var currentCardHand: PlayerCardHand;
    
    init(playerName: String, initialHand: PlayerCardHand, type: PlayerType = .human) {
        self.key = playerName;
        self.currentCardHand = initialHand;
    }
    
}

//

public enum PlayerType {
    case human;
    case virtual;
}

//

public typealias PlayerCardHand = (
    CardModel, CardModel, CardModel
);
