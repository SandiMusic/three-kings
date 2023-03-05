//
//  ExtensionUIView.swift
//  three-kings
//
//  Created by Sandi Music on 04/03/2023.
//

import UIKit

extension UIView {
    
    func anchorCenter(to: UIView) {
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: to.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: to.centerYAnchor)
        ])
        self.layoutIfNeeded()
    }
    
    func anchorSize(to: UIView, multiplier: CGFloat) {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalTo: to.widthAnchor, multiplier: multiplier),
            self.heightAnchor.constraint(equalTo: self.widthAnchor) // Not an issue given portrait mode only
        ])
        self.layoutIfNeeded()
    }
    
    func anchorAtLocation(row: Int, column: Int, padding: CGFloat, on: UIView) {
        let verticalPadding: CGFloat = (on.frame.height * padding) * (CGFloat(row) + CGFloat(1.0))
        let horizontalPadding: CGFloat = (on.frame.width * padding) * (CGFloat(column) + CGFloat(1.0))
        let verticalTokenOffset: CGFloat = self.frame.height * CGFloat(row)
        let horizontalTokenOffset: CGFloat = self.frame.width * CGFloat(column)
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: on.topAnchor, constant: verticalPadding + verticalTokenOffset),
            self.leftAnchor.constraint(equalTo: on.leftAnchor, constant: horizontalPadding + horizontalTokenOffset)
        ])
        
        self.layoutIfNeeded()
    }
    
}
