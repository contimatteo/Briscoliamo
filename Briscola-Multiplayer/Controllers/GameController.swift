//
//  MultiPlayerController.swift
//  Briscola-Multiplayer
//
//  Created by Matteo Conti on 28/12/2019.
//  Copyright © 2019 Matteo Conti. All rights reserved.
//

import UIKit
import MultipeerConnectivity


class GameController: UIViewController {
    
    //
    // MARK: Graphic Variables
    
    @IBOutlet weak var trumpImgView: UIImageView! // trump card
    
    @IBOutlet weak var lp_c1ImgView: UIImageView! // player 1 card 1
    @IBOutlet weak var lp_c2ImgView: UIImageView!
    @IBOutlet weak var lp_c3ImgView: UIImageView!
    @IBOutlet weak var rp1_c1ImgView: UIImageView! // remote-player 1 card 1
    @IBOutlet weak var rp1_c2ImgView: UIImageView!
    @IBOutlet weak var rp1_c3ImgView: UIImageView!
    
    @IBOutlet weak var tc1ImgView: UIImageView! // table card 1
    @IBOutlet weak var tc2ImgView: UIImageView!
    
    @IBOutlet weak var lp_labelName: UILabel!
    @IBOutlet weak var lp_LabelPoints: UILabel!
    @IBOutlet weak var rp1_labelName: UILabel!
    @IBOutlet weak var rp1_LabelPoints: UILabel!
    
    private var playersCardImgViews: Array<Array<UIImageView>> = [];
    private var tableCardImgViews: Array<UIImageView> = [];
    private var playersPointsLabels: Array<UILabel> = [];
    
    //
    // MARK: Functional Variables
    
    public var localPlayerIndex: Int?;
    public var gameOptions: GameOptions!;
    private var gameHandler: GameHandler = GameHandler.init();
    private var sessionManager: SessionManager?;
    
    //
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.localPlayerIndex = 1;
        let playersTypes: [PlayerType] = [.local, .emulator];
        
        /// prepare player's cards variables.
        prepareAssets();
        
        /// load all the cards and load 3 cards foreach player, load
        /// the trump card, create players and load 3 cards for these.
        if (gameOptions.mode == .multiplayer) {
            /// MULTI-PLAYER
            //            sessionManager = SessionManager();
            //            sessionManager!.delegate = self;
            //            title = "MCSession: \(sessionManager!.displayName)";
            //
            //            shareSession();
        } else {
            /// SINGLE-PLAYER
            gameHandler.initSinglePlayer(numberOfPlayers: gameOptions.numberOfPlayers, localPlayerIndex: localPlayerIndex!, playersType: playersTypes);
            
            
            /// gestures
            initGestures()
            
            /// render
            render();
        }
    }
    
    
    private func prepareAssets() {
        playersPointsLabels.append(lp_LabelPoints);
        playersPointsLabels.append(rp1_LabelPoints);
        
        // hand cards
        
        var lpCards: Array<UIImageView> = [];
        lpCards.append(lp_c1ImgView);
        lpCards.append(lp_c2ImgView);
        lpCards.append(lp_c3ImgView);
        
        var rp1Cards: Array<UIImageView> = [];
        rp1Cards.append(rp1_c1ImgView);
        rp1Cards.append(rp1_c2ImgView);
        rp1Cards.append(rp1_c3ImgView);
        
        playersCardImgViews.append([]);
        playersCardImgViews.append([]);
        
        let currentPlayerIndex: Int = self.localPlayerIndex!;
        let remotePlayer1Index: Int = (currentPlayerIndex + 1) % CONSTANTS.NUMBER_OF_PLAYERS;
        
        playersCardImgViews[currentPlayerIndex] = lpCards;
        playersCardImgViews[remotePlayer1Index] = rp1Cards;
        
        // cards on table
        
        tableCardImgViews.append(UIImageView(image: nil));
        tableCardImgViews.append(UIImageView(image: nil));
        
        tableCardImgViews[currentPlayerIndex] = tc1ImgView;
        tableCardImgViews[remotePlayer1Index] = tc2ImgView;
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
        // TODO: improve this logic
        // let localPlayerIndex: Int = self.localPlayerIndex!;
        //let currentLocalPlayerIndex: Int = gameHandler.players.firstIndex(where: {$0.type == .local})!;
        
        // let currentPlayerHand = playersCardImgViews[currentLocalPlayerIndex];
        // for cIndex in currentPlayerHand.indices {
        //     let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: // #selector(cardTapped(tapGestureRecognizer:)));
        //
        //    playersCardImgViews[currentLocalPlayerIndex][cIndex].isUserInteractionEnabled = true;
        //    playersCardImgViews[currentLocalPlayerIndex][cIndex].addGestureRecognizer(tapGestureRecognizer);
        //}
        
        let tapRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(cardTapped(tapGestureRecognizer:)));
        let tapRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(cardTapped(tapGestureRecognizer:)));
        let tapRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(cardTapped(tapGestureRecognizer:)));
        
        lp_c1ImgView.isUserInteractionEnabled = true;
        lp_c1ImgView.addGestureRecognizer(tapRecognizer1);
        lp_c2ImgView.isUserInteractionEnabled = true;
        lp_c2ImgView.addGestureRecognizer(tapRecognizer2);
        lp_c3ImgView.isUserInteractionEnabled = true;
        lp_c3ImgView.addGestureRecognizer(tapRecognizer3);
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
    
    func shareSession() {
        sessionManager?.startServices();
    }
    
    func shareCardsDeck() {
        // sessionManager.send(img: UIImage(named: "1-bastoni")!);
        // let _ = sessionManager?.send(array: ["ciao1", "1-bastoni", "pippo", "{weeee}"]);
        
        
        let playersTypes: [PlayerType] = [.local, .emulator];
        gameHandler.initMultiPlayer(numberOfPlayers: gameOptions.numberOfPlayers, localPlayerIndex: 1, playersType: playersTypes, deckCards: nil);
    }
    
}


extension GameController: SessionControllerDelegate {
    
    func sessionDidChangeState() {
        // Ensure UI updates occur on the main queue.
        DispatchQueue.main.async(execute: { [weak self] in
            // self?.tableView.reloadData()
            // TODO: ...
            
            print("// NUMERO DI GIOCATORI: \(self!.gameOptions.numberOfPlayers)");
            print("// NUMERO DI PEER CONNESSI: \(self!.sessionManager!.connectedPeers.count)")
        })
    }
}


struct GameOptions {
    var mode: GameType;
    var numberOfPlayers: Int;
    var indexOfStarterPlayer: Int;
}

