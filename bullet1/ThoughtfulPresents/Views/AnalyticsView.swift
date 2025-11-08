import SwiftUI
import Charts

struct AnalyticsView: View {
    @ObservedObject var viewModel: GiftIdeaViewModel
    @State private var selectedTimeRange: TimeRange = .all
    @State private var selectedChartType: ChartType = .status
    
    enum TimeRange: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
        case all = "All Time"
        
        var icon: String {
            switch self {
            case .week: return "calendar"
            case .month: return "calendar.badge.clock"
            case .year: return "calendar.badge.plus"
            case .all: return "infinity"
            }
        }
    }
    
    enum ChartType: String, CaseIterable {
        case status = "By Status"
        case occasion = "By Occasion"
        case spending = "Spending"
        
        var icon: String {
            switch self {
            case .status: return "chart.pie"
            case .occasion: return "chart.bar"
            case .spending: return "chart.line.uptrend.xyaxis"
            }
        }
    }
    
    var filteredGifts: [GiftIdea] {
        let now = Date()
        let calendar = Calendar.current
        
        switch selectedTimeRange {
        case .week:
            let weekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now
            return viewModel.giftIdeas.filter { $0.dateAdded >= weekAgo }
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            return viewModel.giftIdeas.filter { $0.dateAdded >= monthAgo }
        case .year:
            let yearAgo = calendar.date(byAdding: .year, value: -1, to: now) ?? now
            return viewModel.giftIdeas.filter { $0.dateAdded >= yearAgo }
        case .all:
            return viewModel.giftIdeas
        }
    }
    
    var body: some View {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.theme.backgroundGradientStart, Color.theme.backgroundGradientEnd]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        HStack {
                            Text("Analytics")
                                .font(AppFonts.largeTitle)
                                .foregroundColor(Color.theme.primaryText)
                            
                            Spacer()
                        }
                        .padding(.top)
                        
                        TimeRangeSelector(selectedRange: $selectedTimeRange)
                        
                        KeyMetricsView(gifts: filteredGifts)
                        
                        ChartTypeSelector(selectedType: $selectedChartType)
                        
                        switch selectedChartType {
                        case .status:
                            StatusChartView(gifts: filteredGifts)
                        case .occasion:
                            OccasionChartView(gifts: filteredGifts)
                        case .spending:
                            SpendingChartView(gifts: filteredGifts)
                        }
                        
                        TopRecipientsView(gifts: filteredGifts)
                        
                        RecentActivityView(gifts: filteredGifts)
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
            }
    }
}

struct TimeRangeSelector: View {
    @Binding var selectedRange: AnalyticsView.TimeRange
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Time Range")
                .font(.theme.title3)
                .foregroundColor(Color.theme.primaryText)
            
