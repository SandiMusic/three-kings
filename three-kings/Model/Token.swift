//
//  Token.swift
//  three-kings
//
//  Created by Sandi Music on 01/03/2023.
//

import SpriteKit

struct Token {
    
    var suit: Suit
    var view: AutoLayoutView = AutoLayoutView()
    
    init(_ suit: Suit) {
        self.suit = suit
        
        if suit.name == "Enemy" {
            self.view.backgroundColor = .red
        } else {
            self.view.backgroundColor = .blue
        }
    }
    
}
