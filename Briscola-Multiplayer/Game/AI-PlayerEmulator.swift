//
//  VirtualDecisionMaker.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 29/12/2019.
//  Copyright © 2019 Matteo Conti. All rights reserved.
//

import Foundation


class AIPlayerEmulator {
    //
    // MARK:
    
    private var trumpCard: CardModel;
    
    private var cardsHandClassification: Array<CardClassification> = [];
    private var cardsOnTableClassification: Array<CardClassification> = [];
    private var playerCardsHand: Array<CardModel> = [];
    private var cardsOnTable: Array<CardModel> = [];
    
    //
    // MARK:
    
    init(trumpCard: CardModel) {
        self.trumpCard = trumpCard;
    }
    
    //
    // MARK:
    
    public func playCard(playerIndex: Int, playersHands: Array<Array<CardModel>>, cardsOnTable: Array<CardModel>) -> Int {
        var cardToPlay: Int?;
        var classifToFind: CardClassification;
        let currentPlayerHand = playersHands[playerIndex];
        
        /// preparing vars used by all class' methods.
        _prepareGlobalAIVars(currentPlayerHand: currentPlayerHand, cardsOnTable: cardsOnTable);
        
        /// è già stata giocata almeno una carta ?
        if (cardsOnTable.count > 0) {
            let isPlayedByMyPartner: Bool = _isCardPlayedByMyPartner();
            
            /// c'è una briscola in tavola ?
            classifToFind = (isTrump: true, isSmooth: false, isCargo: false);
            let trumpOnTable: Bool = _existCardWithClassification(cardsOnTableClassification, cardToFind: classifToFind);
            
            /// c'è una briscola in tavola ?
            if (trumpOnTable) {
                /// l'ha giocata il mio compagno ?
                if (isPlayedByMyPartner) {
                    /// gioca il carico più alto che ho.
                    cardToPlay = _getCargo(.higher);
                    if (cardToPlay != nil) { return cardToPlay!; }
                    
                    /// gioco il liscio più basso che ho
                    cardToPlay = _getSmooth(.lower);
                    if (cardToPlay != nil) { return cardToPlay!; }
                    
                    /// gioco la briscola più bassa che ho
                    return _getTrump(.lower)!;
                } else {
                    /// gioca il liscio più alto che ho.
                    cardToPlay = _getSmooth(.higher);
                    if (cardToPlay != nil) { return cardToPlay!; }
                }
            }
        } else {
            /// gioco il liscio più basso che ho
            cardToPlay = _getSmooth(.lower);
            if (cardToPlay != nil) { return cardToPlay!; }
            
            /// gioca il carico più basso che ho.
            cardToPlay = _getCargo(.lower);
            if (cardToPlay != nil) { return cardToPlay!; }
            
            /// gioco la briscola più bassa che ho
            return _getTrump(.lower)!;
        }
        
        /// UN-REACHABLE CODE !!
        /// FIXME: this throws an error.
        return currentPlayerHand.indices.last! + 1;
    }
    
    private func _prepareGlobalAIVars(currentPlayerHand: Array<CardModel>, cardsOnTable: Array<CardModel>) {
        /// init vars.
        cardsHandClassification.removeAll();
        cardsOnTableClassification.removeAll();
        self.playerCardsHand.removeAll();
        self.cardsOnTable.removeAll();
        
        /// prepare player vars.
        self.playerCardsHand = currentPlayerHand;
        self.cardsOnTable = cardsOnTable;
        
        /// classificazione di ogni carta.
        for (cIndex, card) in cardsOnTable.enumerated() { cardsOnTableClassification.insert(_classifySingleCard(card), at: cIndex); }
        for (cIndex, card) in currentPlayerHand.enumerated() { cardsHandClassification.insert(_classifySingleCard(card), at: cIndex); }
    }
    
