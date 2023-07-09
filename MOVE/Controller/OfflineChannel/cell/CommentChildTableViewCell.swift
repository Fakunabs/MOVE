//
//  CommentChildTableViewCell.swift
//  MOVE
//
//  Created by Vinh Nguyen on 06/06/2023.
//

import UIKit

class CommentChildTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var kolImageView: UIImageView!
    @IBOutlet private weak var postTimeLabel: UILabel!
    @IBOutlet private weak var commentLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var likeCountLabel: UILabel!
    @IBOutlet private weak var dislikeButton: UIButton!
    
    private var likeStatus: LikeStatus = .noneValue
    private var likeCount: Int = 0
    private var id: Int?
    private var changeReaction: ((_ likeStatus: LikeStatus, _ likeCount: Int) -> Void)?
    private var counter = 0
    private var trackingReationtimer: Timer?
    private var oldLikeStatus: LikeStatus = .noneValue
    private var originalStatusReaction: LikeStatus = .noneValue {
        didSet {
            self.likeStatus = originalStatusReaction
            self.oldLikeStatus = originalStatusReaction
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }

    private func configUI() {
        self.backgroundColor = .clear
        usernameLabel.font = AppFonts.fontMontserratBold(size: 16)
        usernameLabel.textColor = .black
        avatarImageView.circle()
        postTimeLabel.font = AppFonts.fontMontserratRegular(size: 14)
        postTimeLabel.textColor = AppColors.darkGray
        commentLabel.font = AppFonts.fontMontserratRegular(size: 16)
        commentLabel.textColor = .black
        likeCountLabel.font = AppFonts.fontMontserratRegular(size: 16)
        likeCountLabel.textColor = AppColors.darkTurquoise
    }
    
    func configCell(comment: Comment, changeReaction: @escaping ((_ likeStatus: LikeStatus, _ likeCount: Int) -> Void)) {
        self.configCellData(comment: comment)
        self.changeReaction = changeReaction
    }
    
    private func configCellData(comment: Comment) {
        likeCount = comment.likeCount ?? 0
        postTimeLabel.text = comment.times
        if comment.user?.isSuspended == 1 {
            usernameLabel.text = AppConstants.Suspended.username
            avatarImageView.backgroundColor = .white
            kolImageView.isHidden = true
            commentLabel.text = AppConstants.Suspended.content
            commentLabel.font = AppFonts.fontMontserratItalic(size: 16)
            likeButton.isHidden = true
            likeCountLabel.isHidden = true
            dislikeButton.isHidden = true
        } else {
            usernameLabel.text = comment.user?.username
            avatarImageView.sd_setImage(with: URL(string: comment.user?.imagePath ?? ""), placeholderImage: AppImages.userDefaultAvatar)
            kolImageView.isHidden = comment.user?.isKol == 0
            commentLabel.text = comment.content
            likeCountLabel.text = String(likeCount)
            showReactionView()
        }
        id = comment.id
        guard let likeStatus = comment.likeStatus else { return }
        originalStatusReaction = likeStatus
        updateLikeButtons()
    }

    @IBAction private func didTapLikeButton(_ sender: UIButton) {
        oldLikeStatus = likeStatus
        likeStatus = likeStatus == .liked ? .noneValue : .liked
        changeLikeCount(likeStatus: likeStatus)
        updateLikeButtons()
        restartTimer()
    }
    
    @IBAction private func didTapDiskikeButton(_ sender: UIButton) {
        oldLikeStatus = likeStatus
        likeStatus = likeStatus == .disliked ? .noneValue : .disliked
        changeLikeCount(likeStatus: likeStatus)
        updateLikeButtons()
        restartTimer()
    }
    
    private func changeLikeCount(likeStatus: LikeStatus) {
        switch likeStatus {
        case .liked:
            likeCount += 1
        case .disliked:
            likeCount = oldLikeStatus == .liked ? likeCount - 1 : likeCount
        case .noneValue:
            likeCount = oldLikeStatus == .liked ? likeCount - 1 : likeCount
        }
        likeCountLabel.text = String(likeCount)
    }
    
    private func restartTimer() {
        trackingReationtimer?.invalidate()
        counter = 0
        trackingReationtimer = Timer.scheduledTimer(timeInterval: 0.75, target: self as Any, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc private func timerAction() {
        counter += 1
        print("====Timer:\(counter)")
        if counter > 1 {
            trackingReationtimer?.invalidate()
            if likeStatus != originalStatusReaction {
                changeReaction?(likeStatus, likeCount)
            }
        }
    }
    
    private func updateLikeButtons() {
        likeButton.setImage(likeStatus == .liked ? AppImages.iconLikeFill : AppImages.iconLike, for: .normal)
        dislikeButton.setImage(likeStatus == .disliked ? AppImages.iconDislikeFill : AppImages.iconDislike, for: .normal)
    }
    
    private func showReactionView() {
        likeButton.isEnabled = AuthenticationManager.shared.isLoggedIn
        dislikeButton.isEnabled = AuthenticationManager.shared.isLoggedIn
    }
}
