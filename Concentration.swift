//
//  Concentration.swift
//  Game
//
//  Created by Пользователь on 17.09.2020.
//  Copyright © 2020 Raisat Ramazanova. All rights reserved.
//

import Foundation

class Concentration {
    
    var cards = [Card]()
    var indexOfOneAndOnlyFaceCard: Int?
    
    func chooseCard(at index:Int) {
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceCard = nil
            } else {
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceCard = index
            }
        }
    }
    
    func shuffleCards(cards: [Card]) -> [Card] {
        var randomCards = cards
        randomCards.shuffle()
        return randomCards
    }
    
    
    func newGame(cardsArray: [Card]) -> [Card] {
        cards = shuffleCards(cards: cardsArray)
        return cards
    }
    

    func restartGame(cardsArray: [Card]) -> [Card]{
        var newCards =  cardsArray
        newCards.removeAll()
        newCards = [Card]()
        cards = shuffleCards(cards: newCards)
        return cards
    }
    
    
    init(numberOfPairsOfCards: Int) {
        for _ in 0..<numberOfPairsOfCards
        {
            let card = Card()
            cards += [card, card]
        }
    }
}
