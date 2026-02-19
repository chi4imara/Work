import SwiftUI

struct CustomTabBar: View {
    @ObservedObject var tabViewModel: TabViewModel
    @Namespace private var tabAnimation
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: tabViewModel.selectedTab == tab,
                    namespace: tabAnimation
                ) {
                    tabViewModel.selectTab(tab)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.cardBackground)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -2)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let namespace: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.theme.accentGradient)
                            .frame(width: 32, height: 32)
                            .matchedGeometryEffect(id: "selectedTab", in: namespace)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isSelected ? Color.theme.primaryText : Color.theme.mediumGray)
                }
                
                Text(tab.rawValue)
                    .font(.playfairDisplay(size: 10, weight: .medium))
                    .foregroundColor(isSelected ? Color.theme.accentText : Color.theme.mediumGray)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isSelected)
    }
}

struct MainTabView: View {
    @StateObject private var tabViewModel = TabViewModel()
    @ObservedObject var gadgetViewModel: GadgetViewModel
    @StateObject private var settingsViewModel = SettingsViewModel()
    
    var body: some View {
        ZStack {
            Color.theme.primaryGradient
                .ignoresSafeArea()
            
            Group {
                switch tabViewModel.selectedTab {
                case .add:
                    AddGadgetView(gadgetViewModel: gadgetViewModel)
                case .catalog:
                    CatalogView(gadgetViewModel: gadgetViewModel)
                case .categories:
                    CategoriesView(gadgetViewModel: gadgetViewModel)
                case .settings:
                    SettingsView(settingsViewModel: settingsViewModel)
                case .statistics:
                    StatisticsView(gadgetViewModel: gadgetViewModel)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Spacer()
                CustomTabBar(tabViewModel: tabViewModel)
            }
        }
    }
}


#Preview {
    MainTabView(gadgetViewModel: GadgetViewModel())
}
