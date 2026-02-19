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
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(AppColors.primaryYellow)
                            .frame(width: 40, height: 40)
                            .scaleEffect(isPressed ? 0.9 : 1.0)
                    }
                    
                    Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isSelected ? .black : AppColors.textPrimary)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                }
                
                Text(tab.title)
                    .font(AppFonts.caption(10))
                    .foregroundColor(isSelected ? AppColors.primaryYellow : AppColors.textSecondary)
                    .fontWeight(isSelected ? .medium : .regular)
            }
        }
        .frame(maxWidth: .infinity)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
}

enum TabItem: String, CaseIterable {
    case home = "Home"
    case menu = "My Menu"
    case progress = "Progress"
    case profile = "Profile"
    case settings = "Settings"
    
    var title: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .home:
            return "house"
        case .menu:
            return "book"
        case .progress:
            return "chart.line.uptrend.xyaxis"
        case .profile:
            return "person"
        case .settings:
            return "gearshape"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .home:
            return "house.fill"
        case .menu:
            return "book.fill"
        case .progress:
            return "chart.line.uptrend.xyaxis"
        case .profile:
            return "person.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
}

#Preview {
    ZStack {
        AppColors.backgroundGradient
            .ignoresSafeArea()
        
        VStack {
            Spacer()
            CustomTabBar(selectedTab: .constant(.home))
        }
    }
}
