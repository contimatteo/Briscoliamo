//
//  Game.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 28/12/2019.
//  Copyright © 2019 Matteo Conti. All rights reserved.
//

import Foundation


// here i handle that "a card y was played" (and not by who).
public class GameModel {
    
    //
    // MARK: Variables
    
    public var initialCards: Array<CardModel>;
    public var deckCards: Array<CardModel>;
    public var usedCards: Array<CardModel>;
    public var cardsOnTable: Array<CardModel>;
    
    public var trumpCard: CardModel? {
        get {
            return initialCards.last;
        }
    };
    
    //
    // MARK: Initializers
    
    init() {
        initialCards = [];
        deckCards = [];
        usedCards = [];
        cardsOnTable = [];
    }
    
    //
    // MARK: Methods
    
    public func extractCardFromDeck() -> CardModel? {
        guard let card = deckCards.first else { return nil; }
        
        // moved {card} from {.deckCards} to {.usedCards}.
        self.deckCards.remove(at: 0);
        // self.usedCards.append(card);
        
        return card;
    }
    
    public func cardPlayed(card: CardModel) {
        cardsOnTable.append(card);
    }
    
    public func turnEnded(card: CardModel) {
        for (index, card) in cardsOnTable.enumerated() {
            usedCards.append(card);
            cardsOnTable.remove(at: index);
        }
    }
}


public enum GameType: String {
    case multiplayer;
    case singleplayer;
}
