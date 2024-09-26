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
    @Published var currentUserTenant: Tenant?
    @Published var isShowLoading = false
    @Published var toast: Toast? = nil
    @Published var tempUserSession: FirebaseAuth.User?
    
    private let service = UserService()
    private let tenantService = TenantService()
    
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
    func register(withEmail email: String, mobile: String, password: String, firstName: String, lastName: String, username: String) {
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
            
            let userData = User(uid: user.uid, username: username, firstName: firstName, lastName: lastName, profileImageUrl: nil, email: email, role: nil, tenantId: nil, mobileNumber: mobile, createdOn: Date.now, updatedOn: nil)
            if let userJson = userData.toJson() {
                Firestore.firestore().collection("users")
                    .document(user.uid)
                    .setData(userJson) { _ in
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
    }
    
    //MARK: - Logout
    func logout() {
        didAuthenticateUser = false
        userSession = nil
        tempUserSession = nil
        try? Auth.auth().signOut()
    }
    
    func uploadProfileImage(_ image: UIImage) {
        self.isShowLoading = true
        guard let uid = userSession?.uid else {
            self.isShowLoading = false
            return
        }
        
        ImageUploader.uploadProfileImage(image: image) { profileImageUrl in
            Firestore.firestore().collection("users")
                .document(uid)
                .updateData(["profileImageUrl": profileImageUrl]) { _ in
                    self.fetchUser()
                    self.isShowLoading = false
                }
        }
    }
    
    func updateProfileData(_ user: User, completion: @escaping() -> Void) {
        self.isShowLoading = true
        guard let uid = userSession?.uid else {
            self.isShowLoading = false
            completion()
            return
        }
        if let userJson = user.toJson() {
            Firestore.firestore().collection("users")
                .document(uid)
                .updateData(userJson) { _ in
                    self.fetchUser()
                    self.isShowLoading = false
                    completion()
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
            if let tenantId = user?.tenantId {
                self.fetchTenantDetails(tenantId: tenantId)
            }
        }
    }
    
    func fetchTenantDetails(tenantId: String) {
        tenantService.fetchTenant(withId: tenantId) { tenant in
            self.currentUserTenant = tenant
        }
    }
    
    func deleteUserDataFromFireStore(completion: @escaping(Bool) -> Void) {
        let collectionName = "users"  // Replace with your collection name
        guard let uid = self.userSession?.uid else { return }       // Replace with the document ID you want to delete
        
        Firestore.firestore().collection(collectionName).document(uid).delete { error in
            if let error = error {
                debugPrint("Delete User from firestore error: \(error.localizedDescription)")
                completion(true)
            } else {
                completion(true)
            }
        }
    }
    
    func deleteUser(completion: @escaping(Bool) -> Void) {
        self.isShowLoading = true
        let user = Auth.auth().currentUser
        if user != nil {
            deleteUserDataFromFireStore { success in
                if success {
                    user?.delete { error in
                        if let error = error {
                            debugPrint("Delete User error: \(error.localizedDescription)")
                            completion(false)
                        } else {
                            completion(true)
                        }
                        self.isShowLoading = false
                    }
                } else {
                    self.isShowLoading = false
                }
            }
        } else {
            debugPrint("User not found")
            self.isShowLoading = false
        }
    }
}
