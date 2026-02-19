import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    let tabs = [
        TabItem(icon: "house.fill", title: "Today", index: 0),
        TabItem(icon: "book.fill", title: "Diary", index: 1),
        TabItem(icon: "chart.bar.fill", title: "Statistics", index: 2),
        TabItem(icon: "heart.fill", title: "Favorites", index: 3),
        TabItem(icon: "gearshape.fill", title: "Settings", index: 4)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.index) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab.index,
                    action: { selectedTab = tab.index }
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            LinearGradient(
                colors: [
                    ColorTheme.cardBackground,
                    Color.white.opacity(0.9)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .overlay(
            Rectangle()
                .fill(ColorTheme.gridBlue)
                .frame(height: 1),
            alignment: .top
        )
        .shadow(color: ColorTheme.cardShadow, radius: 20, x: 0, y: -5)
    }
}

struct TabItem {
    let icon: String
    let title: String
    let index: Int
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
            
            withAnimation(.easeInOut(duration: 0.3)) {
                action()
            }
        }) {
            VStack(spacing: 6) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(tabColor.opacity(0.2))
                            .frame(width: 40, height: 40)
                            .scaleEffect(isPressed ? 0.9 : 1.0)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: isSelected ? 20 : 18, weight: isSelected ? .semibold : .medium))
                        .foregroundColor(isSelected ? tabColor : ColorTheme.secondaryText)
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                }
                .frame(height: 40)
                
                Text(tab.title)
                    .font(.ubuntuCaption())
                    .foregroundColor(isSelected ? tabColor : ColorTheme.secondaryText)
                    .scaleEffect(isSelected ? 1.0 : 0.9)
                
                if isSelected {
                    Circle()
                        .fill(tabColor)
                        .frame(width: 4, height: 4)
                        .transition(.scale.combined(with: .opacity))
                } else {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 4, height: 4)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var tabColor: Color {
        switch tab.index {
        case 0: return ColorTheme.primaryBlue
        case 1: return ColorTheme.lightGreen
        case 2: return ColorTheme.lavender
        case 3: return ColorTheme.softPink
        case 4: return ColorTheme.primaryYellow
        default: return ColorTheme.primaryBlue
        }
    }
}

struct MainTabView: View {
    @StateObject private var appState = AppStateViewModel()
    @StateObject private var diaryViewModel = DiaryViewModel()
    
    var body: some View {
        ZStack {
            Group {
                switch appState.selectedTab {
                case 0:
                    TodayView()
                case 1:
                    DiaryView()
                case 2:
                    StatisticsView()
                case 3:
                    FavoritesView()
                case 4:
                    SettingsView()
                default:
                    TodayView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .environmentObject(diaryViewModel)
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $appState.selectedTab)
            }
        }
    }
}

#Preview {
    MainTabView()
}
