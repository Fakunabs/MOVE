//
//  FaqTableViewCell.swift
//  MOVE
//
//  Created by Fakunabs on 26/05/2023.
//

import UIKit

class FaqTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var iconExpandImageView: UIImageView!
    @IBOutlet private weak var expandContentLabel: UILabel!
    @IBOutlet private weak var contentBottomConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.configLineSpacing(lineSpacing: 3.5)
        containerView.applyDropShadow(cornerRadius: 8, shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.16).cgColor, shadowOffset: CGSize(width: 0, height: 3), shadowOpacity: 1, shadowRadius: 6.0)
    }
}


// MARK: SetupData 
extension FaqTableViewCell {
    func setUpData(isExpanded: Bool, faq: FAQ) {
        titleLabel.text = faq.title
        expandContentLabel.text = isExpanded ? faq.content : ""
        contentBottomConstraint.constant = isExpanded ? 12 : 0
        iconExpandImageView.image = isExpanded ? AppImages.iconHighLightMinus : AppImages.iconPlus
        titleLabel.textColor = isExpanded ? AppColors.brightGreen : AppColors.black
        expandContentLabel.configLineSpacing(lineSpacing: 3.5)
    }
}


