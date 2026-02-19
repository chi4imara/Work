import SwiftUI

struct StatsView: View {
    @StateObject private var viewModel = StoreViewModel()
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("Statistics")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(.appText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Your shopping insights")
                            .font(.ubuntu(16))
                            .foregroundColor(.appTextSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    if viewModel.stores.isEmpty {
                        EmptyStateView(
                            title: "No statistics yet",
                            subtitle: "Add some stores to see your insights",
                            systemImage: "chart.bar"
                        )
                    } else {
                        VStack(spacing: 20) {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 16) {
                                StatCardView(
                                    title: "Total Stores",
                                    value: "\(viewModel.stores.count)",
                                    icon: "bag.fill",
                                    color: .appPrimary
                                )
                                
                                StatCardView(
                                    title: "Categories",
                                    value: "\(getCategoryCount())",
                                    icon: "folder.fill",
                                    color: .appAccent
                                )
                                
                                StatCardView(
                                    title: "Online Stores",
                                    value: "\(getOnlineStoreCount())",
                                    icon: "globe",
                                    color: .appSuccess
                                )
                                
                                StatCardView(
                                    title: "Boutiques",
                                    value: "\(getBoutiqueCount())",
                                    icon: "storefront",
                                    color: .appWarning
                                )
                            }
                            .padding(.horizontal, 20)
                            
                            CategoryBreakdownView(viewModel: viewModel)
                            
                            PriceLevelDistributionView(viewModel: viewModel)
                        }
                    }
                }
                .padding(.bottom, 100)
            }
        }
    }
    
    private func getCategoryCount() -> Int {
        Set(viewModel.stores.map { $0.category }).count
    }
    
    private func getOnlineStoreCount() -> Int {
        viewModel.stores.filter { $0.type == .online }.count
    }
    
    private func getBoutiqueCount() -> Int {
        viewModel.stores.filter { $0.type == .boutique }.count
    }
}

struct StatCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [color.opacity(0.3), color.opacity(0.1)],
                            center: .center,
                            startRadius: 15,
                            endRadius: 30
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(.appText)
                
                Text(title)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(.appTextSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appCardBackground)
        .cornerRadius(16)
        .shadow(color: Color.appShadow, radius: 8, x: 0, y: 4)
    }
}

struct CategoryBreakdownView: View {
    @ObservedObject var viewModel: StoreViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Category Breakdown")
                .font(.ubuntu(20, weight: .medium))
                .foregroundColor(.appText)
                .padding(.horizontal, 20)
            
            VStack(spacing: 12) {
                let categoryCounts = viewModel.getCategoryCounts()
                
                ForEach(StoreCategory.allCases, id: \.self) { category in
                    let count = categoryCounts[category] ?? 0
                    if count > 0 {
                        CategoryProgressView(
                            category: category,
                            count: count,
                            total: viewModel.stores.count
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 20)
        .background(Color.appCardBackground)
        .cornerRadius(16)
        .shadow(color: Color.appShadow, radius: 8, x: 0, y: 4)
        .padding(.horizontal, 20)
    }
}

struct CategoryProgressView: View {
    let category: StoreCategory
    let count: Int
    let total: Int
    
    private var percentage: Double {
        total > 0 ? Double(count) / Double(total) : 0
    }
    
    private var categoryColor: Color {
        switch category {
        case .clothing: return .blue
        case .cosmetics: return .pink
        case .shoes: return .brown
        case .home: return .green
        case .accessories: return .purple
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(category.displayName)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(.appText)
                
                Spacer()
                
                Text("\(count)")
                    .font(.ubuntu(14, weight: .bold))
                    .foregroundColor(categoryColor)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [categoryColor, categoryColor.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * percentage, height: 8)
                        .cornerRadius(4)
                        .animation(.easeInOut(duration: 1.0), value: percentage)
                }
            }
            .frame(height: 8)
        }
    }
}

struct PriceLevelDistributionView: View {
    @ObservedObject var viewModel: StoreViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Price Level Distribution")
                .font(.ubuntu(20, weight: .medium))
                .foregroundColor(.appText)
                .padding(.horizontal, 20)
            
            HStack(spacing: 16) {
                ForEach(PriceLevel.allCases, id: \.self) { level in
                    let count = viewModel.stores.filter { $0.priceLevel == level }.count
                    
                    VStack(spacing: 8) {
                        Text(level.displayName)
                            .font(.ubuntu(18, weight: .bold))
                            .foregroundColor(.appAccent)
                        
                        Text("\(count)")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(.appText)
                        
                        Text("stores")
                            .font(.ubuntu(12))
                            .foregroundColor(.appTextSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.appCardBackground.opacity(0.7))
                    .cornerRadius(12)
                    .shadow(color: Color.appShadow, radius: 4, x: 0, y: 2)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 20)
        .background(Color.appCardBackground)
        .cornerRadius(16)
        .shadow(color: Color.appShadow, radius: 8, x: 0, y: 4)
        .padding(.horizontal, 20)
    }
}

#Preview {
    StatsView()
}
