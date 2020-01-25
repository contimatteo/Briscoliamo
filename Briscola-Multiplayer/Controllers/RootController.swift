//
//  GameRunnerController.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 06/01/2020.
//  Copyright © 2020 Matteo Conti. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RootController: UIViewController {
    
    var container: PersistentContainer!;
    
    //
    // MARK: Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("This view needs an AppDelegate instance for getting persistent container (CoreData).")
        };
        
        if let nextVC = segue.destination as? GameViewController {
            nextVC.container = appDelegate.persistentContainer;
        }
    }
}
