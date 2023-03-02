//
//  Suit.swift
//  three-kings
//
//  Created by Sandi Music on 01/03/2023.
//

import SpriteKit

enum Suit: Int {
    
    case enemy = 0, king
    
    var name: String {
        switch self.rawValue {
        case 0:
            return "Enemy"
        default:
            return "King"
        }
    }
    
}
