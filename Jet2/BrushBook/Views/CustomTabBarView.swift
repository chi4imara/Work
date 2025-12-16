import SwiftUI

enum TabItem: String, CaseIterable {
    case tools = "Tools"
    case schedule = "Schedule"
    case notes = "Notes"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var iconName: String {
        switch self {
        case .tools: return "paintbrush.pointed.fill"
        case .schedule: return "calendar"
        case .notes: return "note.text"
        case .statistics: return "chart.bar.fill"
        case .settings: return "gearshape.fill"
        }
    }
    
    var title: String {
        return self.rawValue
    }
}

struct CustomTabBarView: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    selectedTab = tab
                }
            }
        }
        .frame(height: 80)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(ColorManager.cardGradient)
                .shadow(color: ColorManager.cardShadow, radius: 15, x: 0, y: -5)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
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
                            .fill(ColorManager.primaryButton)
                            .frame(width: 40, height: 40)
                            .shadow(color: ColorManager.primaryText.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    
                    Image(systemName: tab.iconName)
                        .font(.system(size: isSelected ? 18 : 16, weight: .medium))
                        .foregroundColor(isSelected ? .white : ColorManager.primaryText.opacity(0.6))
                }
                
                Text(tab.title)
                    .font(.playfairDisplay(10, weight: .medium))
                    .foregroundColor(isSelected ? ColorManager.primaryText : ColorManager.primaryText.opacity(0.6))
            }
        }
        .frame(maxWidth: .infinity)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct MainTabView: View {
    @State private var selectedTab: TabItem = .tools
    @StateObject private var toolsViewModel = ToolsViewModel()
    @StateObject private var notesViewModel = NotesViewModel()
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case .tools:
                    ToolsListView()
                        .environmentObject(toolsViewModel)
                case .schedule:
                    ScheduleCheckView()
                        .environmentObject(toolsViewModel)
                case .notes:
                    NotesListView()
                        .environmentObject(notesViewModel)
                case .statistics:
                    StatisticsView()
                        .environmentObject(toolsViewModel)
                        .environmentObject(notesViewModel)
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBarView(selectedTab: $selectedTab)
            }
        }
    }
}

