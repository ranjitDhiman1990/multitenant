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
            VStack {
                Text("Main View Content")
                    .font(.largeTitle)
                    .padding()
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



