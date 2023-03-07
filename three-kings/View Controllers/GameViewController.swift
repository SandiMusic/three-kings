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
    
}
