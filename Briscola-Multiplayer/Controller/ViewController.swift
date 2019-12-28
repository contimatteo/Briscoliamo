//
//  ViewController.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 28/12/2019.
//  Copyright © 2019 Matteo Conti. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var gameHandler: GameHandler = GameHandler.init();

    //
    
    @IBOutlet weak var player1Card1: UIImageView!
    @IBOutlet weak var player1Card2: UIImageView!
    @IBOutlet weak var player1Card3: UIImageView!
    
    @IBOutlet weak var player2Card1: UIImageView!
    @IBOutlet weak var player2Card2: UIImageView!
    @IBOutlet weak var player2Card3: UIImageView!
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load all the cards and load 3 cards foreach player.
        gameHandler.loadCards();
        
        // create players and load 3 cards for these.
        gameHandler.initializePlayers(numberOfPlayers: 2);
        
        self.displayInitialCardHands();
    }


    private func displayInitialCardHands() {
        let (p1c1, p1c2, p1c3): PlayerCardHand = gameHandler.players[0].currentCardHand;
        let (p2c1, p2c2, p2c3): PlayerCardHand = gameHandler.players[1].currentCardHand;
        
        self.updatePlayerCard(playerCard: player1Card1, newCard: p1c1);
        self.updatePlayerCard(playerCard: player1Card2, newCard: p1c2);
        self.updatePlayerCard(playerCard: player1Card3, newCard: p1c3);

        self.updatePlayerCard(playerCard: player2Card1, newCard: p2c1);
        self.updatePlayerCard(playerCard: player2Card2, newCard: p2c2);
        self.updatePlayerCard(playerCard: player2Card3, newCard: p2c3);
    }
    
    private func updatePlayerCard(playerCard: UIImageView, newCard: CardModel) {
        playerCard.image = UIImage.init(named: newCard.imageUrl);
    }
}

