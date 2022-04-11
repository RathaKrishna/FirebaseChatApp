//
//  RegisterViewController.swift
//  FirebaseChatApp
//
//  Created by Rathakrishnan Ramasamy on 2022/4/6.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    private let imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "person.circle")
        imgView.tintColor = .secondaryLabel
        imgView.contentMode = .scaleAspectFit
        imgView.layer.masksToBounds = true
        imgView.layer.borderColor = UIColor.secondaryLabel.cgColor
        imgView.layer.borderWidth = 1
        return imgView
    }()
    
    private let nameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .next
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Enter Firstname.."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .next
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Email Address.."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .next
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Password..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    private let repasswordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Reenter Password..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    private let loginBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitle("Register", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        return button
    }()
    // MARK: - View  load and layouts
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account"
        view.backgroundColor = .systemBackground
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(imgView)
        scrollView.addSubview(nameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(repasswordField)
        scrollView.addSubview(loginBtn)
        
        emailField.delegate = self
        passwordField.delegate = self
        loginBtn.addTarget(self, action: #selector(registerBtnTapped), for: .touchUpInside)
        
        imgView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfilPic(_:)))
        imgView.addGestureRecognizer(gesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        imgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
            make.width.height.equalTo(view.width/3)
        }
        
        let imgSize = view.width/3
        imgView.layer.cornerRadius = imgSize/2
        
        nameField.snp.makeConstraints { make in
            make.top.equalTo(imgView.snp.bottom).offset(30)
            make.left.equalTo(30)
            make.width.equalTo(scrollView.width-60)
            make.height.equalTo(52)
        }
        
       
        
        emailField.snp.makeConstraints { make in
            make.top.equalTo(nameField.snp.bottom).offset(10)
            make.left.equalTo(30)
            make.width.equalTo(scrollView.width-60)
            make.height.equalTo(52)
        }
        
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(10)
            make.left.equalTo(30)
            make.width.equalTo(scrollView.width-60)
            make.height.equalTo(52)
        }
        repasswordField.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(10)
            make.left.equalTo(30)
            make.width.equalTo(scrollView.width-60)
            make.height.equalTo(52)
        }
        
        loginBtn.snp.makeConstraints { make in
            make.top.equalTo(repasswordField.snp.bottom).offset(30)
            make.left.equalTo(30)
            make.width.equalTo(scrollView.width-60)
            make.height.equalTo(52)
        }
        
       
    }
    
    // MARK: - Button actions
    @objc func didTapProfilPic(_ sender: UITapGestureRecognizer) {
        presentPhotoActionSheet()
    }
    
    @objc func didRightBtnTapped() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func registerBtnTapped() {
        nameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        repasswordField.resignFirstResponder()
        guard let firstName = nameField.text,
              let email = emailField.text ,
              let password = passwordField.text,
              let repassword = repasswordField.text,
              !firstName.isEmpty,
              !email.isEmpty, !password.isEmpty,
              password.count >= 6, password == repassword else {
            alertUserLoginError()
            return
        }
        
//        DatabaseManager.shared.validateEmail(with: email) { [weak self] exists in
//
//            guard let strongSelf = self else {
//                return
//            }
//
//            guard !exists else {
//                // user already exists
//                strongSelf.alertUserLoginError(message: "Looks like a user account for that email address already exists.")
//                return
//            }
//
//
//        }
        
       
        // Firebase log in
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else {
                           return
                       }
            guard authResult != nil, error == nil else {
                print("Error creating User")
                return
            }
            DatabaseManager.shared.insertUser(with: ChatAppUser(profilePicUrl: "", displayName: firstName, emailAddress: email))
            strongSelf.navigationController?.dismiss(animated: true)
        }
        
    }
    
    func alertUserLoginError(message: String = "Please enter all informations to register") {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameField {
            emailField.becomeFirstResponder()
        }
        else if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            repasswordField.becomeFirstResponder()
        }
        else if textField == repasswordField {
            registerBtnTapped()
        }
        return true
    }
    
}

// MARK: - Image picker delegate
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet () {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "Choose options to select Picture", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self]_ in
            self?.presentCamera()
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Album", style: .default, handler: {[weak self] _ in
            self?.presentAlbum()
        }))
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentAlbum() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImg = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
       
        self.imgView.image = selectedImg
        picker.dismiss(animated: true)
    }
}
