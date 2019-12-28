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
    
    func loadCards() -> Array<CardModel> {
        var cards: Array<CardModel> = [];
        let types: Array<CardType> = [.bastoni, .denari, .coppe, .spade];
        
        for type: CardType in types {
            for index in 1...10 {
                cards.append(CardModel.init(type: type, number: index));
            }
        }
        
        return cards;
    }
}



