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
    
    @IBOutlet weak var trumpImgView: UIImageView!
    @IBOutlet weak var p1c1ImgView: UIImageView!
    @IBOutlet weak var p1c2ImgView: UIImageView!
    @IBOutlet weak var p1c3ImgView: UIImageView!
    @IBOutlet weak var p2c1ImgView: UIImageView!
    @IBOutlet weak var p2c2ImgView: UIImageView!
    @IBOutlet weak var p2c3ImgView: UIImageView!
    
    //
    // MARK: Variables
    
    private var gameHandler: GameHandler = GameHandler.init();
    private var playersCards: T_PlayersCards = [];
    private var player1Cards: T_PlayerCardsHand = [];
    private var player2Cards: T_PlayerCardsHand = [];
    private var player3Cards: T_PlayerCardsHand = [];
    private var player4Cards: T_PlayerCardsHand = [];
    private var trumpCard: T_CardObject?;
    
    //
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// prepare player's cards variables.
        _prepareAssets();
        
        /// load all the cards and load 3 cards foreach player,
        /// load the trump card, create players and load 3 cards for these.
        gameHandler.initializeGame(mode: .singleplayer, numberOfPlayers: CONSTANTS.NUMBER_OF_PLAYERS, playersType: [.human, .virtual]);
        
        /// display players initial hands + load trump card
        displayInitialState();
        
        /// gestures
        initGestures()
    }
    
    private func _prepareAssets() {
        trumpCard = T_CardObject(model: nil, imageView: trumpImgView);
        
        player1Cards.append(T_CardObject(model: nil, imageView: p1c1ImgView));
        player1Cards.append(T_CardObject(model: nil, imageView: p1c2ImgView));
        player1Cards.append(T_CardObject(model: nil, imageView: p1c3ImgView));
        
        player2Cards.append(T_CardObject(model: nil, imageView: p2c1ImgView));
        player2Cards.append(T_CardObject(model: nil, imageView: p2c2ImgView));
        player2Cards.append(T_CardObject(model: nil, imageView: p2c3ImgView));
        
        /// TODO: missing UIImageView components in storyboard.
        player3Cards.append(T_CardObject(model: nil, imageView: p2c1ImgView));
        player3Cards.append(T_CardObject(model: nil, imageView: p2c2ImgView));
        player3Cards.append(T_CardObject(model: nil, imageView: p2c3ImgView));
        
        /// TODO: missing UIImageView components in storyboard.
        player4Cards.append(T_CardObject(model: nil, imageView: p2c1ImgView));
        player4Cards.append(T_CardObject(model: nil, imageView: p2c2ImgView));
        player4Cards.append(T_CardObject(model: nil, imageView: p2c3ImgView));
        
        playersCards.append(player1Cards);
        playersCards.append(player2Cards);
        playersCards.append(player3Cards);
        playersCards.append(player4Cards);
    }
    
    private func displayInitialState() {
        /// display players initial cards hand.
        for (pIndex, starterCardHand) in playersCards.enumerated() {
            if (pIndex < gameHandler.players.count) {
                /// retrieve the initial cards for this player.
                let cardsHandModels: PlayerCardHand = gameHandler.players[pIndex].currentCardHand;
                
                /// update each cards in the initial hand.
                for (cIndex, card) in starterCardHand.enumerated() {
                    _updateCardImage(imageToUpdate: card.imageView, newCardModel: cardsHandModels[cIndex]);
                }
            }
        }
        
        /// display the card trump
        let trumpCardModel = gameHandler.game.trumpCard!;
        trumpCard!.imageView.image = trumpCardModel.image;
        trumpCard!.model = trumpCardModel;
    }
    
    
    private func _updateCardImage(imageToUpdate: UIImageView, newCardModel: CardModel) {
        /// find the {T_CardObject} using the {cardImageView} param in input.
        guard let (playerIndex, cardIndex) = _findCardObjectByCardImageView(imageToFind: imageToUpdate) else { return };
        
        /// update the {T_CardObject}.
        playersCards[playerIndex][cardIndex].imageView.image = newCardModel.image;
        playersCards[playerIndex][cardIndex].model = newCardModel;
        
        if (playerIndex == CONSTANTS.CURRENT_HUMAN_PLAYER_INDEX) {
            _attachTapGestureToCard(playerIndex: playerIndex, cardIndex: cardIndex);
        }
    }
    
    private func _findCardObjectByCardImageView(imageToFind: UIImageView) -> (playerIndex: Int, cardIndex: Int)? {
        for (pIndex, playerHand) in playersCards.enumerated() {
            // let cardObject = playerHand.first(where: { $0.imageView == imageToFind });
            
            for (cIndex, cardObject) in playerHand.enumerated() {
                if (cardObject.imageView == imageToFind) {
                    return (playerIndex: pIndex, cardIndex: cIndex);
                }
            }
        }
        
        return nil;
    }
    
    
    //
    // MARK: Gestures
    
    private func initGestures() {
        let currentHumanPlayerIndex: Int = CONSTANTS.CURRENT_HUMAN_PLAYER_INDEX;
        let currentPlayerHand = playersCards[currentHumanPlayerIndex];
    
        for cIndex in currentPlayerHand.indices {
            _attachTapGestureToCard(playerIndex: currentHumanPlayerIndex, cardIndex: cIndex);
        }
    }
    
    private func _attachTapGestureToCard(playerIndex: Int, cardIndex: Int) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cardImageViewTapped(tapGestureRecognizer:)));
        
        playersCards[playerIndex][cardIndex].imageView.isUserInteractionEnabled = true;
        playersCards[playerIndex][cardIndex].imageView.addGestureRecognizer(tapGestureRecognizer);
    }
    
    
    @objc func cardImageViewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        guard let tappedImage: UIImageView = tapGestureRecognizer.view as? UIImageView else { return };
        
        guard let (playerIndex, cardIndex) = _findCardObjectByCardImageView(imageToFind: tappedImage) else { return };
        let cardObjectFound = playersCards[playerIndex][cardIndex];
        print("[INFO] img tapped -> \(cardObjectFound.model!.number)-\(cardObjectFound.model!.type.rawValue)");
        
        
        // ////////////////////////
        // TODO: DELETE THIS. (testing ...)
        let cardsHandModels = gameHandler.getCardFromDeck()!;
        print("[INFO] NEWWWW -> \(cardsHandModels.number)-\(cardsHandModels.type.rawValue) \n");
        _updateCardImage(imageToUpdate: playersCards[playerIndex][cardIndex].imageView, newCardModel: cardsHandModels);
    }
}

private typealias T_CardObject = (model: CardModel?, imageView: UIImageView);
private typealias T_PlayerCardsHand = Array<T_CardObject>;
private typealias T_PlayersCards = Array<T_PlayerCardsHand>;
