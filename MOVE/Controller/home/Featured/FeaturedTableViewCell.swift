//
//  FeaturedTableViewCell.swift
//  MOVE
//
//  Created by Vinh Nguyen on 09/05/2023.
//

import UIKit
//MARK: - FeaturedTableViewCellDelegate
protocol FeaturedTableViewCellDelegate: AnyObject {
    
    func pushToOfflineChannelViewController(with videoInfo: Video)
}
//MARK: -  UITableViewCell
class FeaturedTableViewCell: UITableViewCell {

    struct Constants {
        static let collectionViewRatio: CGFloat = 310 / 414
        static let itemSpacing: CGFloat = 20
    }
    
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var featuredCollectionView: UICollectionView!
    
    weak var delegate: FeaturedTableViewCellDelegate?
    private var timer: Timer?
    private var currentItemIndex = 0
    var featuredVideos: [Video] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }
    
    private func configUI() {
        self.backgroundColor = UIColor.clear
        configCollectionViewCell()
        setCollectionViewHeight()
        configTimerForCarouselCollectionView()
    }
   
    func reloadCellData(){
        featuredCollectionView.reloadData()
    }
    
    private func configCollectionViewCell() {
        featuredCollectionView.backgroundColor = UIColor.clear
        featuredCollectionView.dataSource = self
        featuredCollectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        featuredCollectionView.collectionViewLayout = layout
        featuredCollectionView.showsHorizontalScrollIndicator = false
        featuredCollectionView.register(UINib(nibName: ItemFeaturedCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: ItemFeaturedCollectionViewCell.className)
    }
    
    private func setCollectionViewHeight() {
        let height = UIScreen.main.bounds.width * Constants.collectionViewRatio
        collectionViewHeightConstraint.constant = CGFloat(height)
    }
    
    private func configTimerForCarouselCollectionView() {
        timer = Timer.scheduledTimer(timeInterval: 3.5, target: self, selector: #selector(scrollToNextItem), userInfo: nil, repeats: true)
        RunLoop.main.add(timer ?? Timer(), forMode: .common)
    }
    
    @objc private func scrollToNextItem() {
        var animated: Bool
        if currentItemIndex < featuredVideos.count - 1 {
            currentItemIndex += 1
            animated = true
        } else {
            currentItemIndex = 0
            animated = false
        }
        featuredCollectionView.scrollToItem(at: IndexPath(item: currentItemIndex, section: 0), at: .centeredHorizontally, animated: animated)
    }
    
    private func getIndexFromItemPosition() -> Int {
        let itemWidth = featuredCollectionView.bounds.width - Constants.itemSpacing * 2
        let proportionalOffset = featuredCollectionView.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        return index
    }
}
//MARK: - UICollectionViewDataSource
extension FeaturedTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return featuredVideos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = featuredCollectionView.dequeueReusableCell(withReuseIdentifier: ItemFeaturedCollectionViewCell.className, for: indexPath) as? ItemFeaturedCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        cell.setUpCell(featuredVideo: featuredVideos[indexPath.row])
        return cell
    }
}
//MARK: - UICollectionViewDelegate
extension FeaturedTableViewCell: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        let index = self.getIndexFromItemPosition()
        let indexPath = IndexPath(row: index, section: 0)
        currentItemIndex = index
        featuredCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pushToOfflineChannelViewController(with: featuredVideos[indexPath.row])
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension FeaturedTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = featuredCollectionView.bounds.width - Constants.itemSpacing * 2
        return CGSize(width: width, height: featuredCollectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: Constants.itemSpacing, bottom: 0, right: Constants.itemSpacing)
    }
}
