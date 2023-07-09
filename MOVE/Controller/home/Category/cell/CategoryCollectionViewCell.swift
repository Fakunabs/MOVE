//
//  CategoryCollectionViewCell.swift
//  MOVE
//
//  Created by Fakunabs on 10/05/2023.
//

import UIKit
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var topicLabel: UILabel!
    @IBOutlet private weak var amountOfViewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
    }
    
    func setUpCell(category: Category) {
        if let imageUrl = URL(string: category.image) {
            thumbnailImageView.sd_setImage(with: imageUrl, completed: nil)
        }
        topicLabel.text = category.name
        amountOfViewLabel.text = "\(category.viewCount) views"
    }
    
    private func configCell() {
        topicLabel.font = AppFonts.fontMontserratBold(size: 18)
        amountOfViewLabel.font = AppFonts.fontMontserratRegular(size: 14)
    }
}
