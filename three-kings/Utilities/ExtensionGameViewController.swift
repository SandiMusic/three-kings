//
//  ExtensionGameViewController.swift
//  three-kings
//
//  Created by Sandi Music on 03/03/2023.
//

import UIKit

extension GameViewController {
    
    // MARK: - Visual setup
    
    func displayBoard() {
        configureBoard()
        spawnTokens()
    }
    
    func configureBoard() {
        self.view.addSubview(self.boardView)
        self.boardView.translatesAutoresizingMaskIntoConstraints = false
        self.boardView.backgroundColor = .yellow
        self.boardView.anchorCenter(to: self.view)
        self.boardView.anchorSize(to: self.view, multiplier: self.boardSize)
    }
    
    func spawnTokens() {
        for i in 0..<self.board.rows {
            for j in 0..<self.board.columns {
                if let suit: String = self.board[Location(i, j)]?.suit.name {
                    let token: UIView = UIView()
                    if suit == "Enemy" {
                        token.backgroundColor = .red
                    } else {
                        token.backgroundColor = .blue
                    }
                    self.boardView.addSubview(token)
                    token.translatesAutoresizingMaskIntoConstraints = false
                    token.anchorSize(to: self.boardView, multiplier: tokenWidth)
                    token.anchorAtLocation(row: i, column: j, padding: self.boardPadding, on: self.boardView)
                }
            }
        }
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
        switch sender.direction {
        case .right:
            print("right")
            print(startingPoint)
            print(translateTouch(startingPoint))
        case .left:
            print("left")
            print(startingPoint)
            print(translateTouch(startingPoint))
        case .up:
            print("up")
            print(startingPoint)
            print(translateTouch(startingPoint))
        case .down:
            print("down")
            print(startingPoint)
            print(translateTouch(startingPoint))
        default:
            break
        }
    }
    
    /// Returns the board location for a touch point on the game board
    ///
    /// - Parameters point: Starting point of the touch within the boards coordinate system.
    /// - Returns: Location corresponding to the starting touch point.
    func translateTouch(_ point: CGPoint) -> Location {
        let rowColumnWidth: CGFloat = self.boardView.frame.width / CGFloat(self.board.columns)
        let row: Int = Int(floor(point.y / rowColumnWidth))
        let column: Int = Int(floor(point.x / rowColumnWidth))
        
        return Location(row, column)
    }
    
}
