import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    let tabs: [TabItem]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.large)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.large)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
                .shadow(color: AppShadow.medium, radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, AppSpacing.md)
        .padding(.bottom, AppSpacing.sm)
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.xs) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(AppColors.accentYellow)
                            .frame(width: 40, height: 40)
                            .scaleEffect(isSelected ? 1.0 : 0.8)
                    }
                    
                    Image(systemName: tab.iconName)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSelected ? AppColors.primaryText : AppColors.secondaryText)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                }
                
                Text(tab.title)
                    .font(AppFonts.small)
                    .foregroundColor(isSelected ? AppColors.accentText : AppColors.secondaryText)
                    .fontWeight(isSelected ? .medium : .regular)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

enum TabItem: String, CaseIterable {
    case recommendations = "Recommendations"
    case mealPlan = "My Diet"
    case progress = "Progress"
    case profile = "Profile"
    case settings = "Settings"
    
    var title: String {
        switch self {
        case .recommendations: return "Home"
        case .mealPlan: return "Diet"
        case .progress: return "Progress"
        case .profile: return "Profile"
        case .settings: return "Settings"
        }
    }
    
    var iconName: String {
        switch self {
        case .recommendations: return "house.fill"
        case .mealPlan: return "fork.knife"
        case .progress: return "chart.line.uptrend.xyaxis"
        case .profile: return "person.fill"
        case .settings: return "gearshape.fill"
        }
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(
            selectedTab: .constant(.recommendations),
            tabs: TabItem.allCases
        )
    }
    .background(AppGradients.primaryBackground)
}
