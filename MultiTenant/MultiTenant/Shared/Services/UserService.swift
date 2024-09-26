//
//  UserService.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 25/09/24.
//

import FirebaseFirestore

struct UserService {
    
    func fetchUser(withUid uid: String, completion: @escaping(User?) -> Void) {
        Firestore.firestore().collection("users")
            .document(uid)
            .getDocument { snapshot, _ in
                guard let snapshot = snapshot else { return }
                var user: User?
                if let dataDict = snapshot.data() {
                    user =  User.fromDictionary(dataDict)
                }
                completion(user)
            }
    }
    
    func fetchUsers(completion: @escaping([User]) -> Void) {
        Firestore.firestore().collection("users")
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let users = documents.compactMap { snapshot in
                    return User.fromDictionary(snapshot.data())
                }
                completion(users)
            }
    }
}
