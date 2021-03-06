//
//  ViewController.swift
//  Game
//
//  Created by Пользователь on 07.09.2020.
//  Copyright © 2020 Raisat Ramazanova. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }

    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key:Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 0.999968946, green: 0.6284034579, blue: 0.263615257, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(game.flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel!{
       didSet {
           updateFlipCountLabel()
      }
   }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func restartGame(_ sender: UIButton) {
        let alertController = UIAlertController(
            title: "New game",
            message: "Do you want to restart?",
            preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(
                                    title: "Yes",
                                    style: UIAlertAction.Style.default,
                                    handler:{ _ in
                                        self.game.restartGame()
                                        self.updateFlipCountLabel()
                                        self.updateViewFromModel()
                                    }))
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            game.flipCount += 1
            updateFlipCountLabel()
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        game.cards = game.shuffleCards(cards: game.cards)
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0.999968946, green: 0.6284034579, blue: 0.263615257, alpha: 0) : #colorLiteral(red: 0.999968946, green: 0.6284034579, blue: 0.263615257, alpha: 1)
            }
        }
    }
 
    private var emojiChoices = "🥶😜🤢👻👺😈😡🐷"
    private var emoji = [Card:String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
}
