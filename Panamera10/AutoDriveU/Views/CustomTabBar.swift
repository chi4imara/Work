import SwiftUI

enum TabItem: String, CaseIterable {
    case modifications = "Mods"
    case categories = "Categories" 
    case budget = "Budget"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .modifications:
            return "wrench.and.screwdriver"
        case .categories:
            return "folder"
        case .budget:
            return "dollarsign.circle"
        case .statistics:
            return "chart.bar.fill"
        case .settings:
            return "gear"
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
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(AppColors.primaryDarkBlue)
                .shadow(color: AppColors.primaryDarkBlue.opacity(0.3), radius: 10, x: 0, y: 5)
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
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(AppColors.primaryOrange)
                            .frame(width: 40, height: 40)
                            .scaleEffect(isPressed ? 0.9 : 1.0)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: isSelected ? 20 : 18, weight: .medium))
                        .foregroundColor(isSelected ? AppColors.primaryWhite : AppColors.primaryWhite.opacity(0.6))
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                }
                
                Text(tab.title)
                    .font(FontManager.caption2)
                    .foregroundColor(isSelected ? AppColors.primaryWhite : AppColors.primaryWhite.opacity(0.6))
                    .scaleEffect(isPressed ? 0.9 : 1.0)
            }
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct MainTabView: View {
    @StateObject private var modificationViewModel = ModificationViewModel()
    @State private var selectedTab: TabItem = .modifications
    @State private var showSplash = true
    @State private var showOnboarding = UserDefaults.standard.bool(forKey: "HasSeenOnboarding")
    
    var body: some View {
        ZStack {
            if !showOnboarding {
                OnboardingView(isPresented: $showOnboarding)
                    .environmentObject(modificationViewModel)
            } else {
                NavigationStack {
                    ZStack {
                        AnimatedBackground()
                            .ignoresSafeArea()
                        
                        Group {
                            switch selectedTab {
                            case .modifications:
                                ModificationListView()
                            case .categories:
                                CategoriesView()
                            case .budget:
                                BudgetView()
                            case .statistics:
                                StatisticsView()
                            case .settings:
                                SettingsView()
                            }
                        }
                        .environmentObject(modificationViewModel)
                        
                        VStack(spacing: 0) {
                            Spacer()
                            
                            CustomTabBar(selectedTab: $selectedTab)
                        }
                    }
                    .navigationBarHidden(true)
                }
            }
        }
        .onAppear {
            modificationViewModel.loadModifications()
        }
    }
}

#Preview {
    MainTabView()
}
