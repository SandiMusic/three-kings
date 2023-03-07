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
        self.board.didAttemptValidMove = self.handleValidMove
        self.board.didMove = self.userDidMove
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
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        let startingPoint = sender.location(in: self.boardView)
        let startingLocation = self.translatePoint(startingPoint)
        
        self.board.checkMove(from: startingLocation, direction: sender.direction)
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
    
    /// Returns the point on the board view for given location on the grid
    ///
    /// - Parameters location: Row, column on the board to be translated to a point on the screen.
    /// - Returns: Location corresponding to the starting touch point.
    func translateLocation(_ location: Location) -> CGPoint {
        let tokenWidth: CGFloat = self.boardView.frame.width * self.tokenWidth  // Equal to token height
        let padding: CGFloat = self.boardView.frame.width * self.boardPadding
        let verticalOffset: CGFloat = padding * (CGFloat(location.row) + CGFloat(1.0)) + tokenWidth * CGFloat(location.row)
        let horizontalOffset: CGFloat = padding * (CGFloat(location.column) + CGFloat(1.0)) + tokenWidth * CGFloat(location.column)
        
        return CGPoint(x: horizontalOffset, y: verticalOffset)
    }
    
    // MARK: - Rendering of game dynamics
    
    func handleValidMove(_ move: Move) {
        if let view: AutoLayoutView = self.tokens[move.from.row][move.from.column] {
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveLinear, animations: {
                view.updateLocationConstraints(location: move.to, padding: self.boardPadding, parent: self.boardView)
            }, completion: { _ in
                if let target: AutoLayoutView = self.tokens[move.to.row][move.to.column] {
                    target.removeConstraints(target.constraints)
                    target.removeFromSuperview()
                }
                self.tokens[move.to.row][move.to.column] = self.tokens[move.from.row][move.from.column]
                self.tokens[move.from.row][move.from.column] = nil
                self.board.updateBoard(move)
            })
        }
    }
    
    func userDidMove() {
        print("User did move")
    }
    
}
