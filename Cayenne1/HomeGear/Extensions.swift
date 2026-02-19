import SwiftUI

extension View {
    func cardStyle() -> some View {
        self
            .background(AppColors.cardGradient)
            .cornerRadius(15)
            .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
    }
    
    func primaryButtonStyle() -> some View {
        self
            .foregroundColor(AppColors.primaryText)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(AppColors.buttonGradient)
            .cornerRadius(20)
            .shadow(color: AppColors.shadowColor, radius: 5, x: 0, y: 2)
    }
    
    func secondaryButtonStyle() -> some View {
        self
            .foregroundColor(AppColors.primaryText)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(AppColors.orangeGradient)
            .cornerRadius(20)
            .shadow(color: AppColors.shadowColor, radius: 5, x: 0, y: 2)
    }
}

extension String {
    var isNotEmpty: Bool {
        !self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func truncated(to length: Int) -> String {
        if self.count > length {
            return String(self.prefix(length)) + "..."
        }
        return self
    }
}

extension Date {
    func formatted(style: DateFormatter.Style = .medium) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        return formatter.string(from: self)
    }
    
    func timeAgo() -> String {
        let now = Date()
        let timeInterval = now.timeIntervalSince(self)
        
        if timeInterval < 60 {
            return "Just now"
        } else if timeInterval < 3600 {
            let minutes = Int(timeInterval / 60)
            return "\(minutes) minute\(minutes == 1 ? "" : "s") ago"
        } else if timeInterval < 86400 {
            let hours = Int(timeInterval / 3600)
            return "\(hours) hour\(hours == 1 ? "" : "s") ago"
        } else {
            let days = Int(timeInterval / 86400)
            return "\(days) day\(days == 1 ? "" : "s") ago"
        }
    }
}

extension Animation {
    static let smoothSpring = Animation.spring(response: 0.6, dampingFraction: 0.8)
    static let quickSpring = Animation.spring(response: 0.3, dampingFraction: 0.7)
    static let gentleEase = Animation.easeInOut(duration: 0.4)
}

struct HapticManager {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
