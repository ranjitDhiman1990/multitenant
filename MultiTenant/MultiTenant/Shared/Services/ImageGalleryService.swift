//
//  ImageGalleryService.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 26/09/24.
//

import FirebaseFirestore

struct ImageGalleryService {
    func fetchImages(completion: @escaping([GalleryImage]) -> Void) {
        Firestore.firestore().collection("images")
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let images = documents.compactMap { snapshot in
                    return GalleryImage.fromDictionary(snapshot.data())
                }
                completion(images)
            }
    }
}
