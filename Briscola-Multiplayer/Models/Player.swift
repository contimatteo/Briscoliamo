//
//  Player.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 28/12/2019.
//  Copyright © 2019 Matteo Conti. All rights reserved.
//

import Foundation


class PlayerModel {
    
    //
    // MARK: Variables
    
    var name: String;
    var index: Int;
    var type: PlayerType;
    
    var cardsHand: Array<CardModel>;
    var currentDeck: Array<CardModel> = [];
    
    var deckPoints: Int {
        get {
            var sum = 0;
            for card in currentDeck { sum += card.points; }
            return sum;
        }
    }
    
    //
    // MARK: Variables
    
    init(index: Int, initialHand: Array<CardModel>, type: PlayerType, name: String?) {
        self.index = index;
        self.cardsHand = initialHand;
        
        self.type = type;
        
        if name == nil {
            self.name = "player-\(index)";
        } else {
            self.name = name!;
        }
    }
    
    //
    // MARK: Methods
    
    func getIndex() -> Int {
        return index;
    }
    
    func playCard(card: CardModel) {
        // remove this card from {currentCardHand}.
        let cardPlayed = cardsHand.enumerated().first(where: {$0.element == card})!;
        cardsHand.remove(at: cardPlayed.offset);
    }
}
