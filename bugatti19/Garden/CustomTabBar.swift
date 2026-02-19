import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
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
        .padding(.horizontal, AppSpacing.sm)
        .padding(.vertical, AppSpacing.sm)
        .background(
            ZStack {
                Capsule()
                    .fill(AppColors.cardBackground)
                
                Capsule()
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                AppColors.iconAccent.opacity(0.7),
                                AppColors.cardBorder,
                                AppColors.iconPrimary.opacity(0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            }
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 10)
        .shadow(color: AppShadows.medium, radius: 12, x: 0, y: -4)
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.xs) {
                ZStack {
                    if isSelected {
                        Capsule()
                            .fill(AppColors.iconAccent.opacity(0.3))
                            .frame(width: 48, height: 36)
                            .scaleEffect(isPressed ? 0.92 : 1.0)
                    }
                    
                    Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                        .font(.system(size: 20, weight: isSelected ? .medium : .regular))
                        .foregroundColor(isSelected ? AppColors.iconAccent : AppColors.iconPrimary)
                        .scaleEffect(isPressed ? 0.85 : 1.0)
                }
                
                Text(tab.title)
                    .font(AppFonts.caption2())
                    .foregroundColor(isSelected ? AppColors.iconAccent : AppColors.iconMuted)
                    .scaleEffect(isPressed ? 0.9 : 1.0)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

enum TabItem: String, CaseIterable {
    case today = "Today"
    case habits = "Habits"
    case statistics = "Statistics"
    case history = "History"
    case settings = "Settings"
    
    var title: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .today: return "house"
        case .habits: return "star"
        case .statistics: return "chart.bar"
        case .history: return "calendar"
        case .settings: return "gearshape"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .today: return "house.fill"
        case .habits: return "star.fill"
        case .statistics: return "chart.bar.fill"
        case .history: return "calendar.circle.fill"
        case .settings: return "gearshape.fill"
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.today))
    }
    .background(AppColors.backgroundGradient)
}
