//
//  LoginViewFormValidator.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 25/09/24.
//

import SwiftUI

class LoginViewFormValidator: ObservableObject {
    // Input Fields
    @Published var email: String = ""
    @Published var password: String = ""
    
    // Error Messages
    @Published var emailError: String?
    @Published var passwordError: String?
    
    // Validation Status
    @Published var isFormValid: Bool = false
    
    // Validate all fields
    func validateForm() {
        emailError = validateEmail(email)
        passwordError = validatePassword(password)
        
        // Check if all fields are valid
        isFormValid = emailError == nil && passwordError == nil
    }
    
    // Email Validation
    private func validateEmail(_ email: String) -> String? {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPred.evaluate(with: email) ? nil : "Invalid email address"
    }
    
    // In Sign In view validate if the password is 8 charcters or not
    private func validatePassword(_ password: String) -> String? {
        guard password.count >= 8 else {
            return "Password must be at least 8 characters"
        }
        return nil
    }
}
