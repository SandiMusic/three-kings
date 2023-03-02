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
    
    /// Returns the token object at a given location on the board.
    ///
    /// - Parameters location: The location at which to return the token.
    /// - Returns: Token at input location (optional).
    func getTokenAt(_ location: Location) -> Token? {
        return self[location]
    }
    
    /// Check whether a given location is located on the board.
    ///
    /// - Parameters location: The location user wants to check.
    /// - Returns: Boolean indicating whether location is on the board.
    func isWithinBounds(_ location: Location) -> Bool {
        return (location.row >= 0 && location.row < numRows) && (location.column >= 0 && location.column < numColumns)
    }
    
    /// Check whether a move is being performed either horizontally or vertically.
    ///
    /// - Parameters move: The move the user is trying to execute.
    /// - Returns: Boolean indicating whether move is linear.
    func isMoveLinear(_ move: Move) -> Bool {
        return (move.from.row == move.to.row) || (move.from.column == move.to.column)
    }
    
    /// Checks whether a move adheres to the rules of the game.
    ///
    /// All moves have to be either horizontal or vertical, regardless of the suit of the token.
    /// Enemy tokens can only move to empty locations, whereas king tokens have to move
    /// to locations occupied by enemy tokens.
    ///
    /// - Parameters move: The move the user is trying to execute.
    /// - Returns: Boolean indicating whether move is adhering to the rules.
    func isMoveAllowed(_ move: Move) -> Bool {
        if let token = getTokenAt(move.from) {
            switch token.suit {
            case .king:
                if let target = getTokenAt(move.to) {
                    return (target.suit == .enemy) && isMoveLinear(move)
                } else {
                    return false
                }
            default:
                return (getTokenAt(move.to) == nil) && isMoveLinear(move)
            }
        }
        
        return false
    }
    
    /// Checks the overall validity of a move.
    ///
    /// If a move is starting within the bounds of the board and adhering to the rules, it
    /// is considered valid, otherwise it is not.
    ///
    /// - Parameters move: The move the user is trying to execute.
    /// - Returns: Boolean indicating whether move is adhering to the rules.
    func isMoveValid(_ move: Move) -> Bool {
        return isWithinBounds(move.from) && isMoveAllowed(move)
    }
    
}
