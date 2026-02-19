import Foundation
import SwiftUI

struct AppConstants {
    
    struct Animation {
        static let short: Double = 0.2
        static let medium: Double = 0.3
        static let long: Double = 0.5
        static let splash: Double = 2.0
    }
    
    struct Layout {
        static let cornerRadius: CGFloat = 16
        static let smallCornerRadius: CGFloat = 8
        static let largeCornerRadius: CGFloat = 28
        
        static let padding: CGFloat = 20
        static let smallPadding: CGFloat = 12
        static let largePadding: CGFloat = 30
        
        static let buttonHeight: CGFloat = 56
        static let smallButtonHeight: CGFloat = 44
        
        static let cardPadding: CGFloat = 16
        static let sectionSpacing: CGFloat = 24
    }
    
    struct FontSize {
        static let title: CGFloat = 28
        static let headline: CGFloat = 24
        static let subheadline: CGFloat = 20
        static let body: CGFloat = 18
        static let callout: CGFloat = 16
        static let caption: CGFloat = 14
        static let caption2: CGFloat = 12
        static let small: CGFloat = 10
    }
    
    struct SystemImage {
        static let plus = "plus"
        static let calendar = "calendar"
        static let clock = "clock"
        static let tag = "tag"
        static let folder = "folder"
        static let person = "person"
        static let gear = "gearshape"
        static let checkmark = "checkmark.circle"
        static let checkmarkFilled = "checkmark.circle.fill"
        static let circle = "circle"
        static let chevronRight = "chevron.right"
        static let chevronLeft = "chevron.left"
        static let chevronDown = "chevron.down"
        static let star = "star"
        static let envelope = "envelope"
        static let shield = "shield.checkerboard"
    }
    
    struct UserDefaultsKeys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let procedures = "procedures"
        static let categories = "categories"
        static let history = "history"
    }
    
    struct URLs {
        static let privacyPolicy = "https://google.com"
        static let contactUs = "https://google.com"
        static let appStore = "https://google.com"
    }
}

class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let impactFeedback = UIImpactFeedbackGenerator(style: style)
        impactFeedback.impactOccurred()
    }
    
    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(type)
    }
    
    func selection() {
        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.selectionChanged()
    }
}

struct ValidationHelper {
    static func isValidProcedureName(_ name: String) -> Bool {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty && trimmed.count >= 2
    }
    
    static func isValidCategoryName(_ name: String) -> Bool {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty && trimmed.count >= 2
    }
    
    static func isValidCustomDays(_ days: Int) -> Bool {
        return days > 0 && days <= 365
    }
}

struct DateHelper {
    static let shared = DateHelper()
    
    private let calendar = Calendar.current
    
    private init() {}
    
    func formatDate(_ date: Date, style: DateFormatter.Style = .medium) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        return formatter.string(from: date)
    }
    
    func formatRelativeDate(_ date: Date) -> String {
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else if calendar.isDateInTomorrow(date) {
            return "Tomorrow"
        } else {
            return formatDate(date)
        }
    }
    
    func dayOfWeek(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
    
    func dayNumber(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    func monthYear(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: date)
    }
    
    func weekDates(for date: Date) -> [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: date) else {
            return []
        }
        
        var dates: [Date] = []
        var currentDate = weekInterval.start
        
        for _ in 0..<7 {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return dates
    }
}
