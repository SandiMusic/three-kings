//
//  AutoLayoutView.swift
//  three-kings
//
//  Created by Sandi Music on 06/03/2023.
//

import UIKit

class AutoLayoutView: UIView {
    
    var boardLocationTopConstraint: NSLayoutConstraint?
    var boardLocationLeftConstraint: NSLayoutConstraint?
    
    init() {
        super.init(frame: CGRect())
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func anchorCenter(to: UIView) {
        UIKit.NSLayoutConstraint.activate([self.centerXAnchor.constraint(equalTo: to.centerXAnchor),
                                           self.centerYAnchor.constraint(equalTo: to.centerYAnchor)])
        
        self.layoutIfNeeded()
    }

    func anchorSize(to: UIView, multiplier: CGFloat) {
        UIKit.NSLayoutConstraint.activate([self.widthAnchor.constraint(equalTo: to.widthAnchor, multiplier: multiplier),
                                           self.heightAnchor.constraint(equalTo: self.widthAnchor)])
        
        self.layoutIfNeeded()
    }
    
    func anchorAtBoardLocation(location: Location, padding: CGFloat, on: UIView) {
        let verticalOffset: CGFloat = self.getVerticalOffset(parent: on, padding: padding, location: location)
        let horizontalOffset: CGFloat = self.getHorizontalOffset(parent: on, padding: padding, location: location)
        
        self.boardLocationTopConstraint = self.topAnchor.constraint(equalTo: on.topAnchor, constant: verticalOffset)
        self.boardLocationLeftConstraint = self.leftAnchor.constraint(equalTo: on.leftAnchor, constant: horizontalOffset)
        
        UIKit.NSLayoutConstraint.activate([self.boardLocationTopConstraint!,
                                           self.boardLocationLeftConstraint!])
        
        self.layoutIfNeeded()
        
    }
    
    func updateLocationConstraints(location: Location, padding: CGFloat, parent: UIView) {
        self.boardLocationTopConstraint?.constant = self.getVerticalOffset(parent: parent, padding: padding, location: location)
        self.boardLocationLeftConstraint?.constant = self.getHorizontalOffset(parent: parent, padding: padding, location: location)
    }
    
    func getHorizontalOffset(parent: UIView, padding: CGFloat, location: Location) -> CGFloat {
        let horizontalPadding: CGFloat = (parent.frame.width * padding) * (CGFloat(location.column) + CGFloat(1.0))
        let horizontalTokenOffset: CGFloat = self.frame.width * CGFloat(location.column)
        
        return horizontalPadding + horizontalTokenOffset
    }
    
    func getVerticalOffset(parent: UIView, padding: CGFloat, location: Location) -> CGFloat {
        let verticalPadding: CGFloat = (parent.frame.height * padding) * (CGFloat(location.row) + CGFloat(1.0))
        let verticalTokenOffset: CGFloat = self.frame.height * CGFloat(location.row)
        
        return verticalPadding + verticalTokenOffset
    }
    
}
