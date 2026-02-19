import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var brandStore: BrandStore
    
    private var totalBrands: Int {
        brandStore.brands.count
    }
    
    private var averageRating: Double {
        guard !brandStore.brands.isEmpty else { return 0 }
        let sum = brandStore.brands.reduce(0) { $0 + $1.rating }
        return Double(sum) / Double(brandStore.brands.count)
    }
    
    private var favoriteBrandsCount: Int {
        brandStore.brands.filter { $0.rating == 5 }.count
    }
    
    private var categoryDistribution: [(category: BrandCategory, count: Int, percentage: Double)] {
        let total = Double(totalBrands)
        guard total > 0 else { return [] }
        
        return brandStore.categoriesWithCounts.map { item in
            let percentage = (Double(item.count) / total) * 100
            return (category: item.category, count: item.count, percentage: percentage)
        }.sorted { $0.count > $1.count }
    }
    
    private var topRatedBrands: [Brand] {
        brandStore.brands.sorted { $0.rating > $1.rating }
            .prefix(5)
            .map { $0 }
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Statistics")
                        .font(.bauhaus(28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if brandStore.brands.isEmpty {
                    EmptyStatisticsView()
                } else {
                    ScrollView {
                        VStack(spacing: 25) {
                            OverviewCardsView(
                                totalBrands: totalBrands,
                                averageRating: averageRating,
                                favoriteBrandsCount: favoriteBrandsCount
                            )
                            
                            CategoryDistributionView(distribution: categoryDistribution)
                            
                            TopRatedBrandsView(brands: topRatedBrands, brandStore: brandStore)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
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
                .foregroundColor(AppColors.secondaryText)
            
            Text("No statistics available")
                .font(.bauhaus(24, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Text("Add brands to see statistics")
                .font(.bauhaus(16, weight: .medium))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding()
    }
}

struct OverviewCardsView: View {
    let totalBrands: Int
    let averageRating: Double
    let favoriteBrandsCount: Int
    
    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                StatCardView(
                    icon: "square.stack.3d.up",
                    title: "Total Brands",
                    value: "\(totalBrands)",
                    color: AppColors.accentBlue
                )
                
                StatCardView(
                    icon: "star.fill",
                    title: "Average Rating",
                    value: String(format: "%.1f", averageRating),
                    color: AppColors.primaryYellow
                )
            }
            
            StatCardView(
                icon: "heart.fill",
                title: "Favorites",
                value: "\(favoriteBrandsCount)",
                color: AppColors.primaryPink,
                fullWidth: true
            )
        }
    }
}

struct StatCardView: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    var fullWidth: Bool = false
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
            
            Text(value)
                .font(.bauhaus(32, weight: .bold))
                .foregroundColor(AppColors.darkGray)
            
            Text(title)
                .font(.bauhaus(14, weight: .medium))
                .foregroundColor(AppColors.darkGray.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 140)
        .padding()
        .background(AppColors.cardGradient)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct CategoryDistributionView: View {
    let distribution: [(category: BrandCategory, count: Int, percentage: Double)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Category Distribution")
                .font(.bauhaus(20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                ForEach(distribution, id: \.category) { item in
                    CategoryStatRowView(
                        category: item.category,
                        count: item.count,
                        percentage: item.percentage
                    )
                }
            }
            .padding()
            .background(AppColors.cardGradient)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

struct CategoryStatRowView: View {
    let category: BrandCategory
    let count: Int
    let percentage: Double
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(category.displayName)
                    .font(.bauhaus(16, weight: .medium))
                    .foregroundColor(AppColors.darkGray)
                
                Spacer()
                
                Text("\(count) (\(String(format: "%.0f", percentage))%)")
                    .font(.bauhaus(14, weight: .medium))
                    .foregroundColor(AppColors.darkGray.opacity(0.7))
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(AppColors.softGray)
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(AppColors.primaryYellow)
                        .frame(width: geometry.size.width * CGFloat(percentage / 100), height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
    }
}

struct TopRatedBrandsView: View {
    let brands: [Brand]
    let brandStore: BrandStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Top Rated Brands")
                .font(.bauhaus(20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 10) {
                ForEach(Array(brands.enumerated()), id: \.element.id) { index, brand in
                    NavigationLink(destination: BrandDetailView(brandId: brand.id, brandStore: brandStore)) {
                        TopBrandRowView(brand: brand, rank: index + 1)
                    }
                }
            }
            .padding()
            .background(AppColors.cardGradient)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

struct TopBrandRowView: View {
    let brand: Brand
    let rank: Int
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(rankColor.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Text("\(rank)")
                    .font(.bauhaus(16, weight: .bold))
                    .foregroundColor(rankColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(brand.name)
                    .font(.bauhaus(18, weight: .bold))
                    .foregroundColor(AppColors.darkGray)
                
                Text(brand.category.displayName)
                    .font(.bauhaus(12, weight: .medium))
                    .foregroundColor(AppColors.darkGray.opacity(0.6))
            }
            
            Spacer()
            
            StarRatingView(rating: brand.rating, interactive: false, color: AppColors.primaryYellow, size: 16)
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(AppColors.darkGray.opacity(0.4))
        }
        .padding(.vertical, 8)
    }
    
    private var rankColor: Color {
        switch rank {
        case 1: return AppColors.primaryYellow
        case 2: return AppColors.accentBlue
        case 3: return AppColors.primaryPink
        default: return AppColors.darkGray
        }
    }
}

#Preview {
    StatisticsView()
}
