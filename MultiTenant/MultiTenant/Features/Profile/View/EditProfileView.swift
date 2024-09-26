//
//  EditProfileView.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 26/09/24.
//

import SwiftUI
import Photos

struct EditProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var selectedProfileImage: UIImage? = nil
    @Environment(\.presentationMode) var presentationMode
    @State private var isImagePickerPresented: Bool = false
    @State private var showPhotoLibraryPermissionAlert: Bool = false
    @StateObject private var formValidator = SignupViewFormValidator()
    
    var body: some View {
        VStack() {
            // Navigation Bar
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Edit Profile")
                    .font(.title)
                    .fontWeight(.medium)
                Spacer()
            }
            .padding(.horizontal) // Padding for left and right
            .padding(.top, 10) // Top padding to push away from the notch
            .padding(.bottom, 10) // Minimal padding for bottom
            .background(Color(UIColor.systemGray6))
            
//            ScrollView {
                Group {
                    // Profile Image
                    // Profile Image with Edit Action
                    ZStack {
                        ImageLoaderView(selectedImage: $selectedProfileImage, height: 100, width: 100, imageUrl: viewModel.currentUser?.profileImageUrl ?? "")
                            .padding(.top, 20)
                            .padding(.bottom, 20)
                            .onTapGesture {
                                checkPhotoLibraryPermission()
                            }
                        
                        // Camera Icon for Editing Profile Picture
                        Button(action: {
                            checkPhotoLibraryPermission()
                        }) {
                            Image(systemName: "pencil")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundColor(.black)
                                .padding(8)
                                .background(Circle().fill(Color.white))
                                .shadow(radius: 3)
                                .offset(x: 35, y: 35)
                        }
                    }
                    
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
                }
                .padding(.horizontal, 20)
//            }
            
            Spacer()
            
            // Save Button
            Button(action: {
                // Action to save the profile details
                if let image = self.selectedProfileImage {
                    // Upload the profile image first then update profile details
                    viewModel.uploadProfileImage(image)
                }
                let currentUser = viewModel.currentUser
                let updatedUser = User(uid: currentUser?.uid, username: currentUser?.username ?? "", firstName: formValidator.firstName, lastName: formValidator.lastName, profileImageUrl: currentUser?.profileImageUrl, email: currentUser?.email ?? "", role: currentUser?.role, tenantId: currentUser?.tenantId, mobileNumber: formValidator.mobileNumber, createdOn: currentUser?.createdOn, updatedOn: Date.now)
                viewModel.updateProfileData(updatedUser) {
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Save")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .padding(.bottom, 20)
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $selectedProfileImage)
        }
        .alert(isPresented: $showPhotoLibraryPermissionAlert) {
            Alert(
                title: Text("Photo Library Access Needed"),
                message: Text("Please allow access to your photo library in settings."),
                primaryButton: .default(Text("Open Settings")) {
                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettings)
                    }
                },
                secondaryButton: .cancel()
            )
        }
        .showHideLoadingOverlay(isLoading: viewModel.isShowLoading)
        .onLoad {
            formValidator.firstName = viewModel.currentUser?.firstName ?? ""
            formValidator.lastName = viewModel.currentUser?.lastName ?? ""
            formValidator.email = viewModel.currentUser?.email ?? ""
            formValidator.mobileNumber = viewModel.currentUser?.mobileNumber ?? ""
        }
    }
    
    // Check and request photo library permissions
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized, .limited:
            // Permission is granted, open image picker
            isImagePickerPresented = true
        case .denied, .restricted:
            // Show alert to open settings
            showPhotoLibraryPermissionAlert = true
        case .notDetermined:
            // Request permission
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized || newStatus == .limited {
                    DispatchQueue.main.async {
                        isImagePickerPresented = true
                    }
                } else {
                    DispatchQueue.main.async {
                        showPhotoLibraryPermissionAlert = true
                    }
                }
            }
        @unknown default:
            break
        }
    }
}
