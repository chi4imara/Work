import SwiftUI

struct StatisticsView: View {
    @ObservedObject var catalogViewModel: CatalogViewModel
    
    private var totalItems: Int {
        catalogViewModel.items.count
    }
    
    private var itemsThisWeek: Int {
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return catalogViewModel.items.filter { $0.dateCreated >= oneWeekAgo }.count
    }
    
    private var itemsThisMonth: Int {
        let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        return catalogViewModel.items.filter { $0.dateCreated >= oneMonthAgo }.count
    }
    
    private var averageTextLength: Double {
        guard !catalogViewModel.items.isEmpty else { return 0 }
        let totalLength = catalogViewModel.items.reduce(0) { $0 + $1.text.count }
        return Double(totalLength) / Double(catalogViewModel.items.count)
    }
    
    private var longestItem: CatalogItem? {
        catalogViewModel.items.max(by: { $0.text.count < $1.text.count })
    }
    
    private var itemsByDayOfWeek: [Int: Int] {
        var counts: [Int: Int] = [:]
        let calendar = Calendar.current
        
        for item in catalogViewModel.items {
            let weekday = calendar.component(.weekday, from: item.dateCreated)
            counts[weekday, default: 0] += 1
        }
        
        return counts
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Statistics")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 20) {
                        OverviewStatsCard(
                            totalItems: totalItems,
                            itemsThisWeek: itemsThisWeek,
                            itemsThisMonth: itemsThisMonth
                        )
                        
                        ActivityStatsCard(itemsByDayOfWeek: itemsByDayOfWeek)
                        
                        TextStatsCard(
                            averageLength: averageTextLength,
                            longestItem: longestItem
                        )
                        
                        TimelineStatsCard(items: catalogViewModel.items)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
    }
}

struct OverviewStatsCard: View {
    let totalItems: Int
    let itemsThisWeek: Int
    let itemsThisMonth: Int
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Overview")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 16) {
                StatisticBox(
                    value: "\(totalItems)",
                    label: "Total Items",
                    icon: "list.bullet",
                    color: AppColors.accent
                )
                
                StatisticBox(
                    value: "\(itemsThisWeek)",
                    label: "This Week",
                    icon: "calendar",
                    color: AppColors.lightGreen
                )
                
                StatisticBox(
                    value: "\(itemsThisMonth)",
                    label: "This Month",
                    icon: "calendar.badge.clock",
                    color: AppColors.lavender
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
}

struct StatisticBox: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(color)
            
            Text(label)
                .font(.ubuntu(12, weight: .regular))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
        )
    }
}

struct ActivityStatsCard: View {
    let itemsByDayOfWeek: [Int: Int]
    
    private let dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    private var maxCount: Int {
        itemsByDayOfWeek.values.max() ?? 1
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Activity by Day")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(1...7, id: \.self) { dayIndex in
                    VStack(spacing: 8) {
                        let count = itemsByDayOfWeek[dayIndex] ?? 0
                        let height = maxCount > 0 ? CGFloat(count) / CGFloat(maxCount) * 100 : 0
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        AppColors.accent,
                                        AppColors.accentSecondary
                                    ],
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            )
                            .frame(height: max(height, 4))
                        
                        Text(dayNames[dayIndex - 1])
                            .font(.ubuntu(10, weight: .regular))
                            .foregroundColor(AppColors.secondaryText)
                        
                        if count > 0 {
                            Text("\(count)")
                                .font(.ubuntu(10, weight: .medium))
                                .foregroundColor(AppColors.accent)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 120, alignment: .bottom)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
}

struct TextStatsCard: View {
    let averageLength: Double
    let longestItem: CatalogItem?
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Text Statistics")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Average Length")
                            .font(.ubuntu(14, weight: .regular))
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text("\(Int(averageLength)) characters")
                            .font(.ubuntu(18, weight: .bold))
                            .foregroundColor(AppColors.accent)
                    }
                    
                    Spacer()
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground.opacity(0.5))
                )
                
                if let longest = longestItem {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Longest Item")
                            .font(.ubuntu(14, weight: .regular))
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text(longest.text)
                            .font(.ubuntu(14, weight: .regular))
                            .foregroundColor(AppColors.primaryText)
                            .lineLimit(2)
                        
                        Text("\(longest.text.count) characters")
                            .font(.ubuntu(12, weight: .light))
                            .foregroundColor(AppColors.accent)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.cardBackground.opacity(0.5))
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
}

struct TimelineStatsCard: View {
    let items: [CatalogItem]
    
    private var itemsByMonth: [(month: Date, count: Int)] {
        let calendar = Calendar.current
        var grouped: [Date: Int] = [:]
        
        for item in items {
            let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: item.dateCreated)) ?? item.dateCreated
            grouped[monthStart, default: 0] += 1
        }
        
        return grouped.map { (month: $0.key, count: $0.value) }
            .sorted(by: { $0.month > $1.month })
            .prefix(6)
            .map { $0 }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Timeline")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if itemsByMonth.isEmpty {
                Text("No data yet")
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 12) {
                    ForEach(Array(itemsByMonth.enumerated()), id: \.offset) { _, item in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.month, formatter: monthFormatter)
                                    .font(.ubuntu(14, weight: .medium))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Text("\(item.count) item\(item.count == 1 ? "" : "s")")
                                    .font(.ubuntu(12, weight: .regular))
                                    .foregroundColor(AppColors.secondaryText)
                            }
                            
                            Spacer()
                            
                            RoundedRectangle(cornerRadius: 2)
                                .fill(AppColors.accent)
                                .frame(width: CGFloat(item.count) * 4, height: 8)
                                .frame(maxWidth: 100)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
}

#Preview {
    StatisticsView(catalogViewModel: CatalogViewModel())
}
