//
//  UILabel+Extension.swift
//  MOVE
//
//  Created by Fakunabs on 30/05/2023.
//

import UIKit
import Foundation

extension UILabel {
    func configLineSpacing(lineSpacing: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        let attributedText = NSMutableAttributedString(string: self.text ?? "")
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
        self.attributedText = attributedText
    }
}
