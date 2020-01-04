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
    private var playercardsHand: Array<CardModel> = [];
    private var cardsOnTable: Array<CardModel> = [];
    
    //
    // MARK:
    
    init(trumpCard: CardModel) {
        self.trumpCard = trumpCard;
    }
    
    //
    // MARK:
    
    // ritorna l'indice della carta nella mano del giocatore in posizione {playerIndex}
    public func playCard(playerIndex: Int, playersHands: Array<Array<CardModel>>, cardsOnTable: Array<CardModel>) -> Int {
        var cardToPlay: Int?;
        var classifToFind: CardClassification;
        let currentPlayerHand = playersHands[playerIndex];
        
        /// preparing vars used by all class' methods.
        _prepareGlobalAIVars(currentPlayerHand: currentPlayerHand, cardsOnTable: cardsOnTable);
        
        /// ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /// ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        /// è già stata giocata almeno una carta ?
        if (cardsOnTable.count > 0) {
            /// let firstCard = cardsOnTable.first!;
            ///
            /// TODO: ...
            let isPlayedByMyPartner: Bool = false;
            
            /// c'è una briscola in tavola ?
            classifToFind = (isTrump: true, isSmooth: false, isCargo: false);
            let trumpOnTable: Bool = _existCardWithClassification(cardsOnTableClassification, cardToFind: classifToFind);
            
            if (trumpOnTable) {
                /// c'è una briscola in tavola.
                classifToFind = (isTrump: false, isSmooth: true, isCargo: false);
                
                /// se ho un liscio gioco quello.
                let playerHasASmooth: Bool = _existCardWithClassification(cardsHandClassification, cardToFind: classifToFind);
                if (playerHasASmooth) {
                    if (isPlayedByMyPartner) {
                        /// gioca il carico più alto che ho.
                        cardToPlay = _getCargo(.higher);
                        if (cardToPlay != nil) { return cardToPlay!; }
                    } else {
                        /// gioca il liscio più basso che ho.
                        cardToPlay = _getSmooth(.lower);
                        if (cardToPlay != nil) { return cardToPlay!; }
                    }
                }
            }
        } else {
        }
        
        /// ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /// ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        /// FIXME: remove this logic.
        return currentPlayerHand.indices.randomElement()!;
    }
    
    private func _prepareGlobalAIVars(currentPlayerHand: Array<CardModel>, cardsOnTable: Array<CardModel>) {
        /// init vars.
        cardsHandClassification.removeAll();
        cardsOnTableClassification.removeAll();
        self.playercardsHand.removeAll();
        self.cardsOnTable.removeAll();
        
        /// prepare player vars.
        self.playercardsHand = currentPlayerHand;
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
    
    //    private func _existsCardWithPartialClassification(_ classifications: Array<CardClassification>, cardToFind cToFind: CardClassification) -> Bool {
    //         let cIndex = classifications.firstIndex(where: {
    //            (cToFind.briscola == nil || $0.briscola == cToFind.briscola) &&
    //                (cToFind.carico == nil || $0.carico == cToFind.carico) &&
    //                (cToFind.liscio == nil || $0.liscio == cToFind.liscio)
    //        });
    //
    //         return cIndex != nil;
    //    }
    
    private func _getCargo(_ searchType: CardSearchingOrder) -> Int? {
        let classifToFind = (isTrump: true, isSmooth: false, isCargo: false);
        let isCargoExist = _existCardWithClassification(cardsHandClassification, cardToFind: classifToFind);
        
        if (!isCargoExist) { return nil; }
        
        /// surely a 'cargo' cart exist!
        var cardFounded: Int = 0;
        for (cIndex, card) in playercardsHand.enumerated() {
            if (_classifySingleCard(card).isCargo) {
                /// higher cargo
                if (searchType == .higher && card.points > playerHand[cardFounded].points) {
                    cardFounded = cIndex;
                }
                /// lower cargo
                if (searchType == .lower && card.points < playerHand[cardFounded].points) {
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
        for (cIndex, card) in playercardsHand.enumerated() {
            if (_classifySingleCard(card).isCargo) {
                /// higher smooth
                if (searchType == .higher && card.number > playerHand[cardFounded].number) {
                    cardFounded = cIndex;
                }
                /// lower smooth
                if (searchType == .lower && card.number < playerHand[cardFounded].number) {
                    cardFounded = cIndex;
                }
            }
        }
        
        return cardFounded;
    }
}


//private typealias CardClassification2 = ( lowerPoints: Int, higherPoints: Int, lowerNumber: Int, higherNumber: Int);
//private typealias CardClassification3 = (
//    trumpHigher: Int?, /// briscola
//    trumpLower: Int?,
//    cargoHigher: Int?, /// carico
//    cargoLower: Int?,
//    smoothHigher: Int?, /// liscio
//    smoothLower: Int?
//);
private typealias CardClassification = (isTrump: Bool, isCargo: Bool, isSmooth: Bool);
private enum CardSearchingOrder { case higher; case lower; }
