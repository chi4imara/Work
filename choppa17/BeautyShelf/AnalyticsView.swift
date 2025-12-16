import SwiftUI
import Charts

struct AnalyticsView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    private var categoryData: [CategoryData] {
        let categories = ProductCategory.allCases
        return categories.compactMap { category in
            let count = appViewModel.allProducts.filter { $0.category == category }.count
            return count > 0 ? CategoryData(category: category, count: count) : nil
        }
    }
    
    private var expirationData: [ExpirationData] {
        let now = Date()
        let calendar = Calendar.current
        
        let expired = appViewModel.allProducts.filter { $0.isExpired }.count
        let expiringSoon = appViewModel.allProducts.filter { $0.isExpiringSoon && !$0.isExpired }.count
        let valid = appViewModel.allProducts.filter { !$0.isExpiringSoon }.count
        
        return [
            ExpirationData(status: "Expired", count: expired, color: .red),
            ExpirationData(status: "Expiring Soon", count: expiringSoon, color: .orange),
            ExpirationData(status: "Valid", count: valid, color: .green)
        ].filter { $0.count > 0 }
    }
    
    private var storageData: [StorageData] {
        return appViewModel.storageLocations.map { location in
            StorageData(location: location.name, count: location.productCount)
        }.filter { $0.count > 0 }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text("Analytics")
                                .font(.ubuntu(28, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            Text("Insights about your beauty collection")
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(AppColors.secondaryText)
                        }
                        .padding(.top, 20)
                        
                        OverviewStatsView()
                            .environmentObject(appViewModel)
                        
                        if !appViewModel.allProducts.isEmpty {
                            RecommendationsView()
                                .environmentObject(appViewModel)
                        }
                        
                        if !appViewModel.allProducts.isEmpty {
                            VStack(spacing: 20) {
                                if !categoryData.isEmpty {
                                    AnalyticsCard(title: "Products by Category") {
                                        CategoryChartView(data: categoryData)
                                    }
                                }
                                
                                if !expirationData.isEmpty {
                                    AnalyticsCard(title: "Expiration Status") {
                                        ExpirationChartView(data: expirationData)
                                    }
                                }
                                
                                if !storageData.isEmpty {
                                    AnalyticsCard(title: "Products by Storage") {
                                        StorageChartView(data: storageData)
                                    }
                                }
                                
                                if !appViewModel.brandStatistics.isEmpty {
                                    AnalyticsCard(title: "Top Brands") {
                                        BrandChartView(brands: appViewModel.brandStatistics.prefix(10).map { $0 })
                                    }
                                }
                                
                                RecentActivityView()
                                    .environmentObject(appViewModel)
                            }
                        } else {
                            EmptyAnalyticsView()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
        }
    }
}

struct OverviewStatsView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    private var totalProducts: Int {
        appViewModel.allProducts.count
    }
    
    private var totalLocations: Int {
        appViewModel.storageLocations.count
    }
    
    private var expiringSoonCount: Int {
        appViewModel.allProducts.filter { $0.isExpiringSoon }.count
    }
    
    private var mostUsedCategory: String {
        let categoryGroups = Dictionary(grouping: appViewModel.allProducts) { $0.category }
        let mostUsed = categoryGroups.max { $0.value.count < $1.value.count }
        return mostUsed?.key.displayName ?? "None"
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Overview")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                StatCard(
                    title: "Total Products",
                    value: "\(totalProducts)",
                    icon: "heart.fill",
                    color: AppColors.primaryYellow
                )
                
                StatCard(
                    title: "Storage Places",
                    value: "\(totalLocations)",
                    icon: "archivebox.fill",
                    color: AppColors.accentPurple
                )
                
                StatCard(
                    title: "Expiring Soon",
                    value: "\(expiringSoonCount)",
                    icon: "clock.fill",
                    color: expiringSoonCount > 0 ? AppColors.warningRed : AppColors.successGreen
                )
                
                StatCard(
                    title: "Top Category",
                    value: mostUsedCategory,
                    icon: "star.fill",
                    color: AppColors.primaryYellow
                )
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(AppColors.darkText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Text(title)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(AppColors.darkText.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct AnalyticsCard<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(Color.black)
            
            content
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct CategoryChartView: View {
    let data: [CategoryData]
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                ForEach(data.prefix(5), id: \.category) { item in
                    HStack {
                        Text(item.category.displayName)
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(AppColors.darkText)
                            .frame(width: 100, alignment: .leading)
                        
                        GeometryReader { geometry in
                            HStack(spacing: 0) {
                                Rectangle()
                                    .fill(AppColors.primaryYellow)
                                    .frame(width: CGFloat(item.count) / CGFloat(data.max(by: { $0.count < $1.count })?.count ?? 1) * geometry.size.width)
                                    .frame(height: 20)
                                    .cornerRadius(4)
                                
                                Spacer()
                            }
                        }
                        .frame(height: 20)
                        
                        Text("\(item.count)")
                            .font(.ubuntu(14, weight: .bold))
                            .foregroundColor(AppColors.darkText)
                            .frame(width: 30, alignment: .trailing)
                    }
                }
            }
        }
    }
}

