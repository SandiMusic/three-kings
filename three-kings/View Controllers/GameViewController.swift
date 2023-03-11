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
    var strategist: GKMinmaxStrategist = GKMinmaxStrategist()
    
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
        self.configureStrategist()
        
        self.startGame()

    }
    
    // MARK: - Game dynamics
    
    func startGame() {
        self.boardView.isUserInteractionEnabled = self.board.isUserTurn
        self.strategist.gameModel = self.board
        
        self.resumeGame()
    }
    
    func resumeGame() {
        self.boardView.isUserInteractionEnabled = self.board.isUserTurn
        
        if !self.board.isUserTurn {
            let move = self.generateCpuMove()
            self.board.processMove(move)
        }
    }
    
    func updateTokenViews(_ move: Move) {
        self.tokens[move.to.row][move.to.column] = self.tokens[move.from.row][move.from.column]
        self.tokens[move.from.row][move.from.column] = nil
    }
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        let startingPoint = sender.location(in: self.boardView)
        let startingLocation = self.translatePoint(startingPoint)
        
        let move: Move = Move(from: startingLocation, to: self.board.getAdjacentLocation(startingLocation, direction: sender.direction))
        self.board.processMove(move)
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
                self.updateTokenViews(move)
                self.board.update(move)
            })
        }
        
    }
    
    func handleInvalidMove(_ move: Move) {
        print("invalid move")
    }
    
    func endMove() {
        self.resumeGame()
    }
    
    func endGame() {
        print("game ended")
        print("winner is", self.board.currentPlayer.suit)
        self.boardView.isUserInteractionEnabled = false
    }
    
    func generateCpuMove() -> Move {
        if let cpuMove = self.strategist.bestMove(for: self.board.currentPlayer) as? Move {
            print("AI Move", cpuMove)
            return cpuMove
        }
        
        print("random move")
        return self.board.moves(for: self.board.currentPlayer.suit).randomElement()!
    }
    
}
