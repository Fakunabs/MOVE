//
//  SettingProfileViewController.swift
//  MOVE
//
//  Created by Fakunabs on 15/05/2023.
//

import UIKit


class SettingProfileViewController: BaseViewController{
        
    private var countryID: Int?
    private var stateID: Int?
    private var listCountries : [Country] = []
    private var listSelectedCountryStates : [State] = []
    private var selectedGender: Gender?
    private var areAllTextFieldsNotEmpty: Bool {
        return !(userNameTextField.text?.isEmpty ?? true) && !(fullNameTextField.text?.isEmpty ?? true) && !(cityTextField.text?.isEmpty ?? true)
    }
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var fullNameTextField: UITextField!
    @IBOutlet private weak var maleRadioButton: UIButton!
    @IBOutlet private weak var femaleRadioButton: UIButton!
    @IBOutlet private weak var otherGenderRadioButton: UIButton!
    @IBOutlet private weak var cityTextField: UITextField!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var userNameErrorMessageLabel: UILabel!
    @IBOutlet private weak var fullNameErrorMessageLabel: UILabel!
    @IBOutlet private weak var viewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var dayDropDownButton: UIButton!
    @IBOutlet private weak var monthDropDownButton: UIButton!
    @IBOutlet private weak var yearDropDownButton: UIButton!
    @IBOutlet private weak var countryDropDownButton: UIButton!
    @IBOutlet private weak var stateDropDownButton: UIButton!
    
    
    @IBAction private func didTapUpdateProfilePictureAction(_ sender: UIButton) {
        let imageSelectionAlert = UIAlertController(title: "Select Image", message: "Select image from ?", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.showImagePicker(selectedSource: .camera)
        }
        let libraryAction = UIAlertAction(title: "Library", style: .default) { (_) in
            self.showImagePicker(selectedSource: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        imageSelectionAlert.addAction(cameraAction)
        imageSelectionAlert.addAction(libraryAction)
        imageSelectionAlert.addAction(cancelAction)
        self.present(imageSelectionAlert, animated: true, completion: nil)
    }

    @IBAction private func didTapSaveAction(_ sender: Any) {
        if areAllTextFieldsValid() {
            let username = userNameTextField.text ?? ""
            let fullName = fullNameTextField.text ?? ""
            let address = cityTextField.text ?? ""
            let countryID = countryID ?? 0
            let stateID = stateID ?? 0
            let genderID = selectedGender?.rawValue ?? 0
            let birthday = getSelectedDateString()
            
            Task {
                do {
                    let result = try await Repository.updateInformation(username: username, fullname: fullName, gender: genderID, birthday: birthday, countryID: countryID, stateID: stateID, address: address)
                    if result {
                        var currentUser = AuthenticationManager.shared.getUser()
                        currentUser?.username = username
                        currentUser?.fullname = fullName
                        currentUser?.address = address
                        currentUser?.countryID = countryID
                        currentUser?.stateID = stateID
                        currentUser?.gender = genderID
                        currentUser?.birthday = birthday
                        AuthenticationManager.shared.cache(user: currentUser)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            self.showAlert(title: "Save Successfully", successButtonTitle: "Cancel")
        } else {
            // Handle case when form is not valid
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setup() {
        setUpAvatar()
        setUpTextFields()
        setUpTargetForGenderRadioButton()
        configureTapGestureToDismissKeyboard()
        registerForKeyboardNotifications()
        setUpButton()
        setUpErrorMessageLabels()
        updateUserSettingInfo()
        setUpDropDownMenu()
        configDropDownButtons()
        getlistCountries()
        updateButtonState()
        
    }
}
// MARK: - Set up UI
extension SettingProfileViewController {
    
    private func setUpAvatar() {
        avatarImageView.circle()
    }
    
    private func setUpButton() {
        saveButton.layer.cornerRadius = 8
        saveButton.isEnabled = false
    }
    private func setUpTextFields() {
        let textFields: [UITextField] = [userNameTextField, emailTextField, fullNameTextField,cityTextField]
        textFields.forEach { textField in
            let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: textField.frame.height))
            textField.layer.cornerRadius = 8
            textField.layer.borderWidth = 1
            textField.layer.borderColor = AppColors.lightGrey.cgColor
            textField.leftView = leftView
            textField.leftViewMode = .always
            textField.delegate = self
            textField.addTarget(self, action: #selector(updateButtonState), for: .editingChanged)
            emailTextField.isEnabled = false
        }
    }
    private func setUpErrorMessageLabels() {
        userNameErrorMessageLabel.isHidden = true
        fullNameErrorMessageLabel.isHidden = true
    }
    
    private func setUpTargetForGenderRadioButton() {
        let radioButtons: [UIButton] = [maleRadioButton, femaleRadioButton, otherGenderRadioButton]
        radioButtons.forEach { radioButton in
            radioButton.addTarget(self, action: #selector(genderRadioButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    override func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            viewBottomConstraint.constant = keyboardHeight
        }
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        self.viewBottomConstraint.constant = 0
    }
}

// MARK: - Handle radio button tapped and text field validation
extension SettingProfileViewController {
    
    @objc private func genderRadioButtonTapped(_ sender: UIButton) {
        let radioButtons: [UIButton: Gender] = [
            maleRadioButton: .male,
            femaleRadioButton: .female,
            otherGenderRadioButton: .other
        ]
        for (button, gender) in radioButtons {
            if button == sender {
                selectedGender = gender
                button.setImage(AppImages.selectedRadioButton, for: .normal)
            } else {
                button.setImage(AppImages.defaultRadioButton, for: .normal)
                
            }
        }
    }
    
    @objc private func updateButtonState() {
        saveButton.backgroundColor = AppColors.brightGreen
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.isEnabled = true
        
        if userNameTextField.text == "" || fullNameTextField.text == "" || cityTextField.text == "" {
            saveButton.backgroundColor = AppColors.grey
            saveButton.setTitleColor(AppColors.lightGrey, for: .normal)
            saveButton.isEnabled = false
        }
    }
    
    private func areAllTextFieldsValid() -> Bool {
        guard let username = userNameTextField.text, AppValidation.isValidUsername(username) else {
            userNameTextField.layer.borderColor = AppColors.red.cgColor
            userNameTextField.tintColor = AppColors.red
            userNameErrorMessageLabel.isHidden = false
            return false
        }
        guard let fullName = fullNameTextField.text, AppValidation.isValidFullname(fullName) else {
            fullNameTextField.layer.borderColor = AppColors.red.cgColor
            fullNameTextField.tintColor = AppColors.red
            fullNameErrorMessageLabel.isHidden = false
            return false
        }
        guard selectedGender != nil else {
            // Handle the case when gender is not selected
            return false
        }
        return true
    }
}

// MARK: - UITextFieldDelegate
extension SettingProfileViewController: UITextFieldDelegate  {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = AppColors.brightGreen.cgColor
        textField.tintColor = AppColors.brightGreen
        userNameErrorMessageLabel.isHidden = true
        fullNameErrorMessageLabel.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = AppColors.lightGrey.cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension SettingProfileViewController {
    func updateUserSettingInfo() {
        guard let user = AuthenticationManager.shared.user else { return }
        avatarImageView.sd_setImage(with: URL(string: user.imagePath ?? ""), placeholderImage: UIImage(named: "user-default-avatar"), options: .continueInBackground, completed: nil)
        userNameTextField.text = user.username
        fullNameTextField.text = user.fullname
        emailTextField.text = user.email
        if let gender = user.getGender() {
            switch gender {
            case .male:
                selectedGender = .male
                maleRadioButton.setImage(AppImages.selectedRadioButton, for: .normal)
            case .female:
                selectedGender = .female
                femaleRadioButton.setImage(AppImages.selectedRadioButton, for: .normal)
            case .other:
                selectedGender = .other
                otherGenderRadioButton.setImage(AppImages.selectedRadioButton, for: .normal)
            }
        }
        if let birthday = user.birthday, let components = getDateComponents(from: birthday) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.dayDropDownButton.menu = UIMenu(children: self.createMenuActions(title: "DD", listItems: (1...31).map { String($0) },
                                                                                      seletedItem: components.day ))
                self.monthDropDownButton.menu = UIMenu(children: self.createMenuActions(title: "MM", listItems: (1...12).map { String($0) },
                                                                                        seletedItem: components.month))
                self.yearDropDownButton.menu = UIMenu(children: self.createMenuActions(title: "YYYY", listItems: (1943...2023).map { String($0) },
                                                                                       seletedItem: components.year))
                self.dayDropDownButton.setTitle(components.day, for: .normal)
                self.monthDropDownButton.setTitle(components.month, for: .normal)
                self.yearDropDownButton.setTitle(components.year, for: .normal)
            }
        }
        countryID = user.countryID
        stateID = user.stateID
        cityTextField.text = user.address
    }
    
    private func getlistCountries() {
        Task {
            let result = try await Repository.getListCountries()
            listCountries = result
            DispatchQueue.main.async { [weak self] in
                if (AuthenticationManager.shared.getUser()?.countryID ?? 0) == 0 {
                    self?.countryDropDownButton.menu = UIMenu(children: self?.createMenuActions(title: "Country", listItems: result, seletedItem: "Country") ?? [])
                    self?.countryDropDownButton.setTitle("Country", for: .normal)
                } else {
                    for item in result {
                        if item.id == AuthenticationManager.shared.getUser()?.countryID {
                            
                            self?.countryDropDownButton.menu = UIMenu(children: self?.createMenuActions(title: item.name, listItems: result, seletedItem: item.name) ?? [])
                            self?.countryDropDownButton.setTitle(item.name, for: .normal)
                            self?.getlistStates(countryId: item.id)
                        }
                    }
                }
            }
        }
    }
    private func getlistStates(countryId: Int) {
        Task {
            let result = try await Repository.getlistStates(id: countryId)
            listSelectedCountryStates = result
            DispatchQueue.main.async { [weak self] in
                if (AuthenticationManager.shared.getUser()?.stateID ?? 0) == 0 {
                    self?.stateDropDownButton.menu = UIMenu(children: self?.createMenuActions(title: "", listItems: result, seletedItem: "") ?? [])
                    self?.stateDropDownButton.setTitle("Please Select State", for: .normal)
                } else {
                    if let item =  result.first(where: { $0.id == AuthenticationManager.shared.getUser()?.stateID }) {
                        self?.stateDropDownButton.menu = UIMenu(children: self?.createMenuActions(title: item.name, listItems: result, seletedItem: item.name) ?? [])
                        self?.stateDropDownButton.setTitle(item.name, for: .normal)
                    } else {
                        self?.stateDropDownButton.menu = UIMenu(children: self?.createMenuActions(title: "", listItems: result, seletedItem: "") ?? [])
                        self?.stateDropDownButton.setTitle("Please Select State", for: .normal)
                    }
                }
            }
        }
    }
}

extension SettingProfileViewController {
    private func configDropDownButtons() {
        let dropDownButtons: [UIButton] = [dayDropDownButton, monthDropDownButton, yearDropDownButton, countryDropDownButton, stateDropDownButton]
        dropDownButtons.forEach { dropDownButton in
            dropDownButton.layer.cornerRadius = 8
            dropDownButton.layer.borderWidth = 1
            dropDownButton.layer.borderColor = AppColors.lightGrey.cgColor
        }
    }
    private func setUpDropDownMenu() {
        if #available(iOS 15.0, *) {
            dayDropDownButton.changesSelectionAsPrimaryAction = true
        } else {
            // Fallback on earlier versionss
        }
    }
    
    private func getSelectedDateString() -> String {
        guard let selectedDay = dayDropDownButton.title(for: .normal),
              let selectedMonth = monthDropDownButton.title(for: .normal),
              let selectedYear = yearDropDownButton.title(for: .normal) else {
            return ""
        }
        return (selectedYear + "-" + selectedMonth + "-" + selectedDay)
    }
    
    private func createMenuActions(title: String, listItems: [Any], seletedItem: String) -> [UIAction] {
        var menuActions: [UIAction] = []
        
        if let listItems = listItems as? [String] {
            menuActions.append(UIAction(title: title, handler: { _ in }))
            for item in listItems {
                let action = UIAction(title: item, state: item == seletedItem ? .on :.off, handler: { (action) in
                })
                menuActions.append(action)
            }
        } else if let listItems = listItems as? [Country] {
            for item in listItems {
                let action = UIAction(title: item.name, state: item.name == seletedItem ? .on :.off, handler: { [weak self] (action) in
                    guard let self = self else { return }
                    self.getlistStates(countryId: item.id)
                    self.countryDropDownButton.setTitle(item.name, for: .normal)
                    self.countryID = item.id
                })
                menuActions.append(action)
            }
        } else if let listItems = listItems as? [State] {
            for item in listItems {
                let action = UIAction(title: item.name, state: item.name == seletedItem ? .on :.off, handler: { [weak self] (action) in
                    guard let self = self else { return }
                    self.stateDropDownButton.setTitle(item.name, for: .normal)
                    self.stateID = item.id
                })
                menuActions.append(action)
            }
        }
        return menuActions
    }
    
    private func getDateComponents(from dateString: String) -> (day: String, month: String, year: String)? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day, .month, .year], from: date)
            
            guard let day = components.day, let month = components.month, let year = components.year else {
                return nil
            }
            
            let dayString = String(day)
            let monthString = String(month)
            let yearString = String(year)
            
            return (day: dayString, month: monthString, year: yearString)
        }
        
        return nil
    }
}
// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension SettingProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func showImagePicker(selectedSource: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(selectedSource) else {
            return
        }
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = selectedSource
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated:true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage{
            avatarImageView.image = selectedImage
        } else {
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
