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
        VStack(alignment: .center, spacing: 20) {
            Text("Welcome!")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Text("We're glad to have you here. Explore and enjoy your experience!")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                viewModel.onSignupCompletion()
            }) {
                Text("Got it!")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .frame(maxWidth: 400)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}
