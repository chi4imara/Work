import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    @State private var animationOffset: CGFloat = 0
    
    private let tabs = TabItem.allCases
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.rawValue) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = tab
                        }
                    }
                )
                .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 80)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
                
                RoundedRectangle(cornerRadius: 25)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.9),
                                Color.white.opacity(0.7)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                HStack(spacing: 0) {
                    ForEach(tabs, id: \.rawValue) { tab in
                        Rectangle()
                            .fill(Color.clear)
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(AppColors.primaryBlue.opacity(0.1))
                                    .scaleEffect(selectedTab == tab ? 1.0 : 0.0)
                                    .animation(.easeInOut(duration: 0.3), value: selectedTab)
                            )
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
            }
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
                Image(systemName: tab.iconName)
                    .font(.system(size: isSelected ? 22 : 20, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.textSecondary)
                    .scaleEffect(isPressed ? 0.9 : 1.0)
                    .animation(.easeInOut(duration: 0.1), value: isPressed)
                
                Text(tab.rawValue)
                    .font(.ibmPlexMono(10, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.textSecondary)
                    .opacity(isSelected ? 1.0 : 0.7)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: isSelected)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct MainTabView: View {
    @StateObject private var appState = AppStateViewModel()
    @StateObject private var reactionsViewModel = ReactionsViewModel()
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            Group {
                switch appState.currentTab {
                case .reactions:
                    ReactionsView()
                        .environmentObject(reactionsViewModel)
                case .categories:
                    CategoriesView()
                        .environmentObject(reactionsViewModel)
                case .statistics:
                    StatisticsView()
                        .environmentObject(reactionsViewModel)
                case .settings:
                    SettingsView()
                case .calendar:
                    CalendarView()
                        .environmentObject(reactionsViewModel)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $appState.currentTab)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
