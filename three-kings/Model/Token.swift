//
//  Token.swift
//  three-kings
//
//  Created by Sandi Music on 01/03/2023.
//

import SpriteKit

struct Token {
    
    var suit: Suit
    var sprite: SKSpriteNode
    
    init(_ suit: Suit) {
        self.suit = suit
        self.sprite = SKSpriteNode(imageNamed: suit.name)
    }
    
}
