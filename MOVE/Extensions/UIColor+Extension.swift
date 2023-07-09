//
//  UIColor+Extension.swift
//  MOVE
//
//  Created by Fakunabs on 08/05/2023.
//

import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexValue: UInt32 = 0
        let scanner = Scanner(string: hex)
        scanner.scanLocation = hex.hasPrefix("#") ? 1 : 0
        scanner.scanHexInt32(&hexValue)
        let red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hexValue & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
