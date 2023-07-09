//
//  UIImageView+Extension.swift
//  MOVE
//
//  Created by Vinh Nguyen on 08/06/2023.
//

import UIKit

extension UIImageView {

   func circle() {
       layer.masksToBounds = false
       layer.cornerRadius = self.frame.height / 2
       clipsToBounds = true
   }
}
