import SwiftUI
import Charts

struct StatisticsView: View {
    @ObservedObject var quoteStore: QuoteStore
    @State private var selectedPeriod: FilterPeriod = .all
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.lg) {
                headerSection
                
                periodSelector
                
                overviewCards
                
                typeDistributionChart
                
                categoryDistributionSection
                
                monthlyActivityChart
                
                detailedStats
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.bottom, 100)
        }
        .backgroundGradient()
        .navigationTitle("Statistics")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private var headerSection: some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Quotes")
                        .font(FontManager.poppinsRegular(size: 14))
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                    
                    Text("\(quoteStore.totalQuotesCount)")
                        .font(FontManager.poppinsBold(size: 32))
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                }
                
                Spacer()
                
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 40))
                    .foregroundColor(DesignSystem.Colors.primaryBlue)
            }
            .padding(DesignSystem.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                    .fill(DesignSystem.Colors.cardBackground)
                    .shadow(color: DesignSystem.Shadow.light, radius: 8, x: 0, y: 4)
            )
        }
    }
    
    private var periodSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DesignSystem.Spacing.sm) {
                ForEach([FilterPeriod.today, .week, .month, .all], id: \.self) { period in
                    PeriodButton(
                        period: period,
                        isSelected: selectedPeriod == period,
                        action: { selectedPeriod = period }
                    )
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
        }
        .padding(.horizontal, -16)
    }
    
    private var overviewCards: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: DesignSystem.Spacing.md) {
            StatCard(
                title: "Active",
                value: "\(quoteStore.activeQuotesCount)",
                icon: "doc.text.fill",
                color: DesignSystem.Colors.primaryBlue
            )
            
            StatCard(
                title: "Archived",
                value: "\(quoteStore.archivedQuotesCount)",
                icon: "archivebox.fill",
                color: Color.orange
            )
            
            StatCard(
                title: "Categories",
                value: "\(quoteStore.categoriesCount)",
                icon: "folder.fill",
                color: Color.green
            )
            
            StatCard(
                title: "This Period",
                value: "\(quoteStore.quotesCreatedInPeriod(selectedPeriod))",
                icon: "calendar",
                color: Color.purple
            )
        }
    }
    
    private var typeDistributionChart: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text("Distribution by Type")
                .font(FontManager.poppinsSemiBold(size: 18))
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            HStack(spacing: DesignSystem.Spacing.lg) {
                TypeDistributionItem(
                    title: "Quotes",
                    count: quoteStore.quotesCount,
                    total: quoteStore.totalQuotesCount,
                    color: DesignSystem.Colors.primaryBlue,
                    icon: "quote.bubble.fill"
                )
                
                TypeDistributionItem(
                    title: "Thoughts",
                    count: quoteStore.thoughtsCount,
                    total: quoteStore.totalQuotesCount,
                    color: Color.orange,
                    icon: "lightbulb.fill"
                )
            }
        }
        .padding(DesignSystem.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                .fill(DesignSystem.Colors.cardBackground)
                .shadow(color: DesignSystem.Shadow.light, radius: 8, x: 0, y: 4)
        )
    }
    
    private var categoryDistributionSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text("Popular Categories")
                .font(FontManager.poppinsSemiBold(size: 18))
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            let distribution = quoteStore.categoryDistribution()
            
            if distribution.isEmpty {
                EmptyStateView(
                    icon: "folder.badge.questionmark",
                    title: "No Categories",
                    subtitle: "Create categories to organize your quotes"
                )
            } else {
                VStack(spacing: DesignSystem.Spacing.sm) {
                    ForEach(Array(distribution.prefix(5).enumerated()), id: \.offset) { index, item in
                        CategoryDistributionRow(
                            name: item.0,
                            count: item.1,
                            total: quoteStore.totalQuotesCount,
                            rank: index + 1
                        )
                    }
                }
            }
        }
        .padding(DesignSystem.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                .fill(DesignSystem.Colors.cardBackground)
                .shadow(color: DesignSystem.Shadow.light, radius: 8, x: 0, y: 4)
        )
    }
    
    private var monthlyActivityChart: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text("Monthly Activity")
                .font(FontManager.poppinsSemiBold(size: 18))
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            let monthlyStats = quoteStore.monthlyQuoteStats()
            
            if monthlyStats.isEmpty {
                EmptyStateView(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "No Data",
                    subtitle: "Create quotes to view activity"
                )
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .bottom, spacing: 8) {
                        ForEach(Array(monthlyStats.enumerated()), id: \.offset) { index, stat in
                            MonthlyBarView(
                                month: stat.0,
                                count: stat.1,
                                maxCount: monthlyStats.map { $0.1 }.max() ?? 1
                            )
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.md)
                }
                .frame(height: 150)
            }
        }
        .padding(DesignSystem.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                .fill(DesignSystem.Colors.cardBackground)
                .shadow(color: DesignSystem.Shadow.light, radius: 8, x: 0, y: 4)
        )
    }
    
    private var detailedStats: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text("Detailed Statistics")
                .font(FontManager.poppinsSemiBold(size: 18))
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            VStack(spacing: DesignSystem.Spacing.sm) {
                DetailedStatRow(
                    title: "Days since first quote",
                    value: "\(quoteStore.daysSinceFirstQuote)",
                    icon: "calendar.badge.clock"
                )
                
                DetailedStatRow(
                    title: "Average per day",
                    value: String(format: "%.1f", quoteStore.averageQuotesPerDay),
                    icon: "chart.line.uptrend.xyaxis"
                )
                
                if let mostPopular = quoteStore.mostPopularCategory {
                    DetailedStatRow(
                        title: "Most popular category",
                        value: mostPopular,
                        icon: "star.fill"
                    )
                }
                
                DetailedStatRow(
                    title: "Without category",
                    value: "\(quoteStore.quotesWithoutCategoryCount)",
                    icon: "folder.badge.questionmark"
                )
                
                if quoteStore.categoriesCount > 0 {
                    DetailedStatRow(
                        title: "Average per category",
                        value: String(format: "%.1f", quoteStore.averageQuotesPerCategory),
                        icon: "divide"
                    )
                }
            }
        }
        .padding(DesignSystem.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                .fill(DesignSystem.Colors.cardBackground)
                .shadow(color: DesignSystem.Shadow.light, radius: 8, x: 0, y: 4)
        )
    }
}

