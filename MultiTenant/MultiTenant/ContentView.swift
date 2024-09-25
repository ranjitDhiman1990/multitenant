//
//  ContentView.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 25/09/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            if viewModel.userSession == nil {
                LoginView()
            } else {
                ProfileView()
            }
        }
    }
}

#Preview {
    ContentView()
}