    private func _classifySingleCard(_ card: CardModel) -> CardClassification {
        var classification: CardClassification = (isTrump: false, isCargo: false, isSmooth: false);
        
        if (card.type == trumpCard.type) { classification.isTrump = true; }
        if (card.type != trumpCard.type && card.points > 0) { classification.isCargo = true; }
        if (card.type != trumpCard.type && card.points < 1) { classification.isSmooth = true;}
        
        return classification;
    }
    
    private func _existCardWithClassification(_ classifications: Array<CardClassification>, cardToFind cToFind: CardClassification) -> Bool {
        let cIndex = classifications.firstIndex(where: {
            $0.isTrump == cToFind.isTrump && $0.isCargo == cToFind.isCargo && $0.isSmooth == cToFind.isSmooth
        });
        
        return cIndex != nil;
    }
    
    private func _getCargo(_ searchType: CardSearchingOrder) -> Int? {
        let classifToFind = (isTrump: false, isSmooth: false, isCargo: true);
        let isCargoExist = _existCardWithClassification(cardsHandClassification, cardToFind: classifToFind);
        
        if (!isCargoExist) { return nil; }
        
        /// surely a 'cargo' cart exist!
        var cardFounded: Int = 0;
        for (cIndex, card) in playerCardsHand.enumerated() {
            if (_classifySingleCard(card).isCargo) {
                /// higher cargo
                if (searchType == .higher && card.points > playerCardsHand[cardFounded].points) {
                    cardFounded = cIndex;
                }
                /// lower cargo
                if (searchType == .lower && card.points < playerCardsHand[cardFounded].points) {
                    cardFounded = cIndex;
                }
            }
        }
        
        return cardFounded;
    }
    
    private func _getSmooth(_ searchType: CardSearchingOrder) -> Int? {
        let classifToFind = (isTrump: false, isSmooth: true, isCargo: false);
        let isCargoExist = _existCardWithClassification(cardsHandClassification, cardToFind: classifToFind);
        
        if (!isCargoExist) { return nil; }
        
        /// surely a 'cargo' cart exist!
        var cardFounded: Int = 0;
        for (cIndex, card) in playerCardsHand.enumerated() {
            if (_classifySingleCard(card).isSmooth) {
                /// higher smooth
                if (searchType == .higher && card.number > playerCardsHand[cardFounded].number) {
                    cardFounded = cIndex;
                }
                /// lower smooth
                if (searchType == .lower && card.number < playerCardsHand[cardFounded].number) {
                    cardFounded = cIndex;
                }
            }
        }
        
        return cardFounded;
    }
    
    private func _getTrump(_ searchType: CardSearchingOrder) -> Int? {
        let classifToFind = (isTrump: true, isSmooth: false, isCargo: false);
        let isCargoExist = _existCardWithClassification(cardsHandClassification, cardToFind: classifToFind);
        
        if (!isCargoExist) { return nil; }
        
        /// surely a 'cargo' cart exist!
        var cardFounded: Int = 0;
        for (cIndex, card) in playerCardsHand.enumerated() {
            if (_classifySingleCard(card).isTrump) {
                /// higher trump
                if (searchType == .higher) {
                    if (card.points > playerCardsHand[cardFounded].points) {
                        cardFounded = cIndex;
                    } else if (card.points == playerCardsHand[cardFounded].points && card.number > playerCardsHand[cardFounded].number) {
                         cardFounded = cIndex;
                    }
                }
                /// lower trump
                if (searchType == .lower) {
                    if (card.points < playerCardsHand[cardFounded].points) {
                        cardFounded = cIndex;
                    } else if (card.points == playerCardsHand[cardFounded].points && card.number < playerCardsHand[cardFounded].number) {
                         cardFounded = cIndex;
                    }
                }
            }
        }
        
        return cardFounded;
    }
    
    private func _isCardPlayedByMyPartner() -> Bool {
        /// TODO: missing logic for handling multiple players.
        return false;
    }
}


private typealias CardClassification = (isTrump: Bool, isCargo: Bool, isSmooth: Bool);
private enum CardSearchingOrder { case higher; case lower; }
