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
    
    // Visuals
    var boardView: UIView = UIView()
    let boardSize: CGFloat = 0.8        // % parent width
    let boardPadding: CGFloat = 0.01    // % parent width/height
    let tokenWidth: CGFloat = 0.188     // % parent width/height

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.displayBoard()
        
    }
    
}
