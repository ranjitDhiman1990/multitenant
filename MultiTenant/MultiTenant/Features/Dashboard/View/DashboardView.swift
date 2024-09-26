//
//  DashboardView.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 26/09/24.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
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
                        Image(systemName: "person.crop.circle") // Replace with actual image name
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    }
                }
                .padding(.horizontal) // Padding for left and right
                .padding(.top, 10) // Top padding to push away from the notch
                .padding(.bottom, 10) // Minimal padding for bottom
                .background(Color(UIColor.systemGray6))
                
                Spacer()
            }
            
            // Custom Dialog Overlay
            if viewModel.tempUserSession != nil {
                WelcomeView()
            }
            
            // FAB Menu
            MenuFAB()
        }
    }
}



