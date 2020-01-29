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
    
    @IBOutlet weak var gameStatusLabel: UILabel!
    @IBOutlet weak var startGameButton: UIButton!
    
    @IBOutlet weak var lp_c1ImgView: UIImageView! // player 1 card 1
    @IBOutlet weak var lp_c2ImgView: UIImageView!
    @IBOutlet weak var lp_c3ImgView: UIImageView!
    @IBOutlet weak var rp1_c1ImgView: UIImageView! // remote-player 1 card 1
    @IBOutlet weak var rp1_c2ImgView: UIImageView!
    @IBOutlet weak var rp1_c3ImgView: UIImageView!
    
    @IBOutlet weak var trumpImgView: UIImageView! // trump card
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
        
        localPlayerIndex = 0;
        
        if (gameOptions.mode == .multiplayer) {
            sessionManager = SessionManager();
            sessionManager!.delegate = self;
            
            // start the session's services.
            // title = "[session] \(sessionManager!.displayName)";
            startSession();
        }
        
    }
    
    private func initSinglePlayerGame() {
        // SINGLE-PLAYER
        let playersTypes: [PlayerType] = [.local, .emulator];
        
        // prepare player's cards variables.
        prepareAssets();
        
        // load all the cards and load 3 cards foreach player, load
        // the trump card, create players and load 3 cards for these.
        gameHandler.initSinglePlayer(numberOfPlayers: gameOptions.numberOfPlayers, localPlayerIndex: localPlayerIndex!, playersType: playersTypes);
        
        // gestures
        initGestures()
        
        // render
        render();
    }
    
    private func initMultiPlayerGame(localPlayerIndex localPlayerNewIndex: Int, deckCards: [String]?) {
        var deckCardsConverted: [CardModel]? = nil;
        if (deckCards != nil) {
            deckCardsConverted = [];
            
            for card in deckCards! {
                let cardComponents = card.components(separatedBy: "-");
                let typeName: String = String(cardComponents[1]);
                let number: Int = Int(cardComponents[0])!;
                deckCardsConverted!.append(CardModel(type: CardType(rawValue: typeName)!, number: number));
            }
        }
        
        // SINGLE-PLAYER
        localPlayerIndex = localPlayerNewIndex;
        var playersTypes: [PlayerType] = [.remote, .remote];
        playersTypes[localPlayerIndex!] = .local;
        
        DispatchQueue.main.async {
            // prepare player's cards variables.
            self.prepareAssets();
            
            // load all the cards and load 3 cards foreach player, load
            // the trump card, create players and load 3 cards for these.
            self.gameHandler.initMultiPlayer(numberOfPlayers: self.gameOptions.numberOfPlayers, localPlayerIndex: self.localPlayerIndex!, playersType: playersTypes, deckCards: deckCardsConverted);
            
            // gestures
            self.initGestures()
            
            // render
            self.render();
        }
    }
    
    private func prepareAssets() {
        let currentPlayerIndex: Int = localPlayerIndex!;
        let remotePlayer1Index: Int = (currentPlayerIndex + 1) % gameOptions.numberOfPlayers;
        
        self.playersCardImgViews.append([]);
        self.playersCardImgViews.append([]);
        self.tableCardImgViews.append(UIImageView(image: nil));
        self.tableCardImgViews.append(UIImageView(image: nil));
        self.playersPointsLabels.append(UILabel());
        self.playersPointsLabels.append(UILabel());
        
        // hand cards
        
        var lpCards: Array<UIImageView> = [];
        lpCards.append(self.lp_c1ImgView);
        lpCards.append(self.lp_c2ImgView);
        lpCards.append(self.lp_c3ImgView);
        
        var rp1Cards: Array<UIImageView> = [];
        rp1Cards.append(self.rp1_c1ImgView);
        rp1Cards.append(self.rp1_c2ImgView);
        rp1Cards.append(self.rp1_c3ImgView);
        
        self.playersCardImgViews[currentPlayerIndex] = lpCards;
        self.playersCardImgViews[remotePlayer1Index] = rp1Cards;
        
        // cards on table
        
        self.tableCardImgViews[currentPlayerIndex] = self.tc1ImgView;
        self.tableCardImgViews[remotePlayer1Index] = self.tc2ImgView;
        
        // player's points and name labels
        
        self.playersPointsLabels[currentPlayerIndex] = self.lp_LabelPoints;
        self.playersPointsLabels[remotePlayer1Index] = self.rp1_LabelPoints;
    }
    
    private func initGestures() {
        let tapRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(cardTapped(tapGestureRecognizer:)));
        lp_c1ImgView.isUserInteractionEnabled = true;
        lp_c1ImgView.addGestureRecognizer(tapRecognizer1);
        
        let tapRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(cardTapped(tapGestureRecognizer:)));
        lp_c2ImgView.isUserInteractionEnabled = true;
        lp_c2ImgView.addGestureRecognizer(tapRecognizer2);
        
        let tapRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(cardTapped(tapGestureRecognizer:)));
        lp_c3ImgView.isUserInteractionEnabled = true;
        lp_c3ImgView.addGestureRecognizer(tapRecognizer3);
    }
    
    private func render() {
        // STEP 0: render buttons and dialogs.
        startGameButton.isHidden = !gameHandler.gameEnded;
        if (gameHandler.gameEnded) {
            gameStatusLabel.text = "pronto per iniziare ?";
        } else {
            if (localPlayerIndex! == gameHandler.playerTurn) {
                gameStatusLabel.text = "è il tuo turno.";
            } else {
                gameStatusLabel.text = "aspetta ...";
            }
        }
        
        // STEP 1: render all players hands.
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
        
        // STEP 2: render all cards on table.
        for (cIndex, cardImg) in tableCardImgViews.enumerated() {
            if (gameHandler.cardsOnTable.indices.contains(cIndex) && gameHandler.cardsOnTable[cIndex] != nil) {
                _updateImageView(images: tableCardImgViews, imageIndex: cIndex, model: gameHandler.cardsOnTable[cIndex]!);
            } else {
                _emptyImageView(imageView: cardImg);
            }
        }
        
        // trump card
        if (gameHandler.deckCards.count > 0) {
            _updateImageView(image: trumpImgView, model: gameHandler.trumpCard!);
        } else {
            _emptyImageView(imageView: trumpImgView);
        }
        
        // display points
        DispatchQueue.main.async {
            for (pIndex, player) in self.gameHandler.players.enumerated() {
                self.playersPointsLabels[pIndex].text = String(player.deckPoints);
            }
        }
        
        // if game is ended go to the results page.
        if (gameHandler.gameEnded) {
            if (gameOptions.mode == .multiplayer) { stopSession(); }
            goToNextView();
        }
    }
    
    private func playCard(card model: CardModel, playerIndex: Int) {
        // play the cards.
        let cardPlayed = gameHandler.playCard(playerIndex: playerIndex, card: model);
        if (!cardPlayed) { return };
        
        // render the new game state.
        render();
        
        // SESSION: share the card played but only if the player who played this card is me.
        // remeber that this function is called each time i will received card played by another remote player.
        if (gameOptions.mode == .multiplayer && playerIndex == localPlayerIndex!) {
            let ssCardPlayed: SS_CardPlayed = SS_CardPlayed(type: model.type.rawValue, number: model.number, senderPlayerIndex: localPlayerIndex!);
            let _ = self.sessionManager!.sendData(data: ssCardPlayed.toData());
        }
        
        // end the turn after a delay.
        gameHandler.endTurn();
        // and render the new state.
        let delay: DispatchTime = DispatchTime.now() + CONSTANTS.TURN_SECONDS_DELAY;
        DispatchQueue.main.asyncAfter(deadline: delay, execute: {
            self.render();
        })
    }
    
    //
    // MARK: IBAction
    
    @IBAction private func startMultiplayerGame() {
        if (gameOptions.mode == .singleplayer) {
            // single-player
            initSinglePlayerGame();
        } else {
            // multi-player
            if (gameHandler.deckCards.count > 0 || !gameHandler.gameEnded) { return; }
            let allRequiredPlayersAreConnected: Bool = (sessionManager!.connectedPeers.count + 1) == gameOptions.numberOfPlayers;
            if (!allRequiredPlayersAreConnected) { return; }
            
            let sharedCardsDeck: [String] = (gameHandler.loadCards()).map { $0.name; };
            let initObject: SS_InitObj = SS_InitObj(senderPlayerIndex: localPlayerIndex!, cardsDeck: sharedCardsDeck);
            
            DispatchQueue.main.async {
                let sended = self.sessionManager!.sendData(data: initObject.toData());
                
                if (sended) {
                    self.initMultiPlayerGame(localPlayerIndex: self.localPlayerIndex!, deckCards: sharedCardsDeck);
                }
            }
        }
    }
    
    //
    // MARK: Gestures
    
    @objc func cardTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        // recognize the image tapped.
        guard let tappedImg: UIImageView = tapGestureRecognizer.view as? UIImageView else { return };
        guard let (model, playerIndex, _) = _getModelFromImageView(imgView: tappedImg) else { return };
        
        playCard(card: model, playerIndex: playerIndex);
    }
    
    //
    // MARK: Navigation
    
    public func goToNextView() {
        self.performSegue(withIdentifier: "goToGameResultView", sender: self);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultController = segue.destination as? ResultsController;
        
        if resultController != nil {
            if (segue.identifier == "goToGameResultView") {
                resultController!.gameInstance = self.gameHandler;
            }
        }
    }
    
}

