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
    
    var body: some View {
        KFImage(URL(string: imageUrl))
            .resizable()
            .serialize(as: .PNG)
            .onSuccess { result in
                print("Image loaded from cache: \(result.cacheType)")
            }
            .onFailure { error in
                print("Error: \(error)")
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
                        print("Image loaded from cache: \(result.cacheType)")
                    }
                    .onFailure { error in
                        print("Error: \(error)")
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

