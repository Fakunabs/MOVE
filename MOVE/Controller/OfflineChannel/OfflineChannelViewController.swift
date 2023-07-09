//
//  OfflineChannelViewController.swift
//  MOVE
//
//  Created by Vinh Nguyen on 11/05/2023.
//

import UIKit
import AVKit
import AVFoundation
import Alamofire

class OfflineChannelViewController: BaseViewController {
    
    struct Constants {
        static var cellCountExceptTypeComment: Int {
            return AuthenticationManager.shared.isLoggedIn ? 2 : 1
        }
    }

    @IBOutlet private weak var videoImageView: UIImageView!
    @IBOutlet private weak var videoView: UIView!
    @IBOutlet private weak var videoNotExistView: UIView!
    @IBOutlet private weak var tableView: UITableView!

    private var isCellTableViewVisible = false
    private var isInputViewExpanded = false
    private var isInputReplyViewExpanded = false
    private var commentInputText = ""
    private var repliesInputText = ""
    private var video: Video?
    private var player: AVPlayer?
    private var avPlayerController = AVPlayerViewController()
    private var comments: [Comment] = []
    private var videoURL: URL?
    private var isExpand: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess(_:)), name: NSNotification.Name(AppConstants.NotificationName.loginSuccess), object: nil)
    }
    
    override func requestAPI() {
        guard let id = video?.id else { return }
        getListComments(by: id)
        getVideoDetail(by: id)
    }
    
    @objc private func loginSuccess(_ notification: Notification) {
        guard let id = video?.id else { return }
        getListComments(by: id)
        tableView.reloadData()
    }
    
    static func loadViewController(video: Video) -> OfflineChannelViewController{
        let viewController = OfflineChannelViewController()
        viewController.video = video
        return viewController
    }
    
    private func configView() {
        self.view.backgroundColor = UIColor.white
        configTableView()
        configureTapGestureToDismissKeyboard()
        avPlayerController.delegate = self
    }
    
    private func configTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.register(UINib(nibName: VideoInfoView.className, bundle: nil), forHeaderFooterViewReuseIdentifier: VideoInfoView.className)
        tableView.register(UINib(nibName: CommentInputView.className, bundle: nil), forHeaderFooterViewReuseIdentifier: CommentInputView.className)
        tableView.register(UINib(nibName: CommentsView.className, bundle: nil), forHeaderFooterViewReuseIdentifier: CommentsView.className)
        tableView.register(UINib(nibName: CommentChildTableViewCell.className, bundle: nil), forCellReuseIdentifier: CommentChildTableViewCell.className)
    }
}
//MARK: - UITableViewDataSource
extension OfflineChannelViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return comments.count + Constants.cellCountExceptTypeComment
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < Constants.cellCountExceptTypeComment {
            return 0
        } else {
            let index = section - Constants.cellCountExceptTypeComment
            guard let listReplies = comments[index].replies else { return 0 }
            return comments[index].isExpanded ?? false ? listReplies.count : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let commentIndex = indexPath.section - Constants.cellCountExceptTypeComment
        guard let listComments = comments[commentIndex].replies,
              listComments.indices ~= indexPath.row,
              let cell = tableView.dequeueReusableCell(withIdentifier: CommentChildTableViewCell.className, for: indexPath) as? CommentChildTableViewCell else { return UITableViewCell() }
        let comment = listComments[indexPath.row]
        cell.configCell(comment: comment,
                        changeReaction: { [weak self] (likeStatus, likeCount) in
            var status : LikeStatus
            if likeStatus == .noneValue {
                if self?.comments[commentIndex].likeStatus == .liked {
                    status = .liked
                } else {
                    status = .disliked
                }
            } else {
                status = likeStatus
            }
            self?.postLike(by: comment.id,
                           status: status,
                           commplete: { [weak self] (result) in
                guard !result else { return }
                
                self?.tableView.reloadRows(at: [indexPath], with: .none)
            })
            self?.comments[commentIndex].replies?[indexPath.row].likeStatus = likeStatus
            self?.comments[commentIndex].replies?[indexPath.row].likeCount = likeCount
        })
        return cell
    }
}
//MARK: - UITableViewDelegate
extension OfflineChannelViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let videoInfoView = VideoInfoView()
            guard let video = video else {
                return nil
            }
            videoInfoView.setUpDataVideoInfo(videoInfo: video)
            return videoInfoView
        }
        if Constants.cellCountExceptTypeComment == 2 {
            if section == 1 {
                let commentInputView = CommentInputView()
                commentInputView.configCell(isExpanded: isInputViewExpanded,
                                            commentInputText: commentInputText)
                commentInputView.delegate = self
                return commentInputView
            }
        }
        
        guard comments.indices ~= section else { return nil }
        let commentsView = CommentsView()
        let commentIndex = section - Constants.cellCountExceptTypeComment
        let comment = comments[commentIndex]
        commentsView.configView(comment: comment,
                                section: commentIndex,
                                isInputExpanded: isInputReplyViewExpanded,
                                replyInputText: repliesInputText,
                                changeReaction: { [weak self] (likeStatus, likeCount) in
            var status : LikeStatus
            if likeStatus == .noneValue {
                if self?.comments[commentIndex].likeStatus == .liked {
                    status = .liked
                } else {
                    status = .disliked
                }
            } else {
                status = likeStatus
            }
            self?.postLike(by: comment.id, status: status, commplete: { [weak self] (result) in
                guard !result else { return }
                self?.tableView.reloadSections(IndexSet(integer: section), with: .none)
            })
            self?.comments[commentIndex].likeStatus = likeStatus
            self?.comments[commentIndex].likeCount = likeCount
        })
        commentsView.changeInputViewExpanded = { [weak self]  in
                self?.comments[commentIndex].isExpandedInputView?.toggle()

        }
        commentsView.changeCellHeight = { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
            }
        }
        commentsView.delegate = self
        return commentsView
    }
}
//MARK: - WriteCommentTableViewCellDelegate
extension OfflineChannelViewController: CommentInputViewDelegate {
    func changeInputViewExpanded(isExpanded: Bool, commentText: String) {
        isInputViewExpanded = isExpanded
        commentInputText = commentText
    }
    
    
    func changeCommentInputCellHeight() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.beginUpdates()
            self?.tableView.endUpdates()
        }
    }
    
    func addNewComment(_ comment: String) {
        guard let id = video?.id else {
            return
        }
        sendComment(by: id, with: comment)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
//MARK: - CommentsViewDelegate
extension OfflineChannelViewController: CommentsViewDelegate {
    
    func changeInputRepliExpanded(commentText: String, isEdting: Bool) {
        repliesInputText = commentText
        isInputReplyViewExpanded = isEdting
    }
    
    
    func addNewReply(content: String, section: Int) {
        sendReply(by: comments[section].id, with: content, index: section)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func showCellTableView(_ section: Int) {
        if comments[section].isExpanded != nil {
            self.comments[section].isExpanded?.toggle()
        } else {
            self.comments[section].isExpanded = true
        }
        
        DispatchQueue.main.async { [weak self] in
            let indexSection = section + Constants.cellCountExceptTypeComment
            self?.tableView.reloadSections([indexSection], with: .automatic)
        }
    }
}
//MARK: PlayVideo
extension OfflineChannelViewController: AVPlayerViewControllerDelegate {
    
    private func fetchVideoFromURL(videoURL: String) {
        if let url = URL(string: videoURL) {
            HCVimeoVideoExtractor.fetchVideoURLFrom(url: url, completion: { ( video:HCVimeoVideo?, error:Error?) -> Void in
                guard error == nil, let vid = video else {
                    DispatchQueue.main.async() { [weak self] in
                        self?.videoImageView.isHidden = true
                        self?.videoNotExistView.isHidden = false
                    }
                    return
                }
                DispatchQueue.main.async() { [weak self] in
                    self?.videoImageView.isHidden = false
                    self?.videoNotExistView.isHidden = true
                    self?.videoURL = vid.videoURL[.quality1080p]
                    self?.startVideo()
                }
            })
        }
    }
    
    private func startVideo() {
        guard let url = videoURL else {
            return
        }
        player = AVPlayer(url: url)
        avPlayerController.player = player
        avPlayerController.view.frame.size = videoView.frame.size
        avPlayerController.videoGravity = .resizeAspectFill
        addChild(avPlayerController)
        self.videoView.addSubview(avPlayerController.view)
    }
}
//MARK: - CallAPI
extension OfflineChannelViewController {
    
    private func getListComments(by id: Int) {
        Task {
            let result = try await Repository.getListComments(id: id)
            comments = result
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    private func sendComment(by id: Int, with content: String) {
        Task {
            guard let result = try await Repository.sendComment(id: id, content: content) else {
                return
            }
            let comment = Comment(id: result.id, content: result.content, parentCommentId: nil, userId: result.user?.id, videoId: result.videoId, createdAt: nil, updatedAt: nil , user: result.user, isLiked: nil, isDisliked: nil, times: result.times)
            comments.insert(comment, at: 0)
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    private func sendReply(by id: Int, with content: String, index: Int) {
        Task {
            guard let result = try await Repository.sendReply(id: id, content: content) else {
                return
            }
            let comment = Comment(id: result.id, content: result.content, parentCommentId: id, userId: result.user?.id, videoId: result.videoId, createdAt: nil, updatedAt: nil , user: result.user, isLiked: nil, isDisliked: nil, times: result.times)
            comments[index].replies?.insert(comment, at: 0)
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadSections(IndexSet(integer: index + Constants.cellCountExceptTypeComment), with: .none)
            }
        }
    }
    
    private func getVideoDetail(by id: Int) {
        Task {
            let result = try await Repository.getVideoDetail(id: id)
            guard let videoId = result?.videoId else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.fetchVideoFromURL(videoURL: APIURLs.videoUrl + videoId)
                self?.tableView.reloadData()
            }
        }
    }
    
    private func postLike(by id: Int, status: LikeStatus, commplete: @escaping (_: Bool) -> Void)  {
        Task {
            let result = try await Repository.postLike(id: id, status: status)
            commplete(result)
        }
    }
}
