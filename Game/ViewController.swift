//
//  ViewController.swift
//  Game
//
//  Created by Пользователь on 07.09.2020.
//  Copyright © 2020 Raisat Ramazanova. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!

    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)

    var flipCount = 0 { didSet { flipCountLabel.text = "Flips: \(flipCount)" } }
    var emojiChoices = ["😉", "😜", "🤢", "👻", "👺", "😈", "😀", "😼"]
    var emoji = [Int:String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        game.cards = game.shuffleCards(cards: game.cards)
    }

    func resetCards() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.backgroundColor =  #colorLiteral(red: 0.999968946, green: 0.6284034579, blue: 0.263615257, alpha: 1)
                button.setTitle("", for: UIControl.State.normal)
            }
        }
    }

    func updateViewFromModel() {
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
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
                let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
                emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }

    @IBAction func restartGame(_ sender: UIButton) {
        flipCount = 0
        resetCards()
        game.restartGame()
    }

    @IBAction func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }

}
