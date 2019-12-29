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
    
    private var name: String;
    private var index: Int;
    
    public var cardsHand: Array<CardModel>;
    public var currentDeck: Array<CardModel> = [];
    public var cardOnTable: CardModel?;
    
    //
    // MARK: Variables
    
    init(index: Int, initialHand: Array<CardModel>, type: PlayerType = .human) {
        self.index = index;
        self.name = "player-\(index)";
        self.cardsHand = initialHand;
    }
    
    //
    // MARK: Methods
    
    public func getIndex() -> Int {
        return index;
    }
    
    public func playCard(card: CardModel) {
        /// this card is on the table.
        /// cardOnTable = card;
        
        /// remove this card from {currentCardHand}.
        /// let cardPlayed = currentCardHand.enumerated().first(where: {$0.element == card})!;
        /// currentCardHand.remove(at: cardPlayed.offset);
    }
}

// ////////////////////////////////////////////////////////////////////////

public enum PlayerType {
    case human;
    case virtual;
}

