import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            Group {
                switch appState.selectedTab {
                case .today:
                    TodayView()
                case .wardrobe:
                    WardrobeView()
                case .outfits:
                    OutfitsView()
                case .statistics:
                    StatisticsView()
                case .settings:
                    SettingsView()
                }
            }
            .environmentObject(appState)
            
            VStack {
                Spacer()
                
                CustomTabBar()
                    .environmentObject(appState)
            }
        }
    }
}

struct CustomTabBar: View {
    @EnvironmentObject var appState: AppState
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarItem(
                    tab: tab,
                    isSelected: appState.selectedTab == tab
                ) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        appState.selectedTab = tab
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.yellow)
                    .frame(width: 70, height: 70)
                    .offset(x: animationOffset)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: animationOffset)
            }
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
        .onChange(of: appState.selectedTab) { newTab in
            updateAnimationOffset(for: newTab)
        }
        .onAppear {
            updateAnimationOffset(for: appState.selectedTab)
        }
    }
    
    private func updateAnimationOffset(for tab: TabItem) {
        let tabIndex = TabItem.allCases.firstIndex(of: tab) ?? 0
        let screenWidth = UIScreen.main.bounds.width - 80
        let tabWidth = screenWidth / CGFloat(TabItem.allCases.count)
        let centerOffset = tabWidth * (CGFloat(tabIndex) + 0.5) - screenWidth / 2
        animationOffset = centerOffset
    }
}

struct TabBarItem: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            action()
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        }) {
            VStack(spacing: 4) {
                Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.accentText : AppColors.primaryText)
                    .scaleEffect(isPressed ? 0.9 : 1.0)
                
                Text(tab.rawValue)
                    .font(.ubuntu(10, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.accentText : AppColors.primaryText)
                    .opacity(isSelected ? 1.0 : 0.7)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState())
}
