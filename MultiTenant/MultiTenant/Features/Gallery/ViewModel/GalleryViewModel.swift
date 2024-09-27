//
//  GalleryViewModel.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 27/09/24.
//

import SwiftUI
import FirebaseFirestore
import OrderedCollections


class GalleryViewModel: ObservableObject {
    @Published var galleryImages: [String : [GalleryImage]] = [:]
    private let service = ImageGalleryService()
    @Published var isShowLoading = false
    
    init() {
        self.fetchGalleryImages()
    }
    
    //MARK: - Login
    func fetchGalleryImages() {
        self.isShowLoading = true
        service.fetchImages { imgs in
            self.galleryImages = Dictionary(grouping: imgs, by: { $0.sessionId ?? "" })
            self.isShowLoading = false
        }
    }
}
