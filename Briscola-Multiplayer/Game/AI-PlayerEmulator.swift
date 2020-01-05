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
        
        /// CARTA IN TAVOLA
        if (cardsOnTable.count > 0) {
            /// TODO: missing multiplayer logic.
            /// let isPlayedByMyPartner: Bool = _isCardPlayedByMyPartner();
            let cardOnTable: CardModel = _getDominantCardOnTable();
            
            /// BRISCOLA IN TAVOLA
            classifToFind = (isTrump: true, isSmooth: false, isCargo: false);
            let trumpOnTable: Bool = _existCardWithClassification(cardsOnTableClassification, cardToFind: classifToFind);
            if (trumpOnTable) {
                print("\n// BRISCOLA IN TAVOLA");
                /// 1.1.1 - gioca il liscio più alto che ho.
                cardToPlay = _getSmooth(.higher);
                if (cardToPlay != nil) { return cardToPlay!; }
                /// 1.1.2 - gioco il carico più basso che ho sotto i 10 punti.
                /// cardToPlay = _getCargo(.lower, pointsRange: 1...4); /// ISSUE: this case not working
                /// if (cardToPlay != nil) { return cardToPlay!; }
                /// 1.1.3 - gioco la briscola più bassa che ho (solo se non vale dei punti).
                /// cardToPlay = _getTrump(.lower, pointsRange: 0...0);
                /// if (cardToPlay != nil) { return cardToPlay!;}
                /// 1.1.4 - gioco la briscola più bassa che ho (solo se la carta in tavola vale dei punti e la mia supera quella in tavola).
                /// cardToPlay = _getTrump(.lower, pointsRange: cardOnTable.points...11);
                /// if (cardToPlay != nil && cardOnTable.points > 0) { return cardToPlay!;}
                /// 1.1.5 - gioco il carico più basso che ho.
                cardToPlay = _getCargo(.lower);
                if (cardToPlay != nil) { return cardToPlay!; }
                /// 1.1.6 - gioco la briscola più bassa che ho.
                return _getTrump(.lower)!;
            }
            
            /// CARICO IN TAVOLA
            classifToFind = (isTrump: false, isSmooth: false, isCargo: true);
            let cargoOnTable: Bool = _existCardWithClassification(cardsOnTableClassification, cardToFind: classifToFind);
            if (cargoOnTable) {
                print("\n// CARICO IN TAVOLA");
                /// 1.2.1 - gioco il carico più alto che ho di questo tipo ma solo se supera la carta in tavola.
                /// cardToPlay = _getCargo(.higher, pointsRange: cardOnTable.points...11, withType: cardOnTable.type);
                /// if (cardToPlay != nil) { return cardToPlay!; }
                /// 1.2.2 - gioco la briscola più bassa che ho
                cardToPlay = _getTrump(.lower);
                if (cardToPlay != nil) { return cardToPlay!; }
                /// 1.2.3 - gioco il liscio più alto che ho
                cardToPlay = _getSmooth(.higher);
                if (cardToPlay != nil) { return cardToPlay!; }
                /// 1.2.4 - gioco il carico più basso che ho.
                return _getCargo(.lower)!;
            }
            
            /// LISCIO IN TAVOLA
            print("\n// LISCIO IN TAVOLA");
            /// 1.3.1 - gioco il carico più alto che ho di questo tipo (solo se è un re, un tre on un asso).
            /// cardToPlay = _getCargo(.higher, pointsRange: 4...11, withType: cardOnTable.type);
            /// if (cardToPlay != nil) { return cardToPlay!; }
            /// 1.3.2 - gioco il liscio più alto che ho non di questo tipo.
            /// cardToPlay = _getSmooth(.higher, notWithType: cardOnTable.type);
            /// if (cardToPlay != nil && currentPlayerHand[cardToPlay!].number < cardOnTable.number) { return cardToPlay!; }
            /// 1.3.2 - gioco il liscio più basso che ho di questo tipo, a patto di non superare la carta in tavola.
            /// cardToPlay = _getSmooth(.lower, withType: cardOnTable.type);
            /// if (cardToPlay != nil && currentPlayerHand[cardToPlay!].number < cardOnTable.number) { return cardToPlay!; }
            /// 1.3.3 - gioco il carico più alto che ho di questo tipo.
            /// cardToPlay = _getCargo(.higher, withType: cardOnTable.type);
            /// if (cardToPlay != nil) { return cardToPlay!; }
            /// 1.3.4 - gioco il liscio più basso che ho.
            cardToPlay = _getSmooth(.lower);
            if (cardToPlay != nil) { return cardToPlay!; }
            /// 1.3.5 - gioca il carico più basso che ho  (fante o cavallo o re)
            /// cardToPlay = _getCargo(.lower, pointsRange: 1...4);
            /// if (cardToPlay != nil) { print("//// gioca il carico più basso che ho  (fante o cavallo o re)"); return cardToPlay!; }
            /// 1.3.6 - gioca la briscola più bassa che ho senza punti.
            /// cardToPlay = _getTrump(.lower, pointsRange: 0...4);
            /// if (cardToPlay != nil) { print("//// gioca la briscola più bassa che ho senza punti."); return cardToPlay!; }
            /// 1.3.7 - gioco il carico più basso che ho.
            cardToPlay = _getCargo(.lower);
            if (cardToPlay != nil) { return cardToPlay!; }
            /// 1.3.8 - gioco la briscola più bassa che ho.
            return _getTrump(.lower)!;
        }
        
        /// NESSUNA CARTA IN TAVOLA
        /// 2.1 - gioco il liscio più basso che ho
        cardToPlay = _getSmooth(.lower);
        if (cardToPlay != nil) { return cardToPlay!; }
        /// 2.2 - gioca il carico più basso che ho.
        /// cardToPlay = _getCargo(.lower, pointsRange: 1...4);
        /// if (cardToPlay != nil) { return cardToPlay!; }
        /// 2.2 - gioca la briscola più bassa che ho.
        /// cardToPlay = _getTrump(.lower, pointsRange: 0...4);
        /// if (cardToPlay != nil) { return cardToPlay!; }
        /// 2.2 - gioca il carico più basso che ho.
        cardToPlay = _getCargo(.lower);
        if (cardToPlay != nil) { return cardToPlay!; }
        /// 2.3 - gioco la briscola più bassa che ho
        return _getTrump(.lower)!;
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
    
    private func _getCargo(_ searchType: CardSearchingOrder, pointsRange: ClosedRange<Int> = 1...11, withType: CardType? = nil, notWithType: CardType? = nil) -> Int? {
        let classifToFind = (isTrump: false, isSmooth: false, isCargo: true);
        let existCargo = _existCardWithClassification(cardsHandClassification, cardToFind: classifToFind);
        
        if (!existCargo) { return nil; }
        
        /// surely a 'cargo' cart exist!
        var cardFounded: Int = 0;
        for (cIndex, card) in playerCardsHand.enumerated() {
            if (_classifySingleCard(card).isCargo) {
                if ((withType == nil || withType! == card.type) && (notWithType == nil || notWithType! != card.type)) {
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
        }
        
        /// attention: {cardFounded} start with initial value zero, so if move this check into the for statement i'm not sure that i will find a
        /// card which has this property {points in the input range} so i could return the initial value, but not because it's the right index, but
        /// beacuse i didn't find any other correct value. So i moved this condition here.
        return  pointsRange.contains(playerCardsHand[cardFounded].points) ? cardFounded : nil;
    }
    
    private func _getSmooth(_ searchType: CardSearchingOrder, withType: CardType? = nil, notWithType: CardType? = nil) -> Int? {
        let classifToFind = (isTrump: false, isSmooth: true, isCargo: false);
        let existSmooth = _existCardWithClassification(cardsHandClassification, cardToFind: classifToFind);
        
        if (!existSmooth) { return nil; }
        
        /// surely a 'cargo' cart exist!
        var cardFounded: Int = 0;
        for (cIndex, card) in playerCardsHand.enumerated() {
            if (_classifySingleCard(card).isSmooth) {
                if((withType == nil ||  withType! == card.type) && (notWithType == nil || notWithType! != card.type)){
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
        }
        
        return cardFounded;
    }
    
    private func _getTrump(_ searchType: CardSearchingOrder, pointsRange: ClosedRange<Int> = 0...11) -> Int? {
        let classifToFind = (isTrump: true, isSmooth: false, isCargo: false);
        let existTrump = _existCardWithClassification(cardsHandClassification, cardToFind: classifToFind);
        
        if (!existTrump) { return nil; }
        
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
        
        /// attention: {cardFounded} start with initial value zero, so if move this check into the for statement i'm not sure that i will find a
        /// card which has this property {points in the input range} so i could return the initial value, but not because it's the right index, but
        /// beacuse i didn't find any other correct value. So i moved this condition here.
        return  pointsRange.contains(playerCardsHand[cardFounded].points) ? cardFounded : nil;
    }
    
    private func _isCardPlayedByMyPartner() -> Bool {
        /// TODO: missing logic for handling multiple players.
        return false;
    }
    
    private func _getDominantCardOnTable () -> CardModel {
        return cardsOnTable.first!;
    }
}


private typealias CardClassification = (isTrump: Bool, isCargo: Bool, isSmooth: Bool);
private enum CardSearchingOrder { case higher; case lower; }
