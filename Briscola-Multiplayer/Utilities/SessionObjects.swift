//
//  SessionObjects.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 24/01/2020.
//  Copyright © 2020 Matteo Conti. All rights reserved.
//

import Foundation

//
// MARK: Session

class SS_InitObj: NSObject, NSCoding {
    // var cardsDeck: [CardModel]!;
    var senderPlayerIndex: Int!;
    
    required convenience init?(coder decoder: NSCoder) {
        self.init()
        self.senderPlayerIndex = decoder.decodeObject(forKey: "senderPlayerIndex") as? Int
        // self.cardsDeck = decoder.decodeObject(forKey: "cardsDeck") as? [CardModel]
    }
    
    convenience init(senderPlayerIndex: Int, cardsDeck: [CardModel]) {
        self.init()
        self.senderPlayerIndex = senderPlayerIndex;
        // self.cardsDeck = cardsDeck;
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(senderPlayerIndex, forKey: "senderPlayerIndex");
        // coder.encode(cardsDeck, forKey: "cardsDeck");
    }
    
    func toData() -> Data {
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false);
        } catch let _ as NSError {
            return Data();
        }
    }
    
    static func fromData(_ data: Data) -> SS_InitObj? {
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? SS_InitObj;
    }
}

class SS_InitConfirmationObj: NSObject, NSCoding {
    var cardsDeckReceived: Bool!;
    var message: SS_Message!;
    
    required convenience init?(coder decoder: NSCoder) {
        self.init()
        self.cardsDeckReceived = decoder.decodeObject(forKey: "cardsDeckReceived") as? Bool
        self.message = decoder.decodeObject(forKey: "message") as? SS_Message
    }
    
    convenience init(cardsDeckReceived: Bool, message: SS_Message) {
        self.init()
        self.cardsDeckReceived = cardsDeckReceived;
        self.message = message;
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(cardsDeckReceived, forKey: "cardsDeckReceived");
        coder.encode(message, forKey: "message");
    }
}
