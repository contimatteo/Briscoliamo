
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

public var _SESSION_DEBUG_: Bool = true;

//
// MARK: Functional Variables

public struct CONSTANTS {
    
    static public let MAX_NUMBER_OF_PLAYERS: Int = 2;
    static public let TURN_SECONDS_DELAY: Double = 1.5;
    static public let PLAYER_CARDS_HAND_SISZE: Int = 3;
    
    static public let REMOTE_PLAYER_NAME: String = "VS";
    static public let EMULATOR_PLAYER_NAME: String = "VS";
    static public let LOCAL_PLAYER_NAME: String = "TU";
    
    static public let APP_GITHUB_REPOSITORY_LINK: String = "https://github.com/contimatteo/Briscola";
    
}
