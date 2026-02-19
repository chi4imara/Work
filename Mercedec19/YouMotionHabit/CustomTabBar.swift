import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        TabItem(title: "Workouts", icon: "dumbbell", selectedIcon: "dumbbell.fill"),
        TabItem(title: "My Workouts", icon: "list.bullet", selectedIcon: "list.bullet.clipboard"),
        TabItem(title: "Progress", icon: "chart.bar", selectedIcon: "chart.bar.fill"),
        TabItem(title: "Profile", icon: "person", selectedIcon: "person.fill"),
        TabItem(title: "Settings", icon: "gearshape", selectedIcon: "gearshape.fill")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                TabBarButton(
                    tab: tabs[index],
                    isSelected: selectedTab == index
                ) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = index
                    }
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(ColorTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(ColorTheme.cardBorder, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabItem {
    let title: String
    let icon: String
    let selectedIcon: String
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(ColorTheme.primaryYellow)
                            .frame(width: 40, height: 40)
                            .scaleEffect(isSelected ? 1.0 : 0.8)
                    }
                    
                    Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isSelected ? ColorTheme.primaryBlue : ColorTheme.textSecondary)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                }
                
                Text(tab.title)
                    .font(.ubuntu(10, weight: isSelected ? .medium : .regular))
                    .foregroundColor(isSelected ? ColorTheme.primaryYellow : ColorTheme.textSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.3), value: isSelected)
    }
}

struct CustomTabView: View {
    @StateObject private var appState = AppStateManager()
    @StateObject private var userProfile = UserProfileViewModel()
    @StateObject private var workouts = WorkoutsViewModel()
    @StateObject private var progress = ProgressViewModel()
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            Group {
                switch appState.selectedTab {
                case 0:
                    WorkoutsView()
                        .environmentObject(workouts)
                        .environmentObject(userProfile)
                case 1:
                    MyWorkoutsView()
                        .environmentObject(workouts)
                        .environmentObject(progress)
                case 2:
                    ProgressView()
                        .environmentObject(progress)
                case 3:
                    ProfileView()
                        .environmentObject(userProfile)
                case 4:
                    SettingsView()
                        .environmentObject(workouts)
                        .environmentObject(userProfile)
                        .environmentObject(progress)
                default:
                    WorkoutsView()
                        .environmentObject(workouts)
                        .environmentObject(userProfile)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $appState.selectedTab)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
