import SwiftUI
import Charts

struct StatisticsView: View {
    @ObservedObject var store: CollectionStore
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if store.collections.isEmpty {
                        emptyStateView
                    } else {
                        statisticsContent
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Statistics")
                .font(.titleLarge)
                .foregroundColor(.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "chart.bar")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.textSecondary)
            
            VStack(spacing: 8) {
                Text("No data to analyze")
                    .font(.titleMedium)
                    .foregroundColor(.textPrimary)
                
                Text("Create collections to see statistics")
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 32)
    }
    
    private var statisticsContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                overviewSection
                
                collectionDistributionSection
                
                statusBreakdownSection
                
                categoryAnalysisSection
                
                recentActivitySection
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
    }
    
    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(.titleSmall)
                .foregroundColor(.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                StatCard(
                    title: "Total Collections",
                    value: "\(store.collections.count)",
                    icon: "square.grid.2x2.fill",
                    color: .primaryBlue
                )
                
                StatCard(
                    title: "Total Items",
                    value: "\(totalItems)",
                    icon: "cube.box.fill",
                    color: .accentGreen
                )
                
                StatCard(
                    title: "Favorites",
                    value: "\(store.favoriteItems.count)",
                    icon: "star.fill",
                    color: .accentOrange
                )
                
                StatCard(
                    title: "Completion Rate",
                    value: "\(completionRate)%",
                    icon: "checkmark.circle.fill",
                    color: .statusInCollection
                )
            }
        }
    }
    
    private var collectionDistributionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Collection Distribution")
                .font(.titleSmall)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 12) {
                ForEach(store.collections.sorted { $0.itemCount > $1.itemCount }) { collection in
                    CollectionProgressBar(
                        collection: collection,
                        maxItems: maxItemsInCollection
                    )
                }
            }
            .padding(16)
            .cardStyle()
        }
    }
    
    private var statusBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Status Breakdown")
                .font(.titleSmall)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 12) {
                StatusProgressBar(
                    title: "In Collection",
                    count: inCollectionCount,
                    total: totalItems,
                    color: .statusInCollection
                )
                
                StatusProgressBar(
                    title: "Wishlist",
                    count: wishlistCount,
                    total: totalItems,
                    color: .statusWishlist
                )
                
                StatusProgressBar(
                    title: "For Trade",
                    count: forTradeCount,
                    total: totalItems,
                    color: .statusForTrade
                )
            }
            .padding(16)
            .cardStyle()
        }
    }
    
    private var categoryAnalysisSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Category Analysis")
                .font(.titleSmall)
                .foregroundColor(.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(CollectionCategory.allCases) { category in
                    CategoryCard(
                        category: category,
                        count: categoryCount(for: category)
                    )
                }
            }
        }
    }
    
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(.titleSmall)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 12) {
                ForEach(recentCollections, id: \.id) { collection in
                    HStack {
                        Image(systemName: collection.category.icon)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primaryBlue)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(collection.name)
                                .font(.bodyMedium)
                                .foregroundColor(.textPrimary)
                            
                            Text("Created \(collection.createdAt.timeAgoDisplay())")
                                .font(.captionSmall)
                                .foregroundColor(.textSecondary)
                        }
                        
                        Spacer()
                        
                        Text("\(collection.itemCount)")
                            .font(.captionLarge)
                            .foregroundColor(.primaryBlue)
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding(16)
            .cardStyle()
        }
    }
    
    private var totalItems: Int {
        store.collections.reduce(0) { $0 + $1.itemCount }
    }
    
    private var maxItemsInCollection: Int {
        store.collections.map { $0.itemCount }.max() ?? 1
    }
    
    private var inCollectionCount: Int {
        store.collections.flatMap { $0.items }.filter { $0.status == .inCollection }.count
    }
    
    private var wishlistCount: Int {
        store.collections.flatMap { $0.items }.filter { $0.status == .wishlist }.count
    }
    
    private var forTradeCount: Int {
        store.collections.flatMap { $0.items }.filter { $0.status == .forTrade }.count
    }
    
    private var completionRate: Int {
        guard totalItems > 0 else { return 0 }
        return Int((Double(inCollectionCount) / Double(totalItems)) * 100)
    }
    
    private var recentCollections: [Collection] {
        Array(store.collections.sorted { $0.createdAt > $1.createdAt }.prefix(5))
    }
    
    private func categoryCount(for category: CollectionCategory) -> Int {
        store.collections.filter { $0.category == category }.count
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
                    .font(.titleMedium)
                    .foregroundColor(.textPrimary)
                
                Text(title)
                    .font(.captionMedium)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .cardStyle()
    }
}

struct CollectionProgressBar: View {
    let collection: Collection
    let maxItems: Int
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(collection.name)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
                
                Spacer()
                
                Text("\(collection.itemCount)")
                    .font(.captionLarge)
                    .foregroundColor(.primaryBlue)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.lightBlue.opacity(0.2))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(Color.primaryBlue)
                        .frame(
                            width: geometry.size.width * (Double(collection.itemCount) / Double(maxItems)),
                            height: 8
                        )
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
    }
}

struct StatusProgressBar: View {
    let title: String
    let count: Int
    let total: Int
    let color: Color
    
    private var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(count) / Double(total)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(title)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("\(count) (\(Int(percentage * 100))%)")
                    .font(.captionLarge)
                    .foregroundColor(color)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(color.opacity(0.2))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(color)
                        .frame(
                            width: geometry.size.width * percentage,
                            height: 8
                        )
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
    }
}

struct CategoryCard: View {
    let category: CollectionCategory
    let count: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: category.icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.primaryBlue)
            
            Text("\(count)")
                .font(.titleSmall)
                .foregroundColor(.textPrimary)
            
            Text(category.rawValue)
                .font(.captionMedium)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                  .fill(Color.lightBlue.opacity(0.1))
                  .overlay(
                      RoundedRectangle(cornerRadius: 12)
                          .stroke(Color.lightBlue.opacity(0.3), lineWidth: 1)
                  )
        )
    }
}

#Preview {
    StatisticsView(store: CollectionStore())
}
