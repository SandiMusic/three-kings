//
//  ExtensionGameViewController.swift
//  three-kings
//
//  Created by Sandi Music on 03/03/2023.
//

import UIKit

extension GameViewController {
    
    // MARK: - Setup
    
    func displayBoard() {
        configureBoard()
        spawnTokens()
    }
    
    func configureBoard() {
        self.view.addSubview(self.boardView)
        self.boardView.backgroundColor = .yellow
        self.boardView.anchorCenter(to: self.view)
        self.boardView.anchorSize(to: self.view, multiplier: self.boardSize)
    }
    
    func spawnTokens() {
        for row in 0..<self.board.rows {
            var viewRow: [AutoLayoutView?] = []
            for column in 0..<self.board.columns {
                let location: Location = Location(row, column)
                if let suit: Suit = self.board[location] {
                    let view: AutoLayoutView = AutoLayoutView()
                    if suit == .king {
                        view.backgroundColor = .blue
                    } else {
                        view.backgroundColor = .red
                    }
                    viewRow.append(view)
                    self.boardView.addSubview(view)
                    view.anchorSize(to: self.boardView, multiplier: tokenWidth)
                    view.anchorAtBoardLocation(location: location, padding: self.boardPadding, on: self.boardView)
                }
            }
            self.tokens.append(viewRow)
        }
    }
    
    func assignClosures() {
        self.board.didPerformValidMove = self.handleValidMove
        self.board.didFinishMove = self.endMove
        self.board.didAttemptInvalidMove = self.handleInvalidMove
        self.board.didEndGame = self.endGame
        
    }
    
    func configureStrategist() {
        self.strategist.maxLookAheadDepth = 5
        self.strategist.randomSource = nil
    }
    
    // MARK: - Touch recognition
    
    func enableTouchRecognition() {
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        rightSwipe.direction = .right
        self.boardView.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        leftSwipe.direction = .left
        self.boardView.addGestureRecognizer(leftSwipe)
        
        let upwardSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        upwardSwipe.direction = .up
        self.boardView.addGestureRecognizer(upwardSwipe)
        
        let downwardSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        downwardSwipe.direction = .down
        self.boardView.addGestureRecognizer(downwardSwipe)
        
    }
    
    /// Returns the board location for a touch point on the game board
    ///
    /// - Parameters point: Starting point of the touch within the boards coordinate system.
    /// - Returns: Location corresponding to the starting touch point.
    func translatePoint(_ point: CGPoint) -> Location {
        let rowColumnWidth: CGFloat = self.boardView.frame.width / CGFloat(self.board.columns)
        let row: Int = Int(floor(point.y / rowColumnWidth))
        let column: Int = Int(floor(point.x / rowColumnWidth))
        
        return Location(row, column)
    }
    
}
