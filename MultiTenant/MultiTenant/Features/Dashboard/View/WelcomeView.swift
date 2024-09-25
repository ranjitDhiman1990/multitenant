//
//  WelcomeView.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 26/09/24.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Color.black.opacity(0.4)
            .edgesIgnoringSafeArea(.all) // Dims the background
        
        VStack(spacing: 20) {
            Text("Welcome to MultiTenant App")
                .font(.title2)
                .padding()
            
            HStack(spacing: 20) {
                Button(action: {
                    viewModel.onSignupCompletion()
                }) {
                    Text("OK")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                }
            }
        }
        .frame(width: 300, height: 200)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 10)
        .transition(.scale)
        .animation(.easeInOut, value: true)
    }
}
