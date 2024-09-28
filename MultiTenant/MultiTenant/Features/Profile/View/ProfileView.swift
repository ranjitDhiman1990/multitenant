//
//  ProfileView.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 25/09/24.
//

import SwiftUI

struct ProfileView: View {
    // Sample data for display
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showLogoutAlert = false
    @State private var showDeleteAccountDialog = false
    
    var body: some View {
        ZStack {
            VStack {
                // Navigation Bar
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Text("Profile")
                        .font(.title)
                        .fontWeight(.medium)
                    Spacer()
                    Button(action: {
                        showLogoutAlert = true
                    }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.black)
                        }
                    }
                    .alert(isPresented: $showLogoutAlert) {
                        Alert(
                            title: Text("Logout"),
                            message: Text("Do you want to logout?"),
                            primaryButton: .default(Text("Yes")) {
                                viewModel.logout()
                            },
                            secondaryButton: .cancel(Text("No")) {}
                        )
                    }
                }
                .padding(.horizontal) // Padding for left and right
                .padding(.top, 10) // Top padding to push away from the notch
                .padding(.bottom, 10) // Minimal padding for bottom
                .background(Color(UIColor.systemGray6))
                
                // Profile Image
                VStack(spacing: 10) {
                    ImageViewer(height: 100, width: 100, imageUrl: viewModel.currentUser?.profileImageUrl ?? "")
                    
                    // Name and Phone Number
                    Text("\(viewModel.currentUser?.firstName ?? "") \(viewModel.currentUser?.lastName ?? "")")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(viewModel.currentUser?.mobileNumber ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    // Edit Profile Button
                    NavigationLink {
                        EditProfileView()
                            .navigationBarHidden(true)
                    } label: {
                        HStack {
                            HStack {
                                Image(systemName: "pencil")
                                Text("Edit Profile")
                            }
                            .frame(width: 150, height: 40)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding(.top, 5)
                    }
                    
                }
                .padding(.top, 30)
                
                // Overview Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Overview")
                        .font(.headline)
                        .padding(.leading, 20)
                        .padding(.top, 10)
                    
                    // Information List
                    Group {
                        ProfileRowView(label: "Account", value: viewModel.currentUser?.email ?? "")
                        ProfileRowView(label: "Created On", value: viewModel.currentUser?.createdOn?.toString(format: "MMM dd, yyyy") ?? "")
                        ProfileRowView(label: "Role", value: viewModel.currentUser?.role ?? "Not Approved")
                        ProfileRowView(label: "Tenant Name", value: viewModel.currentUserTenant?.name ?? "Not Assigned")
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                
                // Delete Account Section
                VStack {
                    Button(action: {
                        withAnimation {
                            showDeleteAccountDialog = true
                        }
                    }) {
                        HStack {
                            Text("Delete Account")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 1)
                    }
                    .padding(.horizontal, 20)
                }
                Spacer()
            }
            .navigationBarHidden(true)
            
            if showDeleteAccountDialog {
                Color.black.opacity(0.7)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation {
                            showDeleteAccountDialog = false
                        }
                    }
                
                DeleteAccountView(showDialog: $showDeleteAccountDialog)
                    .transition(.scale)
            }
        }
    }
}

struct ProfileRowView: View {
    var label: String
    var value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .foregroundColor(.black)
        }
        .padding(.vertical, 5)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
