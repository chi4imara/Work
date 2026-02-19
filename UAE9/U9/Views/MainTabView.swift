import SwiftUI

struct MainTabView: View {
    @StateObject private var productViewModel = ProductViewModel()
    
    var body: some View {
        TabView {
            ProductsView(productViewModel: productViewModel)
                .tabItem {
                    Image(systemName: "drop.circle")
                    Text("Products")
                }
                .tag(0)
            
            CategoriesView(productViewModel: productViewModel)
                .tabItem {
                    Image(systemName: "folder.circle")
                    Text("Categories")
                }
                .tag(1)
            
            StockView(productViewModel: productViewModel)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Stock")
                }
                .tag(2)
            
            AnalyticsView(productViewModel: productViewModel)
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Analytics")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(Color.orange)
        .preferredColorScheme(.dark)
    }
}

struct AnalyticsView: View {
    @ObservedObject var productViewModel: ProductViewModel
    
    var body: some View {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("Analytics")
                            .font(.playfairDisplay(32, weight: .bold))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    
                    if productViewModel.products.isEmpty {
                        EmptyAnalyticsView()
                        
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 20) {
                                UsageStatsSection(productViewModel: productViewModel)
                                
                                CategoryBreakdownSection(productViewModel: productViewModel)
                                
                                StockAlertsSection(productViewModel: productViewModel)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                        }
                    }
                }
            }
    }
}

struct EmptyAnalyticsView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(ColorTheme.lightBlue.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(ColorTheme.lightBlue)
            }
            
            VStack(spacing: 16) {
                Text("No Analytics Data")
                    .font(.playfairDisplay(24, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Add products to see usage analytics and insights")
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct UsageStatsSection: View {
    @ObservedObject var productViewModel: ProductViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Usage Statistics")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                StatCard(
                    title: "Total Products",
                    value: "\(productViewModel.products.count)",
                    icon: "cube.fill",
                    color: ColorTheme.lightBlue
                )
                
                StatCard(
                    title: "In Use",
                    value: "\(productViewModel.products.filter { $0.status == .inUse }.count)",
                    icon: "checkmark.circle.fill",
                    color: ColorTheme.green
                )
                
                StatCard(
                    title: "Running Out",
                    value: "\(productViewModel.runningOutProducts.count)",
                    icon: "exclamationmark.triangle.fill",
                    color: ColorTheme.orange
                )
                
                StatCard(
                    title: "Low Stock",
                    value: "\(productViewModel.lowStockProducts.count)",
                    icon: "minus.circle.fill",
                    color: ColorTheme.red
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
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.playfairDisplay(24, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text(title)
                    .font(.playfairDisplay(12, weight: .regular))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .cardStyle()
    }
}

struct CategoryBreakdownSection: View {
    @ObservedObject var productViewModel: ProductViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Category Breakdown")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 8) {
                ForEach(ProductCategory.allCases) { category in
                    let count = productViewModel.products(for: category).count
                    if count > 0 {
                        CategoryBreakdownRow(
                            category: category,
                            count: count,
                            total: productViewModel.products.count
                        )
                    }
                }
            }
            .cardStyle()
        }
    }
}

struct CategoryBreakdownRow: View {
    let category: ProductCategory
    let count: Int
    let total: Int
    
    private var percentage: Double {
        total > 0 ? Double(count) / Double(total) : 0
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: category.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(categoryColor)
                    .frame(width: 20)
                
                Text(category.displayName)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Text("\(count)")
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(categoryColor)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(ColorTheme.tertiaryBackground.opacity(0.3))
                        .frame(height: 4)
                        .cornerRadius(2)
                    
                    Rectangle()
                        .fill(categoryColor)
                        .frame(width: geometry.size.width * percentage, height: 4)
                        .cornerRadius(2)
                }
            }
            .frame(height: 4)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    private var categoryColor: Color {
        switch category {
        case .cream: return ColorTheme.lightBlue
        case .oil: return ColorTheme.orange
        case .shampoo: return ColorTheme.green
        case .balm: return ColorTheme.yellow
        case .gel: return ColorTheme.red
        case .other: return ColorTheme.secondaryText
        }
    }
}

struct StockAlertsSection: View {
    @ObservedObject var productViewModel: ProductViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Stock Alerts")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            if productViewModel.lowStockProducts.isEmpty && productViewModel.runningOutProducts.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(ColorTheme.green)
                    
                    Text("All products are well stocked!")
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(ColorTheme.primaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .cardStyle()
            } else {
                VStack(spacing: 8) {
                    ForEach(productViewModel.lowStockProducts.prefix(3)) { product in
                        AlertRow(
                            product: product,
                            alertType: "Low Stock",
                            color: ColorTheme.red
                        )
                    }
                    
                    ForEach(productViewModel.runningOutProducts.prefix(3)) { product in
                        AlertRow(
                            product: product,
                            alertType: "Running Out",
                            color: ColorTheme.orange
                        )
                    }
                }
                .cardStyle()
            }
        }
    }
}

struct AlertRow: View {
    let product: Product
    let alertType: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: product.category.icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(product.name)
                    .font(.playfairDisplay(14, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text(alertType)
                    .font(.playfairDisplay(12, weight: .regular))
                    .foregroundColor(color)
            }
            
            Spacer()
            
            Text(product.lastUsedText)
                .font(.playfairDisplay(12, weight: .regular))
                .foregroundColor(ColorTheme.tertiaryText)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

#Preview {
    MainTabView()
}
