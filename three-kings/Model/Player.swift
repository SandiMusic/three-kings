//
//  Player.swift
//  three-kings
//
//  Created by Sandi Music on 07/03/2023.
//

import GameplayKit

class Player: NSObject, GKGameModelPlayer {
    
    var suit: Suit
    var playerId: Int
    var name: String
    
    init(suit: Suit) {
        self.suit = suit
        self.playerId = suit.rawValue
        self.name = suit.name
    }
    
    static var allPlayers = [Player(suit: .king), Player(suit: .enemy)]
    
    var opponent: Player {
        if self.suit == .king {
            return Player.allPlayers[1]
        }
        return Player.allPlayers[0]
    }
    
}
