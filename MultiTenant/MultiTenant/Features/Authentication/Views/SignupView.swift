//
//  SignupView.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 25/09/24.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject private var formValidator = SignupViewFormValidator()
    
    var body: some View {
        ScrollView {
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
                    VStack(alignment: .leading, spacing: 4) {
                        MTTextField(placeholderText: "First name", textInputAutoCapital: .words, allowedMaxLength: FormValidatorConstants.NAME_LENGTH, text: $formValidator.firstName)
                            .onChange(of: formValidator.firstName) { newValue in
                                formValidator.validateForm()
                            }
                        if let error = formValidator.firstNameError {
                            Text(error).font(.footnote).foregroundColor(.red).padding(.leading, 4)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        MTTextField(placeholderText: "Last Name", textInputAutoCapital: .words, allowedMaxLength: FormValidatorConstants.NAME_LENGTH, text: $formValidator.lastName)
                            .onChange(of: formValidator.lastName) { newValue in
                                formValidator.validateForm()
                            }
                        if let error = formValidator.lastNameError {
                            Text(error).font(.footnote).foregroundColor(.red).padding(.leading, 4)
                        }
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        MTTextField(placeholderText: "Email", keyboardType: .emailAddress, allowedMaxLength: FormValidatorConstants.EMAIL_LENGTH, text: $formValidator.email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .onChange(of: formValidator.email) { newValue in
                                formValidator.validateForm()
                            }
                        if let error = formValidator.emailError {
                            Text(error).font(.footnote).foregroundColor(.red).padding(.leading, 4)
                        }
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        MTTextField(placeholderText: "Mobile Number", keyboardType: .phonePad, allowedMaxLength: FormValidatorConstants.MOBILE_LENGTH, text: $formValidator.mobileNumber)
                            .keyboardType(.phonePad)
                            .onChange(of: formValidator.mobileNumber) { newValue in
                                formValidator.validateForm()
                            }
                        if let error = formValidator.mobileError {
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
                    
                    VStack(alignment: .leading, spacing: 4) {
                        MTTextField(placeholderText: "Repeat Password", isSecureField: true, allowedMaxLength: FormValidatorConstants.PASSWORD_LENGTH, text: $formValidator.repeatPassword)
                            .onChange(of: formValidator.repeatPassword) { newValue in
                                formValidator.validateForm()
                            }
                        if let error = formValidator.repeatPasswordError {
                            Text(error).font(.footnote).foregroundColor(.red).padding(.leading, 4)
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                
                // Toggle for terms and privacy policy agreement
                VStack(alignment: .leading, spacing: 0) {
                    Toggle(isOn: $formValidator.isAgreed) {
                        HStack(spacing: 4) {
                            Text("I agree to the")
                            Link("Terms of Service", destination: URL(string: "https://example.com/terms")!)
                            Text("and")
                            Link("Privacy Policy", destination: URL(string: "https://example.com/privacy")!)
                        }
                        .font(.caption)
                    }
                    .onChange(of: formValidator.isAgreed) { newValue in
                        formValidator.validateForm()
                    }
                    
                    
                    if let error = formValidator.isAgreedError {
                        Text(error).font(.caption).foregroundColor(.red)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                
                // Sign Up Button
                Button(action: {
                    // Handle sign-up action
                    formValidator.validateForm()
                    if formValidator.isFormValid {
                        viewModel.register(withEmail: formValidator.email, mobile: formValidator.mobileNumber,
                                           password: formValidator.password,
                                           firstName: formValidator.firstName,
                                           lastName: formValidator.lastName,
                                           username: formValidator.firstName)
                    }
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
        .dismissKeyboardOnTap()
        .toastView(toast: $viewModel.toast)
        .showHideLoadingOverlay(isLoading: viewModel.isShowLoading)
    }
}



struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
