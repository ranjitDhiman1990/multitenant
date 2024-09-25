//
//  MultiTenantApp.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 25/09/24.
//

import SwiftUI
import Firebase

@main
struct MultiTenantApp: App {
    
    @StateObject var viewModel = AuthViewModel()
    @StateObject var networkMonitor = NetworkMonitor()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .environmentObject(viewModel)
            .environmentObject(networkMonitor)
        }
    }
}
