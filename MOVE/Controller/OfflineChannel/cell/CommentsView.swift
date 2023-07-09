//
//  CommentsTableViewCell.swift
//  MOVE
//
//  Created by Vinh Nguyen on 12/05/2023.
//

import UIKit

protocol CommentsViewDelegate: AnyObject {
    func showCellTableView(_ section: Int)
    func changeInputRepliExpanded(commentText: String, isEdting: Bool)
    func addNewReply(content: String, section: Int)
}

enum LikeStatus: Codable {
    case noneValue
    case liked
    case disliked
}

class CommentsView: UIView {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var kolImageView: UIImageView!
    @IBOutlet private weak var postTimeLabel: UILabel!
    @IBOutlet private weak var commentLabel: UILabel!
    @IBOutlet private weak var likeCountLabel: UILabel!
    @IBOutlet private weak var replyButton: UIButton!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dislikeButton: UIButton!
    @IBOutlet private weak var replyViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var avatarUserImageView: UIImageView!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var replyView: UIView!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var arrowImageView: UIImageView!
    @IBOutlet private weak var showReplyView: UIView!
    @IBOutlet private weak var toggleLabel: UILabel!
    @IBOutlet private weak var showReplyButton: UIButton!
    @IBOutlet private weak var showReplyHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var lineView: UIView!
    @IBOutlet private weak var reactionView: UIView!
    @IBOutlet private weak var reactionViewHeightConstraint: NSLayoutConstraint!
    
    
    private var isInputViewExpanded: Bool = false
    private var isCommentViewExpanded: Bool = false
    private var likeCount: Int = 0
    private var id: Int?
    private let placeholderText = "Write a comment"
    private var commentText = ""
    private var changeReaction: ((_ likeStatus: LikeStatus, _ likeCount: Int) -> Void)?
    var changeCellHeight: (() -> Void)?
    var changeInputViewExpanded: (() -> Void)?
    weak var delegate: CommentsViewDelegate?
    private var section: Int = 0
    private var counter = 0
    private var trackingReationtimer: Timer?
    private var oldLikeStatus: LikeStatus = .noneValue
    private var likeStatus: LikeStatus = .noneValue
    private var originalStatusReaction: LikeStatus = .noneValue {
        didSet {
            self.likeStatus = originalStatusReaction
            self.oldLikeStatus = originalStatusReaction
        }
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        loadNib()
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
        loadNib()
    }
    
    func loadNib() {
        Bundle.main.loadNibNamed(CommentsView.className, owner: self)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        configUI()
    }
    
    func configView(comment: Comment,
                    section: Int,
                    isInputExpanded: Bool,
                    replyInputText: String,
                    changeReaction: @escaping ((_ likeStatus: LikeStatus, _ likeCount: Int) -> Void)) {
        self.configCellData(comment: comment)
        self.changeReaction = changeReaction
        self.section = section
        setUpCellHeight(isExpanded: isInputViewExpanded)
        setupTextViewReplyUI(isEditing: isInputExpanded)
        commentText = replyInputText
        configViewReplyUI()
        updateToggleButton(isExpanded: isCommentViewExpanded, commentCount: comment.replies?.count ?? 0)
        lineView.isHidden = section == 0
    }
    
    private func configUI() {
        self.backgroundColor = .clear
        avatarImageView.circle()
        usernameLabel.font = AppFonts.fontMontserratBold(size: 16)
        usernameLabel.textColor = .black
        postTimeLabel.font = AppFonts.fontMontserratRegular(size: 14)
        postTimeLabel.textColor = AppColors.darkGray
        commentLabel.font = AppFonts.fontMontserratRegular(size: 16)
        commentLabel.textColor = .black
        likeCountLabel.font = AppFonts.fontMontserratRegular(size: 16)
        likeCountLabel.textColor = AppColors.darkTurquoise
        replyButton.tintColor = AppColors.darkTurquoise
        replyButton.titleLabel?.font = AppFonts.fontMontserratRegular(size: 16)
    }

