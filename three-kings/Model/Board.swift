//
//  Board.swift
//  three-kings
//
//  Created by Sandi Music on 01/03/2023.
//

import Foundation
import UIKit

class Board: NSObject {
    
    let rows: Int = 5
    let columns: Int = 5
    
    var tokens: [[Suit?]] = [
        [.enemy,.enemy,.enemy,.enemy,.king],
        [.enemy,.enemy,.enemy,.enemy,.enemy],
        [.enemy,.enemy,.king,.enemy,.enemy],
        [.enemy,.enemy,.enemy,.enemy,.enemy],
        [.king,.enemy,.enemy,.enemy,.enemy]
    ]

    // MARK: - Callbacks
    
    var didMove: (() -> ())?
    var didAttemptValidMove: ((Move) -> ())?
    var didAttemptInvalidMove: (() -> ())?
    
    // MARK: - Players
    var userPlayer: Player = Player(.king)
    var currentPlayer: Player = Player(.king)
    
    //MARK: - Utilities
    
    subscript(location: Location) -> Suit? {
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
    func getSuitAt(_ location: Location) -> Suit? {
        return self[location]
    }
    
    // MARK: - Game logic
    
    /// Check whether a given location is located on the board.
    ///
    /// - Parameters location: The location user wants to check.
    /// - Returns: Boolean indicating whether location is on the board.
    func isWithinBounds(_ location: Location) -> Bool {
        return (location.row >= 0 && location.row < self.rows) && (location.column >= 0 && location.column < self.columns)
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
        if let suit = getSuitAt(move.from) {
            switch suit {
            case .king:
                if let target = getSuitAt(move.to) {
                    return (target == .enemy) && isMoveLinear(move)
                } else {
                    return false
                }
            default:
                return (getSuitAt(move.to) == nil) && isMoveLinear(move)
            }
        }
        
        return false
    }
    
    /// Checks that the suit of the token to be moved matches the player's suit.
    ///
    /// - Parameters move: The move the user is trying to execute.
    /// - Returns: Boolean indicating whether player assigned suit matches the token.
    func isMoveMatchingSuit(_ move: Move) -> Bool {
        return self[move.from] == self.currentPlayer.suit
    }
    
    /// Checks the overall validity of a move.
    ///
    /// If a move is starting within the bounds of the board, adhering to the rules and in line with the
    /// moving player's assigned suit, it is considered valid, otherwise it is not.
    ///
    /// - Parameters move: The move the user is trying to execute.
    /// - Returns: Boolean indicating whether move is adhering to the rules.
    func isMoveValid(_ move: Move) -> Bool {
        return isWithinBounds(move.from) && isWithinBounds(move.to) && isMoveAllowed(move) && isMoveMatchingSuit(move)
    }
    
    // MARK: - Game mechanics
    
    func checkMove(from: Location, direction: UISwipeGestureRecognizer.Direction) {
        let to: Location = self.getAdjacentLocation(from, direction: direction)
        let move: Move = Move(from: from, to: to)
        
        if self.isMoveValid(move) {
            self.didAttemptValidMove?(move)
        } else {
            //TODO: implement attempt invalid move
            print("Invalid move")
        }
    }
    
    func getAdjacentLocation(_ location: Location, direction: UISwipeGestureRecognizer.Direction) -> Location {
        switch direction {
        case .right:
            return Location(location.row, location.column + 1)
        case .left:
            return Location(location.row, location.column - 1)
        case .up:
            return Location(location.row - 1, location.column)
        case .down:
            return Location(location.row + 1, location.column)
        default:
            return location
        }
    }
    
    func updateBoard(_ move: Move) {
        self[move.to] = self[move.from]
        self[move.from] = nil
        self.didMove?()
    }
    
}
