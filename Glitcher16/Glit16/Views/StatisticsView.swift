import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var productViewModel: ProductViewModel
    
    private var statistics: ProductStatistics {
        ProductStatistics(from: productViewModel.products)
    }
    
    var body: some View {
        ZStack {
            AppColorScheme.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    headerView
                    
                    if productViewModel.products.isEmpty {
                        emptyStateView
                    } else {
                        statisticsContent
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Statistics")
                .font(.playfairDisplay(28, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Spacer()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
                .frame(height: 100)
            
            Image(systemName: "chart.bar.doc.horizontal")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            
            Text("No statistics available")
                .font(.playfairDisplay(24, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Text("Add products to see your collection statistics")
                .font(.playfairDisplay(16, weight: .regular))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var statisticsContent: some View {
        VStack(spacing: 20) {
            overviewSection
            
            categoriesSection
            
            ratingSection
            
            expirationSection
        }
    }
    
    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Overview")
                .font(.playfairDisplay(20, weight: .bold))
                .foregroundColor(.textPrimary)
            
            HStack(spacing: 15) {
                StatCardView(
                    title: "Total Products",
                    value: "\(statistics.totalProducts)",
                    icon: "cube.box.fill",
                    color: .primaryYellow
                )
                
                StatCardView(
                    title: "Categories",
                    value: "\(statistics.totalCategories)",
                    icon: "folder.fill",
                    color: .accentBlue
                )
            }
            
            HStack(spacing: 15) {
                StatCardView(
                    title: "Favorites",
                    value: "\(statistics.favoriteCount)",
                    icon: "star.fill",
                    color: .primaryYellow
                )
                
                StatCardView(
                    title: "Avg Rating",
                    value: String(format: "%.1f", statistics.averageRating),
                    icon: "star.circle.fill",
                    color: .accentGreen
                )
            }
        }
    }
    
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Top Categories")
                .font(.playfairDisplay(20, weight: .bold))
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 10) {
                ForEach(statistics.topCategories.prefix(5), id: \.name) { category in
                    CategoryStatRowView(category: category)
                }
            }
            .padding(16)
            .background(AppColorScheme.cardGradient)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
        }
    }
    
    private var ratingSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Rating Distribution")
                .font(.playfairDisplay(20, weight: .bold))
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 10) {
                ForEach(1...5, id: \.self) { rating in
                    RatingStatRowView(
                        rating: rating,
                        count: statistics.ratingDistribution[rating] ?? 0,
                        total: statistics.totalProducts
                    )
                }
            }
            .padding(16)
            .background(AppColorScheme.cardGradient)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
        }
    }
    
    private var expirationSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Expiration Status")
                .font(.playfairDisplay(20, weight: .bold))
                .foregroundColor(.textPrimary)
            
            HStack(spacing: 15) {
                StatCardView(
                    title: "Expired",
                    value: "\(statistics.expiredCount)",
                    icon: "exclamationmark.triangle.fill",
                    color: .red
                )
                
                StatCardView(
                    title: "Expiring Soon",
                    value: "\(statistics.expiringSoonCount)",
                    icon: "clock.fill",
                    color: .orange
                )
            }
        }
    }
}

struct ProductStatistics {
    let totalProducts: Int
    let totalCategories: Int
    let favoriteCount: Int
    let averageRating: Double
    let topCategories: [CategoryStat]
    let ratingDistribution: [Int: Int]
    let expiredCount: Int
    let expiringSoonCount: Int
    
    init(from products: [Product]) {
        self.totalProducts = products.count
        
        let categories = Set(products.map { $0.category })
        self.totalCategories = categories.count
        
        self.favoriteCount = products.filter { $0.rating >= 4 }.count
        
        if products.isEmpty {
            self.averageRating = 0.0
        } else {
            self.averageRating = Double(products.reduce(0) { $0 + $1.rating }) / Double(products.count)
        }
        
        var categoryCounts: [String: Int] = [:]
        for product in products {
            categoryCounts[product.category, default: 0] += 1
        }
        
        self.topCategories = categoryCounts.map { CategoryStat(name: $0.key, count: $0.value) }
            .sorted { $0.count > $1.count }
        
        var ratingDist: [Int: Int] = [:]
        for product in products {
            ratingDist[product.rating, default: 0] += 1
        }
        self.ratingDistribution = ratingDist
        
        self.expiredCount = products.filter { $0.isExpired }.count
        self.expiringSoonCount = products.filter { $0.isExpiringSoon && !$0.isExpired }.count
    }
}

struct CategoryStat {
    let name: String
    let count: Int
}

struct StatCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.playfairDisplay(24, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Text(title)
                .font(.playfairDisplay(12, weight: .regular))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(AppColorScheme.cardGradient)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
}

struct CategoryStatRowView: View {
    let category: CategoryStat
    
    var body: some View {
        HStack {
            Text(category.name)
                .font(.playfairDisplay(16, weight: .medium))
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Text("\(category.count)")
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(.primaryYellow)
        }
        .padding(.vertical, 4)
    }
}

struct RatingStatRowView: View {
    let rating: Int
    let count: Int
    let total: Int
    
    private var percentage: Double {
        total > 0 ? Double(count) / Double(total) : 0.0
    }
    
    var body: some View {
        HStack(spacing: 10) {
            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: star <= rating ? "star.fill" : "star")
                        .font(.system(size: 12))
                        .foregroundColor(star <= rating ? .primaryYellow : .textSecondary)
                }
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.cardBackground)
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(Color.primaryYellow)
                        .frame(width: geometry.size.width * percentage, height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
            
            Text("\(count)")
                .font(.playfairDisplay(14, weight: .medium))
                .foregroundColor(.textSecondary)
                .frame(width: 30, alignment: .trailing)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    StatisticsView()
        .environmentObject(ProductViewModel())
}
