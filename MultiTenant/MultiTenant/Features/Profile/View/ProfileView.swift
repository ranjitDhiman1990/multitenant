//
//  ProfileView.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 25/09/24.
//

import SwiftUI

struct ProfileView: View {
    // Sample data for display
    @State private var name = "Firstname Lastname"
    @State private var phoneNumber = "1 (212) 222-2222"
    @State private var accountNumber = "0018 1994 1293 1841"
    @State private var createdOn = "May 7th 2024"
    @State private var role = "SUPER_ADMIN"
    @State private var tenantName = "TATA CORP"
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            // Navigation Bar
            HStack {
                Button(action: {
                    // Action to go back
                    viewModel.logout()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Profile")
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding()
            
            Spacer(minLength: 20)
            
            // Profile Image
            VStack(spacing: 10) {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                
                // Name and Phone Number
                Text(name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(phoneNumber)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                // Edit Profile Button
                Button(action: {
                    // Edit profile action
                }) {
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
            
            // Overview Section
            VStack(alignment: .leading, spacing: 15) {
                Text("Overview")
                    .font(.headline)
                    .padding(.leading, 20)
                    .padding(.top, 10)
                
                // Information List
                Group {
                    ProfileRowView(label: "Account", value: accountNumber)
                    ProfileRowView(label: "Created On", value: createdOn)
                    ProfileRowView(label: "Role", value: role)
                    ProfileRowView(label: "Tenant Name", value: tenantName)
                }
                .padding(.horizontal, 20)
            }
            .padding(.top, 20)
            
            // Delete Account Section
            VStack {
                Button(action: {
                    // Delete account action
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
