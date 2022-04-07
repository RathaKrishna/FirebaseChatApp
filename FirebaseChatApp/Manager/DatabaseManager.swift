//
//  DatabaseManager.swift
//  FirebaseChatApp
//
//  Created by Rathakrishnan Ramasamy on 2022/4/6.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    
    static func safeEmail(emailAddress: String) -> String {
           var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
           safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
           return safeEmail
       }
    
    public func test() {
//        database.child("foo").setValue(["something": true])
        print("at here check")
        database.child("foo").setValue(["something": false]) { error, ref in
            print("chec--- \(error?.localizedDescription as Any) ")
        }
    }
}

// MARK: - Account Management
extension DatabaseManager {
    /// validate database
    ///
    public func validateEmail(with email: String, completion: @escaping ((Bool) -> Void)) {
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        
        
        var tempHandle: DatabaseHandle?
        tempHandle = database.child(safeEmail).observe(.value) { [weak self] (snapshot) in
            guard let handle = tempHandle, let `self` = self else { return }

            if snapshot.value != nil {
                print("Has chat")
                completion(false)
            }
            else {
                print("Has chat")
                completion(true)
            }

            self.database.removeObserver(withHandle: handle)
        }
    
    }
    

    /// Inserts new user  to database
    public func insertUser(with user: ChatAppUser) {
        database.child(user.safeEmail).setValue([
            "name": user.displayName
        ])
    }
}

struct ChatAppUser {
    let profilePicUrl: String
    let displayName: String
    let emailAddress: String
    
    var safeEmail: String {
           var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
           safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
           return safeEmail
       }

    
}
