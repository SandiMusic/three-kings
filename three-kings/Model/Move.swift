//
//  Move.swift
//  three-kings
//
//  Created by Sandi Music on 02/03/2023.
//

import GameplayKit

class Move: NSObject, GKGameModelUpdate {
    
    var value: Int = 0
    
    var from: Location
    var to: Location
    
    init(from: Location, to: Location) {
        self.from = from
        self.to = to
    }
    
}
