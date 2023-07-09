//
//  FaqViewController.swift
//  MOVE
//
//  Created by Fakunabs on 26/05/2023.
//

import UIKit

class FaqViewController: BaseViewController {
    
    struct Constant {
        static let contactText = "Can’t find an answer? Contact us here and we will address your problem as soon as possible."
    }

    private var faqData: [FAQ] = []
    
    @IBOutlet private weak var faqTableView: UITableView!
    @IBOutlet private weak var contactTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setup() {
        super.setup()
        configTableView()
        configContactText()
        getListFAQs()
    }
}

// MARK: ConfigUITableView
extension FaqViewController {
    private func configTableView() {
        faqTableView.separatorStyle = .none
        faqTableView.backgroundColor = .white
        faqTableView.register(UINib(nibName: FaqTableViewCell.className, bundle: nil),forCellReuseIdentifier: FaqTableViewCell.className)
        faqTableView.delegate = self
        faqTableView.dataSource = self
    }
}

// MARK: ConfigDataTableView
extension FaqViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FaqTableViewCell.className, for: indexPath) as? FaqTableViewCell else { return UITableViewCell() }
        let faq = faqData[indexPath.row]
        cell.setUpData(isExpanded: faq.isExpanded ?? false, faq: faq)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if faqData[indexPath.row].isExpanded == nil {
            faqData[indexPath.row].isExpanded = false
        }
        faqData[indexPath.row].isExpanded?.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

// MARK: Config Contact Text
extension FaqViewController {
    private func configContactText() {
        let contactText = Constant.contactText
        let attributedString = NSMutableAttributedString(string: contactText)
        let range = (attributedString.string as NSString).range(of: "Contact us")
        attributedString.addAttributes([.foregroundColor: AppColors.brightGreen, .underlineStyle: NSUnderlineStyle.single.rawValue], range: range)
        contactTextLabel.attributedText = attributedString
    }
}

// MARK: Get Data
extension FaqViewController {
    
    private func getListFAQs() {
        Task {
            let result = try await Repository.getListFAQs()
            faqData = result
            DispatchQueue.main.async { [weak self] in
                self?.faqTableView.reloadData()
            }
        }
    }
}
