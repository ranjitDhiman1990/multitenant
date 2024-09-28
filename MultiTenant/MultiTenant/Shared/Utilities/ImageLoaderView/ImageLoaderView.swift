//
//  ImageLoaderView.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 27/09/24.
//

import SwiftUI
import Combine
import Kingfisher

struct ImageViewer: View {
    let height: CGFloat
    let width: CGFloat
    let imageUrl: String
    var isCircular: Bool = true
    var canShowProgressIndicator: Bool = false
    
    @State private var progress: Double = 0.0
    
    var body: some View {
        ZStack {
            if isCircular {
                KFImage(URL(string: imageUrl))
                    .resizable()
                    .serialize(as: .PNG)
                    .onProgress { receivedSize, totalSize in
                        if totalSize > 0 {
                            progress = Double(receivedSize) / Double(totalSize)
                        }
                    }
                    .onSuccess { result in
                        debugPrint("Image loaded from cache: \(result.cacheType)")
                        progress = 1
                    }
                    .onFailure { error in
                        debugPrint("Error: \(error)")
                        progress = 1
                    }
                    .placeholder({
                        Image(systemName: isCircular ? "person.circle.fill" : "photo.artframe") // Placeholder image
                            .resizable()
                            .scaledToFill()
                            .frame(width: width, height: height)
                            .foregroundColor(.gray)
                    })
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 0.1))
                    .onAppear {
                        debugPrint("onAppear: called \(imageUrl)")
                    }
                    .onDisappear {
                        debugPrint("onDisappear: called \(imageUrl)")
                        KingfisherManager.shared.cache.removeImage(forKey: imageUrl, fromDisk: false)
                    }
            } else {
                KFImage(URL(string: imageUrl))
                    .resizable()
                    .serialize(as: .PNG)
                    .onProgress { receivedSize, totalSize in
                        if totalSize > 0 {
                            progress = Double(receivedSize) / Double(totalSize)
                        }
                    }
                    .onSuccess { result in
                        debugPrint("Image loaded from cache: \(result.cacheType)")
                        progress = 1
                    }
                    .onFailure { error in
                        debugPrint("Error: \(error)")
                        progress = 1
                    }
                    .placeholder({
                        Image(systemName: isCircular ? "person.circle.fill" : "photo.artframe") // Placeholder image
                            .resizable()
                            .scaledToFill()
                            .frame(width: width, height: height)
                            .foregroundColor(.gray)
                    })
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipShape(Rectangle())
                    .overlay(Rectangle().stroke(Color.gray, lineWidth: 0.1))
                    .onAppear {
                        debugPrint("onAppear: called \(imageUrl)")
                    }
                    .onDisappear {
                        debugPrint("onDisappear: called \(imageUrl)")
                        KingfisherManager.shared.cache.removeImage(forKey: imageUrl, fromDisk: false)
                    }
            }
            
            // Progress Indicator
            if canShowProgressIndicator && progress < 1.0 {
                VStack {
                    Text(String(format: "%.0f%%", progress * 100))
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.black.opacity(0.7))
                        .clipShape(Capsule())
                        .padding(.bottom, 8)
                    
                    ProgressView(value: progress, total: 1.0)
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue)) // Circular style
                        .frame(width: 50, height: 50) // Adjust size as needed
                        .padding(4)
                        .background(Color.white)
                        .clipShape(Circle())
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
    }
}

struct ImageLoaderView: View {
    @Binding var selectedImage: UIImage?
    let height: CGFloat
    let width: CGFloat
    let imageUrl: String
    
    var body: some View {
        Group {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
            } else {
                KFImage(URL(string: imageUrl))
                    .resizable()
                    .serialize(as: .PNG)
                    .onSuccess { result in
                        debugPrint("Image loaded from cache: \(result.cacheType)")
                    }
                    .onFailure { error in
                        debugPrint("Error: \(error)")
                    }
                    .placeholder({
                        Image(systemName: "person.circle.fill") // Placeholder image
                            .resizable()
                            .scaledToFill()
                            .frame(width: width, height: height)
                            .foregroundColor(.gray)
                    })
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
            }
        }
    }
}


class ImageLoader: ObservableObject {
    @Published var image: UIImage? = nil
    private var cancellable: AnyCancellable?
    
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}

