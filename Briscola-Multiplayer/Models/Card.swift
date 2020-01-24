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
    
    //
    // MARK: Protocol Adapters
    
    public static func == (lhs: CardModel, rhs: CardModel) -> Bool {
        return lhs.number == rhs.number && lhs.type == rhs.type;
    }
    
    //
    // MARK: Variables
    
    public var name: String;
    public var type: CardType;
    public var tag: Int = 0;
    
    public var number: Int;
    public var points: Int;
    public var imageUrl: String;
    public var image: UIImage;
    
    public var hasPoints: Bool { get { return points > 0; } }
    
    //
    // MARK: Initialzers
    
    init(type: CardType, number: Int) {
        // card descriptor
        self.type = type;
        self.number = number;
        name = "\(number)-\(type.rawValue)";
        points = 0;
        
        // image
        imageUrl = self.name;
        image = UIImage(named: imageUrl)!;
        
        // points
        _initCardPoints(number: number);
        
        // generate unique tag.
        _generateCardTag();
    }
    
    //
    // MARK: Methods
    
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


public enum CardType: String, Equatable {
    case coppe
    case bastoni
    case spade
    case denari
}
