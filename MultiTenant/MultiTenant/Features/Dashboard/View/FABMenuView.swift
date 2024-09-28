//
//  FABMenuView.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 26/09/24.
//

import SwiftUI

struct MenuFAB: View {
    @State private var isExpanded: Bool = false
    
    var body: some View {
        ZStack {
            // Main Floating Button (FAB)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack {
                        // Additional Options - Visible when FAB is expanded
                        if isExpanded {
                            NavigationLink(destination: GalleryView().navigationBarHidden(true)) {
                                menuOptionView(icon: "tray.fill")
                            }
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            
                            NavigationLink(destination: GalleryView().navigationBarHidden(true)) {
                                menuOptionView(icon: "menucard.fill")
                            }
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            
                            NavigationLink(destination: GalleryView().navigationBarHidden(true)) {
                                menuOptionView(icon: "camera.fill")
                            }
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                        
                        // Main FAB Button
                        Button(action: {
                            withAnimation(.spring()) {
                                isExpanded.toggle() // Toggle menu expansion
                            }
                        }) {
                            mainFABView(icon: "plus")
                        }
                        // Rotate the main FAB by -45 degrees when expanded
                        .rotationEffect(.degrees(isExpanded ? -45 : 0))
                        .animation(.easeInOut, value: isExpanded)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .onAppear {
            if isExpanded {
                isExpanded.toggle()
            }
        }
    }
    
    // View for the Main FAB
    private func mainFABView(icon: String) -> some View {
        Image(systemName: icon)
            .foregroundColor(.white)
            .font(.system(size: 24))
            .padding()
            .background(Color.black)
            .clipShape(Circle())
            .shadow(radius: 10)
    }
    
    // View for Menu Options
    private func menuOptionView(icon: String) -> some View {
        Image(systemName: icon)
            .foregroundColor(.white)
            .font(.system(size: 20))
            .padding()
            .background(Color.black)
            .clipShape(Circle())
            .shadow(radius: 10)
    }
}
