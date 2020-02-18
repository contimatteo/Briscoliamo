//
//  SessionObjects.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 24/01/2020.
//  Copyright © 2020 Matteo Conti. All rights reserved.
//

import Foundation

//
// MARK: - SS_InitObj

class SS_InitObj: NSObject, NSCoding {
    
    var cardsDeck: [String]!;
    var senderPlayerIndex: Int!;
    var senderPlayerName: String!;
    
    required convenience init?(coder decoder: NSCoder) {
        self.init()
        self.senderPlayerName = decoder.decodeObject(forKey: "senderPlayerName") as? String;
        self.senderPlayerIndex = decoder.decodeObject(forKey: "senderPlayerIndex") as? Int;
        self.cardsDeck = decoder.decodeObject(forKey: "cardsDeck") as? [String];
    }
    
    convenience init(senderPlayerIndex: Int, cardsDeck: [String], senderPlayerName: String) {
        self.init();
        self.senderPlayerName = senderPlayerName;
        self.senderPlayerIndex = senderPlayerIndex;
        self.cardsDeck = cardsDeck;
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(senderPlayerName, forKey: "senderPlayerName");
        coder.encode(senderPlayerIndex, forKey: "senderPlayerIndex");
        coder.encode(cardsDeck, forKey: "cardsDeck");
    }
    
    func toData() -> Data {
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false);
        } catch let error as NSError {
            print("\n[ERROR] failed conversion from SS_InitObj to Data. Error: \(error.localizedDescription)");
            return Data();
        }
    }
    
    static func fromData(_ data: Data) -> SS_InitObj? {
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? SS_InitObj;
    }

}

//
// MARK: - SS_CardPlayed

class SS_CardPlayed: NSObject, NSCoding {
    
    var type: String!;
    var number: Int!;
    var senderPlayerIndex: Int!;
    
    required convenience init?(coder decoder: NSCoder) {
        self.init();
        self.type = decoder.decodeObject(forKey: "type") as? String;
        self.number = decoder.decodeObject(forKey: "number") as? Int;
        self.senderPlayerIndex = decoder.decodeObject(forKey: "senderPlayerIndex") as? Int;
    }
    
    convenience init(type: String, number: Int, senderPlayerIndex: Int) {
        self.init();
        self.type = type;
        self.number = number;
        self.senderPlayerIndex = senderPlayerIndex;
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(type, forKey: "type");
        coder.encode(number, forKey: "number");
        coder.encode(senderPlayerIndex, forKey: "senderPlayerIndex");
    }
    
    func toData() -> Data {
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false);
        } catch let error as NSError {
            print("\n[ERROR] failed conversion from SS_CardPlayed to Data. Error: \(error.localizedDescription)");
            return Data();
        }
    }
    
    static func fromData(_ data: Data) -> SS_CardPlayed? {
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? SS_CardPlayed;
    }

}
