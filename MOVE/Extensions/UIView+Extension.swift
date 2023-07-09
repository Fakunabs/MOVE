//
//  UIView+Extension.swift
//  MOVE
//
//  Created by Fakunabs on 30/05/2023.
//

import UIKit
import Foundation

extension UIView {
    func applyDropShadow(cornerRadius: CGFloat, shadowColor: CGColor, shadowOffset: CGSize, shadowOpacity: Float, shadowRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.masksToBounds = false
    }
}