//
// MARK: SessionControllerDelegate (protocol extension)

extension GameController: SessionControllerDelegate {
    
    //
    // MARK: Triggers
    
    func sessionDidChangeState() {
        // Ensure UI updates occur on the main queue.
        DispatchQueue.main.async {
            // self?.tableView.reloadData()
            // TODO: ...
        }
    }
    
    func didReceivedDataFromPeer(_ data: Data) {
        var dataConverted: Any? = nil;
        var end: Bool = false;
        
        // SS_InitObj
        dataConverted = SS_InitObj.fromData(data);
        if (gameHandler.deckCards.count < 1 && gameHandler.gameEnded) {
            end = _receveidSSInitObject(dataConverted);
            if end { return; }
        }
        
        // SS_CardPlayed
        dataConverted = SS_CardPlayed.fromData(data);
        if (!gameHandler.gameEnded) {
            end = _receveidSSCardPlayed(dataConverted);
            if end { return; }
        }
    }
    
}

//
// MARK: Session + Receivers

extension GameController {
    
    //
    // MARK: Session
    
    func startSession() {
        sessionManager!.startServices();
    }
    
    func stopSession() {
        sessionManager!.stopServices();
    }
    
    //
    // MARK: Receivers
    
    private func _receveidSSInitObject(_ data: Any?) -> Bool {
        // avoid `nil` value.
        guard let dataConverted = data else { return false; }
        // avoid not matching objects.
        guard let initObj: SS_InitObj = dataConverted as? SS_InitObj else { return false; };
        
        let newLocalPlayerIndex: Int = (initObj.senderPlayerIndex + 1) % gameOptions.numberOfPlayers;
        initMultiPlayerGame(localPlayerIndex: newLocalPlayerIndex, deckCards: initObj.cardsDeck);
        
        return true;
    }
    
