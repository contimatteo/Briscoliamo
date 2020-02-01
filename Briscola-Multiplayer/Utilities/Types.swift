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

public enum CardType: String {
    case coppe
    case bastoni
    case spade
    case denari
}

public struct GameOptions {
    var mode: GameType;
    var gameSpeed: Double;
    var numberOfPlayers: Int;
    var indexOfStarterPlayer: Int;
    var localPlayerName: String;
    var showLocalPlayerPoints: Bool;
    var showRemotePlayerCards: Bool;
    var showRemotePlayerPoints: Bool;
}

public enum PlayerType: String {
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

//
// MARK: Database

struct DB_Player {
    var index: Int;
    var name: String;
    var type: PlayerType;
    
    static func instanceFrom(_ dbPlayer: Players) -> DB_Player {
        return DB_Player(index: Int(dbPlayer.index), name: dbPlayer.name!, type: PlayerType(rawValue: dbPlayer.type!)!);
    }
}

struct DB_Result {
    var cards: String;
    var handsWon: Int;
    var points: Int;
    
    static func instanceFrom(_ dbResult: Results) -> DB_Result {
        return DB_Result(cards: dbResult.cards!, handsWon: Int(dbResult.handsWon), points: Int(dbResult.points));
    }
}

struct DB_Match {
    var localPlayer: DB_Player;
    var localPlayerResult: DB_Result;
    var remotePlayer: DB_Player;
    var remotePlayerResult: DB_Result;
    
    static func instanceFrom(_ dbMatch: Matches) -> DB_Match {
        let localPlayer: DB_Player = DB_Player.instanceFrom(dbMatch.localPlayer!);
        let remotePlayer: DB_Player = DB_Player.instanceFrom(dbMatch.remotePlayer!);
        let localPlayerResult: DB_Result = DB_Result.instanceFrom(dbMatch.localPlayerResult!);
        let remotePlayerResult: DB_Result = DB_Result.instanceFrom(dbMatch.remotePlayerResult!);
        
        return DB_Match(localPlayer: localPlayer, localPlayerResult: localPlayerResult, remotePlayer: remotePlayer, remotePlayerResult: remotePlayerResult);
    }
    
    public func hasLocalPlayerWon() -> Bool {
        return localPlayerResult.points > remotePlayerResult.points;
    }
    
    public func hasLocalPlayerDrew() -> Bool {
        return localPlayerResult.points == remotePlayerResult.points;
    }
    
    public func hasLocalPlayerLost() -> Bool {
        return localPlayerResult.points < remotePlayerResult.points;
    }
}
