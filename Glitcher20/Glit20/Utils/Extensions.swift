import SwiftUI

extension View {
    func cardStyle() -> some View {
        self
            .background(AppColorScheme.cardGradient)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
    }
    
    func primaryButtonStyle() -> some View {
        self
            .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
            .foregroundColor(Color.primaryPurple)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color.primaryYellow)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    func secondaryButtonStyle() -> some View {
        self
            .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
            .foregroundColor(Color.textPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
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
    func timeAgo() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
