//
//  User.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 25/09/24.
//

import FirebaseFirestore
import FirebaseAuth

struct User: Codable {
    let uid: String?
    let username: String
    let firstName: String
    let lastName: String
    let profileImageUrl: String?
    let email: String
    let role: String?
    let tenantId: String?
    let mobileNumber: String?
    let createdOn: Date?
    let updatedOn: Date?
    
    // Factory method to decode User from JSON Data
    static func fromJson(_ jsonData: Data) -> User? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601 // Assuming ISO8601 date format
        
        do {
            let user = try decoder.decode(User.self, from: jsonData)
            return user
        } catch {
            debugPrint("Error decoding User: \(error)")
            return nil
        }
    }
    
    // Factory method to decode User from Dictionary
    static func fromDictionary(_ dictionary: [String: Any]) -> User? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            return fromJson(jsonData) // Use the same JSON decoding logic
        } catch {
            debugPrint("Error serializing dictionary to JSON: \(error)")
            return nil
        }
    }
    
    // Method to convert User to JSON
    func toJson() -> [String: Any]? {
        guard let data = toJsonData() else { return nil }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            if let dictionary = jsonObject as? [String: Any] {
                return dictionary
            } else {
                debugPrint("JSON is not a dictionary.")
                return nil
            }
        } catch {
            debugPrint("Error deserializing JSON data: \(error)")
            return nil
        }
    }
    
    func toJsonData() -> Data? {
        let encoder = JSONEncoder()
        // Optionally, set the date encoding strategy if you want to format dates
        encoder.dateEncodingStrategy = .iso8601 // or .millisecondsSince1970, etc.
        
        do {
            let data = try encoder.encode(self)
            return data
        } catch {
            debugPrint("Error encoding User to JSON: \(error)")
            return nil
        }
    }
    
    // You can also create a method to convert Data to a JSON String for easier readability
    func toJsonString() -> String? {
        guard let jsonData = toJsonData() else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
}

extension User {
    var avatarUrl: String {
        profileImageUrl ?? "https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50"
    }
    
    var isCurrentUser: Bool {
        Auth.auth().currentUser?.uid == uid
    }
}
