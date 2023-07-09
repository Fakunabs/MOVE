//
//  ItemFeaturedCollectionViewCell.swift
//  MOVE
//
//  Created by Vinh Nguyen on 19/04/2023.
//

import UIKit
import SDWebImage

class ItemFeaturedCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var viewCountBackgroundView: UIView!
    @IBOutlet private weak var viewCountLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var rateLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var kolImageview: UIImageView!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var tagBackgroundView: UIView!
    @IBOutlet private weak var tagLabel: UILabel!
    @IBOutlet private weak var durationBackgroundView: UIView!
    @IBOutlet private weak var durationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
    }
    
    private func configCell() {
        viewCountBackgroundView.layer.cornerRadius = 4
        viewCountLabel.font = AppFonts.fontMontserratBold(size: 12)
        titleLabel.font = AppFonts.fontMontserratBold(size: 18)
        titleLabel.textColor = AppColors.black
        rateLabel.font = AppFonts.fontMontserratBold(size: 16)
        rateLabel.textColor = AppColors.black
        usernameLabel.font = AppFonts.fontMontserratRegular(size: 14)
        usernameLabel.textColor = AppColors.darkGray
        categoryLabel.font = AppFonts.fontMontserratRegular(size: 14)
        categoryLabel.textColor = AppColors.darkGray
        tagBackgroundView.layer.cornerRadius = 13
        tagBackgroundView.backgroundColor = AppColors.lightGray
        tagLabel.font = AppFonts.fontMontserratBold(size: 10)
        tagLabel.textColor = AppColors.black
        durationBackgroundView.layer.cornerRadius = 13
        durationBackgroundView.backgroundColor = AppColors.lightGray
        durationLabel.font = AppFonts.fontMontserratBold(size: 10)
        durationLabel.textColor = AppColors.black
    }
    
    func setUpCell(featuredVideo: Video) {
        thumbnailImageView.sd_setImage(with: URL(string: featuredVideo.thumbnailPath ?? ""), placeholderImage: AppImages.thumbnaiVideo)
        viewCountLabel.text = String(featuredVideo.countView ?? 0)
        titleLabel.text = featuredVideo.title
        rateLabel.text = featuredVideo.roundingRating
        usernameLabel.text = featuredVideo.username
        categoryLabel.text = featuredVideo.categoryName
        tagBackgroundView.isHidden = featuredVideo.isJustMove
        tagLabel.text = featuredVideo.levelTitle
        durationBackgroundView.isHidden = featuredVideo.isJustMove
        durationLabel.text = featuredVideo.durationTitle
        avatarImageView.circle()
        avatarImageView.sd_setImage(with: URL(string: featuredVideo.avatarPath ?? ""), placeholderImage: AppImages.userDefaultAvatar)
    }
}
