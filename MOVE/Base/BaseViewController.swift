//
//  BaseViewController.swift
//  MOVE
//
//  Created by Fakunabs on 25/04/2023.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    weak var delegate : MenuViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        requestAPI()
    }
    
    func setup() {
        setupNavigationBar()
    }
    
    func requestAPI() {
        
    }
    
    private func setupNavigationBar() {
        if let appearance = self.navigationController?.navigationBar.standardAppearance {
            appearance.backgroundColor = .black
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            let logoButton = UIButton()
            logoButton.setImage(AppImages.logo?.withRenderingMode(.alwaysOriginal), for: .normal)
            logoButton.addTarget(self, action: #selector(backToHomeView), for: .touchUpInside)
            self.navigationItem.titleView = logoButton
            
            // Menu Button
            let menuButton = UIButton()
            menuButton.setImage(AppImages.iconMenu?.withRenderingMode(.alwaysOriginal), for: .normal)
            menuButton.addTarget(self, action: #selector(showMenuView), for: .touchUpInside)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension BaseViewController {
    func configureTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension BaseViewController {
    @objc func showMenuView() {
        let menuViewController = MenuViewController()
        menuViewController.delegate = self
        menuViewController.modalPresentationStyle = .overFullScreen
        menuViewController.modalTransitionStyle = .coverVertical
        self.present(menuViewController, animated: true, completion: nil)
    }
    
    @objc func showSearchView() {
    }
    
    @objc func backToHomeView() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - MenuViewControllerDelegate
extension BaseViewController: MenuViewControllerDelegate {
    func pushToViewController(viewController: UIViewController) {
        guard let listViewControllers = navigationController?.viewControllers else { return }
        if listViewControllers.contains(where: { $0.className == viewController.className }) {
            if listViewControllers.last?.className != viewController.className {
                if let existedVC = listViewControllers.first(where: { $0.className == viewController.className }) {
                    navigationController?.popToViewController(existedVC, animated: false)
                }
            }
        } else {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
