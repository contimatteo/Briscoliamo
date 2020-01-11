//
//  PersistentContainer.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 11/01/2020.
//  Copyright © 2020 Matteo Conti. All rights reserved.
//

import Foundation
import CoreData


class PersistentContainer: NSPersistentContainer {
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext;
        guard context.hasChanges else { return }
        
        do {
            try context.save();
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)");
        }
    }
    
    func getContext(request: NSFetchRequest<NSFetchRequestResult>, backgroundContext: NSManagedObjectContext? = nil) -> [Any]? {
        let context = backgroundContext ?? viewContext;
        var results: [Any]? = nil;
        
        do {
            results = try context.fetch(request);
        } catch {}
        
        return results;
    }
    
}

