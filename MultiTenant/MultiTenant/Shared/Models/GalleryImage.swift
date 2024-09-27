//
//  File.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 26/09/24.
//

import Foundation

struct GalleryImage: Codable, Identifiable {
    let id: String?
    let imageUrl: String?
    let sessionId: String?
    let createdOn: Date?
    
    // Factory method to decode GalleryImage from JSON Data
    static func fromJson(_ jsonData: Data) -> GalleryImage? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601 // Assuming ISO8601 date format
        
        do {
            let imageObj = try decoder.decode(GalleryImage.self, from: jsonData)
            return imageObj
        } catch {
            print("Error decoding GalleryImage: \(error)")
            return nil
        }
    }
    
    // Factory method to decode GalleryImage from Dictionary
    static func fromDictionary(_ dictionary: [String: Any]) -> GalleryImage? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            return fromJson(jsonData) // Use the same JSON decoding logic
        } catch {
            print("Error serializing dictionary to JSON: \(error)")
            return nil
        }
    }
    
    // Method to convert GalleryImage to JSON
    func toJson() -> [String: Any]? {
        guard let data = toJsonData() else { return nil }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            if let dictionary = jsonObject as? [String: Any] {
                return dictionary
            } else {
                print("JSON is not a dictionary.")
                return nil
            }
        } catch {
            print("Error deserializing JSON data: \(error)")
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
            print("Error encoding GalleryImage to JSON: \(error)")
            return nil
        }
    }
    
    // You can also create a method to convert Data to a JSON String for easier readability
    func toJsonString() -> String? {
        guard let jsonData = toJsonData() else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
}
