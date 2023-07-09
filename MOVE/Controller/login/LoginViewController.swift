//
//  LoginViewController.swift
//  MOVE
//
//  Created by Fakunabs on 27/04/2023.
//

import UIKit

class LoginViewController: BaseViewController {
    
    private var isPasswordHidden = true
    private var isBothTextFieldsNotEmpty: Bool {
        return !(emailLoginTextField.text?.isEmpty ?? true) && !(passwordLoginTextField.text?.isEmpty ?? true)
    }
    
    @IBOutlet private weak var loginContainerView: UIView!
    @IBOutlet private weak var emailLoginTextField: UITextField!
    @IBOutlet private weak var passwordLoginTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var emailErrorMessageLabel: UILabel!
    @IBOutlet private weak var passwordErrorMessageLabel: UILabel!
    @IBOutlet private weak var loginErrorMessageLabel: UILabel!
    @IBOutlet private weak var viewBottomConstraint: NSLayoutConstraint!
    
    @IBAction private func didTapCloseLoginAction(_ sender: UIButton) {
        dismissLoginView()
    }
    @IBAction private func didTapShowPasswordAction(_ sender: UIButton) {
        togglePasswordVisibility()
    }
    @IBAction private func didTapLoginAction(_ sender: UIButton) {
        if validateInputTextFields() {
            guard let email = emailLoginTextField.text, let password = passwordLoginTextField.text else {
                return
            }
            Task {
                do {
                    let _ = try await Repository.login(email: email, password: password)
                    if let menuViewController = self.presentingViewController as? MenuViewController {
                        menuViewController.updateUserInfo()
                        self.dismiss(animated: true)
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(AppConstants.NotificationName.loginSuccess), object: nil)
                } catch {
                    self.loginErrorMessageLabel.isHidden = false
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setup() {
        super.setup()
        setUpLoginContainerView()
        setUpLoginButton()
        setUpTextField(emailLoginTextField, isSecureTextEntry: false)
        setUpTextField(passwordLoginTextField, isSecureTextEntry: true)
        setUpErrorMessageLabels()
        configView()
        registerForKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailLoginTextField.becomeFirstResponder()
    }
}

extension LoginViewController {
    
    private func configView() {
        self.view.backgroundColor = .clear
    }
    
    private func setUpTextField(_ textField: UITextField, isSecureTextEntry: Bool) {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 42, height: textField.frame.height))
        textField.delegate = self
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = AppColors.lightGrey.cgColor
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        textField.isSecureTextEntry = isSecureTextEntry
        textField.rightView = rightView
        textField.rightViewMode = .always
    }
    
    
    private func updateLoginButtonState() {
        loginButton.isEnabled = isBothTextFieldsNotEmpty
    }
    
    private func togglePasswordVisibility() {
        isPasswordHidden.toggle()
        passwordLoginTextField.isSecureTextEntry = isPasswordHidden
    }
    
    private func setUpLoginContainerView() {
        loginContainerView.layer.cornerRadius = 10
    }
    
    private func setUpLoginButton() {
        loginButton.layer.cornerRadius = 8
        loginButton.isEnabled = false
    }
    
    private func setUpErrorMessageLabels() {
        emailErrorMessageLabel.isHidden = true
        passwordErrorMessageLabel.isHidden = true
        loginErrorMessageLabel.isHidden = true
    }
    
    private func validateInputTextFields() -> Bool {
        guard let email = emailLoginTextField.text, AppValidation.isValidEmail(email) else {
            emailLoginTextField.layer.borderColor = AppColors.red.cgColor
            emailLoginTextField.tintColor = AppColors.red
            emailErrorMessageLabel.isHidden = false
            return false
        }
        guard let password = passwordLoginTextField.text, AppValidation.isValidPassword(password) else {
            passwordLoginTextField.layer.borderColor = AppColors.red.cgColor
            passwordLoginTextField.tintColor = AppColors.red
            passwordErrorMessageLabel.isHidden = false
            return false
        }
        return true
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.viewBottomConstraint.constant = 0
        }
    }
    
    override func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            viewBottomConstraint.constant = keyboardHeight
        }
    }
}

extension LoginViewController {
    
    @objc private func textFieldEditingChanged() {
        loginButton.isEnabled = isBothTextFieldsNotEmpty
        updateLoginButtonState()
    }
    
    @objc private func dismissLoginView() {
        self.dismiss(animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = AppColors.brightGreen.cgColor
        textField.tintColor = AppColors.brightGreen
        emailErrorMessageLabel.isHidden = true
        passwordErrorMessageLabel.isHidden = true
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = AppColors.lightGrey.cgColor
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == passwordLoginTextField && string.contains(" "){
            return false
        }
        return true
    }
}
