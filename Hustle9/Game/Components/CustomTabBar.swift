import SwiftUI

struct MenuCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let isSelected: Bool
    let isWide: Bool
    
    init(icon: String, title: String, subtitle: String, isSelected: Bool, isWide: Bool = false) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.isSelected = isSelected
        self.isWide = isWide
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 30, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.accent : AppColors.primaryText)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(isSelected ? AppColors.accent.opacity(0.2) : AppColors.buttonBackground)
                            .overlay(
                                Circle()
                                    .stroke(isSelected ? AppColors.accent : AppColors.buttonBorder, lineWidth: 1)
                            )
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(AppFonts.title2)
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(1)
                    
                    Text(subtitle)
                        .font(AppFonts.bodyMedium)
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(1)
                }
                
                if !isWide {
                    Spacer()
                }
                
                if isWide {
                    Spacer()
                }
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isSelected ? AppColors.cardBackground : AppColors.cardBackground.opacity(0.7))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? AppColors.accent : AppColors.cardBorder, lineWidth: isSelected ? 2 : 1)
                )
        )
    }
}
