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
    
    private func savePlayer(_ player: PlayerModel) -> NSManagedObject {
        let context = container.viewContext;
        
        let entity = NSEntityDescription.entity(forEntityName: PLAYER_TABLE_NAME, in: context)
        let newPlayer = NSManagedObject(entity: entity!, insertInto: context);
        
        newPlayer.setValue(player.index, forKey: "index");
        newPlayer.setValue(player.name, forKey: "name");
        newPlayer.setValue(player.type.rawValue, forKey: "type");
        container.saveContext();
        
        return newPlayer;
    }
    
    
    //
    // MARK: Public Methods
    
    
    public func getMatches() -> Array<Any> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: MATCH_TABLE_NAME);
        request.returnsObjectsAsFaults = false
        // request.predicate = NSPredicate(format: "age = %@", "12")
        
        // run the query
        let results = container.getContext(request: request) ?? [];
        for data in results as! [NSManagedObject] {
            print(data.value(forKey: "playersCount") as! Int);
            print(data.value(forKey: "player1"));
            print(data.value(forKey: "player2"));
        }
        
        return results;
    }
    
    public func saveMatch(players: Array<PlayerModel>) {
        let context = container.viewContext;
        
        let entity = NSEntityDescription.entity(forEntityName: MATCH_TABLE_NAME, in: context)
        let newMatch = NSManagedObject(entity: entity!, insertInto: context);
        
        // create players
        for (pIndex, player) in players.enumerated() {
            let playerCreated: NSManagedObject = savePlayer(player);
            // assign player to this match
            newMatch.setValue(playerCreated, forKey: "player\(pIndex + 1)");
        }
        
        newMatch.setValue(players.count, forKey: "playersCount");
        container.saveContext();
    }
    
}
