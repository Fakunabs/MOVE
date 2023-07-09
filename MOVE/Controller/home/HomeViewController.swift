//
//  HomeViewController.swift
//  MOVE
//
//  Created by Vinh Nguyen on 21/04/2023.
//

import UIKit

//MARK: - HomeSectionType
enum HomeSectionType: CaseIterable {
    case featured
    case category
    case trendingVideos
    
    var title: String {
        switch self {
        case .featured:
            return "Featured"
        case .category:
            return "Category"
        case .trendingVideos:
            return "Videos you may like"
        }
    }
    var height: CGFloat {
        switch self {
        case .featured:
            return 52
        case .category:
            return 68
        case .trendingVideos:
            return 78
        }
    }
}
//MARK: - ViewController
class HomeViewController: BaseViewController {
    
    @IBOutlet private weak var homeTableView: UITableView!
    
    private var featuredVideos: [Video] = []
    private var suggestionVideos: [Video] = []
    private var listCategories : [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        self.delegate = self
        getFeaturedVideos()
        getSuggestionVideos()
        getListCategories()
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess(_:)), name: NSNotification.Name(AppConstants.NotificationName.loginSuccess), object: nil)
    }
    
    @objc private func loginSuccess(_ notification: Notification) {
        getSuggestionVideos()
        homeTableView.reloadData()
    }
    
    private func configTableView() {
        homeTableView.separatorStyle = .none
        homeTableView.backgroundColor = .white
        homeTableView.dataSource = self
        homeTableView.delegate = self
        homeTableView.register(UINib(nibName: FeaturedHeaderView.className, bundle: nil),
                               forHeaderFooterViewReuseIdentifier: FeaturedHeaderView.className)
        homeTableView.register(UINib(nibName: CustomHeaderView.className, bundle: nil),
                               forHeaderFooterViewReuseIdentifier: CustomHeaderView.className)
        homeTableView.register(UINib(nibName: VideoSuggestionTableViewCell.className, bundle: nil), forCellReuseIdentifier: VideoSuggestionTableViewCell.className)
        homeTableView.register(UINib(nibName: FeaturedTableViewCell.className, bundle: nil),
                               forCellReuseIdentifier: FeaturedTableViewCell.className)
        homeTableView.register(UINib(nibName: CategoryTableViewCell.className, bundle: nil), forCellReuseIdentifier: CategoryTableViewCell.className)
    }
}
// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return HomeSectionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch HomeSectionType.allCases[section] {
        case .featured, .category:
            return 1
        case .trendingVideos:
            return suggestionVideos.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch HomeSectionType.allCases[indexPath.section]{
        case .featured:
            if featuredVideos.isEmpty {
                let cell = UITableViewCell()
                cell.isHidden = true
                return cell
            }
            guard let featuredCell = homeTableView.dequeueReusableCell(withIdentifier: FeaturedTableViewCell.className, for: indexPath) as? FeaturedTableViewCell else {
                return UITableViewCell()
            }
            
            featuredCell.featuredVideos = featuredVideos
            featuredCell.reloadCellData()
            featuredCell.delegate = self
            return featuredCell
        case .category:
            guard let categoryCell = homeTableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.className, for: indexPath) as? CategoryTableViewCell
            else {
                return UITableViewCell()
            }
            categoryCell.listCategories = listCategories
            categoryCell.reloadCollectionCellData()
            return categoryCell
        case .trendingVideos:
            guard let videoSuggestionCell = homeTableView.dequeueReusableCell(withIdentifier: VideoSuggestionTableViewCell.className, for: indexPath) as? VideoSuggestionTableViewCell
            else {
                return UITableViewCell()
            }
            videoSuggestionCell.setUp(suggestionVideo: suggestionVideos[indexPath.row])
            return videoSuggestionCell
        }
    }
}
//MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch HomeSectionType.allCases[section] {
        case .featured:
            let headerView = FeaturedHeaderView()
            headerView.setUp()
            return headerView
        case .category, .trendingVideos:
            let headerView = CustomHeaderView()
            headerView.setUp(title: HomeSectionType.allCases[section].title)
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HomeSectionType.allCases[section].height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch HomeSectionType.allCases[indexPath.section] {
        case .featured, .category:
            break
        case .trendingVideos:
            guard suggestionVideos.indices ~= indexPath.row else { return }
            let offlineChannelController = OfflineChannelViewController.loadViewController(video: suggestionVideos[indexPath.row])
            navigationController?.pushViewController(offlineChannelController, animated: true)
        }
    }
}
//MARK: - FeaturedTableViewCellDelegate
extension HomeViewController: FeaturedTableViewCellDelegate {
    func pushToOfflineChannelViewController(with videoInfo: Video) {
        let offlineChannelController = OfflineChannelViewController.loadViewController(video: videoInfo)
        navigationController?.pushViewController(offlineChannelController, animated: true)
    }
}
//MARK: - CallAPI
extension HomeViewController {
    
    private func getFeaturedVideos() {
        Task {
            let result = try await Repository.getFeaturedVideo()
            featuredVideos = result
            DispatchQueue.main.async { [weak self] in
                self?.homeTableView.reloadData()
            }
        }
    }
    
    private func getSuggestionVideos() {
        Task {
            let result = try await Repository.getSuggestionVideos()
            suggestionVideos = result
            DispatchQueue.main.async { [weak self] in
                self?.homeTableView.reloadData()
            }
        }
    }

    private func getListCategories() {
        Task {
            let result = try await Repository.getListCategories()
            listCategories = result
            DispatchQueue.main.async { [weak self] in
                self?.homeTableView.reloadData()
            }
        }
    }
}
