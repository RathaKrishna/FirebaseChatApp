//
//  ChatViewController.swift
//  FirebaseChatApp
//
//  Created by Rathakrishnan Ramasamy on 2022/4/6.
//

import UIKit
import FirebaseAuth

class ChatViewController: UIViewController {

    let button: UIButton = {
        let btn = UIButton()
        btn.setTitle("clicke", for: .normal)
        btn.tintColor = .white
        btn.titleLabel?.textColor = .black
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "logout", style: .done, target: self, action: #selector(didRightBtnTapped))
        view.addSubview(button)
        button.addTarget(self, action: #selector(didRightBtnTapped), for: .touchUpInside)
        DatabaseManager.shared.test()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        validateAuth()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
    }
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }
    }
    
    @objc func didRightBtnTapped() {
        
        DatabaseManager.shared.test()
        
        do {
            try FirebaseAuth.Auth.auth().signOut()
            validateAuth()
        } catch {
            print("could not sign out")
        }
    }
}

