//
//  Player.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 28/12/2019.
//  Copyright © 2019 Matteo Conti. All rights reserved.
//

import Foundation


public class PlayerModel {
    
    //
    // MARK: Variables
    
    private var key: String;
    private var index: Int;
    public var currentCardHand: PlayerCardHand;
    
    //
    // MARK: Variables
    
    init(index: Int, initialHand: PlayerCardHand, type: PlayerType = .human) {
        self.index = index;
        self.key = "player-\(index)";
        self.currentCardHand = initialHand;
    }
    
    //
    // MARK: Methods
    
    public func getIndex() -> Int {
        return index;
    }
}

// ////////////////////////////////////////////////////////////////////////

public enum PlayerType {
    case human;
    case virtual;
}

// ////////////////////////////////////////////////////////////////////////

public typealias PlayerCardHand = Array<CardModel>;
