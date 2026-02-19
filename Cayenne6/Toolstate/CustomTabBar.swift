import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    let tabs = [
        TabItem(icon: "house", title: "Garage", tag: 0),
        TabItem(icon: "location", title: "Locations", tag: 1),
        TabItem(icon: "plus.circle.fill", title: "Add", tag: 2),
        TabItem(icon: "magnifyingglass", title: "Search", tag: 3),
        TabItem(icon: "gearshape", title: "Settings", tag: 4)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.tag) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab.tag,
                    action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedTab = tab.tag
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(AppColors.surfaceBackground)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: -2)
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
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [AppColors.lightBlue, AppColors.orange]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 40, height: 40)
                            .scaleEffect(isSelected ? 1.0 : 0.8)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: tab.tag == 2 ? 24 : 20, weight: isSelected ? .semibold : .medium))
                        .foregroundColor(isSelected ? AppColors.white : AppColors.secondaryText)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                }
                
                Text(tab.title)
                    .font(.ubuntu(10, weight: isSelected ? .medium : .regular))
                    .foregroundColor(isSelected ? AppColors.lightBlue : AppColors.secondaryText)
            }
        }
        .frame(maxWidth: .infinity)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct TabItem {
    let icon: String
    let title: String
    let tag: Int
}

struct MainTabView: View {
    @StateObject private var garageViewModel = GarageViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    @State private var selectedTab = 0
    @State private var showingAddItem = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            Group {
                switch selectedTab {
                case 0:
                    GarageView(viewModel: garageViewModel, selectedTab: $selectedTab)
                case 1:
                    LocationsView(viewModel: garageViewModel, selectedTab: $selectedTab)
                case 2:
                    AddItemView(viewModel: garageViewModel, selectedTab: $selectedTab)
                case 3:
                    SearchView(viewModel: garageViewModel)
                case 4:
                    SettingsView(viewModel: settingsViewModel)
                default:
                    GarageView(viewModel: garageViewModel, selectedTab: $selectedTab)
                }
            }
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}
