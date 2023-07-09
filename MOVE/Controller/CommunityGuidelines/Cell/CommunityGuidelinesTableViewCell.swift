//
//  CommunityGuidelinesTableViewCell.swift
//  MOVE
//
//  Created by Vinh Nguyen on 08/06/2023.
//

import UIKit
import WebKit

class CommunityGuidelinesTableViewCell: UITableViewCell {

    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configCellUI()
    }

    private func configCellUI() {
        self.backgroundColor = .clear
        titleLabel.font = AppFonts.fontMontserratBold(size: 16)
        titleLabel.textColor = .black
        textView.font = AppFonts.fontMontserratRegular(size: 16)
        textView.textColor = .black
    }
    
    func configCellData(data: CommunityGuideline) {
        titleLabel.text = data.title
        textView.text = data.content?.htmlToString
    }
}
