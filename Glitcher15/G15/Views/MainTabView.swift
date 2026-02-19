import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel: ItemsViewModel = ItemsViewModel()
    @State private var selectedTab: TabItem = .items
    @State private var showingAddItem = false
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case .items:
                    ItemsListView(viewModel: viewModel)
                case .categories:
                    CategoriesView(viewModel: viewModel)
                case .add:
                    AddItemView(viewModel: viewModel, selectedTab: $selectedTab)
                case .settings:
                    SettingsView()
                case .statistics:
                    StatisticsView(viewModel: viewModel)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

struct StatisticsView: View {
    @ObservedObject var viewModel: ItemsViewModel

    private var totalItems: Int {
        viewModel.itemSets.reduce(0) { $0 + $1.items.count }
    }
    
    private var totalCategories: Int {
        viewModel.getItemsByCategory().keys.count
    }
    
    private var itemsInBag: Int {
        viewModel.itemSets.flatMap { $0.items }.filter { $0.isInBag }.count
    }
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    VStack(spacing: 16) {
                        Circle()
                            .fill(AppColors.cardGradient)
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "chart.bar.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(AppColors.yellow)
                            )
                        
                        Text("Statistics")
                            .font(FontManager.playfairBold(size: 24))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("Track your items and progress")
                            .font(FontManager.playfairRegular(size: 16))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    VStack(spacing: 16) {
                        StatisticsCard(
                            icon: "bag.fill",
                            title: "Total Items",
                            value: "\(totalItems)",
                            color: AppColors.yellow
                        )
                        
                        StatisticsCard(
                            icon: "folder.fill",
                            title: "Categories",
                            value: "\(totalCategories)",
                            color: AppColors.yellow
                        )
                        
                        StatisticsCard(
                            icon: "list.bullet",
                            title: "Item Sets",
                            value: "\(viewModel.itemSets.count)",
                            color: AppColors.purple
                        )
                        
                        StatisticsCard(
                            icon: "checkmark.circle.fill",
                            title: "Items in Bag",
                            value: "\(itemsInBag)",
                            color: AppColors.success
                        )
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                .padding(.bottom, 120)
            }
        }
    }
}

struct StatisticsCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(color.opacity(0.2))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(FontManager.playfairMedium(size: 16))
                    .foregroundColor(AppColors.primaryText)
                
                Text(value)
                    .font(FontManager.playfairBold(size: 20))
                    .foregroundColor(color)
            }
            
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}
