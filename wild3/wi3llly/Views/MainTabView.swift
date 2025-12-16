import SwiftUI

enum TabItem: CaseIterable {
    case dreams
    case addDream
    case tags
    case statistics
    case settings
    
    var title: String {
        switch self {
        case .dreams:
            return "Dreams"
        case .addDream:
            return "Add"
        case .tags:
            return "Tags"
        case .statistics:
            return "Stats"
        case .settings:
            return "Settings"
        }
    }
    
    var iconName: String {
        switch self {
        case .dreams:
            return "book.fill"
        case .addDream:
            return "plus.circle.fill"
        case .tags:
            return "tag.fill"
        case .statistics:
            return "chart.bar.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab: TabItem = .dreams
    @State private var showingSplash = true
    @StateObject private var navigationState = NavigationState.shared
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            Group {
                switch selectedTab {
                case .dreams:
                    DreamListView(selectedTab: $selectedTab)
                case .addDream:
                    NewDreamView(selectedTab: $selectedTab)
                case .tags:
                    TagsView()
                case .statistics:
                    StatisticsView()
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
                    .padding(.bottom, 10)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showingSplash = false
                }
            }
        }
        .onChange(of: navigationState.shouldNavigateToDreams) { shouldNavigate in
            if shouldNavigate {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedTab = .dreams
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    navigationState.shouldNavigateToDreams = false
                }
            }
        }
    }
}

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
                .fill(Color.white.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.app.cardBorder, lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.iconName)
                    .font(.system(size: isSelected ? 24 : 20, weight: .medium))
                    .foregroundColor(isSelected ? Color.app.primaryPurple : Color.app.textSecondary)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(tab.title)
                    .font(.builderSans(.medium, size: 10))
                    .foregroundColor(isSelected ? Color.app.primaryPurple : Color.app.textTertiary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.app.primaryPurple.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MainTabView()
}
