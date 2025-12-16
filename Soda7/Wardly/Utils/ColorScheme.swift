import SwiftUI

struct AppColors {
    static let primaryPurple = Color(red: 0.4, green: 0.2, blue: 0.8)
    static let secondaryPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    static let lightPurple = Color(red: 0.8, green: 0.7, blue: 0.95)
    
    static let blueText = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let yellowAccent = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let lightYellow = Color(red: 1.0, green: 0.95, blue: 0.7)
    
    static let backgroundWhite = Color.white
    static let backgroundGray = Color(red: 0.98, green: 0.98, blue: 0.99)
    static let cardBackground = Color(red: 0.99, green: 0.99, blue: 1.0)
    
    static let successGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let warningOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let errorRed = Color(red: 0.9, green: 0.3, blue: 0.3)
    static let neutralGray = Color(red: 0.6, green: 0.6, blue: 0.6)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    
    static let purpleGradient = LinearGradient(
        colors: [primaryPurple, secondaryPurple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let backgroundGradient = LinearGradient(
        colors: [backgroundWhite, lightPurple.opacity(0.3)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let cardGradient = LinearGradient(
        colors: [cardBackground, lightPurple.opacity(0.1)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static func priorityColor(for priority: Priority) -> Color {
        switch priority {
        case .high:
            return errorRed
        case .medium:
            return warningOrange
        case .low:
            return successGreen
        }
    }
    
    static func statusColor(for status: ItemStatus) -> Color {
        switch status {
        case .purchased:
            return successGreen
        case .notPurchased:
            return neutralGray
        }
    }
}

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppColors.cardGradient)
            .cornerRadius(12)
            .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct PrimaryButtonStyle: ViewModifier {
    let isEnabled: Bool
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .padding()
            .background(
                isEnabled ? AppColors.purpleGradient : 
                LinearGradient(colors: [AppColors.neutralGray], startPoint: .top, endPoint: .bottom)
            )
            .cornerRadius(10)
            .disabled(!isEnabled)
    }
}

struct SecondaryButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(AppColors.primaryPurple)
            .padding()
            .background(AppColors.lightPurple.opacity(0.3))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(AppColors.primaryPurple.opacity(0.3), lineWidth: 1)
            )
    }
}

extension View {
    func cardStyle() -> some View {
        self.modifier(CardStyle())
    }
    
    func primaryButtonStyle(isEnabled: Bool = true) -> some View {
        self.modifier(PrimaryButtonStyle(isEnabled: isEnabled))
    }
    
    func secondaryButtonStyle() -> some View {
        self.modifier(SecondaryButtonStyle())
    }
}
