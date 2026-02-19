import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        TabItem(title: "Home", icon: "house.fill", tag: 0),
        TabItem(title: "Collection", icon: "heart.fill", tag: 1),
        TabItem(title: "Progress", icon: "chart.bar.fill", tag: 2),
        TabItem(title: "Profile", icon: "person.fill", tag: 3),
        TabItem(title: "Settings", icon: "gearshape.fill", tag: 4)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.tag) { tab in
                TabBarButton(
                    title: tab.title,
                    icon: tab.icon,
                    isSelected: selectedTab == tab.tag
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab.tag
                    }
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(ColorTheme.backgroundWhite)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 10, x: 0, y: -5)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(ColorTheme.primaryBlue.opacity(0.1), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabBarButton: View {
    let title: String
    let icon: String
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
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isSelected ? ColorTheme.whiteText : ColorTheme.primaryText)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                }
                
                Text(title)
                    .font(.playfairDisplay(10, weight: .medium))
                    .foregroundColor(isSelected ? ColorTheme.primaryText : ColorTheme.secondaryText)
                    .scaleEffect(isSelected ? 1.0 : 0.9)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct TabItem {
    let title: String
    let icon: String
    let tag: Int
}

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            GridPatternView()
                .ignoresSafeArea()
            
                Group {
                    switch appState.selectedTab {
                    case 0:
                        HomeView()
                    case 1:
                        CollectionView()
                    case 2:
                        ProgressView()
                    case 3:
                        ProfileView()
                    case 4:
                        SettingsView()
                    default:
                        HomeView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $appState.selectedTab)
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState())
}
