import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: WatchViewModel
    
    init(viewModel: WatchViewModel = WatchViewModel()) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var totalWatches: Int {
        viewModel.watches.count
    }
    
    var totalWearingDays: Int {
        viewModel.getAllWearingDays().count
    }
    
    var averageWearingDays: Double {
        guard totalWatches > 0 else { return 0 }
        return Double(totalWearingDays) / Double(totalWatches)
    }
    
    var mostWornWatch: Watch? {
        viewModel.watches.max { $0.wearingDays.count < $1.wearingDays.count }
    }
    
    var styleDistribution: [WatchStyle: Int] {
        var distribution: [WatchStyle: Int] = [:]
        for watch in viewModel.watches {
            distribution[watch.style, default: 0] += 1
        }
        return distribution
    }
    
    var conditionDistribution: [WatchCondition: Int] {
        var distribution: [WatchCondition: Int] = [:]
        for watch in viewModel.watches {
            distribution[watch.condition, default: 0] += 1
        }
        return distribution
    }
    
    var recentWearingDays: [WearingDay] {
        viewModel.getAllWearingDays()
            .sorted { $0.date > $1.date }
            .prefix(5)
            .map { $0 }
    }
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    Text("Statistics")
                        .font(.playfairDisplay(size: 32, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                        .padding(.top, 20)
                    
                    OverviewSection(
                        totalWatches: totalWatches,
                        totalWearingDays: totalWearingDays,
                        averageWearingDays: averageWearingDays,
                        mostWornWatch: mostWornWatch
                    )
                    
                    StyleDistributionSection(distribution: styleDistribution, total: totalWatches)
                    
                    ConditionDistributionSection(distribution: conditionDistribution)
                    
                    RecentActivitySection(
                        viewModel: viewModel,
                        recentWearingDays: recentWearingDays
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 120)
            }
        }
    }
}

struct OverviewSection: View {
    let totalWatches: Int
    let totalWearingDays: Int
    let averageWearingDays: Double
    let mostWornWatch: Watch?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(.playfairDisplay(size: 20, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
            
            VStack(spacing: 12) {
                StatisticCard(
                    icon: "applewatch",
                    title: "Total Watches",
                    value: "\(totalWatches)",
                    color: ColorManager.lightBlue
                )
                
                StatisticCard(
                    icon: "calendar",
                    title: "Total Wearing Days",
                    value: "\(totalWearingDays)",
                    color: ColorManager.orange
                )
                
                StatisticCard(
                    icon: "chart.bar.fill",
                    title: "Average Days per Watch",
                    value: String(format: "%.1f", averageWearingDays),
                    color: ColorManager.green
                )
                
                if let mostWorn = mostWornWatch, mostWorn.wearingDays.count > 0 {
                    StatisticCard(
                        icon: "star.fill",
                        title: "Most Worn Watch",
                        value: mostWorn.name,
                        subtitle: "\(mostWorn.wearingDays.count) days",
                        color: ColorManager.orange
                    )
                }
            }
        }
    }
}

struct StatisticCard: View {
    let icon: String
    let title: String
    let value: String
    var subtitle: String? = nil
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.playfairDisplay(size: 14, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                
                Text(value)
                    .font(.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                    .lineLimit(2)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.playfairDisplay(size: 12, weight: .regular))
                        .foregroundColor(ColorManager.secondaryText)
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(ColorManager.cardGradient)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

struct StyleDistributionSection: View {
    let distribution: [WatchStyle: Int]
    let total: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Style Distribution")
                .font(.playfairDisplay(size: 20, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
            
            if distribution.isEmpty {
                Text("No watches added yet")
                    .font(.playfairDisplay(size: 14, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 12) {
                    ForEach(WatchStyle.allCases, id: \.self) { style in
                        if let count = distribution[style], count > 0 {
                            StyleDistributionRow(
                                style: style,
                                count: count,
                                total: total
                            )
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(ColorManager.cardGradient)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
        )
    }
}

struct StyleDistributionRow: View {
    let style: WatchStyle
    let count: Int
    let total: Int
    
    var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(count) / Double(total) * 100
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(style.displayName)
                    .font(.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                
                Spacer()
                
                Text("\(count)")
                    .font(.playfairDisplay(size: 14, weight: .medium))
                    .foregroundColor(ColorManager.lightBlue)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(ColorManager.secondaryText.opacity(0.2))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [ColorManager.lightBlue, ColorManager.orange],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * CGFloat(percentage / 100), height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
            
            Text(String(format: "%.0f%%", percentage))
                .font(.playfairDisplay(size: 12, weight: .regular))
                .foregroundColor(ColorManager.secondaryText)
        }
    }
}

struct ConditionDistributionSection: View {
    let distribution: [WatchCondition: Int]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Condition Overview")
                .font(.playfairDisplay(size: 20, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
            
            if distribution.isEmpty {
                Text("No watches added yet")
                    .font(.playfairDisplay(size: 14, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 12) {
                    ForEach(WatchCondition.allCases, id: \.self) { condition in
                        if let count = distribution[condition], count > 0 {
                            ConditionDistributionRow(
                                condition: condition,
                                count: count
                            )
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(ColorManager.cardGradient)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorManager.orange.opacity(0.3), lineWidth: 1)
        )
    }
}

struct ConditionDistributionRow: View {
    let condition: WatchCondition
    let count: Int
    
    var conditionColor: Color {
        switch condition {
        case .new:
            return ColorManager.green
        case .excellent:
            return ColorManager.lightBlue
        case .good:
            return ColorManager.orange
        case .wornSigns:
            return ColorManager.red
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(conditionColor)
                .frame(width: 12, height: 12)
            
            Text(condition.displayName)
                .font(.playfairDisplay(size: 16, weight: .regular))
                .foregroundColor(ColorManager.primaryText)
            
            Spacer()
            
            Text("\(count)")
                .font(.playfairDisplay(size: 16, weight: .semibold))
                .foregroundColor(conditionColor)
        }
        .padding(.vertical, 8)
    }
}

struct RecentActivitySection: View {
    @ObservedObject var viewModel: WatchViewModel
    let recentWearingDays: [WearingDay]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(.playfairDisplay(size: 20, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
            
            if recentWearingDays.isEmpty {
                Text("No recent wearing activity")
                    .font(.playfairDisplay(size: 14, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 12) {
                    ForEach(recentWearingDays) { wearingDay in
                        if let watch = viewModel.getWatch(by: wearingDay.watchId) {
                            RecentActivityRow(
                                watch: watch,
                                date: wearingDay.date
                            )
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(ColorManager.cardGradient)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorManager.green.opacity(0.3), lineWidth: 1)
        )
    }
}

struct RecentActivityRow: View {
    let watch: Watch
    let date: Date
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "applewatch")
                .font(.system(size: 16))
                .foregroundColor(ColorManager.lightBlue)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(ColorManager.lightBlue.opacity(0.2))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(watch.name)
                    .font(.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                    .lineLimit(1)
                
                Text(formatDate(date))
                    .font(.playfairDisplay(size: 12, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

#Preview {
    StatisticsView()
}
