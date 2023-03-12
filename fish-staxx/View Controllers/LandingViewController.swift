//
//  LandingViewController.swift
//  three-kings
//
//  Created by Sandi Music on 02/03/2023.
//

import UIKit

class LandingViewController: UIViewController {
    
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        label.text = "III"
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.textColor = .yellow
        label.frame = CGRect(origin: self.view.center, size: CGSize(width: self.view.frame.width * 0.8, height: self.view.frame.height * 0.4))
        label.center = label.frame.origin
        view.addSubview(label)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            AppDelegate.shared.rootViewController.singlePlayerGame()
        }
    }

}
