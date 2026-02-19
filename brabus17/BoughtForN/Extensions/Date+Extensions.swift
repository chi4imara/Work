import Foundation

extension Date {
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    var shortDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
    
    var timeOnly: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}