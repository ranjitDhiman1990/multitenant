//
//  SignupView.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 25/09/24.
//

import SwiftUI

struct SignUpView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var mobileNumber = ""
    @State private var password = ""
    @State private var repeatPassword = ""
    @State private var isAgreed = false
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Create a New Account")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            Text("Create an account so you can start using the application after approval")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.bottom, 20)
            
            Group {
                MTTextField(placeholderText: "First name", textInputAutoCapital: .words, text: $firstName)
                MTTextField(placeholderText: "Last Name", textInputAutoCapital: .words, text: $lastName)
                MTTextField(placeholderText: "Email", keyboardType: .emailAddress, text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                MTTextField(placeholderText: "Mobile Number", keyboardType: .phonePad, text: $mobileNumber)
                    .keyboardType(.phonePad)
                MTTextField(placeholderText: "Password", isSecureField: true, text: $password)
                MTTextField(placeholderText: "Repeat Password", isSecureField: true, text: $repeatPassword)
            }.padding(.horizontal, 20)
            
            
            // Toggle for terms and privacy policy agreement
            Toggle(isOn: $isAgreed) {
                HStack {
                    Text("I agree to the")
                    Link("Terms of Service", destination: URL(string: "https://example.com/terms")!)
                    Text("and")
                    Link("Privacy Policy", destination: URL(string: "https://example.com/privacy")!)
                }
                .font(.caption)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            // Sign Up Button
            Button(action: {
                // Handle sign-up action
                viewModel.register(withEmail: email,
                                   password: password,
                                   fullname: "\(firstName) \(lastName)",
                                   username: firstName)
            }) {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.top, 10)
            
            Spacer()
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack {
                    Text("Already have an account?")
                        .font(.footnote)

                    Text("Sign In")
                        .foregroundColor(.blue)
                        .font(.footnote)
                        .fontWeight(.semibold)
                }
            }
            .padding(.bottom, 20)
        }
    }
//        var body: some View {
//            VStack {
//                Spacer()
//                Text("Create a New Account")
//                    .font(.title)
//                    .fontWeight(.bold)
//                    .padding(.bottom, 10)
//    
//                Text("Create an account so you can start using the application after approval")
//                    .font(.subheadline)
//                    .multilineTextAlignment(.center)
//                    .padding(.bottom, 20)
//    
//                Group {
//                    MTTextField(placeholderText: "First name", text: $firstName)
//                    MTTextField(placeholderText: "Last Name", text: $lastName)
//                    MTTextField(placeholderText: "Email", text: $email)
//                        .keyboardType(.emailAddress)
//                        .autocapitalization(.none)
//                    MTTextField(placeholderText: "Mobile Number", text: $mobileNumber)
//                        .keyboardType(.phonePad)
//                    MTTextField(placeholderText: "Password", text: $password, isSecureField: true)
//                    MTTextField(placeholderText: "Repeat Password", text: $repeatPassword, isSecureField: true)
//                }
//    
//                Toggle(isOn: $isAgreed) {
//                    HStack {
//                        Text("I agree to the")
//                        Link("Terms of Service", destination: URL(string: "https://example.com/terms")!)
//                        Text("and")
//                        Link("Privacy Policy and Data Use", destination: URL(string: "https://example.com/privacy")!)
//                    }
//                    .font(.caption)
//                }
//                .padding(.vertical, 20)
//    
//                Button(action: {
//                    // Handle sign-up action
//                    viewModel.register(withEmail: email,
//                                       password: password,
//                                       fullname: "\(firstName) \(lastName)",
//                                       username: firstName)
//                }) {
//                    Text("Sign Up")
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.black)
//                        .cornerRadius(10)
//                }
//                .padding(.bottom, 20)
//    
//                Spacer()
//    
//                Button {
//                    presentationMode.wrappedValue.dismiss()
//                } label: {
//                    HStack {
//                        Text("Already have an account?")
//                            .font(.footnote)
//    
//                        Text("Sign In")
//                            .foregroundColor(.blue)
//                            .font(.footnote)
//                            .fontWeight(.semibold)
//                    }
//                }
//                .padding(.bottom, 20)
//            }
//        }
}



struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
