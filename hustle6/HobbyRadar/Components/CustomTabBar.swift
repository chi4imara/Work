import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    @State private var animationOffset: CGFloat = 0
    
    private let tabs = TabItem.allCases
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        colors: [
                            AppColors.cardBackground,
                            AppColors.surfaceBackground,
                            AppColors.cardBackground
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: AppColors.primary.opacity(0.1), radius: 10, x: 0, y: -5)
            
            FloatingTabBubbles()
            
            HStack(spacing: 0) {
                ForEach(tabs, id: \.self) { tab in
                    TabBarButton(
                        tab: tab,
                        isSelected: selectedTab == tab
                    ) {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            selectedTab = tab
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 80)
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
                            .fill(AppColors.primaryGradient)
                            .frame(width: 50, height: 50)
                            .shadow(color: AppColors.primary.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    
                    Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(isSelected ? AppColors.onPrimary : AppColors.secondaryText)
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                }
                
                Text(tab.title)
                    .font(AppFonts.tabBarTitle)
                    .foregroundColor(isSelected ? AppColors.primary : AppColors.secondaryText)
                    .fontWeight(isSelected ? .semibold : .medium)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct FloatingTabBubbles: View {
    @State private var bubbleOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            ForEach(0..<5, id: \.self) { index in
                Circle()
                    .fill(AppColors.bubbleBlue1)
                    .frame(width: CGFloat.random(in: 8...16), height: CGFloat.random(in: 8...16))
                    .position(
                        x: CGFloat(index) * 60 + 30 + sin(bubbleOffset + Double(index)) * 10,
                        y: 40 + cos(bubbleOffset + Double(index) * 0.7) * 8
                    )
                    .blur(radius: 1)
            }
        }
        .onAppear {
            withAnimation(
                Animation.linear(duration: 8)
                    .repeatForever(autoreverses: false)
            ) {
                bubbleOffset = .pi * 4
            }
        }
    }
}

enum TabItem: String, CaseIterable {
    case home = "Home"
    case allIdeas = "All Ideas"
    case favorites = "Favorites"
    case settings = "Settings"
    
    var title: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .home:
            return "dice"
        case .allIdeas:
            return "books.vertical"
        case .favorites:
            return "heart"
        case .settings:
            return "gearshape"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .home:
            return "dice.fill"
        case .allIdeas:
            return "books.vertical.fill"
        case .favorites:
            return "heart.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
}

struct AnimatedTabIndicator: View {
    let selectedTab: TabItem
    let tabs: [TabItem]
    
    var body: some View {
        GeometryReader { geometry in
            let tabWidth = geometry.size.width / CGFloat(tabs.count)
            let selectedIndex = tabs.firstIndex(of: selectedTab) ?? 0
            let indicatorOffset = CGFloat(selectedIndex) * tabWidth
            
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.primaryGradient)
                .frame(width: tabWidth - 20, height: 4)
                .offset(x: indicatorOffset + 10)
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: selectedTab)
        }
        .frame(height: 4)
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.home))
    }
    .background(AppColors.backgroundGradient)
}
