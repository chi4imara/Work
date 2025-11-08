import SwiftUI

enum TabItem: String, CaseIterable {
    case today = "Today"
    case calendar = "Calendar"
    case archive = "Archive"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .today: return "house.fill"
        case .calendar: return "calendar"
        case .archive: return "archivebox.fill"
        case .settings: return "gearshape.fill"
        }
    }
    
    var title: String {
        return self.rawValue
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
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
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
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.primary)
                            .frame(width: 40, height: 40)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isSelected ? .white : AppColors.mediumGray)
                }
                
                Text(tab.title)
                    .font(.appCaption1)
                    .foregroundColor(isSelected ? AppColors.primary : AppColors.mediumGray)
            }
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
}

struct CustomTabView: View {
    @State private var selectedTab: TabItem = .today
    @StateObject private var taskManager = TaskManager()
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        ZStack {
            AppColors.universalGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .today:
                        TodayView()
                    case .calendar:
                        CalendarView()
                    case .archive:
                        ArchiveView()
                    case .settings:
                        SettingsView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .environmentObject(taskManager)
        .sheet(isPresented: .constant(!hasSeenOnboarding)) {
            OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
        }
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView()
    }
}
