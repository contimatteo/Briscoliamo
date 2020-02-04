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
    // MARK: @
    
    @IBOutlet weak var localPlayerName: UITextField!
    @IBOutlet weak var gameMode: UISegmentedControl!
    @IBOutlet weak var gameSpeed: UISlider!
    @IBOutlet weak var showRemotePlayerCardsSwitcher: UISwitch!
    @IBOutlet weak var showRemotePlayerPointsSwitcher: UISwitch!
    @IBOutlet weak var showLocalPlayerPoints: UISwitch!
    @IBOutlet weak var startGameButton: UIButton!
    
    //
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegate
        localPlayerName.delegate=self;
        
        // game options
        gameOptions = GameOptions(mode: .singleplayer, gameSpeed: 3, numberOfPlayers: CONSTANTS.MAX_NUMBER_OF_PLAYERS, indexOfStarterPlayer: 0, localPlayerName: "", showLocalPlayerPoints: true, showRemotePlayerCards: true, showRemotePlayerPoints: true);
        
        // graphic
        startGameButton.isEnabled = false;
        
        // event handler
        localPlayerName.addTarget(self, action: #selector(localPlayerNameChanged), for: .editingChanged);
    }
    
    //
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "startTheGame":
            let gameController: GameController = segue.destination as! GameController;
            
            self.gameOptions!.localPlayerName = localPlayerName.text!;
            self.gameOptions!.mode = self.gameMode.selectedSegmentIndex == 0 ? .singleplayer : .multiplayer;
            self.gameOptions!.gameSpeed = CONSTANTS.TURN_SECONDS_DELAY - (Double(self.gameSpeed.value) * 0.5);
            self.gameOptions!.showRemotePlayerCards = showRemotePlayerCardsSwitcher.isOn;
            self.gameOptions!.showRemotePlayerPoints = showRemotePlayerPointsSwitcher.isOn;
            self.gameOptions!.showLocalPlayerPoints = showLocalPlayerPoints.isOn;
            
            gameController.gameOptions = self.gameOptions!;
            break;
        default:
            // nothing to do ...
            // let socialsController = segue.destination as? SocialController;
            print("[INFO] segue.identifier = \(segue.identifier ?? "?????")")
        }
    }
    
    //
    // MARK:
    
    @objc func localPlayerNameChanged(_ input: UITextField) {
        guard let playerName: String = input.text else { return; }
        
        if (playerName.count > 0) {
            startGameButton.isEnabled = true;
        }
    }
    
}


//
// MARK: UITextFieldDelegate (extension)

extension MenuController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true;
    }
    
}
