//
//  DatabaseHandler.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 11/01/2020.
//  Copyright © 2020 Matteo Conti. All rights reserved.
//

import Foundation
import CoreData


class DatabaseHandler {
    
    //
    // MARK: Variables
    
    private let PLAYER_TABLE_NAME: String = "Players";
    private let MATCH_TABLE_NAME: String = "Matches";
    private let RESULT_TABLE_NAME: String = "Results";
    
    private var container: PersistentContainer;
    
    //
    // MARK: Initializer
    
    init(_ coreDataContainer: PersistentContainer) {
        self.container = coreDataContainer;
    }
    
    //
    // MARK: Private Methods
    
    private func savePlayer(_ player: DB_Player) -> NSManagedObject {
        let entity = NSEntityDescription.entity(forEntityName: PLAYER_TABLE_NAME, in: container.viewContext)
        let newPlayer = NSManagedObject(entity: entity!, insertInto: container.viewContext);
        
        newPlayer.setValue(player.index, forKey: "index");
        newPlayer.setValue(player.name, forKey: "name");
        newPlayer.setValue(player.type.rawValue, forKey: "type");
        container.saveContext();
        
        return newPlayer;
    }
    
    private func savePlayerResult(_ result: DB_Result) -> NSManagedObject {
        let entity = NSEntityDescription.entity(forEntityName: RESULT_TABLE_NAME, in: container.viewContext)
        let newPlayerResult = NSManagedObject(entity: entity!, insertInto: container.viewContext);
        
        newPlayerResult.setValue(result.cards, forKey: "cards");
        newPlayerResult.setValue(result.handsWon, forKey: "handsWon");
        newPlayerResult.setValue(result.points, forKey: "points");
        container.saveContext();
        
        return newPlayerResult;
    }
    
    
    //
    // MARK: Public Methods
    
    
    func getMatches() -> [DB_Match] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: MATCH_TABLE_NAME);
        request.returnsObjectsAsFaults = false
        // request.predicate = NSPredicate(format: "age = %@", "12")
        
        // run the query
        var results: [DB_Match] = [];
        let dbQueryResults = container.getContext(request: request) ?? [];
        for match in dbQueryResults as! [Matches] {
            results.append(DB_Match.instanceFrom(match));
        }
        
        return results;
    }
    
    func saveMatch(_ match: DB_Match) {
        let context = container.viewContext;
        
        let entity = NSEntityDescription.entity(forEntityName: MATCH_TABLE_NAME, in: context)
        let newMatch = NSManagedObject(entity: entity!, insertInto: context);
        
        // players
        let localPlayer: NSManagedObject = savePlayer(match.localPlayer);
        let remotePlayer: NSManagedObject = savePlayer(match.remotePlayer);
        newMatch.setValue(localPlayer, forKey: "localPlayer");
        newMatch.setValue(remotePlayer, forKey: "remotePlayer");
        
        // results
        let localPlayerResult: NSManagedObject = savePlayerResult(match.localPlayerResult);
        let remotePlayerResult: NSManagedObject = savePlayerResult(match.remotePlayerResult);
        newMatch.setValue(localPlayerResult, forKey: "localPlayerResult");
        newMatch.setValue(remotePlayerResult, forKey: "remotePlayerResult");
        
        container.saveContext();
    }
    
}
