//
//  Extensions.swift
//  Flashlight
//
//  Created by Filip  Gonera on 20/07/2018.
//  Copyright © 2018 Filip  Gonera. All rights reserved.
//

import Foundation
import UIKit

extension UIButton
{
    func applyGradient(colors: [CGColor])
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        self.layer.addSublayer(gradientLayer)
    }
}


