//
//  CategoryTableViewCell.swift
//  MOVE
//
//  Created by Fakunabs on 10/05/2023.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    struct Constants {
        static let collectionViewRatio: CGFloat = 251/414
        static let collectionViewMinLineSpacing: CGFloat = 12
        static let collectionViewMinInteritemSpacing: CGFloat = 0
        static let collectionItemImageWidthRatio: CGFloat = 140/414
        static let collectionItemImageHeightRatio: CGFloat = 203/140
        static let imageBottomPadding: CGFloat = 48
        static var collectionViewEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
    }
    
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var listCategories : [Category] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configCollectionView()
    }
}

// MARK: - Config Category Collection View
extension CategoryTableViewCell {
    private func configCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing =  Constants.collectionViewMinLineSpacing
        layout.minimumInteritemSpacing =  Constants.collectionViewMinInteritemSpacing
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionViewHeightConstraint.constant = CGFloat(UIScreen.main.bounds.width * Constants.collectionViewRatio)
        collectionView.register(UINib(nibName: CategoryCollectionViewCell.className, bundle: nil),
                                        forCellWithReuseIdentifier: CategoryCollectionViewCell.className)
    }
    func reloadCollectionCellData() {
        collectionView.reloadData()
    }
}

// MARK: - Collection View Delegate and Data Source
extension CategoryTableViewCell:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.className, for: indexPath) as? CategoryCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        categoryCell.setUpCell(category: listCategories[indexPath.row])
        return categoryCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.collectionViewEdgeInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width * Constants.collectionItemImageWidthRatio
        let height = width * Constants.collectionItemImageHeightRatio + Constants.imageBottomPadding
        return CGSize(width: width, height: height)
    }
}
