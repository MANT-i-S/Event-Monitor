//
//  CustomImageView.swift
//  Event-Monitor
//
//  Created by Serhii Holiak on 5/26/21.
//

import UIKit

class CustomImageView: UIView {

    var check = "Hello"
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 20)
        roundedRect.addClip()
        UIColor.black.setFill()
        roundedRect.fill()
        let image = UIImage(named: "NoImagePlaceholder")
        image?.draw(in: bounds)
    }

}
