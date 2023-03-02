//
//  Board.swift
//  three-kings
//
//  Created by Sandi Music on 01/03/2023.
//

import Foundation

let numRows: Int = 5
let numColumns: Int = 5

class Board: NSObject {
    
    var tokens: [[Token?]] = [
        [Token(.enemy),Token(.enemy),Token(.enemy),Token(.enemy),Token(.king)],
        [Token(.enemy),Token(.enemy),Token(.enemy),Token(.enemy),Token(.enemy)],
        [Token(.enemy),Token(.enemy),Token(.king),Token(.enemy),Token(.enemy)],
        [Token(.enemy),Token(.enemy),Token(.enemy),Token(.enemy),Token(.enemy)],
        [Token(.king),Token(.enemy),Token(.enemy),Token(.enemy),Token(.enemy)]
    ]
    
    subscript(location: Location) -> Token? {
        get {
            return tokens[location.row][location.column]
        }
        set {
            tokens[location.row][location.column] = newValue
        }
    }
    
}
