//
//  Board.swift
//  three-kings
//
//  Created by Sandi Music on 01/03/2023.
//

import GameplayKit

class Board: NSObject, GKGameModel {
    
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
    
    var didFinishMove: (() -> ())?
    var didPerformValidMove: ((Move) -> ())?
    var didAttemptInvalidMove: ((Move) -> ())?
    var didEndGame: (() -> ())?
    
    // MARK: - Players
    
    var userPlayer: Player = Player(.king)
    var currentPlayer: Player = Player(.king)
    
    var players: [GKGameModelPlayer]? {
        return Player.allPlayers
    }
    
    var activePlayer: GKGameModelPlayer? {
        return self.currentPlayer
    }
    
    var isUserTurn: Bool {
        return self.userPlayer.suit == self.currentPlayer.suit
    }
    
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
    
    /// Returns an array of all locations on the board for a given suit.
    ///
    /// - Parameters suit: The suit to find the locations for.
    /// - Returns: Array of locations.
    func locations(for suit: Suit) -> Array<Location> {
        var locations = [Location]()
        for row in 0..<self.rows {
            for column in 0..<self.columns {
                if let token = getSuitAt(Location(row, column)) {
                    if token == suit {
                        locations.append(Location(row, column))
                    }
                }
            }
        }
        return locations
    }
    
    /// Returns an array of allowed moves for a given suit.
    ///
    /// - Parameters suit: The suit to find the moves for.
    /// - Returns: Array of moves.
    func moves(for suit: Suit) -> Array<Move> {
        var moves: [Move] = []
        let directions: [UISwipeGestureRecognizer.Direction] = [.up, .down, .right, .left]
        for location in self.locations(for: suit) {
            for direction in directions {
                let destination = self.getAdjacentLocation(location, direction: direction)
                let move = Move(from: location, to: destination)
                
                if isMoveValid(move) {
                    moves.append(move)
                }
            }
        }
        return moves
    }
    
    func dist(between locations: [Location]) -> Double {
        var distances: [Double] = []
        
        for i in 0..<locations.count {
            for j in (i + 1)..<locations.count {
                let loc1: Location = locations[i]
                let loc2: Location = locations[j]
                let dist: Double = sqrt(pow(Double(loc2.row - loc1.row), 2) + pow(Double(loc2.column - loc1.column), 2))
                
                distances.append(dist)
            }
        }
        
        return distances.reduce(0, +) / Double(locations.count)
    }
    
    func processMove(_ move: Move) {
        if self.isMoveValid(move) {
            self.didPerformValidMove?(move)
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
    
    func takeTurn() {
        self.currentPlayer = self.currentPlayer.opponent
    }
    
    func update(_ move: Move) {
        self[move.to] = self[move.from]
        self[move.from] = nil
        
        self.takeTurn()
        self.checkGameState()
        
    }
    
    func checkGameState() {
        if self.isWin(for: self.currentPlayer) {
            self.didEndGame?()
        } else {
            self.didFinishMove?()
        }
    }
    
    // MARK: - GKGameModel conformance
    
    /// Checks whether a given plater has won the game.
    ///
    /// King wins if he has no more moves available on his turn, i.e. no enemies on adjacent fields.
    /// Enemy wins if all three kings are either in the same row or the same column.
    ///
    /// - Parameters suit: Suit to check the win for.
    /// - Returns: Boolean indicating whether the specified suit has won.
    private func isWin(for player: Player) -> Bool {
        if player.suit == .king {
            return moves(for: player.suit).isEmpty && currentPlayer.suit == .king
        }
        
        let kings = locations(for: .king)
        let kingsInRow = (kings[0].row == kings[1].row) && (kings[0].row == kings[2].row)
        let kingsInColumn = (kings[0].column == kings[1].column) && (kings[0].column == kings[2].column)
        
        return kingsInRow || kingsInColumn
    }
    
    func score(for player: GKGameModelPlayer) -> Int {
        if let player = player as? Player {
            if isWin(for: player) {
                return 10000
            } else if isWin(for: player.opponent) {
                return -10000
            }
            
            let moves: [Move] = moves(for: .king)
            let locations: [Location] = locations(for: .king)
            let rows: Set<Int> = Set(locations.map { loc in loc.row })
            let columns: Set<Int> = Set(locations.map { loc in loc.column })
            let distance: Double = dist(between: locations)
            
            let rowColumnPenalty: Int = max(rows.count^4, columns.count^4) - 1
            let distanceReward: Int = Int(ceil(10 / (1 - distance) + 10))
            
            switch player.suit {
            case .king:
                let numMovesScore: Int = Int(ceil(Double(60) * exp(-0.25 * Double(moves.count)) - Double(5)))
                
                return numMovesScore - rowColumnPenalty + distanceReward
            case .enemy:
                let numMovesScore: Int = Int(ceil(Double(5) * exp(0.25 * Double(moves.count)) - Double(5)))
                
                return numMovesScore + rowColumnPenalty - distanceReward
            }
        }

        return 0
    }
    
    func setGameModel(_ gameModel: GKGameModel) {
        if let board = gameModel as? Board {
            tokens = board.tokens
            currentPlayer = board.currentPlayer
        }
    }
    
    func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        guard let player = player as? Player else {
            return nil
        }
        
        if isWin(for: player) {
            return nil
        }
        
        return moves(for: player.suit)
    }
    
    func apply(_ gameModelUpdate: GKGameModelUpdate) {
        guard let move = gameModelUpdate as? Move else {
            return
        }
        
        update(move)
        currentPlayer = currentPlayer.opponent
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Board()
        copy.setGameModel(self)
        
        return copy
    }
    
}
