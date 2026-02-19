import SwiftUI

extension View {
    func cardStyle() -> some View {
        self
            .background(AppColors.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
            .cornerRadius(16)
    }
    
    func primaryButton() -> some View {
        self
            .font(.lumierepolis(16, weight: .bold))
            .foregroundColor(AppColors.primaryWhite)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(AppColors.buttonPrimary)
            .cornerRadius(25)
    }
    
    func secondaryButton() -> some View {
        self
            .font(.lumierepolis(16, weight: .bold))
            .foregroundColor(AppColors.secondaryText)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(AppColors.buttonSecondary)
            .cornerRadius(25)
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: 
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

import Foundation

extension UUID: Identifiable {
    public var id: UUID { self }
}
