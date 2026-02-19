import SwiftUI
import Charts

struct StatisticsView: View {
    @ObservedObject var eventStore: EventStore
    
    private var totalEvents: Int {
        eventStore.events.count
    }
    
    private var eventsThisMonth: Int {
        let calendar = Calendar.current
        let now = Date()
        return eventStore.events.filter { calendar.isDate($0.date, equalTo: now, toGranularity: .month) }.count
    }
    
    private var eventsThisYear: Int {
        let calendar = Calendar.current
        let now = Date()
        return eventStore.events.filter { calendar.isDate($0.date, equalTo: now, toGranularity: .year) }.count
    }
    
    private var oldestEventDate: Date? {
        eventStore.events.min(by: { $0.date < $1.date })?.date
    }
    
    private var mostRecentEventDate: Date? {
        eventStore.events.max(by: { $0.date < $1.date })?.date
    }
    
    /// Last 6 months with event count for the chart.
    private var eventsByMonth: [MonthChartItem] {
        let calendar = Calendar.current
        let now = Date()
        var result: [MonthChartItem] = []
        
        for monthOffset in (0..<6).reversed() {
            guard let monthStart = calendar.date(byAdding: .month, value: -monthOffset, to: now),
                  let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: monthStart)) else { continue }
            
            let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) ?? startOfMonth
            let count = eventStore.events.filter { event in
                event.date >= startOfMonth && event.date <= endOfMonth
            }.count
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM"
            let label = formatter.string(from: startOfMonth)
            
            result.append(MonthChartItem(monthStart: startOfMonth, label: label, count: count))
        }
        
        return result
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GridBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Text("Statistics")
                            .font(AppFonts.title(32))
                            .foregroundColor(AppColors.primaryWhite)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    if eventStore.events.isEmpty {
                        emptyState
                    } else {
                        statsCards
                        eventsChartSection
                        timelineSummary
                    }
                }
                .padding(.bottom, 100)
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 24) {
            Image(systemName: "chart.bar.doc.horizontal")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(AppColors.primaryWhite.opacity(0.5))
            
            Text("No events yet. Add events to see statistics.")
                .font(AppFonts.body(16))
                .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
    
    private var statsCards: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                StatCardView(
                    title: "Total",
                    value: "\(totalEvents)",
                    subtitle: "events",
                    icon: "list.bullet.clipboard"
                )
                
                StatCardView(
                    title: "This month",
                    value: "\(eventsThisMonth)",
                    subtitle: "events",
                    icon: "calendar"
                )
            }
            .padding(.horizontal, 20)
            
            HStack(spacing: 16) {
                StatCardView(
                    title: "This year",
                    value: "\(eventsThisYear)",
                    subtitle: "events",
                    icon: "calendar.badge.clock"
                )
                
                StatCardView(
                    title: "Average",
                    value: averagePerMonth,
                    subtitle: "per month",
                    icon: "chart.line.uptrend.xyaxis"
                )
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var averagePerMonth: String {
        guard totalEvents > 0, let oldest = oldestEventDate, let newest = mostRecentEventDate else {
            return "0"
        }
        let months = max(1, Calendar.current.dateComponents([.month], from: oldest, to: newest).month ?? 1)
        let avg = Double(totalEvents) / Double(months)
        return String(format: "%.1f", avg)
    }
    
    private var eventsChartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Events per month")
                .font(AppFonts.caption(14))
                .foregroundColor(AppColors.primaryWhite.opacity(0.7))
                .textCase(.uppercase)
            
            Chart(eventsByMonth) { item in
                BarMark(
                    x: .value("Month", item.label),
                    y: .value("Count", item.count)
                )
                .foregroundStyle(AppColors.primaryYellow)
                .cornerRadius(4)
            }
            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(AppColors.primaryWhite.opacity(0.2))
                    AxisValueLabel()
                        .foregroundStyle(AppColors.primaryWhite.opacity(0.8))
                        .font(Font.ubuntu(12, weight: .regular))
                }
            }
            .chartXAxis {
                AxisMarks { _ in
                    AxisValueLabel()
                        .foregroundStyle(AppColors.primaryWhite.opacity(0.8))
                        .font(Font.ubuntu(12, weight: .regular))
                }
            }
            .frame(height: 200)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: AppConstants.cornerRadius)
                    .fill(AppColors.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppConstants.cornerRadius)
                            .stroke(AppColors.primaryWhite.opacity(0.1), lineWidth: 1)
                    )
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
    
    private var timelineSummary: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Timeline range")
                .font(AppFonts.caption(14))
                .foregroundColor(AppColors.primaryWhite.opacity(0.7))
                .textCase(.uppercase)
            
            HStack(spacing: 12) {
                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.primaryYellow)
                
                if let oldest = oldestEventDate, let newest = mostRecentEventDate {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(formattedShort(oldest))
                            .font(AppFonts.caption(14))
                            .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                        Text(formattedShort(newest))
                            .font(AppFonts.caption(14))
                            .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                    }
                } else {
                    Text("Single event")
                        .font(AppFonts.body(14))
                        .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: AppConstants.cornerRadius)
                    .fill(AppColors.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppConstants.cornerRadius)
                            .stroke(AppColors.primaryWhite.opacity(0.1), lineWidth: 1)
                    )
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
    
    private func formattedShort(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "MMM d, yyyy"
        return f.string(from: date        )
    }
}

struct MonthChartItem: Identifiable {
    let id = UUID()
    let monthStart: Date
    let label: String
    let count: Int
}

struct StatCardView: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.primaryYellow)
                
                Spacer()
            }
            
            Text(value)
                .font(AppFonts.title(28))
                .foregroundColor(AppColors.primaryWhite)
            
            Text(subtitle)
                .font(AppFonts.caption(12))
                .foregroundColor(AppColors.primaryWhite.opacity(0.7))
            
            Text(title)
                .font(AppFonts.caption(12))
                .foregroundColor(AppColors.primaryWhite.opacity(0.5))
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppConstants.cornerRadius)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: AppConstants.cornerRadius)
                        .stroke(AppColors.primaryWhite.opacity(0.1), lineWidth: 1)
                )
        )
    }
}
