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
    
    
}

// MARK: - Account Management
extension DatabaseManager {
    /// validate database
    public func validateEmail(with email: String, completion: @escaping ((Bool) -> Void)) {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            print("snapshot \(snapshot.value)")
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
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
