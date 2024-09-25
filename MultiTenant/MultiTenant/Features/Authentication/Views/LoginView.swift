//
//  LoginView.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 25/09/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject private var formValidator = LoginViewFormValidator()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Spacer()
                
                // Welcome Message
                Text("Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Some small message which appears when people were away")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                // Email and Password Fields
                
                Group {
                    VStack(alignment: .leading, spacing: 4) {
                        MTTextField(placeholderText: "Email", keyboardType: .emailAddress, allowedMaxLength: FormValidatorConstants.EMAIL_LENGTH, text: $formValidator.email)
                            .onChange(of: formValidator.email) { newValue in
                                formValidator.validateForm()
                            }
                        if let error = formValidator.emailError {
                            Text(error).font(.footnote).foregroundColor(.red).padding(.leading, 4)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        MTTextField(placeholderText: "Password", isSecureField: true, allowedMaxLength: FormValidatorConstants.PASSWORD_LENGTH, text: $formValidator.password)
                            .onChange(of: formValidator.password) { newValue in
                                formValidator.validateForm()
                            }
                        if let error = formValidator.passwordError {
                            Text(error).font(.footnote).foregroundColor(.red).padding(.leading, 4)
                        }
                    }
                    
                }.padding(.horizontal, 20)
                
                
                // Forgot Password Link
                Button(action: {
                    // Forgot password action
                }) {
                    Text("Forgotten Password?")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 10)
                
                // Login Button
                Button(action: {
                    // Login action
                    formValidator.validateForm()
                    if formValidator.isFormValid {
                        viewModel.login(withEmail: formValidator.email, password: formValidator.password)
                    } else {
                        
                    }
                }) {
                    Text("Login")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                
                // Sign Up Navigation
                NavigationLink {
                    SignUpView()
                        .navigationBarHidden(true)
                } label: {
                    HStack {
                        Text("Don't have an account?")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text("Sign Up")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 10)
                }
                
                // Spacer before Face ID button
                Spacer()
                
                // Face ID Button
                Button(action: {
                    // Face ID action
                }) {
                    HStack {
                        Image(systemName: "faceid")
                            .font(.system(size: 24))
                        Text("Enabled Face ID")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .dismissKeyboardOnTap()
        .toastView(toast: $viewModel.toast)
        .showHideLoadingOverlay(isLoading: viewModel.isShowLoading)
    }
}
