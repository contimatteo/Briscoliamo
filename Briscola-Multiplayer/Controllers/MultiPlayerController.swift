//
//  MultiPlayerController.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 28/12/2019.
//  Copyright © 2019 Matteo Conti. All rights reserved.
//

import UIKit
import MultipeerConnectivity


class MultiPlayerController: UIViewController {
    
    @IBOutlet weak var GameModeOptionView: UIView!
    
    //
    // MARK: @IBOutlets
    
    @IBOutlet weak var trumpImgView: UIImageView! // trump card
    
    @IBOutlet weak var p1c1ImgView: UIImageView! // player 1 card 1
    @IBOutlet weak var p1c2ImgView: UIImageView!
    @IBOutlet weak var p1c3ImgView: UIImageView!
    @IBOutlet weak var p2c1ImgView: UIImageView!
    @IBOutlet weak var p2c2ImgView: UIImageView!
    @IBOutlet weak var p2c3ImgView: UIImageView!
    
    @IBOutlet weak var tc1ImgView: UIImageView! // table card 1
    @IBOutlet weak var tc2ImgView: UIImageView!
    
    @IBOutlet weak var p1labelName: UILabel!
    @IBOutlet weak var p1LabelPoints: UILabel!
    @IBOutlet weak var p2labelName: UILabel!
    @IBOutlet weak var p2LabelPoints: UILabel!
    //
    // MARK: Variables
    
    private var gameHandler: GameHandler = GameHandler.init();
    
    private var playersCardImgViews: Array<Array<UIImageView>> = [];
    private var tableCardImgViews: Array<UIImageView> = [];
    private var playersPointsLabels: Array<UILabel> = [];
    
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    //
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// prepare player's cards variables.
        prepareAssets();
        
        /// load all the cards and load 3 cards foreach player, load
        /// the trump card, create players and load 3 cards for these.
        gameHandler.initializeGame(mode: .singleplayer, numberOfPlayers: CONSTANTS.NUMBER_OF_PLAYERS, playersType: [.human, .virtual]);
        
        /// gestures
        initGestures()
        
        render();
        
