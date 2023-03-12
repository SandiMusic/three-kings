//
//  RootViewController.swift
//  three-kings
//
//  Created by Sandi Music on 02/03/2023.
//

import UIKit

class RootViewController: UIViewController {
    
    var activeController: UIViewController
    
    init() {
        self.activeController = LandingViewController()
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(activeController)
        activeController.view.frame = view.bounds
        view.addSubview(activeController.view)
        activeController.didMove(toParent: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func singlePlayerGame() {
        let singleplayergame = GameViewController()
        animateTransition(to: singleplayergame)
    }

    private func animateTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        activeController.willMove(toParent: nil)
        addChild(new)
        
        transition(from: activeController, to: new, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
        }) { completed in
            self.activeController.removeFromParent()
            new.didMove(toParent: self)
            self.activeController = new
            completion?()
        }
    }
    
}
