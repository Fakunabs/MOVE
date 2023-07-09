//
//  MenuViewController.swift
//  MOVE
//
//  Created by Fakunabs on 21/04/2023.
//

import UIKit
import SDWebImage

enum MenuItemType: String, CaseIterable {
    case following = "Following"
    case browse = "Browse"
    case settings = "Settings"
    case more = "More"
    case login = "Login"
    case logout = "Logout"
}

protocol MenuViewControllerDelegate: AnyObject {
    func pushToViewController(viewController: UIViewController)
}

class MenuViewController: UIViewController {
    var isLoggedIn: Bool {
        return AuthenticationManager.shared.isLoggedIn
    }
    
    var allItems: [MenuItemType] {
        if isLoggedIn {
            return [.following, .browse, .settings, .more, .logout]
        } else {
            return [.browse, .more, .login]
        }
    }
    
    weak var delegate: MenuViewControllerDelegate?
    private var isMoreItemExpanded = false
    
    @IBOutlet private weak var avatarImage: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var verifyAccountImage: UIImageView!
    @IBOutlet private weak var avatarHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var menuTableView: UITableView!
    
    @IBAction private func didTapLogoAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapCloseAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapTermOfServiceAction(_ sender: UIButton) {
    }
    
    @IBAction private func didTapPrivacyPolicyAction(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAvatar()
        configTableView()
        updateUserInfo()
        updateUserInfoVisibility()
    }
}

// MARK - Configure Table View

extension MenuViewController {
    private func configTableView() {
        menuTableView.separatorStyle = .none
        menuTableView.register(UINib(nibName: MenuTableViewCell.className, bundle: nil),forCellReuseIdentifier: MenuTableViewCell.className)
        menuTableView.delegate = self
        menuTableView.dataSource = self
    }
    
    private func updateUserInfoVisibility() {
        let isLoggedIn = self.isLoggedIn
        avatarImage.isHidden = !isLoggedIn
        usernameLabel.isHidden = !isLoggedIn
        verifyAccountImage.isHidden = !isLoggedIn
        avatarHeightConstraint.constant = !isLoggedIn ? 0 : 48
    }
    
    private func setUpAvatar() {
        avatarImage.circle()
    }
    
    func reloadScreen() {
        menuTableView.reloadData()
        updateUserInfoVisibility()
    }
}


// MARK - Custom Table View
extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < allItems.count {
            let selectedItem = allItems[indexPath.row]
            switch selectedItem {
            case .more:
                isMoreItemExpanded.toggle()
                tableView.reloadData()
            case .login:
                let loginView = LoginViewController()
                self.present(loginView, animated: false) {
                }
            case .settings:
                delegate?.pushToViewController(viewController: SettingProfileViewController())
                self.dismiss(animated: true)
            case .logout:
                AuthenticationManager.shared.cleanCache()
                reloadScreen()
            default:
                break
            }
        } else {
            print("Invalid indexPath.row: \(indexPath.row)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.className, for: indexPath) as? MenuTableViewCell else {
            return UITableViewCell() }
        
        if indexPath.row < allItems.count {
            let menuItemType = allItems[indexPath.row]
            cell.setUpData(menuItemType: menuItemType, isExpanded: isMoreItemExpanded)
        } else {
            print("Invalid indexPath.row: \(indexPath.row)")
        }
        cell.delegate = self
        return cell
    }
}

extension MenuViewController: MenuTableViewCellDelegate {
    func pushToFaqViewController() {
        delegate?.pushToViewController(viewController: FaqViewController())
        self.dismiss(animated: true)
    }
    
    func pushToCGViewController() {
        delegate?.pushToViewController(viewController: CommunityGuidelinesViewController())
        self.dismiss(animated: true)
    }
}

// MARK : Handle user data
extension MenuViewController {
    func updateUserInfo() {
        guard let user = AuthenticationManager.shared.user else { return }
        avatarImage.sd_setImage(with: URL(string: user.imagePath ?? "user-default-avatar"), placeholderImage: UIImage(named: "user-default-avatar"), options: .continueInBackground, completed: nil)
        usernameLabel.text = user.username
        verifyAccountImage.isHidden = user.isKol == 1
        reloadScreen()
    }
}
