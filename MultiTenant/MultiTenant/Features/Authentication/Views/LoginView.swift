//
//  LoginView.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 25/09/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
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
                MTTextField(placeholderText: "Email", keyboardType: .emailAddress, text: $email)
                MTTextField(placeholderText: "Password", isSecureField: true, text: $password)
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
                viewModel.login(withEmail: email, password: password)
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
}