    private func _receveidSSCardPlayed(_ data: Any?) -> Bool {
        // avoid `nil` value.
        guard let dataConverted = data else { return false; }
        
        // avoid not matching objects.
        guard let ssCardPlayed: SS_CardPlayed = dataConverted as? SS_CardPlayed else { return false; };
        
        let cardType: CardType = CardType(rawValue: ssCardPlayed.type!)!;
        let cardModel = CardModel(type: cardType, number: ssCardPlayed.number!);
        
        let senderPlayerIndex: Int = ssCardPlayed.senderPlayerIndex!;
        // if (senderPlayerIndex == localPlayerIndex!) { return true; }
        
        playCard(card: cardModel, playerIndex: senderPlayerIndex);
        return true;
    }
    
}

//
// MARK: Image/Model Methods (get, update)

extension GameController {
    
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
        
        DispatchQueue.main.async {
            images[imageIndex].image = model.image;
            images[imageIndex].tag = model.tag;
        }
    }
    
    private func _updateImageView(image: UIImageView, model: CardModel) {
        _updateImageView(images: [image], imageIndex: 0, model: model);
    }
    
    private func _emptyImageView(imageView: UIImageView, imageName: String? = "empty") {
        DispatchQueue.main.async {
            imageView.image = UIImage(named: imageName!);
            imageView.tag = -1;
        }
    }
    
}
