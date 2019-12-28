//
//  Game.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 28/12/2019.
//  Copyright © 2019 Matteo Conti. All rights reserved.
//

import Foundation

public class GameModel {
    
    public var deckCards: Array<CardModel>;
    public var usedCards: Array<CardModel>;

    init() {
        self.deckCards = [];
        self.usedCards = [];
    }
    
    public func extractCardFromDeck() -> CardModel? {
        guard let card = self.deckCards.randomElement() else {
            return nil;
        }
                
        // moved {card} from {.deckCards} to {.usedCards}.
        self.deckCards.remove(at: self.deckCards.firstIndex(of: card)!);
        self.usedCards.append(card);
        
        return card;
    }
}


public enum GameType: String {
    case multiplayer;
    case singleplayer;
}
