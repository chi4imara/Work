import SwiftUI

struct StatisticsView: View {
    @StateObject private var viewModel = BagViewModel()
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerView
                    
                    if viewModel.bags.isEmpty {
                        emptyStateView
                    } else {
                        statisticsContent
                    }
                }
                .padding(.bottom, 120)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Collection Statistics")
                .font(FontManager.ubuntu(.bold, size: 28))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 28))
                .foregroundColor(AppColors.primaryYellow)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var statisticsContent: some View {
        let stats = viewModel.getStatistics()
        
        return VStack(spacing: 24) {
            totalBagsCard(stats.totalBags)
            
            styleStatisticsSection(stats.styleStats)
            
            usageStatisticsSection(stats.usageStats)
            
            brandStatisticsSection()
            
            smartRecommendationsSection()
            
            recommendationCard(stats.recommendation)
        }
        .padding(.horizontal, 20)
    }
    
    private func totalBagsCard(_ total: Int) -> some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(AppColors.primaryYellow.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Text("\(total)")
                    .font(FontManager.ubuntu(.bold, size: 32))
                    .foregroundColor(AppColors.primaryYellow)
            }
            
            Text("Total Bags")
                .font(FontManager.ubuntu(.medium, size: 18))
                .foregroundColor(AppColors.darkText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .cardStyle()
    }
    
    private func styleStatisticsSection(_ styleStats: [BagStyle: Int]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "tag.fill")
                    .foregroundColor(AppColors.primaryPurple)
                
                Text("By Style")
                    .font(FontManager.ubuntu(.bold, size: 20))
                    .foregroundColor(AppColors.darkText)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                ForEach(BagStyle.allCases) { style in
                    let count = styleStats[style] ?? 0
                    StatisticRow(
                        icon: styleIcon(for: style),
                        title: style.displayName,
                        count: count,
                        color: AppColors.primaryPurple
                    )
                }
            }
        }
        .padding(20)
        .cardStyle()
    }
    
    private func usageStatisticsSection(_ usageStats: [UsageFrequency: Int]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(AppColors.primaryBlue)
                
                Text("By Usage")
                    .font(FontManager.ubuntu(.bold, size: 20))
                    .foregroundColor(AppColors.darkText)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                ForEach(UsageFrequency.allCases) { frequency in
                    let count = usageStats[frequency] ?? 0
                    StatisticRow(
                        icon: "circle.fill",
                        title: frequency.displayName,
                        count: count,
                        color: usageFrequencyColor(for: frequency)
                    )
                }
            }
        }
        .padding(20)
        .cardStyle()
    }
    
    private func recommendationCard(_ recommendation: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(AppColors.primaryYellow)
                
                Text("Recommendation")
                    .font(FontManager.ubuntu(.bold, size: 20))
                    .foregroundColor(AppColors.darkText)
                
                Spacer()
            }
            
            Text(recommendation)
                .font(FontManager.ubuntu(.regular, size: 16))
                .foregroundColor(AppColors.darkText)
                .lineSpacing(4)
        }
        .padding(20)
        .cardStyle()
    }
    
    private func brandStatisticsSection() -> some View {
        let brandStats = viewModel.getBrandStatisticsSorted()
        
        guard !brandStats.isEmpty else { return AnyView(EmptyView()) }
        
        return AnyView(
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "tag.fill")
                        .foregroundColor(AppColors.primaryYellow)
                    
                    Text("By Brand")
                        .font(FontManager.ubuntu(.bold, size: 20))
                        .foregroundColor(AppColors.darkText)
                    
                    Spacer()
                }
                
                VStack(spacing: 12) {
                    ForEach(Array(brandStats.prefix(5)), id: \.0) { brand, count in
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(AppColors.primaryYellow.opacity(0.2))
                                    .frame(width: 40, height: 40)
                                
                                Text(String(brand.prefix(1)))
                                    .font(FontManager.ubuntu(.bold, size: 16))
                                    .foregroundColor(AppColors.primaryYellow)
                            }
                            
                            Text(brand)
                                .font(FontManager.ubuntu(.medium, size: 16))
                                .foregroundColor(AppColors.darkText)
                            
                            Spacer()
                            
                            HStack(spacing: 8) {
                                Text("\(count)")
                                    .font(FontManager.ubuntu(.bold, size: 16))
                                    .foregroundColor(AppColors.darkText)
                                
                                Text(count == 1 ? "bag" : "bags")
                                    .font(FontManager.ubuntu(.regular, size: 14))
                                    .foregroundColor(AppColors.darkText.opacity(0.7))
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .padding(20)
            .cardStyle()
        )
    }
    
    private func smartRecommendationsSection() -> some View {
        let unusedBags = viewModel.getUnusedBags(daysThreshold: 30)
        
        guard !unusedBags.isEmpty else { return AnyView(EmptyView()) }
        
        return AnyView(
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(AppColors.warning)
                    
                    Text("Smart Recommendations")
                        .font(FontManager.ubuntu(.bold, size: 20))
                        .foregroundColor(AppColors.darkText)
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Bags not used in 30+ days:")
                        .font(FontManager.ubuntu(.medium, size: 14))
                        .foregroundColor(AppColors.darkText.opacity(0.7))
                    
                    ForEach(unusedBags.prefix(3)) { bag in
                        HStack(spacing: 12) {
                            Image(systemName: "handbag.fill")
                                .font(.system(size: 16))
                                .foregroundColor(AppColors.warning)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(bag.name)
                                    .font(FontManager.ubuntu(.bold, size: 14))
                                    .foregroundColor(AppColors.darkText)
                                
                                Text(bag.brand)
                                    .font(FontManager.ubuntu(.regular, size: 12))
                                    .foregroundColor(AppColors.darkText.opacity(0.6))
                            }
                            
                            Spacer()
                            
                            if let lastUsed = bag.lastUsedDate {
                                Text(daysSince(lastUsed))
                                    .font(FontManager.ubuntu(.regular, size: 12))
                                    .foregroundColor(AppColors.darkText.opacity(0.6))
                            } else {
                                Text("Never")
                                    .font(FontManager.ubuntu(.regular, size: 12))
                                    .foregroundColor(AppColors.darkText.opacity(0.6))
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .padding(20)
            .cardStyle()
        )
    }
    
    private func daysSince(_ date: Date) -> String {
        let days = Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
        if days == 0 {
            return "Today"
        } else if days == 1 {
            return "1 day ago"
        } else {
            return "\(days) days ago"
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "chart.bar")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryYellow.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No data for analysis")
                    .font(FontManager.ubuntu(.bold, size: 24))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add at least one bag to your collection to see statistics.")
                    .font(FontManager.ubuntu(.regular, size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private func styleIcon(for style: BagStyle) -> String {
        switch style {
        case .everyday:
            return "bag"
        case .evening:
            return "sparkles"
        case .travel:
            return "airplane"
        case .other:
            return "questionmark.circle"
        }
    }
    
    private func usageFrequencyColor(for frequency: UsageFrequency) -> Color {
        switch frequency {
        case .often:
            return AppColors.success
        case .sometimes:
            return AppColors.warning
        case .rarely:
            return AppColors.error
        }
    }
}

struct StatisticRow: View {
    let icon: String
    let title: String
    let count: Int
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(color)
                .frame(width: 20)
            
            Text(title)
                .font(FontManager.ubuntu(.medium, size: 16))
                .foregroundColor(AppColors.darkText)
            
            Spacer()
            
            HStack(spacing: 8) {
                Text("\(count)")
                    .font(FontManager.ubuntu(.bold, size: 16))
                    .foregroundColor(AppColors.darkText)
                
                Text(count == 1 ? "bag" : "bags")
                    .font(FontManager.ubuntu(.regular, size: 14))
                    .foregroundColor(AppColors.darkText.opacity(0.7))
            }
        }
        .padding(.vertical, 4)
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
