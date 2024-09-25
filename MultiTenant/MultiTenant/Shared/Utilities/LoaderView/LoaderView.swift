//
//  LoaderView.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 25/09/24.
//

import SwiftUI


struct LoaderView: View {
    @State private var degree: Int = 270
    @State private var spinnerLength = 0.6
    
    var body: some View {
        Circle()
            .trim(from: 0.0,to: spinnerLength)
            .stroke(LinearGradient(colors: [.red,.blue], startPoint: .topLeading, endPoint: .bottomTrailing),style: StrokeStyle(lineWidth: 8.0,lineCap: .round,lineJoin:.round))
            .animation(Animation.easeIn(duration: 1.5).repeatForever(autoreverses: true), value: UUID())
            .frame(width: 60,height: 60)
            .rotationEffect(Angle(degrees: Double(degree)))
            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: UUID())
            .onAppear{
                degree = 270 + 360
                spinnerLength = 0
            }
    }
}

struct LoadingModifier: ViewModifier {
    // Flag to control the visibility of the loader
    var isLoading: Bool
    
    // The loader overlay content
    func body(content: Content) -> some View {
        ZStack {
            // Main content view
            content
            
            // Loader overlay
            if isLoading {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                LoaderView()
//                ProgressView()
//                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                    .scaleEffect(2)
            }
        }
        .disabled(isLoading) // Disable interaction while loading
    }
}

