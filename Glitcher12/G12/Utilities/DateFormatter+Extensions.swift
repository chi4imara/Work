import Foundation

extension DateFormatter {
    static let manicureDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    static let displayDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

extension Date {
    var manicureDateString: String {
        DateFormatter.manicureDate.string(from: self)
    }
    
    var displayDateString: String {
        DateFormatter.displayDate.string(from: self)
    }
}
