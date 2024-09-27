//
//  GalleryView.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 27/09/24.
//

import SwiftUI

// Model to represent each gallery item (image and date information)
struct GalleryItem: Identifiable {
    let id = UUID()
    let imageName: String
    let dateAgo: String
    let exactDate: String
}

// Sample Data
let sampleGalleryItems: [GalleryItem] = [
    GalleryItem(imageName: "baby1", dateAgo: "21 Days Ago", exactDate: "April 12th"),
    GalleryItem(imageName: "baby2", dateAgo: "22 Days Ago", exactDate: "April 11th"),
    GalleryItem(imageName: "baby3", dateAgo: "23 Days Ago", exactDate: "April 10th"),
    GalleryItem(imageName: "baby4", dateAgo: "24 Days Ago", exactDate: "April 9th")
]

// Main Gallery View
struct GalleryView: View {
    @Namespace private var animationNamespace // Namespace for matchedGeometryEffect
    @State private var selectedImage: String? // The selected image for the previewer
    @State private var isShowingPreview = false // Controls showing the preview
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                // Navigation Bar
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Text("Gallery View")
                        .font(.title)
                        .fontWeight(.medium)
                    Spacer()
                }
                .padding(.horizontal) // Padding for left and right
                .padding(.top, 10) // Top padding to push away from the notch
                .padding(.bottom, 10) // Minimal padding for bottom
                .background(Color(UIColor.systemGray6))
                
                // Gallery Content
                ScrollView {
                    ForEach(sampleGalleryItems) { item in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(item.dateAgo)
                                    .font(.headline)
                                Spacer()
                                Text(item.exactDate)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal)
                            
                            // Image grid/list
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                ForEach(0..<4) { index in

                                    NavigationLink(destination: DetailView(imageName: item.imageName, animationNamespace: animationNamespace).navigationBarHidden(true)) {
                                        Image(item.imageName)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 150, height: 150)
                                            .cornerRadius(10)
                                            .clipped()
                                            .matchedGeometryEffect(id: item.imageName, in: animationNamespace)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}


struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode
    var imageName: String
    var animationNamespace: Namespace.ID
    @State private var isZoomed = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black
                .ignoresSafeArea()
            
            // Full-Screen Image with Hero Animation
            GeometryReader { geometry in
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .matchedGeometryEffect(id: imageName, in: animationNamespace)
                    .onTapGesture {
                        // Tap to dismiss
                        withAnimation(.easeInOut) {
                            isZoomed.toggle() // Full-screen mode
                        }
                    }
            }
            .transition(.scale) // Full-screen transition effect
            
            // Close Button
            Button(action: {
                withAnimation(.spring()) {
                    isZoomed = false
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .padding()
            }
        }
        .navigationBarHidden(true) // Hide navigation bar for full-screen view
    }
}
