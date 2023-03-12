//
//  GameViewController.swift
//  fish-staxx
//
//  Created by Sandi Music on 11/03/2023.
//

import UIKit

class GameViewController: UIViewController {
    
    var boardView: AutoLayoutView = AutoLayoutView()
    
    let boardSize: CGFloat = 0.8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.displayBoard()
        
    }
 
    func displayBoard() {
        configureBoard()
    }
    
    func configureBoard() {
        self.view.addSubview(self.boardView)
        self.boardView.backgroundColor = .yellow
        self.boardView.anchorCenter(to: self.view)
        self.boardView.anchorSize(to: self.view, widthMultiplier: self.boardSize, aspectRatio: (4 / 3))
    }
    
}
