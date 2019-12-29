//
//  Card.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 28/12/2019.
//  Copyright © 2019 Matteo Conti. All rights reserved.
//

import Foundation
import UIKit

public class CardModel: Equatable {
    
    public static func == (lhs: CardModel, rhs: CardModel) -> Bool {
        return lhs.number == rhs.number && lhs.type == rhs.type;
    }
    
    public var name: String;
    public var type: CardType;
    public var tag: Int = 0;
    
    public var number: Int;
    public var points: Int = 0;
    public var imageUrl: String;
    public var image: UIImage;
    
    init(type: CardType, number: Int) {
        self.type = type;
        self.number = number;
        self.name = "\(number)-\(type.rawValue)";
        
        self.imageUrl = self.name;
        self.image = UIImage(named: imageUrl)!;
        
        self._initCardPoints(number: number);
         _generateCardTag();
    }
    
    private func _generateCardTag() {
        var fromTypeToNumber = 0;
        
        switch type {
        case .bastoni:
            fromTypeToNumber = 1;
            break;
        case .denari:
            fromTypeToNumber = 2;
            break;
        case .coppe:
            fromTypeToNumber = 3;
            break;
        case .spade:
            fromTypeToNumber = 4;
            break;
        }
        
        self.tag = (fromTypeToNumber * 10) + number;
    }
    
    private func _initCardPoints(number: Int) {
        switch number {
        case 1:
            self.points = 11;
            break;
        case 3:
            self.points = 10;
            break;
        case 10:
            self.points = 4;
            break;
        case 9:
            self.points = 3;
            break;
        case 8:
            self.points = 2;
            break;
        default:
            self.points = 0;
        }
    }
}


public enum CardType: String {
    case coppe
    case bastoni
    case spade
    case denari
}
