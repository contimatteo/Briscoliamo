
//
//  File.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 29/12/2019.
//  Copyright © 2019 Matteo Conti. All rights reserved.
//

import Foundation

//
// MARK: Env Variables

var _SESSION_DEBUG_: Bool = true;

//
// MARK: Functional Variables

struct CONSTANTS {
    
    static let MAX_NUMBER_OF_PLAYERS: Int = 2;
    static let TURN_SECONDS_DELAY: Double = 4;
    static let PLAYER_CARDS_HAND_SISZE: Int = 3;
    
    static let REMOTE_PLAYER_NAME: String = "avversario";
    static let EMULATOR_PLAYER_NAME: String = "avversario";
    static let LOCAL_PLAYER_NAME: String = "TU"; // unused
    
    static let APP_GITHUB_REPOSITORY_LINK: String = "https://github.com/contimatteo/Briscola";
    
}
