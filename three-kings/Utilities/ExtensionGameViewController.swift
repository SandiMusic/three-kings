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
    
}
