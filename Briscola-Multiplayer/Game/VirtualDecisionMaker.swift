//
//  VirtualDecisionMaker.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 29/12/2019.
//  Copyright © 2019 Matteo Conti. All rights reserved.
//

import Foundation




class VirtualDecisionMaker {
    //
    // MARK:
    
    private var trumpCard: CardModel;
    
    //
    // MARK:
    
    init(trumpCard: CardModel) {
        self.trumpCard = trumpCard;
    }
    
    //
    // MARK:
    
    // ritorna l'indice della carta nella mano del giocatore in posizione {playerIndex}
    public func playCard(playerIndex: Int, playersHands: Array<Array<CardModel>>, cardsOnTable: Array<CardModel>) -> Int {
        /// let classification = _classifyPlayerHand(playersHands[playerIndex]);
        
        if (_oneCardIsAlreadyPlayed(cardsOnTable)) {
            
        } else {
            /// ho un liscio in mano ?
        }
        
        /// FIXME: remove this logic.
        return playersHands[playerIndex].indices.randomElement()!;
    }
    
    private func _classifyPlayerHand(_ hand: Array<CardModel>) -> CardClassification {
        /// var cWithMinPoints : Int = 0;
        /// var cWithMaxPoints : Int = 0;
        /// var cLower: Int = 0;
        /// var cHigher : Int = 0;
        
        /// for (index, card) in hand.enumerated() {
        ///     /// card with min points.
        ///     if (card.points < hand[cWithMinPoints].points) { cWithMinPoints = index; }
        ///
        ///     /// card with max points.
        ///     if (card.points > hand[cWithMaxPoints].points) { cWithMaxPoints = index; }
        ///
        ///     /// card with min points.
        ///     if (card.number < hand[cLower].number) { cLower = index; }
        ///
        ///     /// card with min points.
        ///     if (card.number > hand[cHigher].number) { cHigher = index; }
        /// }
        
        return (lowerPoints: -1, higherPoints: -1, lowerNumber: -1, higherNumber: -1);
    }
    
    private func _oneCardIsAlreadyPlayed(_ cardsOnTable: Array<CardModel>) -> Bool {
        return cardsOnTable.count > 0;
    }
}


private typealias CardClassification = ( lowerPoints: Int, higherPoints: Int, lowerNumber: Int, higherNumber: Int);
