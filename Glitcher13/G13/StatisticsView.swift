import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: ProductViewModel
    
    private var totalProducts: Int {
        viewModel.products.count
    }
    
    private var favoriteCount: Int {
        viewModel.favoriteProducts.count
    }
    
    private var likedCount: Int {
        viewModel.products.filter { $0.result == .liked }.count
    }
    
    private var neutralCount: Int {
        viewModel.products.filter { $0.result == .neutral }.count
    }
    
    private var dislikedCount: Int {
        viewModel.products.filter { $0.result == .disliked }.count
    }
    
    private var categoryStats: [(ProductCategory, Int)] {
        ProductCategory.allCases.map { category in
            (category, viewModel.products(for: category).count)
        }.filter { $0.1 > 0 }
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Statistics")
                        .font(.playfair(28, weight: .bold))
                        .foregroundColor(AppColors.blueText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if totalProducts == 0 {
                    EmptyStatisticsView()
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            OverviewCardsView(
                                totalProducts: totalProducts,
                                favoriteCount: favoriteCount,
                                likedCount: likedCount,
                                neutralCount: neutralCount,
                                dislikedCount: dislikedCount
                            )
                            
                            ResultDistributionView(
                                likedCount: likedCount,
                                neutralCount: neutralCount,
                                dislikedCount: dislikedCount,
                                totalProducts: totalProducts
                            )
                            
                            CategoryStatsView(categoryStats: categoryStats)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
    }
}

struct EmptyStatisticsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "chart.bar")
                .font(.system(size: 60))
                .foregroundColor(AppColors.mediumGray)
            
            Text("No statistics available yet.")
                .font(.playfair(18, weight: .medium))
                .foregroundColor(AppColors.darkGray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Text("Add some products to see your statistics.")
                .font(.playfair(14, weight: .regular))
                .foregroundColor(AppColors.mediumGray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct OverviewCardsView: View {
    let totalProducts: Int
    let favoriteCount: Int
    let likedCount: Int
    let neutralCount: Int
    let dislikedCount: Int
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                StatCardView(
                    title: "Total Products",
                    value: "\(totalProducts)",
                    icon: "flask.fill",
                    color: AppColors.blueText
                )
                
                StatCardView(
                    title: "Favorites",
                    value: "\(favoriteCount)",
                    icon: "heart.fill",
                    color: AppColors.pink
                )
            }
            
            HStack(spacing: 12) {
                StatCardView(
                    title: "Liked",
                    value: "\(likedCount)",
                    icon: "hand.thumbsup.fill",
                    color: AppColors.green
                )
                
                StatCardView(
                    title: "Neutral",
                    value: "\(neutralCount)",
                    icon: "minus.circle.fill",
                    color: AppColors.mediumBlue
                )
            }
            
            StatCardView(
                title: "Disliked",
                value: "\(dislikedCount)",
                icon: "hand.thumbsdown.fill",
                color: AppColors.red,
                fullWidth: true
            )
        }
    }
}

struct StatCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    var fullWidth: Bool = false
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(color)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.playfair(24, weight: .bold))
                    .foregroundColor(AppColors.blueText)
                
                Text(title)
                    .font(.playfair(12, weight: .medium))
                    .foregroundColor(AppColors.darkGray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
        )
        .frame(maxWidth: fullWidth ? .infinity : nil)
    }
}

struct ResultDistributionView: View {
    let likedCount: Int
    let neutralCount: Int
    let dislikedCount: Int
    let totalProducts: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Result Distribution")
                .font(.playfair(20, weight: .bold))
                .foregroundColor(AppColors.blueText)
            
            VStack(spacing: 12) {
                DistributionBarView(
                    label: "Liked",
                    count: likedCount,
                    total: totalProducts,
                    color: AppColors.green
                )
                
                DistributionBarView(
                    label: "Neutral",
                    count: neutralCount,
                    total: totalProducts,
                    color: AppColors.mediumBlue
                )
                
                DistributionBarView(
                    label: "Disliked",
                    count: dislikedCount,
                    total: totalProducts,
                    color: AppColors.red
                )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
        )
    }
}

struct DistributionBarView: View {
    let label: String
    let count: Int
    let total: Int
    let color: Color
    
    private var percentage: CGFloat {
        total > 0 ? CGFloat(count) / CGFloat(total) : 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.playfair(14, weight: .semibold))
                    .foregroundColor(AppColors.blueText)
                
                Spacer()
                
                Text("\(count) (\(Int(percentage * 100))%)")
                    .font(.playfair(12, weight: .medium))
                    .foregroundColor(AppColors.darkGray)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.softGray.opacity(0.3))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geometry.size.width * percentage, height: 8)
                }
            }
            .frame(height: 8)
        }
    }
}

struct CategoryStatsView: View {
    let categoryStats: [(ProductCategory, Int)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("By Category")
                .font(.playfair(20, weight: .bold))
                .foregroundColor(AppColors.blueText)
            
            VStack(spacing: 12) {
                ForEach(categoryStats, id: \.0) { category, count in
                    CategoryStatRowView(category: category, count: count)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
        )
    }
}

struct CategoryStatRowView: View {
    let category: ProductCategory
    let count: Int
    
    private var categoryColor: Color {
        switch category {
        case .skincare:
            return AppColors.green
        case .makeup:
            return AppColors.yellow
        case .cleansing:
            return AppColors.mediumBlue
        case .fragrance:
            return AppColors.purple
        case .other:
            return AppColors.mediumGray
        }
    }
    
    private var categoryIcon: String {
        switch category {
        case .skincare:
            return "drop.fill"
        case .makeup:
            return "paintbrush.fill"
        case .cleansing:
            return "bubbles.and.sparkles.fill"
        case .fragrance:
            return "aqi.medium"
        case .other:
            return "ellipsis.circle.fill"
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(categoryColor.opacity(0.2))
                    .frame(width: 36, height: 36)
                
                Image(systemName: categoryIcon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(categoryColor)
            }
            
            Text(category.displayName)
                .font(.playfair(16, weight: .medium))
                .foregroundColor(AppColors.blueText)
            
            Spacer()
            
            Text("\(count)")
                .font(.playfair(16, weight: .bold))
                .foregroundColor(AppColors.blueText)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationView {
        StatisticsView(viewModel: ProductViewModel())
    }
}