    private func configCellData(comment: Comment) {
        commentLabel.numberOfLines = 0
        commentLabel.lineBreakMode = .byWordWrapping
        postTimeLabel.text = comment.times
        likeCount = comment.likeCount ?? 0
        if comment.user?.isSuspended == 1 {
            commentLabel.text = AppConstants.Suspended.content
            commentLabel.font = AppFonts.fontMontserratItalic(size: 16)
            usernameLabel.text = AppConstants.Suspended.username
            avatarImageView.backgroundColor = .white
            kolImageView.isHidden = true
            likeButton.isHidden = true
            likeCountLabel.isHidden = true
            dislikeButton.isHidden = true
            replyButton.isHidden = true
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
        isCommentViewExpanded = comment.isExpanded ?? false
        isInputViewExpanded = comment.isExpandedInputView ?? false
        updateLikeButtons()
    }
    
    @IBAction private func didTapLikeButton(_ sender: UIButton) {
        oldLikeStatus = likeStatus
        likeStatus = likeStatus == .liked ? .noneValue : .liked
        changeLikeCount(likeStatus: likeStatus)
        updateLikeButtons()
        restartTimer()
    }
    
    @IBAction private func didTapDislikeButton(_ sender: UIButton) {
        oldLikeStatus = likeStatus
        likeStatus = likeStatus == .disliked ? .noneValue : .disliked
        changeLikeCount(likeStatus: likeStatus)
        updateLikeButtons()
        restartTimer()
    }
    
    @IBAction private func didTapReplyButton(_ sender: UIButton) {
        isInputViewExpanded.toggle()
        changeInputViewExpanded?()
        setUpCellHeight(isExpanded: isInputViewExpanded)
        changeCellHeight?()
    }
    
    @IBAction private func didTapCancelButton(_ sender: UIButton) {
        commentText = ""
        setupTextViewReplyUI(isEditing: false)
        changeInputViewExpanded?()
        setUpCellHeight(isExpanded: isInputViewExpanded)
        delegate?.changeInputRepliExpanded(commentText: commentText, isEdting: false)
        changeCellHeight?()
    }
    
    @IBAction private func didTapSendButton(_ sender: UIButton) {
        commentText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if commentText == placeholderText || commentText.isEmpty {
            commentText = ""
            return
        }
        delegate?.addNewReply(content: commentText, section: section)
        commentText = ""
        setupTextViewReplyUI(isEditing: false)
        changeInputViewExpanded?()
        setUpCellHeight(isExpanded: isInputViewExpanded)
        delegate?.changeInputRepliExpanded(commentText: commentText, isEdting: false)
    }
    
    @IBAction private func didTapToggleReplies(_ sender: UIButton) {
        delegate?.showCellTableView(section)
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
    
    private func updateLikeButtons() {
        likeButton.setImage(likeStatus == .liked ? AppImages.iconLikeFill : AppImages.iconLike, for: .normal)
        dislikeButton.setImage(likeStatus == .disliked ? AppImages.iconDislikeFill : AppImages.iconDislike, for: .normal)
    }
    
    private func updateToggleButton(isExpanded: Bool, commentCount: Int) {
        if commentCount == 0 {
            showReplyView.isHidden = true
            showReplyHeightConstraint.constant = 0
        }else {
            showReplyHeightConstraint.constant = 16
            arrowImageView.image = isExpanded ? AppImages.iconArrowUpTurquoise : AppImages.iconArrowDownTurquoise
            toggleLabel.font = AppFonts.fontMontserratBold(size: 16)
            toggleLabel.textColor = AppColors.darkTurquoise
            toggleLabel.text = isExpanded ? "Hide \(commentCount) reply" : "Show \(commentCount) reply"
        }
    }
    
    private func showReactionView() {
        likeButton.isEnabled = AuthenticationManager.shared.isLoggedIn
        dislikeButton.isEnabled = AuthenticationManager.shared.isLoggedIn
        replyButton.isEnabled = AuthenticationManager.shared.isLoggedIn
    }
}
//MARK: - UITextViewDelegate
extension CommentsView: UITextViewDelegate {
    
    private func configViewReplyUI() {
        textView.delegate = self
        avatarUserImageView.circle()
        textView.font = AppFonts.fontMontserratRegular(size: 16)
        sendButton.backgroundColor = AppColors.darkTurquoise
        sendButton.tintColor = .white
        sendButton.titleLabel?.font = AppFonts.fontMontserratBold(size: 16)
        sendButton.layer.cornerRadius = 8
        cancelButton.titleLabel?.font = AppFonts.fontMontserratRegular(size: 16)
        cancelButton.tintColor = AppColors.darkTurquoise
        guard let user = AuthenticationManager.shared.user else { return }
        avatarUserImageView.sd_setImage(with: URL(string: user.imagePath ?? ""), placeholderImage: AppImages.userDefaultAvatar)
    }
    
    private func setUpCellHeight(isExpanded: Bool) {
        replyView.isHidden = !isExpanded
        if isExpanded {
            if textView.contentSize.height < 100 {
                replyViewHeightConstraint.constant = textView.contentSize.height + 70
            } else {
                replyViewHeightConstraint.constant = 200
            }
        } else {
            replyViewHeightConstraint.constant = 0
        }
    }
    
    private func setupTextViewReplyUI(isEditing: Bool) {
        textView.text = isEditing ? commentText : placeholderText
        textView.textColor = isEditing ? .black : AppColors.darkGray
        if !isEditing {
            textView.resignFirstResponder()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        commentText = ""
        setupTextViewReplyUI(isEditing: true)
        setUpCellHeight(isExpanded: isInputViewExpanded)
        delegate?.changeInputRepliExpanded(commentText: commentText, isEdting: true)
        changeCellHeight?()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty || textView.text == placeholderText {
            commentText = ""
            setupTextViewReplyUI(isEditing: false)
            setUpCellHeight(isExpanded: isInputViewExpanded)
            delegate?.changeInputRepliExpanded(commentText: textView.text, isEdting: false)
        }else {
            commentText = textView.text
            setupTextViewReplyUI(isEditing: true)
            setUpCellHeight(isExpanded: isInputViewExpanded)
            delegate?.changeInputRepliExpanded(commentText: textView.text, isEdting: true)
        }
        changeCellHeight?()
    }
}
