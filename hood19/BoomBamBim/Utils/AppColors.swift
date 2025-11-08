import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let secondaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let lightBlue = Color(red: 0.8, green: 0.9, blue: 1.0)
    static let darkBlue = Color(red: 0.1, green: 0.3, blue: 0.8)
    
    static let background = Color.white
    static let cardBackground = Color(red: 0.98, green: 0.99, blue: 1.0)
    static let sidebarBackground = Color(red: 0.95, green: 0.97, blue: 1.0)
    
    static let primaryText = Color(red: 0.1, green: 0.2, blue: 0.4)
    static let secondaryText = Color(red: 0.4, green: 0.5, blue: 0.7)
    static let lightText = Color(red: 0.6, green: 0.7, blue: 0.8)
    
    static let completedGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let inProgressYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let overdueRed = Color(red: 1.0, green: 0.3, blue: 0.3)
    
    static let accent = Color(red: 0.9, green: 0.4, blue: 0.8)
    static let purple = Color(red: 0.6, green: 0.4, blue: 0.9)
    static let teal = Color(red: 0.2, green: 0.8, blue: 0.8)
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color.white,
            Color(red: 0.95, green: 0.98, blue: 1.0),
            Color(red: 0.9, green: 0.95, blue: 1.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color(red: 0.98, green: 0.99, blue: 1.0),
            Color(red: 0.95, green: 0.97, blue: 1.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension Color {
    static func statusColor(for status: TaskStatus) -> Color {
        switch status {
        case .completed:
            return AppColors.completedGreen
        case .inProgress:
            return AppColors.inProgressYellow
        case .overdue:
            return AppColors.overdueRed
        }
    }
}
