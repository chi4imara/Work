import SwiftUI

struct TabItem {
    let title: String
    let icon: String
    let selectedIcon: String
    let tag: Int
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        TabItem(title: "Wishlist", icon: "heart", selectedIcon: "heart.fill", tag: 0),
        TabItem(title: "Analysis", icon: "chart.bar", selectedIcon: "chart.bar.fill", tag: 1),
        TabItem(title: "Summary", icon: "doc.text", selectedIcon: "doc.text.fill", tag: 2),
        TabItem(title: "Add", icon: "plus.circle", selectedIcon: "plus.circle.fill", tag: 3),
        TabItem(title: "Settings", icon: "gearshape", selectedIcon: "gearshape.fill", tag: 4)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.tag) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab.tag
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab.tag
                    }
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.primaryPurple.opacity(0.15), radius: 8, x: 0, y: -2)
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
                            .fill(AppColors.purpleGradient)
                            .frame(width: 40, height: 40)
                            .scaleEffect(isSelected ? 1.0 : 0.8)
                    }
                    
                    Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                        .font(.system(size: isSelected ? 20 : 18, weight: .medium))
                        .foregroundColor(isSelected ? .white : AppColors.neutralGray)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                }
                .frame(height: 40)
                
                Text(tab.title)
                    .font(AppTypography.tabBarTitle)
                    .foregroundColor(isSelected ? AppColors.primaryPurple : AppColors.neutralGray)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
        }
        .frame(maxWidth: .infinity)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct MainTabView: View {
    @StateObject private var itemsViewModel = ItemsViewModel()
    @StateObject private var appState = AppStateViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            TabView(selection: $appState.selectedTab) {
                WishlistView()
                    .environmentObject(itemsViewModel)
                    .tag(0)
                
                AnalysisView()
                    .environmentObject(itemsViewModel)
                    .tag(1)
                
                SummaryView()
                    .environmentObject(itemsViewModel)
                    .tag(2)
                
                AddItemView()
                    .environmentObject(itemsViewModel)
                    .environmentObject(appState)
                    .tag(3)
                
                SettingsView()
                    .tag(4)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            CustomTabBar(selectedTab: $appState.selectedTab)
        }
    }
}

struct WishlistView: View {
    @EnvironmentObject var itemsViewModel: ItemsViewModel
    
    var body: some View {
        VStack {
            Text("Wishlist View")
                .font(AppTypography.title1)
                .foregroundColor(AppColors.primaryPurple)
            
            Text("Items: \(itemsViewModel.items.count)")
                .font(AppTypography.body)
                .foregroundColor(AppColors.darkGray)
        }
    }
}

struct AnalysisView: View {
    @EnvironmentObject var itemsViewModel: ItemsViewModel
    
    var body: some View {
        VStack {
            Text("Analysis View")
                .font(AppTypography.title1)
                .foregroundColor(AppColors.primaryPurple)
            
            Text("Monthly Analysis")
                .font(AppTypography.body)
                .foregroundColor(AppColors.darkGray)
        }
    }
}

struct SummaryView: View {
    @EnvironmentObject var itemsViewModel: ItemsViewModel
    
    var body: some View {
        VStack {
            Text("Summary View")
                .font(AppTypography.title1)
                .foregroundColor(AppColors.primaryPurple)
            
            Text("Monthly Summary")
                .font(AppTypography.body)
                .foregroundColor(AppColors.darkGray)
        }
    }
}

struct AddItemView: View {
    @EnvironmentObject var itemsViewModel: ItemsViewModel
    @EnvironmentObject var appState: AppStateViewModel
    
    var body: some View {
        VStack {
            Text("Add Item View")
                .font(AppTypography.title1)
                .foregroundColor(AppColors.primaryPurple)
            
            Button("Add Sample Item") {
                let newItem = Item(
                    name: "Sample Item",
                    estimatedPrice: 50,
                    priority: .medium,
                    comment: "Sample comment"
                )
                itemsViewModel.addItem(newItem)
                appState.selectTab(0)
            }
            .primaryButtonStyle()
        }
        .padding()
    }
}

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Settings View")
                .font(AppTypography.title1)
                .foregroundColor(AppColors.primaryPurple)
            
            Text("App Settings")
                .font(AppTypography.body)
                .foregroundColor(AppColors.darkGray)
        }
    }
}

#Preview {
    MainTabView()
}