struct ExpirationChartView: View {
    let data: [ExpirationData]
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(data, id: \.status) { item in
                HStack {
                    Circle()
                        .fill(item.color)
                        .frame(width: 12, height: 12)
                    
                    Text(item.status)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.darkText)
                    
                    Spacer()
                    
                    Text("\(item.count)")
                        .font(.ubuntu(14, weight: .bold))
                        .foregroundColor(AppColors.darkText)
                }
            }
        }
    }
}

struct StorageChartView: View {
    let data: [StorageData]
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(data.prefix(5), id: \.location) { item in
                HStack {
                    Text(item.location)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.darkText)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text("\(item.count)")
                        .font(.ubuntu(14, weight: .bold))
                        .foregroundColor(AppColors.accentPurple)
                }
                .padding(.vertical, 4)
            }
        }
    }
}

struct RecentActivityView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    private var recentProducts: [Product] {
        appViewModel.allProducts
            .sorted { $0.createdAt > $1.createdAt }
            .prefix(5)
            .map { $0 }
    }
    
    var body: some View {
        AnalyticsCard(title: "Recently Added") {
            if recentProducts.isEmpty {
                Text("No products added yet")
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(AppColors.darkText.opacity(0.6))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 12) {
                    ForEach(recentProducts, id: \.id) { product in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(product.name)
                                    .font(.ubuntu(14, weight: .medium))
                                    .foregroundColor(AppColors.darkText)
                                    .lineLimit(1)
                                
                                Text(product.brand)
                                    .font(.ubuntu(12, weight: .regular))
                                    .foregroundColor(AppColors.darkText.opacity(0.6))
                            }
                            
                            Spacer()
                            
                            Text(RelativeDateTimeFormatter().localizedString(for: product.createdAt, relativeTo: Date()))
                                .font(.ubuntu(12, weight: .regular))
                                .foregroundColor(AppColors.darkText.opacity(0.6))
                        }
                    }
                }
            }
        }
    }
}

struct EmptyAnalyticsView: View {
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 60))
                .foregroundColor(AppColors.primaryYellow)
            
            VStack(spacing: 12) {
                Text("No Data Yet")
                    .font(.ubuntu(22, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add some products to see analytics about your beauty collection.")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
        .padding(.vertical, 60)
    }
}

struct BrandChartView: View {
    let brands: [BrandStat]
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(brands.prefix(5), id: \.brand) { brand in
                HStack {
                    Text(brand.brand)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.darkText)
                        .frame(width: 120, alignment: .leading)
                        .lineLimit(1)
                    
                    GeometryReader { geometry in
                        HStack(spacing: 0) {
                            Rectangle()
                                .fill(AppColors.accentPurple)
                                .frame(width: CGFloat(brand.count) / CGFloat(brands.max(by: { $0.count < $1.count })?.count ?? 1) * geometry.size.width)
                                .frame(height: 20)
                                .cornerRadius(4)
                            
                            Spacer()
                        }
                    }
                    .frame(height: 20)
                    
                    Text("\(brand.count)")
                        .font(.ubuntu(14, weight: .bold))
                        .foregroundColor(AppColors.darkText)
                        .frame(width: 30, alignment: .trailing)
                }
            }
        }
    }
}

struct CategoryData {
    let category: ProductCategory
    let count: Int
}

struct ExpirationData {
    let status: String
    let count: Int
    let color: Color
}

struct StorageData {
    let location: String
    let count: Int
}

#Preview {
    AnalyticsView()
        .environmentObject(AppViewModel())
}
