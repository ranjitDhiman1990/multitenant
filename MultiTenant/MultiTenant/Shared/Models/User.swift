//
//  User.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 25/09/24.
//

import FirebaseFirestore
import FirebaseAuth

struct User: Identifiable, Decodable {
    @DocumentID var id: String?
    let username: String
    let fullname: String
    let profileImageUrl: String?
    let email: String
}

extension User {
    var avatarUrl: String {
        profileImageUrl ?? "https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50"
    }
        
    var isCurrentUser: Bool {
        Auth.auth().currentUser?.uid == id
    }
}
