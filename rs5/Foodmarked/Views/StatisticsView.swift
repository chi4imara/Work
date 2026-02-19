import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var productStore: ProductStore
    @EnvironmentObject var achievementManager: AchievementManager
    @State private var showingAchievements = false
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Statistics")
                        .font(.playfairDisplay(size: 28, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAchievements = true
                    }) {
                        HStack(spacing: 6) {
                            Text("🏆")
                            Text("\(achievementManager.unlockedAchievements.count)")
                                .font(.playfairDisplay(size: 14, weight: .semibold))
                                .foregroundColor(ColorManager.primaryText)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(ColorManager.cardGradient)
                                .shadow(color: ColorManager.primaryBlue.opacity(0.2), radius: 4, x: 0, y: 2)
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if productStore.products.isEmpty {
                    EmptyStatisticsView()
                    
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 25) {
                            DailyChallengeView()
                            
                            HealthScoreView()
                            
                            OverviewCardsView()
                            
                            SmartInsightsView()
                            
                            RandomProductPickerView()
                            
                            ShoppingListGeneratorView()
                            
                            StatusDistributionView()
                            
                            RecentActivityView()
                            
                            ProductTrendsView()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAchievements) {
            NavigationView {
                AchievementsView()
                    .environmentObject(achievementManager)
                    .environmentObject(productStore)
            }
        }
    }
}

struct OverviewCardsView: View {
    @EnvironmentObject var productStore: ProductStore
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                StatCard(
                    title: "Total Products",
                    value: "\(productStore.products.count)",
                    icon: "cube.box.fill",
                    color: ColorManager.primaryBlue
                )
                
                StatCard(
                    title: "Suitable",
                    value: "\(productStore.suitableProducts.count)",
                    icon: "checkmark.circle.fill",
                    color: ColorManager.suitableGreen
                )
            }
            
            HStack(spacing: 16) {
                StatCard(
                    title: "Not Suitable",
                    value: "\(productStore.unsuitableProducts.count)",
                    icon: "xmark.circle.fill",
                    color: ColorManager.unsuitableRed
                )
                
                StatCard(
                    title: "Suitable %",
                    value: String(format: "%.0f%%", suitablePercentage),
                    icon: "percent",
                    color: ColorManager.primaryYellow
                )
            }
        }
    }
    
    private var suitablePercentage: Double {
        guard !productStore.products.isEmpty else { return 0 }
        return Double(productStore.suitableProducts.count) / Double(productStore.products.count) * 100
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(color)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text(title)
                    .font(.playfairDisplay(size: 12, weight: .medium))
                    .foregroundColor(ColorManager.secondaryText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.cardGradient)
                .shadow(color: color.opacity(0.2), radius: 8, x: 0, y: 4)
        )
    }
}

struct StatusDistributionView: View {
    @EnvironmentObject var productStore: ProductStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Status Distribution")
                .font(.playfairDisplay(size: 20, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            VStack(spacing: 12) {
                DistributionBar(
                    title: "Suitable",
                    count: productStore.suitableProducts.count,
                    total: productStore.products.count,
                    color: ColorManager.suitableGreen
                )
                
                DistributionBar(
                    title: "Not Suitable",
                    count: productStore.unsuitableProducts.count,
                    total: productStore.products.count,
                    color: ColorManager.unsuitableRed
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.cardGradient)
                .shadow(color: ColorManager.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

struct DistributionBar: View {
    let title: String
    let count: Int
    let total: Int
    let color: Color
    
    private var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(count) / Double(total)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.playfairDisplay(size: 14, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                
                Spacer()
                
                Text("\(count) (\(String(format: "%.0f", percentage * 100))%)")
                    .font(.playfairDisplay(size: 14, weight: .medium))
                    .foregroundColor(ColorManager.secondaryText)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(ColorManager.lightBlue.opacity(0.3))
                        .frame(height: 12)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color)
                        .frame(width: geometry.size.width * CGFloat(percentage), height: 12)
                }
            }
            .frame(height: 12)
        }
    }
}

struct RecentActivityView: View {
    @EnvironmentObject var productStore: ProductStore
    
    var recentProducts: [Product] {
        Array(productStore.products.sorted { $0.dateAdded > $1.dateAdded }.prefix(5))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(.playfairDisplay(size: 20, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            if recentProducts.isEmpty {
                Text("No recent activity")
                    .font(.playfairDisplay(size: 14, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 12) {
                    ForEach(recentProducts) { product in
                        NavigationLink(destination: ProductDetailView(productId: product.id)
                            .environmentObject(productStore)) {
                            RecentActivityRow(product: product)
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.cardGradient)
                .shadow(color: ColorManager.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

struct RecentActivityRow: View {
    let product: Product
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(product.status == .suitable ? ColorManager.suitableGreen : ColorManager.unsuitableRed)
                .frame(width: 10, height: 10)
            
            Text(product.name)
                .font(.playfairDisplay(size: 14, weight: .medium))
                .foregroundColor(ColorManager.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(formatDate(product.dateAdded))
                .font(.playfairDisplay(size: 12, weight: .regular))
                .foregroundColor(ColorManager.secondaryText)
        }
        .padding(.vertical, 8)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct ProductTrendsView: View {
    @EnvironmentObject var productStore: ProductStore
    
    var productsByDate: [(date: Date, count: Int)] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: productStore.products) { product in
            calendar.startOfDay(for: product.dateAdded)
        }
        
        return grouped.map { (date, products) in
            (date: date, count: products.count)
        }.sorted { $0.date > $1.date }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Products Added Over Time")
                .font(.playfairDisplay(size: 20, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            if productsByDate.isEmpty {
                Text("No data available")
                    .font(.playfairDisplay(size: 14, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 12) {
                    ForEach(Array(productsByDate.prefix(7).reversed()), id: \.date) { item in
                        HStack {
                            Text(formatDate(item.date))
                                .font(.playfairDisplay(size: 12, weight: .medium))
                                .foregroundColor(ColorManager.secondaryText)
                                .frame(width: 100, alignment: .leading)
                            
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(ColorManager.lightBlue.opacity(0.3))
                                        .frame(height: 20)
                                    
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(ColorManager.primaryBlue)
                                        .frame(width: geometry.size.width * min(CGFloat(item.count) / 10.0, 1.0), height: 20)
                                }
                            }
                            .frame(height: 20)
                            
                            Text("\(item.count)")
                                .font(.playfairDisplay(size: 12, weight: .semibold))
                                .foregroundColor(ColorManager.primaryText)
                                .frame(width: 30, alignment: .trailing)
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.cardGradient)
                .shadow(color: ColorManager.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

struct EmptyStatisticsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "chart.bar")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(ColorManager.secondaryText)
            
            VStack(spacing: 8) {
                Text("No Statistics Yet")
                    .font(.playfairDisplay(size: 20, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text("Add some products to see your statistics and trends.")
                    .font(.playfairDisplay(size: 14, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}