            HStack(spacing: 8) {
                ForEach(AnalyticsView.TimeRange.allCases, id: \.self) { range in
                    Button(action: { selectedRange = range }) {
                        HStack(spacing: 4) {
                            Image(systemName: range.icon)
                                .font(.caption)
                            Text(range.rawValue)
                                .font(.theme.caption)
                        }
                        .foregroundColor(selectedRange == range ? .white : Color.theme.primaryBlue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(selectedRange == range ? Color.theme.primaryBlue : Color.theme.cardBackground)
                        .cornerRadius(12)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .concaveCard(cornerRadius: 16, depth: 3, color: Color.theme.cardBackground)
    }
}

struct KeyMetricsView: View {
    let gifts: [GiftIdea]
    
    private var metrics: (total: Int, totalSpent: Double, averageSpent: Double, completionRate: Double) {
        let total = gifts.count
        let totalSpent = gifts.filter { $0.status != .idea }.compactMap { $0.estimatedPrice }.reduce(0, +)
        let averageSpent = totalSpent / Double(max(gifts.filter { $0.status != .idea }.count, 1))
        let completionRate = Double(gifts.filter { $0.status != .idea }.count) / Double(max(total, 1)) * 100
        
        return (total, totalSpent, averageSpent, completionRate)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Key Metrics")
                .font(.theme.title3)
                .foregroundColor(Color.theme.primaryText)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                MetricCard(
                    title: "Total Gifts",
                    value: "\(metrics.total)",
                    icon: "gift",
                    color: Color.theme.primaryBlue
                )
                
                MetricCard(
                    title: "Total Spent",
                    value: String(format: "$%.0f", metrics.totalSpent),
                    icon: "dollarsign.circle",
                    color: Color.theme.boughtColor
                )
                
                MetricCard(
                    title: "Avg. Price",
                    value: String(format: "$%.0f", metrics.averageSpent),
                    icon: "chart.bar",
                    color: Color.theme.accentOrange
                )
                
                MetricCard(
                    title: "Completion",
                    value: String(format: "%.0f%%", metrics.completionRate),
                    icon: "checkmark.circle",
                    color: Color.theme.successGreen
                )
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .concaveCard(cornerRadius: 16, depth: 3, color: Color.theme.cardBackground)
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.theme.title2)
                .foregroundColor(Color.theme.primaryText)
            
            Text(title)
                .font(.theme.caption)
                .foregroundColor(Color.theme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.5))
        .cornerRadius(12)
    }
}

struct ChartTypeSelector: View {
    @Binding var selectedType: AnalyticsView.ChartType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Chart Type")
                .font(.theme.title3)
                .foregroundColor(Color.theme.primaryText)
            
