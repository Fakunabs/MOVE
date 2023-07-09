//
//  CommunityGuidelinesViewController.swift
//  MOVE
//
//  Created by Vinh Nguyen on 08/06/2023.
//

import UIKit
import WebKit

class CommunityGuidelinesViewController: BaseViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    private var data:[CommunityGuideline] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configTableView()
        getListCommunityGuidelines()
    }
    
    private func configView() {
        tableView.backgroundColor = .clear
        self.view.backgroundColor = .white
        titleLabel.font = AppFonts.fontMontserratBold(size: 20)
        titleLabel.textColor = .black
        titleLabel.text = "Community Guidelines"
    }
    
    private func configTableView() {
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.register(UINib(nibName: CommunityGuidelinesTableViewCell.className, bundle: nil), forCellReuseIdentifier: CommunityGuidelinesTableViewCell.className)
    }
}
//MARK: - UITableViewDataSource
extension CommunityGuidelinesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard data.indices ~= indexPath.row else {
            return UITableViewCell()
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommunityGuidelinesTableViewCell.className, for: indexPath) as? CommunityGuidelinesTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configCellData(data: data[indexPath.row])
        return cell
    }
}
//MARK: - CallAPI
extension CommunityGuidelinesViewController {
    
    private func getListCommunityGuidelines() {
        Task {
            let result = try await Repository.getListCommunityGuidelines()
            data = result
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
}
