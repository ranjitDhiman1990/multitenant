//
//  TenantService.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 26/09/24.
//

import FirebaseFirestore

struct TenantService {
    
    func fetchTenant(withId id: String, completion: @escaping(Tenant) -> Void) {
        Firestore.firestore().collection("tenants")
            .document(id)
            .getDocument { snapshot, _ in
                guard let snapshot = snapshot else { return }
                var tenant: Tenant
                
                do {
                    tenant = try snapshot.data(as: Tenant.self)
                } catch {
                    debugPrint("Error fetch Tenant: \(error)")
                    return
                }
                
                completion(tenant)
            }
    }
    
    func fetchTenants(completion: @escaping([Tenant]) -> Void) {
        Firestore.firestore().collection("tenants")
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let tenants = documents.compactMap({ try? $0.data(as: Tenant.self)})
                
                completion(tenants)
            }
    }
}
