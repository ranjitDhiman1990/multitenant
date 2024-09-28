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
    
    func timeAgoSinceDate() -> String {
        let calendar = Calendar.current
        let now = Date()
        
        let components = calendar.dateComponents([.year, .month, .weekOfYear, .day], from: self, to: now)
        
        // Check for years
        if let year = components.year, year > 0 {
            return year == 1 ? "1 year ago" : "\(year) years ago"
        }
        
        // Check for months
        if let month = components.month, month > 0 {
            return month == 1 ? "1 month ago" : "\(month) months ago"
        }
        
        // Check for weeks
        if let week = components.weekOfYear, week > 0 {
            return week == 1 ? "1 week ago" : "\(week) weeks ago"
        }
        
        // Check for days
        if let day = components.day {
            switch day {
            case 0:
                return "Today"
            case 1:
                return "Yesterday"
            default:
                return "\(day) days ago"
            }
        }
        
        return "Just now"
    }
}
