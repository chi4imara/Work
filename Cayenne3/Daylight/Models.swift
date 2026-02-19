import Foundation
import SwiftUI

struct Task: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var category: TaskCategory
    var date: TaskDate
    var comment: String
    var isCompleted: Bool
    var createdAt: Date
    
    init(title: String, category: TaskCategory, date: TaskDate, comment: String = "", isCompleted: Bool = false) {
        self.id = UUID()
        self.title = title
        self.category = category
        self.date = date
        self.comment = comment
        self.isCompleted = isCompleted
        self.createdAt = Date()
    }
}

enum TaskCategory: String, CaseIterable, Codable {
    case home = "Home"
    case work = "Work"
    case personal = "Personal"
    case shopping = "Shopping"
    case hobby = "Hobby"
    case other = "Other"
    
    var color: Color {
        switch self {
        case .home: return AppColors.homeCategory
        case .work: return AppColors.workCategory
        case .personal: return AppColors.personalCategory
        case .shopping: return AppColors.shoppingCategory
        case .hobby: return AppColors.hobbyCategory
        case .other: return AppColors.otherCategory
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .work: return "briefcase.fill"
        case .personal: return "person.fill"
        case .shopping: return "cart.fill"
        case .hobby: return "gamecontroller.fill"
        case .other: return "folder.fill"
        }
    }
}

enum TaskDate: String, CaseIterable, Codable {
    case yesterday = "Yesterday"
    case today = "Today"
    case tomorrow = "Tomorrow"
    
    var date: Date {
        let calendar = Calendar.current
        let today = Date()
        
        switch self {
        case .yesterday:
            return calendar.date(byAdding: .day, value: -1, to: today) ?? today
        case .today:
            return today
        case .tomorrow:
            return calendar.date(byAdding: .day, value: 1, to: today) ?? today
        }
    }
    
    var displayDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct Note: Identifiable, Codable {
    let id: UUID
    var content: String
    var createdAt: Date
    var updatedAt: Date
    
    init(content: String) {
        self.id = UUID()
        self.content = content
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    var preview: String {
        let maxLength = 100
        if content.count <= maxLength {
            return content
        }
        return String(content.prefix(maxLength)) + "..."
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: createdAt)
    }
}

enum TabItem: String, CaseIterable {
    case tasks = "Tasks"
    case categories = "Categories"
    case notes = "Notes"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .tasks: return "checkmark.circle"
        case .categories: return "folder"
        case .notes: return "note.text"
        case .statistics: return "chart.bar"
        case .settings: return "gearshape"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .tasks: return "checkmark.circle.fill"
        case .categories: return "folder.fill"
        case .notes: return "note.text"
        case .statistics: return "chart.bar.fill"
        case .settings: return "gearshape.fill"
        }
    }
}

struct SettingsItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let action: SettingsAction
}

enum SettingsAction {
    case privacyPolicy
    case contactEmail
    case rateApp
}
