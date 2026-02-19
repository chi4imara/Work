import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: RecipeViewModel
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        Text("Statistics")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    VStack(spacing: 16) {
                        StatisticCardView(
                            title: "Total Recipes",
                            value: "\(viewModel.recipes.count)",
                            icon: "flask.fill",
                            color: ColorManager.accent
                        )
                        
                        StatisticCardView(
                            title: "Favorite Recipes",
                            value: "\(viewModel.favoriteRecipes.count)",
                            icon: "heart.fill",
                            color: ColorManager.yellow
                        )
                        
                        StatisticCardView(
                            title: "Categories",
                            value: "\(viewModel.categoriesWithCount.count)",
                            icon: "folder.fill",
                            color: ColorManager.green
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    if !viewModel.categoriesWithCount.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Recipes by Category")
                                .font(.ubuntu(20, weight: .medium))
                                .foregroundColor(ColorManager.primaryText)
                                .padding(.horizontal, 20)
                            
                            ForEach(viewModel.categoriesWithCount, id: \.category.id) { categoryData in
                                CategoryStatisticView(
                                    category: categoryData.category,
                                    count: categoryData.count,
                                    total: viewModel.recipes.count
                                )
                            }
                        }
                        .padding(.top, 20)
                    }
                }
                .padding(.bottom, 10)
            }
        }
    }
}

struct StatisticCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.ubuntu(32, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text(title)
                    .font(.ubuntu(14))
                    .foregroundColor(ColorManager.secondaryText)
            }
            
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.cardGradient)
        )
    }
}

struct CategoryStatisticView: View {
    let category: RecipeCategory
    let count: Int
    let total: Int
    
    private var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(count) / Double(total) * 100
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(category.displayName)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                
                Spacer()
                
                Text("\(count)")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(ColorManager.accent)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(ColorManager.divider)
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(ColorManager.accent)
                        .frame(width: geometry.size.width * CGFloat(percentage / 100), height: 8)
                }
            }
            .frame(height: 8)
            
            Text(String(format: "%.1f%%", percentage))
                .font(.ubuntu(12))
                .foregroundColor(ColorManager.secondaryText)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorManager.cardGradient)
        )
        .padding(.horizontal, 20)
    }
}

#Preview {
    StatisticsView(viewModel: RecipeViewModel())
}
