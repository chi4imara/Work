import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppStateManager
    @StateObject private var bookingsViewModel = BookingsViewModel()
    @State private var selectedTab: Int = 0
    
    let tabs = [
        TabItem(title: "Home", icon: "house.fill", selectedIcon: "house.fill"),
        TabItem(title: "Bookings", icon: "calendar", selectedIcon: "calendar"),
        TabItem(title: "Statistics", icon: "chart.line.uptrend.xyaxis", selectedIcon: "chart.line.uptrend.xyaxis"),
        TabItem(title: "Profile", icon: "person", selectedIcon: "person.fill"),
        TabItem(title: "Settings", icon: "gearshape", selectedIcon: "gearshape.fill")
    ]
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case 0:
                    MainScreenView()
                case 1:
                    BookingsView()
                case 2:
                    ProgressView()
                case 3:
                    ProfileView()
                case 4:
                    SettingsView()
                default:
                    MainScreenView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab, tabs: tabs)
            }
        }
        .environmentObject(bookingsViewModel)
        .onChange(of: selectedTab) { newValue in
            appState.selectedTab = newValue
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    let tabs: [TabItem]
    @State private var tabBackgroundOffset: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                TabBarButton(
                    tab: tabs[index],
                    isSelected: selectedTab == index,
                    action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            selectedTab = index
                            updateTabBackgroundOffset(for: index)
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
                    .fill(ColorTheme.cardBackground)
                    .shadow(color: ColorTheme.shadowColor, radius: 15, x: 0, y: -5)
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(ColorTheme.buttonGradient)
                    .frame(width: 60, height: 60)
                    .offset(x: tabBackgroundOffset)
                    .shadow(color: ColorTheme.primaryYellow.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
        .onAppear {
            updateTabBackgroundOffset(for: selectedTab)
        }
    }
    
    private func updateTabBackgroundOffset(for index: Int) {
        let screenWidth = UIScreen.main.bounds.width - 40 
        let tabWidth = screenWidth / CGFloat(tabs.count)
        let centerOffset = tabWidth * (CGFloat(index) + 0.5) - screenWidth / 2
        tabBackgroundOffset = centerOffset
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? .white : ColorTheme.textSecondary)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(tab.title)
                    .font(.ubuntu(10, weight: .medium))
                    .foregroundColor(isSelected ? .white : ColorTheme.textSecondary)
                    .opacity(isSelected ? 1.0 : 0.7)
            }
            .frame(maxWidth: .infinity)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TabItem {
    let title: String
    let icon: String
    let selectedIcon: String
}

#Preview {
    MainTabView()
        .environmentObject(AppStateManager())
}
