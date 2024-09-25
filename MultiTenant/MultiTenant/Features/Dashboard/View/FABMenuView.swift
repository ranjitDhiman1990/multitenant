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
                            Button(action: {
                                print("Option 1 tapped")
                            }) {
                                menuOptionView(icon: "tray.fill")
                            }
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            
                            Button(action: {
                                print("Option 2 tapped")
                            }) {
                                menuOptionView(icon: "exclamationmark.triangle.fill")
                            }
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            
                            Button(action: {
                                print("Option 3 tapped")
                            }) {
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
                            mainFABView(icon: "doc.fill")
                        }
                        // Rotate the main FAB by 180 degrees when expanded
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .animation(.easeInOut, value: isExpanded)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
            }
        }
    }
    
    // View for the Main FAB
    private func mainFABView(icon: String) -> some View {
        Image(systemName: icon)
            .foregroundColor(.white)
            .font(.system(size: 24))
            .padding()
            .background(Color.purple)
            .clipShape(Circle())
            .shadow(radius: 10)
    }
    
    // View for Menu Options
    private func menuOptionView(icon: String) -> some View {
        Image(systemName: icon)
            .foregroundColor(.white)
            .font(.system(size: 20))
            .padding()
            .background(Color.purple)
            .clipShape(Circle())
            .shadow(radius: 10)
    }
}