struct PeriodButton: View {
    let period: FilterPeriod
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(period.rawValue)
                .font(FontManager.poppinsRegular(size: 14))
                .foregroundColor(isSelected ? .white : DesignSystem.Colors.textSecondary)
                .padding(.horizontal, DesignSystem.Spacing.md)
                .padding(.vertical, DesignSystem.Spacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                        .fill(isSelected ? DesignSystem.Colors.primaryBlue : DesignSystem.Colors.cardBackground)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                
                Spacer()
            }
            
            Text(value)
                .font(FontManager.poppinsBold(size: 24))
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            Text(title)
                .font(FontManager.poppinsRegular(size: 12))
                .foregroundColor(DesignSystem.Colors.textSecondary)
        }
        .padding(DesignSystem.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                .fill(DesignSystem.Colors.cardBackground)
                .shadow(color: DesignSystem.Shadow.light, radius: 4, x: 0, y: 2)
        )
    }
}

struct TypeDistributionItem: View {
    let title: String
    let count: Int
    let total: Int
    let color: Color
    let icon: String
    
    private var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(count) / Double(total) * 100
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
                
                Text(title)
                    .font(FontManager.poppinsRegular(size: 14))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                
                Spacer()
            }
            
            Text("\(count)")
                .font(FontManager.poppinsBold(size: 20))
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            Text("\(Int(percentage))%")
                .font(FontManager.poppinsRegular(size: 12))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CategoryDistributionRow: View {
    let name: String
    let count: Int
    let total: Int
    let rank: Int
    
    private var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(count) / Double(total)
    }
    
    var body: some View {
        HStack {
            Text("\(rank)")
                .font(FontManager.poppinsBold(size: 14))
                .foregroundColor(DesignSystem.Colors.primaryBlue)
                .frame(width: 24, height: 24)
                .background(
                    Circle()
                        .fill(DesignSystem.Colors.primaryBlue.opacity(0.1))
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(FontManager.poppinsRegular(size: 14))
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(DesignSystem.Colors.backgroundSecondary)
                            .frame(height: 4)
                        
                        Rectangle()
                            .fill(DesignSystem.Colors.primaryBlue)
                            .frame(width: geometry.size.width * percentage, height: 4)
                    }
                }
                .frame(height: 4)
            }
            
            Spacer()
            
            Text("\(count)")
                .font(FontManager.poppinsSemiBold(size: 14))
                .foregroundColor(DesignSystem.Colors.textPrimary)
        }
    }
}

struct MonthlyBarView: View {
    let month: String
    let count: Int
    let maxCount: Int
    
    private var barHeight: CGFloat {
        guard maxCount > 0 else { return 0 }
        return CGFloat(count) / CGFloat(maxCount) * 100
    }
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xs) {
            Text("\(count)")
                .font(FontManager.poppinsRegular(size: 10))
                .foregroundColor(DesignSystem.Colors.textSecondary)
            
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [DesignSystem.Colors.primaryBlue, DesignSystem.Colors.primaryBlue.opacity(0.6)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 24, height: max(barHeight, 4))
                .cornerRadius(2)
            
            Text(month)
                .font(FontManager.poppinsRegular(size: 8))
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .frame(width: 40)
        }
    }
}

struct DetailedStatRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(DesignSystem.Colors.primaryBlue)
                .frame(width: 24)
            
            Text(title)
                .font(FontManager.poppinsRegular(size: 14))
                .foregroundColor(DesignSystem.Colors.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(FontManager.poppinsSemiBold(size: 14))
                .foregroundColor(DesignSystem.Colors.textPrimary)
        }
        .padding(.vertical, DesignSystem.Spacing.xs)
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(DesignSystem.Colors.textSecondary.opacity(0.6))
            
            VStack(spacing: DesignSystem.Spacing.xs) {
                Text(title)
                    .font(FontManager.poppinsSemiBold(size: 16))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                
                Text(subtitle)
                    .font(FontManager.poppinsRegular(size: 12))
                    .foregroundColor(DesignSystem.Colors.textSecondary.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(DesignSystem.Spacing.xl)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationView {
        StatisticsView(quoteStore: QuoteStore())
    }
}
