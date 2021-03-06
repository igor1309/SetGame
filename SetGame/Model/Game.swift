//
//  Game.swift
//  SetGame
//
//  Created by Igor Malyarov on 05.06.2020.
//  Copyright © 2020 Igor Malyarov. All rights reserved.
//
//  Stanford CS193p
//  https://cs193p.sites.stanford.edu
//  Assignment III: Set
//

import SwiftUI

struct Game {
    private var deck: [Card]//Set<Card>
    
    private init(deck: Set<Card>) {
        self.deck = Array(deck)//deck
    }

    init() {
        self.init(deck: Game.createDeck())
    }
    
    static func createDeck() -> Set<Card> {
        let cards = Card.NumberOfShapes.allCases.flatMap { numberOfShapes in
            Card.CardShape.allCases.flatMap { shape in
                Card.CardColor.allCases.flatMap { color in
                    Card.CardShading.allCases.map { shading in
                        Card(numberOfShapes: numberOfShapes,
                             shape: shape,
                             color: color,
                             shading: shading)
                    }
                }
            }
        }
        return Set(cards)
    }
    
    private(set) var match: Bool?
    private(set) var result: String = ""
    
    private var selectedCards: [Card] { deck.filter { $0.isSelected } }
    
    //  MARK: - Model access
    
    func cards() -> [Card] {//SSet<Card> {
        deck
    }
    
    //  MARK: - Intent(s)
    
    mutating func selectCard(_ card: Card) {
        guard let index = deck.firstIndex(of: card) else { return }
        
        if selectedCards.count < 3 {
            deck[index].isSelected.toggle()
        }
            
        if selectedCards.count == 3 {
            (match, result) = matchResult()
            print(result)
            for card in selectedCards { markCard(card, match: match!) }
        }
        
        
    }
    
    mutating func markCard(_ card: Card, match: Bool) {
        guard let index = deck.firstIndex(of: card) else { return }
        
        deck[index].isMatch = match
    }
    
    func matchResult() -> (Bool, String) {
        guard selectedCards.count == 3 else { return (false, "") }
        
        //  Сет состоит из трёх карт, которые удовлетворяют всем условиям:
        //  все карты имеют то же количество символов или же 3 различных значения;
        //  все карты имеют тот же символ или же 3 различных символа;
        //  все карты имеют ту же текстуру или же 3 различных варианта текстуры;
        //  все карты имеют тот же цвет или же 3 различных цвета.

        let condition1 = selectedCards.map { $0.numberOfShapes }.allSameOrDifferent()
        let condition2 = selectedCards.map { $0.shape }.allSameOrDifferent()
        let condition3 = selectedCards.map { $0.color }.allSameOrDifferent()
        let condition4 = selectedCards.map { $0.shading }.allSameOrDifferent()
        
        let match = condition1 && condition2 && condition3 && condition4
        
        let result1 = condition1 ? "" : "Number of shapes don't match."
        let result2 = condition2 ? "" : "Shapes don't match."
        let result3 = condition3 ? "" : "Colors don't match."
        let result4 = condition4 ? "" : "Shading don't match."
        
        let result = [result1, result2, result3, result4]
                        .filter { !$0.isEmpty }
            .joined(separator: "\n")
                        
        return (match, result.isEmpty ? "It's a match!!" : result)
    }
    
    mutating func reset() {
        deck = Array(Game.createDeck())
        match = nil
        result = ""
    }
}
