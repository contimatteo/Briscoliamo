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
    public var type: PlayerType;
    
    public var deckPoints: Int {
        get {
            var sum = 0;
            for card in currentDeck { sum += card.points; }
            return sum;
        }
    }
    
    //
    // MARK: Variables
    
    init(index: Int, initialHand: Array<CardModel>, type: PlayerType = .human) {
        self.index = index;
        self.name = "player-\(index)";
        self.cardsHand = initialHand;
        
        self.type = type;
    }
    
    //
    // MARK: Methods
    
    public func getIndex() -> Int {
        return index;
    }
    
    public func playCard(card: CardModel) {
        /// remove this card from {currentCardHand}.
        let cardPlayed = cardsHand.enumerated().first(where: {$0.element == card})!;
        cardsHand.remove(at: cardPlayed.offset);
    }
}

// ////////////////////////////////////////////////////////////////////////

public enum PlayerType {
    case human;
    case virtual;
}

