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
    private var playersCards: T_PlayersCards = [];
    private var player1Cards: T_PlayerCardsHand = [];
    private var player2Cards: T_PlayerCardsHand = [];
    private var player3Cards: T_PlayerCardsHand = [];
    private var player4Cards: T_PlayerCardsHand = [];
    private var trumpCard: T_CardObject?;
    private var tableCards: T_PlayerCardsHand = [];
    
    //
    // MARK: Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// prepare player's cards variables.
        _prepareAssets();
        
        /// load all the cards and load 3 cards foreach player,
        /// load the trump card, create players and load 3 cards for these.
        gameHandler.initializeGame(mode: .singleplayer, numberOfPlayers: CONSTANTS.NUMBER_OF_PLAYERS, playersType: [.human, .virtual]);
        
        /// gestures
        _initGestures()
        
        
        render();
    }
    
    public func render() {
        /// display players initial cards hand.
        for (pIndex, starterCardHand) in playersCards.enumerated() {
            if (pIndex < gameHandler.players.count) {
                /// retrieve the initial cards for this player.
                let cardsHandModels: PlayerCardHand = gameHandler.players[pIndex].currentCardHand;
                
                /// update each cards in the initial hand.
                for (cIndex, card) in starterCardHand.enumerated() {
                    if (cardsHandModels.indices.contains(cIndex)) {
                        _updateCardImage(imageToUpdate: card.imageView, newCardModel: cardsHandModels[cIndex]);
                    }
                }
            }
        }
        
        /// display the card trump
        let trumpCardModel = gameHandler.game.trumpCard;
        if trumpCardModel == nil {
            trumpCard!.imageView.image = trumpCardModel!.image;
            trumpCard!.model = trumpCardModel!;
        }
        
        /// display the card on table
        for (card) in tableCards {
            guard let cardModel = card.model else { continue };
            _updateTableCardImage(imageToUpdate: card.imageView, newCardModel: cardModel);
        }
    }
    
    //
    // MARK: Private Methods
    
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
        
        tableCards.append(T_CardObject(model: nil, imageView: tc1ImgView));
        tableCards.append(T_CardObject(model: nil, imageView: tc2ImgView));
        tableCards.append(T_CardObject(model: nil, imageView: tc3ImgView));
        tableCards.append(T_CardObject(model: nil, imageView: tc4ImgView));
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
    
    private func _updateTableCardImage(imageToUpdate: UIImageView, newCardModel: CardModel) {
        for (index, cardObject) in tableCards.enumerated() {
            if (cardObject.imageView == imageToUpdate) {
                tableCards[index].imageView.image = newCardModel.image;
                tableCards[index].model = newCardModel;
            }
        }
    }
    
    private func _initGestures() {
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
    
    private func _playCard(playerIndex: Int, cardIndex: Int) -> Bool {
        let cardObjectFound = playersCards[playerIndex][cardIndex];
        let cardPlayed = gameHandler.playOneCard(playerIndex: playerIndex, card: cardObjectFound.model!);
        
        if (cardPlayed) {
            print("[_playCard] set card on the table ? \(cardPlayed)");
            
            // set the card on the table.
            _updateTableCardImage(imageToUpdate: tableCards[playerIndex].imageView, newCardModel: cardObjectFound.model!);
            
            /// unset the card for this player.
            playersCards[playerIndex][cardIndex].imageView.image = nil;
            playersCards[playerIndex][cardIndex].model = nil;
        }
        
        return cardPlayed;
    }
    
    //
    // MARK: Gestures
    
    @objc func cardImageViewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        guard let tappedImg: UIImageView = tapGestureRecognizer.view as? UIImageView else { return };
        guard let (playerIndex, cardIndex) = _findCardObjectByCardImageView(imageToFind: tappedImg) else { return };
        
        print("[cardImageViewTapped] \((playerIndex, cardIndex))");
        
        /// play the card.
        let cardPlayed: Bool = _playCard(playerIndex: playerIndex, cardIndex: cardIndex);
        
        /// TODO: missin logic ...
        print("[cardImageViewTapped] render ? \(cardPlayed)");
        
        if (cardPlayed) {
            render()
        }
    }
}

private typealias T_CardObject = (model: CardModel?, imageView: UIImageView);
private typealias T_PlayerCardsHand = Array<T_CardObject>;
private typealias T_PlayersCards = Array<T_PlayerCardsHand>;
