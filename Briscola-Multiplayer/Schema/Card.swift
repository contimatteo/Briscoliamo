//
//  Card.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 28/12/2019.
//  Copyright © 2019 Matteo Conti. All rights reserved.
//

import Foundation

class CardModel {
    public var type: CardType;
    public var number: Int8;
    public var imageUrl: String;
    
    init(type: CardType, number: Int8) {
        self.type = type;
        self.number = number;
        self.imageUrl = "Assets.xcassets/Cards/\(self.number)-\(self.type.rawValue)";
    }
    
    init(type: CardType, number: Int8, imageUrl: String) {
        self.type = type;
        self.number = number;
        self.imageUrl = imageUrl;
    }
}


public enum CardType: String {
    case coppe
    case bastoni
    case spade
    case denari
}
