//
//  GameViewController.swift
//  three-kings
//
//  Created by Sandi Music on 28/02/2023.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
        
    var board: Board = Board()
    
    // MARK: - Visualisation class members
    
    var boardView: AutoLayoutView = AutoLayoutView()    // Board shape is a square
    var tokens: [[AutoLayoutView?]] = []
    
    let boardSize: CGFloat = 0.8        // %-age of root view width
    let boardPadding: CGFloat = 0.01    // %-age board width/height
    let tokenWidth: CGFloat = 0.188      // %-age board width/height
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.displayBoard()
        self.enableTouchRecognition()
        self.assignClosures()
    }
    
    // MARK: - Game dynamics
    
    func updateTokens(_ move: Move) {
        self.tokens[move.to.row][move.to.column] = self.tokens[move.from.row][move.from.column]
        self.tokens[move.from.row][move.from.column] = nil
    }
    
    func handleValidMove(_ move: Move) {
        if let view: AutoLayoutView = self.tokens[move.from.row][move.from.column] {
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveLinear, animations: {
                view.updateLocationConstraints(location: move.to, padding: self.boardPadding, parent: self.boardView)
            }, completion: { _ in
                if let target: AutoLayoutView = self.tokens[move.to.row][move.to.column] {
                    target.removeConstraints(target.constraints)
                    target.removeFromSuperview()
                }
                self.updateTokens(move)
                self.board.updateBoard(move)
            })
        }
    }
    
    func userDidMove() {
        print("User did move")
    }
    
}
