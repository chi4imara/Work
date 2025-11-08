import SwiftUI

enum TabItem: String, CaseIterable {
    case calendar = "calendar"
    case analytics = "chart.line.uptrend.xyaxis"
    case favorites = "star.fill"
    case settings = "gearshape.fill"
    
    var title: String {
        switch self {
        case .calendar: return "Calendar"
        case .analytics: return "Analytics"
        case .favorites: return "Favorites"
        case .settings: return "Settings"
        }
    }
    
    var icon: String {
        return self.rawValue
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    @State private var animateSelection = false
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = tab
                            animateSelection = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            animateSelection = false
                        }
                    }
                )
            }
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.vertical, AppTheme.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.extraLarge)
                .fill(Color.white.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.extraLarge)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: AppTheme.Shadow.medium, radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, AppTheme.Spacing.lg)
        .padding(.bottom, AppTheme.Spacing.md)
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            HapticFeedback.light()
            action()
        }) {
            VStack(spacing: AppTheme.Spacing.xs) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(AppTheme.Colors.accentYellow.opacity(0.2))
                            .frame(width: 40, height: 40)
                            .scaleEffect(isPressed ? 0.9 : 1.0)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSelected ? AppTheme.Colors.accentYellow : AppTheme.Colors.secondaryText)
                        .scaleEffect(isPressed ? 0.8 : 1.0)
                }
                
                Text(tab.title)
                    .font(AppTheme.Fonts.tabBarFont)
                    .foregroundColor(isSelected ? AppTheme.Colors.accentYellow : AppTheme.Colors.tertiaryText)
                    .opacity(isSelected ? 1.0 : 0.8)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.calendar))
    }
    .background(AppTheme.Colors.backgroundGradient)
}
