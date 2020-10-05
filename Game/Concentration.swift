//
//  Concentration.swift
//  Game
//
//  Created by Пользователь on 17.09.2020.
//  Copyright © 2020 Raisat Ramazanova. All rights reserved.
//

import Foundation

struct Concentration
{
    var cards = [Card]()
    
    var flipCount = 0
    
    private var indexOfOneAndOnlyFaceCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }

        
    mutating func chooseCard(at index:Int) {
        assert(cards.indices.contains(index), "Concentration.shooseCard(at: \(index)): chosen index not in the cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceCard, matchIndex != index {
                if cards[matchIndex] == cards[index]{
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceCard = index
            }
        }
    }
    
    mutating func shuffleCards(cards: [Card]) -> [Card] {
        var randomCards = cards
        randomCards.shuffle()
        return randomCards
    }

    mutating func restartGame() {
        self.flipCount = 0
        for (index, _) in cards.enumerated() {
            cards[index].isMatched = false
            cards[index].isFaceUp = false
        }
        cards = shuffleCards(cards: cards)
    }
    
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
