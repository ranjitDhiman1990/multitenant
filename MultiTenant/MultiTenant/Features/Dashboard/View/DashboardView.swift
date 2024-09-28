//
//  DashboardView.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 26/09/24.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showWelcomeDialog = false
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea(edges: .top)
            VStack(spacing: 0) {
                HStack {
                    Text("Dashboard")
                        .font(.title)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    // Profile Image with Navigation Link
                    NavigationLink(destination: ProfileView()) {
                        ImageViewer(height: 40, width: 40, imageUrl: viewModel.currentUser?.profileImageUrl ?? "")
                    }
                }
                .padding(.horizontal) // Padding for left and right
                .padding(.top, 10) // Top padding to push away from the notch
                .padding(.bottom, 10) // Minimal padding for bottom
                .background(Color(UIColor.systemGray6))
                
                Spacer() // This Spacer will push the text down to the center
                
                // Centered text
                Text("Dashboard View")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundColor(.primary)
                
                
                Spacer()
            }
            
            // Bottom left corner texts
            VStack(alignment: .leading) {
                Spacer() // Pushes texts to the bottom
                Text("Tenant: \(viewModel.currentUserTenant?.name ?? "Not Assigned")")
                    .font(.callout)
                    .foregroundColor(.black)
                    .padding(.leading, 20)
                
                Text("Status: \(viewModel.currentUser?.role ?? "Not Approved")")
                    .font(.callout)
                    .foregroundColor(.black)
                    .padding(.leading, 20)
                    .padding(.bottom, 20) // Add bottom padding
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Custom Dialog Overlay
            if viewModel.tempUserSession != nil {
                Color.black.opacity(0.7)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                
                WelcomeView()
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .transition(.scale)
            }
            
            if viewModel.tempUserSession == nil {
                // FAB Menu
                MenuFAB()
            }
        }
    }
}



