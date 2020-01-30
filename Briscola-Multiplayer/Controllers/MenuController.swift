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
        
        gameOptions = GameOptions(mode: .singleplayer, numberOfPlayers: 2, indexOfStarterPlayer: 0, localPlayerName: CONSTANTS.LOCAL_PLAYER_NAME);
    }
    
    //
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let gameController = segue.destination as? GameController;
        if (gameController != nil) {
            if (segue.identifier == "singlePlayerButton") {
                self.gameOptions?.mode = .singleplayer;
            }
            
            if (segue.identifier == "multiPlayerButton") {
                self.gameOptions?.mode = .multiplayer
            }
            
            gameController!.gameOptions = self.gameOptions!;
        }
        
        let socialsController = segue.destination as? SocialController;
        if (socialsController != nil) {}
    }
    
    

}
