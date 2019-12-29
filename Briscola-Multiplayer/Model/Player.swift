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
    public var cardOnTable: CardModel?;
    
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
    
    public func playCard(card: CardModel) {
        /// this card is on the table.
        cardOnTable = card;
        
        /// remove this card from {currentCardHand}.
        let cardPlayed = currentCardHand.enumerated().first(where: {$0.element == card})!;
        currentCardHand.remove(at: cardPlayed.offset);
    }
}

// ////////////////////////////////////////////////////////////////////////

public enum PlayerType {
    case human;
    case virtual;
}

// ////////////////////////////////////////////////////////////////////////

public typealias PlayerCardHand = Array<CardModel>;
