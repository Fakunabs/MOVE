//
//  MenuTableViewCell.swift
//  MOVE
//
//  Created by Fakunabs on 21/04/2023.
//

import UIKit

protocol MenuTableViewCellDelegate : AnyObject {
    func pushToFaqViewController()
    func pushToCGViewController()
}

class MenuTableViewCell: UITableViewCell {
    
    weak var delegate: MenuTableViewCellDelegate?
    
    @IBOutlet private weak var containMoreView: UIView!
    @IBOutlet private weak var menuLabel: UILabel!
    @IBOutlet private weak var menuImage: UIImageView!
    @IBOutlet private weak var menuOfMoreHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction private func didTapFAQ(_ sender: UIButton){
        delegate?.pushToFaqViewController()
    }
    
    @IBAction private func didTapCommunityGuideline(_ sender: UIButton){
        delegate?.pushToCGViewController()
    }
}

extension MenuTableViewCell {
    func setUpData(menuItemType: MenuItemType, isExpanded: Bool) {
        menuLabel.text = menuItemType.rawValue
        menuImage.image = isExpanded ? AppImages.iconArrowUp : AppImages.iconArrowDown
        menuImage.isHidden = menuItemType != .more
        menuLabel.font = AppFonts.fontMontserratBold(size: 20)
        menuOfMoreHeightConstraint.constant = menuItemType == .more ? isExpanded ? 100 : 0 : 0
    }
}
