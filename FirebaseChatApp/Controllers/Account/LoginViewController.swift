//
//  LoginViewController.swift
//  FirebaseChatApp
//
//  Created by Rathakrishnan Ramasamy on 2022/4/6.
//

import UIKit
import SnapKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    private let imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "icon")
        imgView.contentMode = .scaleAspectFit
        return imgView
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
        field.returnKeyType = .done
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
    
    private let loginBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitle("Login", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didRightBtnTapped))
    
        view.addSubview(scrollView)
        scrollView.addSubview(imgView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginBtn)
        
        emailField.delegate = self
        passwordField.delegate = self
        loginBtn.addTarget(self, action: #selector(loginBtnTapped), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        imgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
            make.width.height.lessThanOrEqualTo(view.width/3)
        }
        
        emailField.snp.makeConstraints { make in
            make.top.equalTo(imgView.snp.bottom).offset(30)
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
        
        loginBtn.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(30)
            make.left.equalTo(30)
            make.width.equalTo(scrollView.width-60)
            make.height.equalTo(52)
        }
        
    }
    @objc func didRightBtnTapped() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func loginBtnTapped() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        guard let email = emailField.text ,
              let password = passwordField.text,
              !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertUserLoginError()
            return
        }
        
        //firebase login
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self]authResult, error in
            guard let strongSelf = self else {
                return
            }
            guard let result = authResult, error == nil else {
                print("Login failed")
                return
            }
            let user = result.user
            print("Results \(user.email ?? "")")
            strongSelf.navigationController?.dismiss(animated: true)
        }
    }
    
    func alertUserLoginError() {
        let alert = UIAlertController(title: "Warning", message: "Email or Password empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            loginBtnTapped()
        }
        return true
    }
}
