//
//  ResultsController.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 06/01/2020.
//  Copyright © 2020 Matteo Conti. All rights reserved.
//

import Foundation
import UIKit

class ResultsController: UIViewController {
    
    //
    // MARK: exposed variables
    
    var gameInstance: GameHandler!;
    
    //
    // MARK: variables
    
    private var databaseHandler: DatabaseHandler?;
    private var localPlayer: PlayerModel?;
    private var remotePlayer: PlayerModel?;
    
    private var matchResultSaved: Bool = false;
    
    //
    // MARK: @IBOutlet
    
    @IBOutlet weak var saveResultButton: UIButton!
    @IBOutlet weak var localPlayerMatchResultLabel: UILabel!
    @IBOutlet weak var localPlayerPointsLabel: UILabel!
    @IBOutlet weak var remotePlayerPointsLabel: UILabel!
    
    //
    // MARK:  initializers
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Database Handler
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate;
        self.databaseHandler = DatabaseHandler(appDelegate.persistentContainer);
        
        // get players
        localPlayer = gameInstance.players.first(where: {$0.type == .local})!;
        remotePlayer = gameInstance.players.first(where: {$0.type != .local})!;
        
        render();
    }
    
    //
    // MARK:
    
    private func render() {
        // button
        saveResultButton.isEnabled = !matchResultSaved;
        
        // match result label
        var localPlayerMatchResultText: String = "HAI PAREGGIATO!";
        if (localPlayer!.deckPoints > remotePlayer!.deckPoints) {
            localPlayerMatchResultText = "HAI VINTO!";
        } else if (localPlayer!.deckPoints < remotePlayer!.deckPoints) {
            localPlayerMatchResultText = "HAI PERSO!";
        }
        localPlayerMatchResultLabel!.text = localPlayerMatchResultText;
        
        // players points
        localPlayerPointsLabel.text = String(localPlayer!.deckPoints);
        remotePlayerPointsLabel.text = String(remotePlayer!.deckPoints);
        
        // alert
        // ...
    }
    
    //
    // MARK: @IBAction
    
    @IBAction func saveResultButton(_ sender: Any) {
        guard let dbHandler: DatabaseHandler = databaseHandler else { return; }
        
        matchResultSaved = true;
        
        let localPlayerCards: [String] = localPlayer!.currentDeck.map({ $0.name });
        let remotePlayerCards: [String] = remotePlayer!.currentDeck.map({ $0.name });
        
        let localPlayerCardsParsed: String = localPlayerCards.joined(separator: ";");
        let remotePlayerCardsParsed: String = remotePlayerCards.joined(separator: ";");
        
        let localPlayerHandsWon = localPlayerCards.count / 2;
        let remotePlayerHandsWon = localPlayerCards.count / 2;
        
        let dbLocalPlayer: DB_Player = DB_Player(index: localPlayer!.index, name: localPlayer!.name, type: localPlayer!.type);
        let dbRemotePlayer: DB_Player = DB_Player(index: remotePlayer!.index, name: remotePlayer!.name, type: remotePlayer!.type);
        
        let dbLocalPlayerResult: DB_Result = DB_Result(cards: localPlayerCardsParsed, handsWon: localPlayerHandsWon, points: localPlayer!.deckPoints);
        let dbRemotePlayerResult: DB_Result = DB_Result(cards: remotePlayerCardsParsed, handsWon: remotePlayerHandsWon, points: remotePlayer!.deckPoints);
        
        let match: DB_Match = DB_Match(localPlayer: dbLocalPlayer, localPlayerResult: dbLocalPlayerResult, remotePlayer: dbRemotePlayer, remotePlayerResult: dbRemotePlayerResult);
        
        dbHandler.saveMatch(match);
    }
    
}
