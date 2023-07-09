//
//  VideoInforTableViewCell.swift
//  MOVE
//
//  Created by Vinh Nguyen on 31/05/2023.
//

import UIKit

class VideoInfoView: UIView {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var kolImageView: UIImageView!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var rateLabel: UILabel!
    @IBOutlet private weak var tagBackgroundView: UIView!
    @IBOutlet private weak var tagLabel: UILabel!
    @IBOutlet private weak var durationBackgroundView: UIView!
    @IBOutlet private weak var durationLabel: UILabel!
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        loadNib()
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
        loadNib()
    }
    
    func loadNib() {
        Bundle.main.loadNibNamed(VideoInfoView.className, owner: self)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        configCell()
    }
   
    private func configCell() {
        self.backgroundColor = .clear
        avatarImageView.circle()
        usernameLabel.font = AppFonts.fontMontserratRegular(size: 20)
        usernameLabel.textColor = AppColors.black
        categoryLabel.font = AppFonts.fontMontserratRegular(size: 16)
        categoryLabel.textColor = AppColors.darkGray
        rateLabel.font = AppFonts.fontMontserratBold(size: 16)
        rateLabel.textColor = AppColors.black
        tagBackgroundView.layer.cornerRadius = 13
        tagBackgroundView.backgroundColor = AppColors.lightGray
        tagLabel.font = AppFonts.fontMontserratBold(size: 10)
        tagLabel.textColor = AppColors.black
        durationBackgroundView.layer.cornerRadius = 13
        durationBackgroundView.backgroundColor = AppColors.lightGray
        durationLabel.font = AppFonts.fontMontserratBold(size: 10)
        durationLabel.textColor = AppColors.black
    }
    
    func setUpDataVideoInfo(videoInfo: Video) {
        avatarImageView.sd_setImage(with: URL(string: videoInfo.avatarPath ?? ""), placeholderImage: AppImages.userDefaultAvatar)
        usernameLabel.text = videoInfo.username
        categoryLabel.text = videoInfo.categoryName
        rateLabel.text = videoInfo.roundingRating
        tagBackgroundView.isHidden = videoInfo.isJustMove
        tagLabel.text = videoInfo.levelTitle
        durationBackgroundView.isHidden = videoInfo.isJustMove
        durationLabel.text = videoInfo.durationTitle
    }
}
