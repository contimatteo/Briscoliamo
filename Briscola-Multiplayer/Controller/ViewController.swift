//
//  ViewController.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 28/12/2019.
//  Copyright © 2019 Matteo Conti. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //
    // MARK: Constants
    
    private let NUMBER_OF_PLAYERS: Int = 2;
    private let MAX_NUMBER_OF_PLAYERS: Int = 4;
    
    //
    // MARK: @IBOutlets
    
    @IBOutlet weak var trumpCard: UIImageView!
    
    @IBOutlet weak var _p1c1: UIImageView! // player 1 - card 1
    @IBOutlet weak var _p1c2: UIImageView!
    @IBOutlet weak var _p1c3: UIImageView!
    @IBOutlet weak var _p2c1: UIImageView!
    @IBOutlet weak var _p2c2: UIImageView!
    @IBOutlet weak var _p2c3: UIImageView!
    
    //
    // MARK: Variables
    
    private var gameHandler: GameHandler = GameHandler.init();
    private var player1Cards: (UIImageView, UIImageView, UIImageView)?;
    private var player2Cards: (UIImageView, UIImageView, UIImageView)?;
    private var player3Cards: (UIImageView, UIImageView, UIImageView)?;
    private var player4Cards: (UIImageView, UIImageView, UIImageView)?;
    private var playersCards: Array<(UIImageView, UIImageView, UIImageView)> = [];
    
    //
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// prepare player's cards variables.
        _prepareAssets();
        
        /// load all the cards and load 3 cards foreach player,
        /// load the trump card, create players and load 3 cards for these.
        gameHandler.initializeGame(mode: .singleplayer, numberOfPlayers: NUMBER_OF_PLAYERS, playersType: [.human, .virtual]);
        
        /// display players initial hands + load trump card
        displayInitialState();
    }
    
    private func _prepareAssets() {
        /// TODO:  missing logic for players number > 2.
        
        /// first assign three cards (images) foreach player
        player1Cards = (_p1c1, _p1c2, _p1c3);
        player2Cards = (_p2c1, _p2c2, _p2c3);
        
        /// then insert each player cards (images) array into general {playersCards} var.
        for i in 0...(min(NUMBER_OF_PLAYERS, MAX_NUMBER_OF_PLAYERS) - 1) {
            if (i == 0) {
                playersCards.append(player1Cards!);
            } else {
                playersCards.append(player2Cards!);
            }
        }
    }
    
    private func displayInitialState() {
        /// display players initial cards hand.
        for (index, player) in playersCards.enumerated() {
            let (c1, c2, c3): PlayerCardHand = gameHandler.players[index].currentCardHand;
            _updateCardImage(imageView: player.0, newCard: c1);
            _updateCardImage(imageView: player.1, newCard: c2);
            _updateCardImage(imageView: player.2, newCard: c3);
        }
        
        /// display the card trump
        _updateCardImage(imageView: trumpCard, newCard: gameHandler.game.trumpCard!);
    }
    
    
    private func _updateCardImage(imageView: UIImageView, newCard: CardModel) {
        imageView.image = UIImage.init(named: newCard.imageUrl);
    }
}

