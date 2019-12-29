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
    // MARK: Variables
    
    private var _gameRef: GameModel?;
    private var players: Array<PlayerModel> = [];
    
    //
    // MARK: Methods
    
    public func loadGame(game: GameModel, players: Array<PlayerModel>) {
        self._gameRef = game;
    }
    
    
}
