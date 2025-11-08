import SwiftUI

extension Font {
    static let titleLarge = Font.system(size: 28, weight: .bold, design: .rounded)
    static let titleMedium = Font.system(size: 22, weight: .semibold, design: .rounded)
    static let titleSmall = Font.system(size: 18, weight: .medium, design: .rounded)
    
    static let bodyLarge = Font.system(size: 16, weight: .regular, design: .default)
    static let bodyMedium = Font.system(size: 14, weight: .regular, design: .default)
    static let bodySmall = Font.system(size: 12, weight: .regular, design: .default)
    
    static let buttonText = Font.system(size: 16, weight: .semibold, design: .rounded)
    static let caption = Font.system(size: 11, weight: .medium, design: .default)
}

struct AppTextStyles {
    static func title(_ text: String) -> some View {
        Text(text)
            .font(.titleLarge)
            .foregroundColor(.primaryText)
    }
    
    static func subtitle(_ text: String) -> some View {
        Text(text)
            .font(.titleMedium)
            .foregroundColor(.primaryText)
    }
    
    static func body(_ text: String) -> some View {
        Text(text)
            .font(.bodyMedium)
            .foregroundColor(.primaryText)
            .lineSpacing(2)
    }
    
    static func caption(_ text: String) -> some View {
        Text(text)
            .font(.caption)
            .foregroundColor(.secondaryText)
    }
}

