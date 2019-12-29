//
//  Game.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 28/12/2019.
//  Copyright © 2019 Matteo Conti. All rights reserved.
//

import Foundation

public class GameModel {
    
    //
    // MARK: Variables
    
    public var initialCards: Array<CardModel>;
    public var deckCards: Array<CardModel>;
    public var usedCards: Array<CardModel>;
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
    }
    
    //
    // MARK: Methods
    
    public func extractCardFromDeck() -> CardModel? {
        guard let card = deckCards.first else { return nil; }
        
        // moved {card} from {.deckCards} to {.usedCards}.
        self.deckCards.remove(at: 0);
        self.usedCards.append(card);
        
        return card;
    }
    
    /// TODO: remove this function.
    private func _extractRandomCardFromDeck() -> CardModel? {
        ///        guard let card = self.deckCards.randomElement() else { return nil; }
        ///
        ///       /// moved {card} from {.deckCards} to {.usedCards}.
        ///        self.deckCards.remove(at: self.deckCards.firstIndex(of: card)!);
        ///        self.usedCards.append(card);
        ///
        ///        return card;
        return nil;
    }
}


public enum GameType: String {
    case multiplayer;
    case singleplayer;
}
