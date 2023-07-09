//
//  AppFont.swift
//  MOVE
//
//  Created by Vinh Nguyen on 08/05/2023.
//

import UIKit

struct AppFonts {
    static let fontMontserratBold = "Montserrat-Bold"
    static let fontMontserratRegular = "Montserrat-Regular"
    static let fontMontserratItalic = "Montserrat-Italic"
    static let fontMontserratSemiBold = "Montserrat-SemiBold"
    
    static func fontMontserratBold(size: CGFloat) -> UIFont? {
        return UIFont(name: fontMontserratBold, size: size)
    }
    
    static func fontMontserratItalic(size: CGFloat) -> UIFont? {
        return UIFont(name: fontMontserratItalic, size: size)
    }
    
    static func fontMontserratRegular(size: CGFloat) -> UIFont? {
        return UIFont(name: fontMontserratRegular, size: size)
    }
    
    static func fontMontserratSemiBold(size: CGFloat) -> UIFont? {
        return UIFont(name: fontMontserratSemiBold, size: size)
    }
    
}
