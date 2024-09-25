//
//  AuthViewModel.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 25/09/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var didAuthenticateUser = false
    @Published var currentUser: User?
    @Published var isShowLoading = false
    @Published var toast: Toast? = nil
    @Published var tempUserSession: FirebaseAuth.User?
    
    private let service = UserService()
    
    init() {
        self.userSession = Auth.auth().currentUser
        self.fetchUser()
    }
    
    //MARK: - Login
    func login(withEmail email: String, password: String) {
        self.toast = nil
        self.isShowLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                debugPrint("DEBUG: Failed to register with error \(error.localizedDescription)")
                self.toast = Toast(style: .error, title: "Error!", message: error.localizedDescription)
                self.isShowLoading = false
                return
            }
            
            guard let user = result?.user else {
                self.isShowLoading = false
                return
            }
            self.userSession = user
            self.fetchUser()
            debugPrint("DEBUG: Did Log user in.. \(String(describing: self.userSession?.email))")
            self.toast = Toast(style: .success, title: "Success", message: "You've logged in successfully")
            self.isShowLoading = false
        }
    }
    
    //MARK: - Register
    func register(withEmail email: String, password: String, fullname: String, username: String) {
        self.toast = nil
        self.isShowLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                debugPrint("DEBUG: Failed to register with error \(error.localizedDescription)")
                self.toast = Toast(style: .error, title: "Error!", message: error.localizedDescription)
                self.isShowLoading = false
                return
            }
            
            guard let user = result?.user else {
                self.isShowLoading = false
                return
            }
            self.tempUserSession = user
            
            let userData = ["email": email,
                            "username": username.lowercased(),
                            "fullname": fullname,
                            "uid": user.uid]
            
            Firestore.firestore().collection("users")
                .document(user.uid)
                .setData(userData) { _ in
                    debugPrint("DEBUG: Did upload user data.")
                    self.didAuthenticateUser = true
                    self.toast = Toast(style: .success, title: "Success", message: "You've signed up successfully")
                    if self.tempUserSession != nil {
                        self.userSession = self.tempUserSession
                    }
                    self.isShowLoading = false
                }
        }
    }
    
    //MARK: - Logout
    func logout() {
        didAuthenticateUser = false
        userSession = nil
        tempUserSession = nil
        try? Auth.auth().signOut()
    }
    
    func uploadProfileImage(_ image: UIImage) {
        guard let uid = tempUserSession?.uid else { return }
        
        ImageUploader.uploadProfileImage(image: image) { profileImageUrl in
            Firestore.firestore().collection("users")
                .document(uid)
                .updateData(["profileImageUrl": profileImageUrl]) { _ in
                    self.userSession = self.tempUserSession
                    self.fetchUser()
                }
        }
    }
    
    func onSignupCompletion() {
        if self.tempUserSession != nil {
            self.userSession = self.tempUserSession
        }
        self.tempUserSession = nil
    }
    
    func fetchUser() {
        guard let uid = self.userSession?.uid else { return }
        
        service.fetchUser(withUid: uid) { user in
            self.currentUser = user
        }
    }
}