            HStack(spacing: 8) {
                ForEach(AnalyticsView.ChartType.allCases, id: \.self) { type in
                    Button(action: { selectedType = type }) {
                        HStack(spacing: 4) {
                            Image(systemName: type.icon)
                                .font(.caption)
                            Text(type.rawValue)
                                .font(.theme.caption)
                        }
                        .foregroundColor(selectedType == type ? .white : Color.theme.primaryBlue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(selectedType == type ? Color.theme.primaryBlue : Color.theme.cardBackground)
                        .cornerRadius(12)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .concaveCard(cornerRadius: 16, depth: 3, color: Color.theme.cardBackground)
    }
}

struct StatusChartView: View {
    let gifts: [GiftIdea]
    
    private var statusData: [(String, Int, Color)] {
        let statusCounts = Dictionary(grouping: gifts, by: { $0.status.displayName })
        return [
            ("Ideas", statusCounts["Idea"]?.count ?? 0, Color.theme.ideaColor),
            ("Bought", statusCounts["Bought"]?.count ?? 0, Color.theme.boughtColor),
            ("Gifted", statusCounts["Gifted"]?.count ?? 0, Color.theme.giftedColor)
        ]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Gifts by Status")
                .font(.theme.title3)
                .foregroundColor(Color.theme.primaryText)
            
            VStack(spacing: 12) {
                ForEach(statusData, id: \.0) { status, count, color in
                    HStack {
                        Circle()
                            .fill(color)
                            .frame(width: 12, height: 12)
                        
                        Text(status)
                            .font(.theme.body)
                            .foregroundColor(Color.theme.primaryText)
                        
                        Spacer()
                        
                        Text("\(count)")
                            .font(.theme.headline)
                            .foregroundColor(Color.theme.primaryBlue)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .concaveCard(cornerRadius: 16, depth: 3, color: Color.theme.cardBackground)
    }
}

struct OccasionChartView: View {
    let gifts: [GiftIdea]
    
    private var occasionData: [(String, Int)] {
        let occasionCounts = Dictionary(grouping: gifts.compactMap { $0.occasion }, by: { $0.displayName })
        return occasionCounts.map { ($0.key, $0.value.count) }.sorted { $0.1 > $1.1 }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Gifts by Occasion")
                .font(.theme.title3)
                .foregroundColor(Color.theme.primaryText)
            
            VStack(spacing: 12) {
                ForEach(occasionData, id: \.0) { occasion, count in
                    HStack {
                        Text(occasion)
                            .font(.theme.body)
                            .foregroundColor(Color.theme.primaryText)
                        
                        Spacer()
                        
                        Text("\(count)")
                            .font(.theme.headline)
                            .foregroundColor(Color.theme.primaryBlue)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .concaveCard(cornerRadius: 16, depth: 3, color: Color.theme.cardBackground)
    }
}

struct SpendingChartView: View {
    let gifts: [GiftIdea]
    
    private var spendingData: [(String, Double)] {
        let peopleSpending = Dictionary(grouping: gifts.compactMap { $0.estimatedPrice != nil ? ($0.recipientName, $0.estimatedPrice!) : nil }, by: { $0.0 })
        return peopleSpending.map { (person, amounts) in
            (person, amounts.map { $0.1 }.reduce(0, +))
        }.sorted { $0.1 > $1.1 }.prefix(5).map { ($0.0, $0.1) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Top Spenders")
                .font(.theme.title3)
                .foregroundColor(Color.theme.primaryText)
            
            VStack(spacing: 12) {
                ForEach(Array(spendingData.enumerated()), id: \.offset) { index, data in
                    HStack {
                        Text("\(index + 1).")
                            .font(.theme.caption)
                            .foregroundColor(Color.theme.secondaryText)
                            .frame(width: 20, alignment: .leading)
                        
                        Text(data.0)
                            .font(.theme.body)
                            .foregroundColor(Color.theme.primaryText)
                        
                        Spacer()
                        
                        Text(String(format: "$%.0f", data.1))
                            .font(.theme.headline)
                            .foregroundColor(Color.theme.primaryBlue)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .concaveCard(cornerRadius: 16, depth: 3, color: Color.theme.cardBackground)
    }
}

struct TopRecipientsView: View {
    let gifts: [GiftIdea]
    
    private var recipients: [(String, Int)] {
        let recipientCounts = Dictionary(grouping: gifts, by: { $0.recipientName })
        return recipientCounts.map { ($0.key, $0.value.count) }.sorted { $0.1 > $1.1 }.prefix(5).map { ($0.0, $0.1) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Top Recipients")
                .font(.theme.title3)
                .foregroundColor(Color.theme.primaryText)
            
            VStack(spacing: 12) {
                ForEach(Array(recipients.enumerated()), id: \.offset) { index, recipient in
                    HStack {
                        Text("\(index + 1).")
                            .font(.theme.caption)
                            .foregroundColor(Color.theme.secondaryText)
                            .frame(width: 20, alignment: .leading)
                        
                        Text(recipient.0)
                            .font(.theme.body)
                            .foregroundColor(Color.theme.primaryText)
                        
                        Spacer()
                        
                        Text("\(recipient.1) gifts")
                            .font(.theme.caption)
                            .foregroundColor(Color.theme.secondaryText)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .concaveCard(cornerRadius: 16, depth: 3, color: Color.theme.cardBackground)
    }
}

struct RecentActivityView: View {
    let gifts: [GiftIdea]
    
    private var recentGifts: [GiftIdea] {
        gifts.sorted { $0.dateAdded > $1.dateAdded }.prefix(5).map { $0 }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(.theme.title3)
                .foregroundColor(Color.theme.primaryText)
            
            VStack(spacing: 12) {
                ForEach(recentGifts) { gift in
                    HStack {
                        Circle()
                            .fill(statusColor(for: gift.status))
                            .frame(width: 8, height: 8)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(gift.recipientName)
                                .font(.theme.body)
                                .foregroundColor(Color.theme.primaryText)
                            
                            Text(gift.giftDescription)
                                .font(.theme.caption)
                                .foregroundColor(Color.theme.secondaryText)
                                .lineLimit(1)
                        }
                        
                        Spacer()
                        
                        Text(gift.dateAdded, style: .relative)
                            .font(.theme.caption2)
                            .foregroundColor(Color.theme.secondaryText)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .concaveCard(cornerRadius: 16, depth: 3, color: Color.theme.cardBackground)
    }
    
    private func statusColor(for status: GiftStatus) -> Color {
        switch status {
        case .idea:
            return Color.theme.ideaColor
        case .bought:
            return Color.theme.boughtColor
        case .gifted:
            return Color.theme.giftedColor
        }
    }
}

