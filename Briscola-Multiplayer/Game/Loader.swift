//
//  Loader.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 28/12/2019.
//  Copyright © 2019 Matteo Conti. All rights reserved.
//

import Foundation


public class GameLoader {

    init() {}
    
    //
    // MARK: Methods
    
    func loadCards() -> Array<CardModel> {
        var initialCards: Array<CardModel> = [];
        var cards: Array<CardModel> = [];
        let types: Array<CardType> = [.bastoni, .denari, .coppe, .spade];
        
        /// load all cards images
        for type: CardType in types {
            for index in 0...9 {
                initialCards.append(CardModel.init(type: type, number: index));
            }
        }
        
        /// shuffle the cards
        while (!initialCards.isEmpty) {
            let card = initialCards.randomElement()!;
                
            initialCards.remove(at: initialCards.firstIndex(of: card)!);
            cards.append(card);
        }
        
        return cards;
    }
}



