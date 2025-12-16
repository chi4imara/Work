import Foundation

class DateManager {
    static let shared = DateManager()
    
    private let dateFormatter: DateFormatter
    private let displayDateFormatter: DateFormatter
    private let timeFormatter: DateFormatter
    
    private init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        displayDateFormatter = DateFormatter()
        displayDateFormatter.dateFormat = "d MMMM yyyy"
        displayDateFormatter.locale = Locale(identifier: "en_US")
        
        timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
    }
    
    func todayString() -> String {
        return dateFormatter.string(from: Date())
    }
    
    func formatDateForDisplay(from dateString: String) -> String {
        guard let date = dateFormatter.date(from: dateString) else {
            return dateString
        }
        return displayDateFormatter.string(from: date)
    }
    
    func formatTime(from date: Date) -> String {
        return timeFormatter.string(from: date)
    }
    
    func isToday(_ dateString: String) -> Bool {
        return dateString == todayString()
    }
    
    func dateFromString(_ dateString: String) -> Date? {
        return dateFormatter.date(from: dateString)
    }
    
    func stringFromDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}
