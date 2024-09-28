//
//  SignupViewFormValidator.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 25/09/24.
//

import SwiftUI

class SignupViewFormValidator: ObservableObject {
    // Input Fields
    @Published var email: String = ""
    @Published var mobileNumber: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var password: String = ""
    @Published  var repeatPassword = ""
    @Published  var isAgreed = false
    
    // Error Messages
    @Published var emailError: String?
    @Published var mobileError: String?
    @Published var firstNameError: String?
    @Published var lastNameError: String?
    @Published var passwordError: String?
    @Published var repeatPasswordError: String?
    @Published var isAgreedError: String?
    
    // Validation Status
    @Published var isFormValid: Bool = false
    
    // Validate all fields
    func validateForm() {
        firstNameError = validateName(firstName)
        lastNameError = validateName(lastName)
        emailError = validateEmail(email)
        mobileError = validateMobileNumber(mobileNumber)
        passwordError = validatePassword(password)
        repeatPasswordError = validateRepeatPassword(password, repeatPassword)
        isAgreedError = validateTermsAndPrivacyChecked()
        
        // Check if all fields are valid
        isFormValid = emailError == nil && firstNameError == nil && lastNameError == nil && passwordError == nil && repeatPasswordError == nil && isAgreedError == nil
    }
    
    func validateFirstNameOnly() {
        firstNameError = validateName(firstName)
    }
    
    func validateLastNameOnly() {
        lastNameError = validateName(lastName)
    }
    
    func validateEmailOnly() {
        emailError = validateEmail(email)
    }
    
    func validateMobileOnly() {
        mobileError = validateMobileNumber(mobileNumber)
    }
    
    func validatePasswordOnly() {
        passwordError = validatePassword(password)
    }
    
    func validateRepeatPasswordOnly() {
        repeatPasswordError = validateRepeatPassword(password, repeatPassword)
    }
    
    // Email Validation
    private func validateEmail(_ email: String) -> String? {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPred.evaluate(with: email) ? nil : "Invalid email address"
    }
    
    // Mobile Validation
    private func validateMobileNumber(_ mobile: String) -> String? {
        let phonePredicate = NSPredicate(format:"SELF MATCHES %@", "^[0-9+]{0,1}+[0-9]{9,16}")
        return phonePredicate.evaluate(with: mobile) ? nil : "Invalid mobile number"
    }
    
    // First Name and Last Name Validation
    private func validateName(_ name: String) -> String? {
        return name.isEmpty ? "This field is required" : nil
    }
    
    // Password Validation (at least 8 characters, with at least 1 uppercase, 1 lowercase, and 1 number)
    private func validatePassword(_ password: String) -> String? {
        guard password.count >= 8 else {
            return "Password must be at least 8 characters"
        }
        let uppercaseLetter = NSCharacterSet.uppercaseLetters
        let lowercaseLetter = NSCharacterSet.lowercaseLetters
        let digit = NSCharacterSet.decimalDigits
        
        if password.rangeOfCharacter(from: uppercaseLetter) == nil {
            return "Password must contain at least 1 uppercase letter"
        }
        if password.rangeOfCharacter(from: lowercaseLetter) == nil {
            return "Password must contain at least 1 lowercase letter"
        }
        if password.rangeOfCharacter(from: digit) == nil {
            return "Password must contain at least 1 number"
        }
        return nil
    }
    
    // Repeat Password should match to password
    private func validateRepeatPassword(_ password: String, _ repeatPassword: String) -> String? {
        guard repeatPassword == password else {
            return "Passwords don't matches"
        }
        return nil
    }
    
    // Email Validation
    private func validateTermsAndPrivacyChecked() -> String? {
        return isAgreed ? nil : "Please toggle on the terms & privacy policy."
    }
}
