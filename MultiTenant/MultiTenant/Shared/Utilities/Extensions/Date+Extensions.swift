//
//  Date+Extensions.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 27/09/24.
//

import Foundation

extension Date {
    func toString(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
