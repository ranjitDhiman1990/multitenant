//
//  ContentView.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 25/09/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    var body: some View {
        Group {
            if !networkMonitor.isConnected {
                OfflineView()
            } else {
                if viewModel.userSession == nil {
                    LoginView()
                } else {
                    DashboardView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
