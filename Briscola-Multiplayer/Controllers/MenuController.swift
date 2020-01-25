//
//  GameRunnerController.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 06/01/2020.
//  Copyright © 2020 Matteo Conti. All rights reserved.
//

import Foundation
import UIKit

class MenuController: UIViewController {
    
    //
    // MARK: Variables
    
    var gameOptions: GameOptions?;
    
    //
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameOptions = GameOptions(mode: .singleplayer, numberOfPlayers: 2, indexOfStarterPlayer: 0);
    }
    
    private func goToNextView() {
        let nextController = GameController();
        
        // setting properties of new controller
        nextController.gameOptions = self.gameOptions!;
        
        self.navigationController!.pushViewController(nextController, animated: true);
    }
    
    //
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextController = segue.destination as! GameController;
        
        if (segue.identifier == "singlePlayerButton") {
            self.gameOptions?.mode = .singleplayer
        }
        
        if (segue.identifier == "multiPlayerButton") {
            self.gameOptions?.mode = .multiplayer
        }
        
        nextController.gameOptions = self.gameOptions!;
    }
    
    

}
