//
//  DeleteAccountView.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 27/09/24.
//

import SwiftUI

struct DeleteAccountView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var showDialog: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                // Warning icon
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.red)
                
                // Title
                Text("Delete your account?")
                    .font(.title)
                    .fontWeight(.bold)
                
                // Warning description
                Text("You will lose all of your data by deleting your account.\nThis includes all of your images and any other data on our servers.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Text("This action cannot be undone")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                
                // Buttons
                VStack(spacing: 12) {
                    Button(action: {
                        // Action for cancel button
                        withAnimation {
                            showDialog = false
                        }
                    }) {
                        Text("No Do Not Delete and Go Back")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        // Action for delete button
                        viewModel.deleteUser { success in
                            if success {
                                viewModel.logout()
                            }
                        }
                    }) {
                        Text("Delete My Account")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 10)
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .showHideLoadingOverlay(isLoading: viewModel.isShowLoading)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
    }
}