        // Multiplayer
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
    }
    
    private func prepareAssets() {
        var player1Cards: Array<UIImageView> = [];
        player1Cards.append(p1c1ImgView);
        player1Cards.append(p1c2ImgView);
        player1Cards.append(p1c3ImgView);
        
        var player2Cards: Array<UIImageView> = [];
        player2Cards.append(p2c1ImgView);
        player2Cards.append(p2c2ImgView);
        player2Cards.append(p2c3ImgView);
        
        var player3Cards: Array<UIImageView> = [];
        player3Cards.append(p2c1ImgView);
        player3Cards.append(p2c2ImgView);
        player3Cards.append(p2c3ImgView);
        
        var player4Cards: Array<UIImageView> = [];
        player4Cards.append(p2c1ImgView);
        player4Cards.append(p2c2ImgView);
        player4Cards.append(p2c3ImgView);
        
        playersCardImgViews.append(player1Cards);
        playersCardImgViews.append(player2Cards);
        playersCardImgViews.append(player3Cards);
        playersCardImgViews.append(player4Cards);
        
        tableCardImgViews.append(tc1ImgView);
        tableCardImgViews.append(tc2ImgView);
        
        playersPointsLabels.append(p1LabelPoints);
        playersPointsLabels.append(p2LabelPoints);
    }
    
    public func render() {
        /// STEP 1: render all players hands.
        for (pIndex, playerImgs) in playersCardImgViews.enumerated() {
            if (gameHandler.players.indices.contains(pIndex)) {
                let playerHand: Array<CardModel> = gameHandler.players[pIndex].cardsHand;
                
                for (cIndex, cardImg) in playerImgs.enumerated() {
                    if (playerHand.indices.contains(cIndex)) {
                        _updateImageView(images: playerImgs, imageIndex: cIndex, model: playerHand[cIndex]);
                    } else {
                        _emptyImageView(imageView: cardImg);
                    }
                }
            }
        }
        
        /// STEP 2: render all cards on table.
        for (cIndex, cardImg) in tableCardImgViews.enumerated() {
            if (gameHandler.cardsOnTable.indices.contains(cIndex) && gameHandler.cardsOnTable[cIndex] != nil) {
                _updateImageView(images: tableCardImgViews, imageIndex: cIndex, model: gameHandler.cardsOnTable[cIndex]!);
            } else {
                _emptyImageView(imageView: cardImg);
            }
        }
        
        /// trump card
        _updateImageView(image: trumpImgView, model: gameHandler.trumpCard!);
        
        /// display points
        for (pIndex, player) in gameHandler.players.enumerated() {
            playersPointsLabels[pIndex].text = String(player.deckPoints);
        }
        
        /// if game is ended go to the results page.
        if (gameHandler.gameEnded) {
            goToNextView();
        }
    }
    
    private func initGestures() {
        let currentHumanPlayerIndex: Int = gameHandler.players.firstIndex(where: {$0.type == .human})!;
        let currentPlayerHand = playersCardImgViews[currentHumanPlayerIndex];
        
        for cIndex in currentPlayerHand.indices {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cardTapped(tapGestureRecognizer:)));
            
            playersCardImgViews[currentHumanPlayerIndex][cIndex].isUserInteractionEnabled = true;
            playersCardImgViews[currentHumanPlayerIndex][cIndex].addGestureRecognizer(tapGestureRecognizer);
        }
    }
    
    private func _getModelFromImageView(imgView: UIImageView) -> (model: CardModel, playerIndex: Int, cardIndex: Int)? {
        for (pIndex, player) in gameHandler.players.enumerated() {
            for (cIndex, card) in player.cardsHand.enumerated() {
                if (imgView.tag == card.tag) {
                    return (model: card, playerIndex: pIndex, cardIndex: cIndex);
                }
            }
        }
        
        return nil;
    }
    
    private func _getImageViewFromModel(card: CardModel) -> (imgView: UIImageView, playerIndex: Int, cardIndex: Int)? {
        for (pIndex, imgViews) in playersCardImgViews.enumerated() {
            for (cIndex, imgView) in imgViews.enumerated() {
                if (imgView.tag == card.tag) {
                    return (imgView: imgView, playerIndex: pIndex, cardIndex: cIndex);
                }
            }
        }
        
        return nil;
    }
    
    private func _updateImageView(images: Array<UIImageView>, imageIndex: Int, model: CardModel) {
        if (!images.indices.contains(imageIndex)) { return; }
        
        /// imageView.image = model.image;
        //// imageView.tag = model.tag;
        images[imageIndex].image = model.image;
        images[imageIndex].tag = model.tag;
    }
    
    private func _updateImageView(image: UIImageView, model: CardModel) {
        _updateImageView(images: [image], imageIndex: 0, model: model);
    }
    
    private func _emptyImageView(imageView: UIImageView, imageName: String? = "empty") {
        imageView.image = UIImage(named: imageName!);
        imageView.tag = -1;
    }
    
    //
    // MARK: Gestures
    
    @objc func cardTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        /// recognize the image tapped.
        guard let tappedImg: UIImageView = tapGestureRecognizer.view as? UIImageView else { return };
        guard let (model, playerIndex, _) = _getModelFromImageView(imgView: tappedImg) else { return };
        
        /// play the cards.
        let cardPlayed = gameHandler.playCard(playerIndex: playerIndex, card: model);
        if (!cardPlayed) { return };
        
        /// render the new game state.
        render();
        
        /// end the turn after a delay.
        gameHandler.endTurn();
        /// and render the new state.
        let delay: DispatchTime = DispatchTime.now() + CONSTANTS.TURN_SECONDS_DELAY;
        DispatchQueue.main.asyncAfter(deadline: delay, execute: {
            self.render();
        })
    }
    
    //
    // MARK: Navigation
    
     public func goToNextView() {
        let nextController = ResultsController();

        /// setting properties of new controller
        nextController.gameInstance = gameHandler;

        self.navigationController!.pushViewController(nextController, animated: true)
    }
    
    //
    // MARK:
    
    
    @IBAction func shareSession(_ sender: Any) {
        self.startHosting();
    }
    
    @IBAction func joinToSession(_ sender: Any) {
        self.joinSession();
    }
    
}

