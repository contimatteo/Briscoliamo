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
    
    @IBOutlet weak var currentCard1: UIImageView!
    @IBOutlet weak var currentCard2: UIImageView!
    @IBOutlet weak var currentCard3: UIImageView!
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load all the cards.
        gameHandler.loadCards();
        
        // load first 3 cards.
        self._setInitialCardHand();
    }


    private func _setInitialCardHand() {
        let card1: CardModel = gameHandler.getCardFromDeck()!;
        let card2: CardModel = gameHandler.getCardFromDeck()!;
        let card3: CardModel = gameHandler.getCardFromDeck()!;
        
        currentCard1.image = UIImage.init(named: card1.imageUrl);
        currentCard2.image = UIImage.init(named: card2.imageUrl);
        currentCard3.image = UIImage.init(named: card3.imageUrl);
    }
}

