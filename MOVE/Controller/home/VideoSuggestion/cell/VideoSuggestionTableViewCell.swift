//
//  VideoLikeTableViewCell.swift
//  MOVE
//
//  Created by Vinh Nguyen on 25/04/2023.
//

import UIKit

class VideoSuggestionTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var kolImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var postTimeLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var viewCountBackgroundView: UIView!
    @IBOutlet private weak var timeBackgroundView: UIView!
    @IBOutlet private weak var viewCountLabel: UILabel!
    @IBOutlet private weak var tagBackgroundView: UIView!
    @IBOutlet private weak var tagLabel: UILabel!
    @IBOutlet private weak var durationBackgroundView: UIView!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var rateLabel: UILabel!
    
    override func awakeFromNib() {
        configCell()
        self.backgroundColor = UIColor.clear
    }
    
    func setUp(suggestionVideo: Video) {
        thumbnailImageView.sd_setImage(with: URL(string: suggestionVideo.thumbnailPath ?? ""), placeholderImage: AppImages.thumbnaiVideo)
        avatarImageView.sd_setImage(with: URL(string: suggestionVideo.avatarPath ?? ""), placeholderImage: AppImages.userDefaultAvatar)
        nameLabel.text = suggestionVideo.username
        titleLabel.text = suggestionVideo.title
        categoryLabel.text = suggestionVideo.categoryName
        postTimeLabel.text = suggestionVideo.postedTimeString
        viewCountLabel.text = String(suggestionVideo.totalView ?? 0)
        timeLabel.text = "10:00"
        tagBackgroundView.isHidden = suggestionVideo.isJustMove
        tagLabel.text = suggestionVideo.levelTitle
        durationBackgroundView.isHidden = suggestionVideo.isJustMove
        durationLabel.text = suggestionVideo.durationTitle
        rateLabel.text = suggestionVideo.roundingRating
    }
    
    private func configCell() {
        nameLabel.font = AppFonts.fontMontserratRegular(size: 14)
        nameLabel.textColor = AppColors.darkGray
        titleLabel.font = AppFonts.fontMontserratRegular(size: 14)
        titleLabel.textColor = AppColors.darkGray
        categoryLabel.font = AppFonts.fontMontserratRegular(size: 14)
        categoryLabel.textColor = AppColors.darkGray
        rateLabel.font = AppFonts.fontMontserratBold(size: 14)
        rateLabel.textColor = .black
        postTimeLabel.font = AppFonts.fontMontserratRegular(size: 14)
        postTimeLabel.textColor = AppColors.darkGray
        timeBackgroundView.layer.cornerRadius = 4
        timeLabel.font = AppFonts.fontMontserratBold(size: 12)
        viewCountBackgroundView.layer.cornerRadius = 4
        viewCountLabel.font = AppFonts.fontMontserratBold(size: 12)
        tagBackgroundView.layer.cornerRadius = 13
        tagBackgroundView.backgroundColor = AppColors.lightGray
        tagLabel.font = AppFonts.fontMontserratBold(size: 10)
        durationBackgroundView.layer.cornerRadius = 13
        durationBackgroundView.backgroundColor = AppColors.lightGray
        durationLabel.font = AppFonts.fontMontserratBold(size: 10)
        avatarImageView.circle()
    }

}
