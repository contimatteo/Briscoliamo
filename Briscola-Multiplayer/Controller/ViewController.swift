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
    @IBOutlet weak var tc3ImgView: UIImageView!
    @IBOutlet weak var tc4ImgView: UIImageView!
    //
    // MARK: Variables
    
    private var gameHandler: GameHandler = GameHandler.init();
    
    private var playersCardImgViews: Array<Array<UIImageView>> = [];
    private var tableCardImages: Array<UIImageView> = [];
    
    //
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// prepare player's cards variables.
        prepareAssets();
        
        /// load all the cards and load 3 cards foreach player,
        /// load the trump card, create players and load 3 cards for these.
        gameHandler.initializeGame(mode: .singleplayer, numberOfPlayers: CONSTANTS.NUMBER_OF_PLAYERS, playersType: [.human, .virtual]);
        
        /// gestures
        initGestures()
        
        render();
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
        
        tableCardImages.append(tc1ImgView);
        tableCardImages.append(tc2ImgView);
        tableCardImages.append(tc3ImgView);
        tableCardImages.append(tc4ImgView);
    }
    
    public func render() {
        /// 1 STEP: render all players hands.
        for (pIndex, playerImgs) in playersCardImgViews.enumerated() {
            if (gameHandler.players.indices.contains(pIndex)) {
                let playerHand: Array<CardModel> = gameHandler.players[pIndex].cardsHand;
                
                for (cIndex, imgView) in playerImgs.enumerated() {
                    _updateImageView(imageView: imgView, model: playerHand[cIndex]);
                }
            }
        }
    }
    
    private func initGestures() {
        let currentHumanPlayerIndex: Int = CONSTANTS.CURRENT_HUMAN_PLAYER_INDEX;
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
    
    private func _updateImageView(imageView: UIImageView, model: CardModel) {
        imageView.image = model.image;
        imageView.tag = model.tag;
    }
    
    //
    // MARK: Gestures
    
    @objc func cardTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        guard let tappedImg: UIImageView = tapGestureRecognizer.view as? UIImageView else { return };
        print("tappedImg -> \(tappedImg)");
        
        guard let (model, playerIndex, cardIndex) = _getModelFromImageView(imgView: tappedImg) else { return };
        print("tappedImg -> \(model.type.rawValue)-\(model.number)");
    }
}

