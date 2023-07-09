//
//  WriteCommentTableViewCell.swift
//  MOVE
//
//  Created by Vinh Nguyen on 15/05/2023.
//

import UIKit

protocol CommentInputViewDelegate: AnyObject {
    
    func changeCommentInputCellHeight()
    func addNewComment(_ comment: String)
    func changeInputViewExpanded(isExpanded: Bool, commentText: String)
}

class CommentInputView: UIView {

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var buttonHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var textViewHeightConstraint: NSLayoutConstraint!
    
    weak var delegate: CommentInputViewDelegate?
    private let placeholderText = "Write a comment"
    private var commentText = ""
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        loadNib()
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
        loadNib()
    }
    
    private func loadNib() {
        Bundle.main.loadNibNamed(CommentInputView.className, owner: self)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        configUI()
    }
    
    func configCell(isExpanded: Bool, commentInputText: String){
        self.backgroundColor = .clear
        textView.delegate = self
        commentText = commentInputText
        setupUICommentTextView(isEditing: isExpanded)
        guard let user = AuthenticationManager.shared.user else { return }
        avatarImageView.sd_setImage(with: URL(string: user.imagePath ?? ""), placeholderImage: AppImages.userDefaultAvatar)
    }
    
    private func configUI() {
        textView.font = AppFonts.fontMontserratRegular(size: 16)
        avatarImageView.circle()
        sendButton.backgroundColor = AppColors.darkTurquoise
        sendButton.tintColor = .white
        sendButton.titleLabel?.font = AppFonts.fontMontserratBold(size: 16)
        sendButton.layer.cornerRadius = 8
        cancelButton.titleLabel?.font = AppFonts.fontMontserratRegular(size: 16)
    }
    
    private func setupUICommentTextView(isEditing: Bool) {
        buttonHeightConstraint.constant = isEditing ? 48 : 0
        cancelButton.tintColor = isEditing ? AppColors.darkTurquoise : .white
        if textView.contentSize.height < 107 {
            textViewHeightConstraint.constant = isEditing ? textView.contentSize.height : 30
        } else {
            textViewHeightConstraint.constant = isEditing ? 107 : 30
        }
        
        textView.text = isEditing ? commentText : placeholderText
        textView.textColor = isEditing ? .black : AppColors.darkGray
        if !isEditing {
            textView.resignFirstResponder()
        }
    }
    
    @IBAction private func didTapCancelButton(_ sender: UIButton) {
        commentText = ""
        setupUICommentTextView(isEditing: false)
        delegate?.changeInputViewExpanded(isExpanded: false, commentText: commentText)
        delegate?.changeCommentInputCellHeight()
       
    }
    @IBAction private func didTapSendButton(_ sender: UIButton) {
        commentText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if commentText.isEmpty || commentText == placeholderText{
            commentText = ""
            return
        }
        delegate?.addNewComment(textView.text)
        commentText = ""
        setupUICommentTextView(isEditing: false)
        delegate?.changeInputViewExpanded(isExpanded: false, commentText: commentText)
    }
}
//MARK: - UITextViewDelegate
extension CommentInputView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        setupUICommentTextView(isEditing: true)
        delegate?.changeInputViewExpanded(isExpanded: true, commentText: commentText)
        delegate?.changeCommentInputCellHeight()
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty || textView.text == placeholderText {
            setupUICommentTextView(isEditing: false)
            delegate?.changeInputViewExpanded(isExpanded: false, commentText: textView.text)
        }else {
            commentText = textView.text
            setupUICommentTextView(isEditing: true)
            delegate?.changeInputViewExpanded(isExpanded: true, commentText: textView.text)
        }
        delegate?.changeCommentInputCellHeight()
    }
    
}
