//
//  Types.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 24/01/2020.
//  Copyright © 2020 Matteo Conti. All rights reserved.
//

import Foundation


//
// MARK: Game

public enum GameType {
    case singleplayer;
    case multiplayer;
}

public enum CardType: String, Equatable {
    case coppe
    case bastoni
    case spade
    case denari
}

public struct GameOptions {
    var mode: GameType;
    var numberOfPlayers: Int;
    var indexOfStarterPlayer: Int;
}

public enum PlayerType {
    case local;
    case remote;
    case emulator;
}

//
// MARK: Session

public enum SS_Message {
    case success;
    case error;
}

public enum SessionAgentRole {
    case server;
    case client;
}

