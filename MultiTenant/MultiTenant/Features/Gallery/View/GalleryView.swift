//
//  GalleryView.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 27/09/24.
//

import SwiftUI

// Main Gallery View
struct GalleryView: View {
    @Namespace private var animationNamespace
    @State private var selectedImage: String? = nil
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var tapLocation: CGPoint = .zero
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel = GalleryViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if selectedImage == nil {
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
                }
                
                
                // Gallery Content
                if viewModel.galleryImages.count > 0 {
                    ScrollView {
                        
                        let dictionarySorted = viewModel.galleryImages.sorted(by: { $0.key < $1.key })
                        
                        ForEach(dictionarySorted, id: \.key) { (key, values) in
                            let firstValue = values.first
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(firstValue?.createdOn?.timeAgoSinceDate() ?? "")
                                        .font(.headline)
                                    Spacer()
                                    Text(firstValue?.createdOn?.toString(format: "MMM dd, yyyy") ?? "")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal)
                                
                                // Image grid/list
                                LazyVGrid(columns: [GridItem(.flexible(minimum: 100, maximum: 200)), GridItem(.flexible(minimum: 100, maximum: 200))], spacing: 12) {
                                    ForEach(values) { item in
                                        ImageViewer(height: (UIScreen.main.bounds.width - 40) / 2, width: (UIScreen.main.bounds.width - 48) / 2, imageUrl: item.thumbnailImageUrl ?? "", isCircular: false)
                                            .cornerRadius(10)
                                            .clipped()
                                            .matchedGeometryEffect(id: item.id, in: animationNamespace)
                                            .onTapGesture {
                                                withAnimation(.spring()) {
                                                    selectedImage = item.imageUrl
                                                }
                                            }
                                        
                                    }
                                }
                                .padding(.leading, 16)
                                .padding(.trailing, 16)
                                
                                
                            }
                            .padding(.bottom, 20)
                        }
                    }
                    .overlay(
                        Group {
                            // Full screen view for selected image
                            if let image = self.selectedImage {
                                FullScreenImageView(imageName: image, animationNamespace: animationNamespace, scale: $scale, offset: $offset, tapLocation: tapLocation) {
                                    withAnimation(.spring()) {
                                        // Reset on dismiss
                                        self.selectedImage = nil
                                        self.tapLocation = .zero
                                    }
                                }
                            }
                        }
                    )
                    
                } else {
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
        .showHideLoadingOverlay(isLoading: viewModel.isShowLoading)
    }
}


struct FullScreenImageView: View {
    let imageName: String
    let animationNamespace: Namespace.ID
    @Binding var scale: CGFloat
    @Binding var offset: CGSize
    let tapLocation: CGPoint
    var dismissAction: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ImageViewer(height: UIScreen.main.bounds.width, width: UIScreen.main.bounds.width, imageUrl: imageName, isCircular: false)
                .scaledToFit()
                .matchedGeometryEffect(id: imageName, in: animationNamespace)
                .scaleEffect(scale)
                .offset(x: offset.width, y: offset.height)
                .gesture(dragGesture()) // Enable panning
                .onTapGesture(count: 2) {
                    withAnimation(.spring()) {
                        toggleZoom()
                    }
                }
                .onTapGesture {
                    withAnimation(.spring()) {
                        dismissAction()
                    }
                }
            
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            // Update scale with pinch gesture
                            scale = max(1.0, value) // Prevent shrinking below original size
                        }
                        .onEnded { value in
                            // Optionally, reset scale on end
                            //                            withAnimation {
                            //                                offset = .zero
                            //                                scale = 1.0
                            //                            }
                        }
                )
            //                .onTapGesture {
            //                    dismissAction() // Dismiss on tap
            //                    offset = .zero
            //                    scale = 1
            //                }
        }
        .transition(.move(edge: .bottom))
        .onAppear {
            // Calculate the initial offset for zoom
            let screenSize = UIScreen.main.bounds.size
            let xOffset = (tapLocation.x - (screenSize.width / 2)) * (1 - 1/scale)
            let yOffset = (tapLocation.y - (screenSize.height / 2)) * (1 - 1/scale)
            
            offset = CGSize(width: xOffset, height: yOffset)
        }
    }
    
    // Function to toggle between zoomed-in and normal state
    private func toggleZoom() {
        if scale == 1.0 {
            scale = 2.0 // Zoom in
        } else {
            scale = 1.0 // Zoom out
            offset = .zero // Reset panning when zooming out
        }
    }
    
    // Gesture for panning when the image is zoomed in
    private func dragGesture() -> some Gesture {
        DragGesture()
            .onChanged { value in
//                if scale > 1.0 {
                    offset = CGSize(width: value.translation.width, height: value.translation.height)
//                }
            }
            .onEnded { _ in
                // Dismiss if dragged down significantly
                if offset.height > 100 {
                    dismissAction() // Dismiss the view
                    offset = .zero
                    scale = 1
                } else {
                    // Reset position if not dismissed
                    withAnimation(.spring()) {
                        offset = .zero
                        scale = 1
                    }
                }
//                if scale == 1.0 {
//                    offset = .zero // Reset when zoomed out
//                }
            }
    }
}
