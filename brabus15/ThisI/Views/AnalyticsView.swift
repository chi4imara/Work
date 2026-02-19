import SwiftUI

struct AnalyticsView: View {
    @EnvironmentObject var viewModel: DecisionViewModel
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Analytics")
                        .font(DesignSystem.Typography.largeTitle)
                        .foregroundColor(DesignSystem.Colors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.decisions.isEmpty {
                    VStack(spacing: DesignSystem.Spacing.lg) {
                        Spacer()
                        
                        Image(systemName: "chart.bar.xaxis")
                            .font(.system(size: 60))
                            .foregroundColor(DesignSystem.Colors.yellow.opacity(0.7))
                        
                        Text("No data to analyze yet")
                            .font(DesignSystem.Typography.body)
                            .foregroundColor(DesignSystem.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                        
                        Text("Add some decisions to see your patterns")
                            .font(DesignSystem.Typography.callout)
                            .foregroundColor(DesignSystem.Colors.placeholderText)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: DesignSystem.Spacing.lg) {
                            AnalyticsCard(
                                title: "Total Decisions",
                                value: "\(viewModel.decisions.count)",
                                icon: "list.number",
                                color: DesignSystem.Colors.yellow
                            )
                            
                            AnalyticsCard(
                                title: "This Month",
                                value: "\(decisionsThisMonth)",
                                icon: "calendar",
                                color: DesignSystem.Colors.success
                            )
                            
                            AnalyticsCard(
                                title: "Average per Month",
                                value: String(format: "%.1f", averagePerMonth),
                                icon: "chart.line.uptrend.xyaxis",
                                color: DesignSystem.Colors.primaryBlue
                            )
                            
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                                Text("Decisions Over Time")
                                    .font(DesignSystem.Typography.headline)
                                    .foregroundColor(DesignSystem.Colors.primaryText)
                                
                                MonthlyDecisionsChart(decisions: viewModel.decisions)
                                    .frame(height: 200)
                            }
                            .padding(DesignSystem.Spacing.md)
                            .background(DesignSystem.Colors.cardBackground)
                            .cornerRadius(DesignSystem.CornerRadius.medium)
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                    .stroke(DesignSystem.Colors.yellow.opacity(0.3), lineWidth: 1)
                            )
                            
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                                Text("Decisions by Day of Week")
                                    .font(DesignSystem.Typography.headline)
                                    .foregroundColor(DesignSystem.Colors.primaryText)
                                
                                WeeklyDecisionsChart(decisions: viewModel.decisions)
                                    .frame(height: 180)
                            }
                            .padding(DesignSystem.Spacing.md)
                            .background(DesignSystem.Colors.cardBackground)
                            .cornerRadius(DesignSystem.CornerRadius.medium)
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                    .stroke(DesignSystem.Colors.yellow.opacity(0.3), lineWidth: 1)
                            )
                            
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                                Text("Recent Activity")
                                    .font(DesignSystem.Typography.headline)
                                    .foregroundColor(DesignSystem.Colors.primaryText)
                                
                                ForEach(recentDecisions.prefix(3)) { decision in
                                    RecentActivityRow(decision: decision)
                                }
                            }
                            .padding(DesignSystem.Spacing.md)
                            .background(DesignSystem.Colors.cardBackground)
                            .cornerRadius(DesignSystem.CornerRadius.medium)
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                    .stroke(DesignSystem.Colors.yellow.opacity(0.3), lineWidth: 1)
                            )
                        }
                        .padding(.horizontal, DesignSystem.Spacing.lg)
                        .padding(.vertical, DesignSystem.Spacing.lg)
                    }
                }
            }
        }
    }
    
    private var decisionsThisMonth: Int {
        let calendar = Calendar.current
        let now = Date()
        return viewModel.decisions.filter { decision in
            calendar.isDate(decision.date, equalTo: now, toGranularity: .month)
        }.count
    }
    
    private var averagePerMonth: Double {
        guard !viewModel.decisions.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let sortedDecisions = viewModel.decisions.sorted { $0.date < $1.date }
        
        guard let firstDate = sortedDecisions.first?.date,
              let lastDate = sortedDecisions.last?.date else { return 0 }
        
        let monthsDifference = calendar.dateComponents([.month], from: firstDate, to: lastDate).month ?? 0
        let totalMonths = max(monthsDifference + 1, 1)
        
        return Double(viewModel.decisions.count) / Double(totalMonths)
    }
    
    private var recentDecisions: [Decision] {
        viewModel.decisions.sorted { $0.date > $1.date }
    }
}

struct AnalyticsCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.md) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(Color.white)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.2))
                .cornerRadius(DesignSystem.CornerRadius.small)
            
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                Text(title)
                    .font(DesignSystem.Typography.callout)
                    .foregroundColor(DesignSystem.Colors.secondaryText)
                
                Text(value)
                    .font(DesignSystem.Typography.title)
                    .foregroundColor(DesignSystem.Colors.primaryText)
            }
            
            Spacer()
        }
        .padding(DesignSystem.Spacing.md)
        .background(DesignSystem.Colors.cardBackground)
        .cornerRadius(DesignSystem.CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

struct RecentActivityRow: View {
    let decision: Decision
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.sm) {
            Circle()
                .fill(DesignSystem.Colors.yellow)
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(decision.shortDescription)
                    .font(DesignSystem.Typography.callout)
                    .foregroundColor(DesignSystem.Colors.primaryText)
                    .lineLimit(1)
                
                Text(decision.formattedDate)
                    .font(DesignSystem.Typography.caption2)
                    .foregroundColor(DesignSystem.Colors.secondaryText)
            }
            
            Spacer()
        }
    }
}

struct MonthlyDecisionsChart: View {
    let decisions: [Decision]
    
    private var monthlyData: [(month: String, count: Int)] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: decisions) { decision in
            calendar.dateComponents([.year, .month], from: decision.date)
        }
        
        let allMonths = grouped.map { (components, decisions) -> (date: Date, month: String, count: Int) in
            let monthDate = calendar.date(from: components) ?? Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM"
            return (date: monthDate, month: formatter.string(from: monthDate), count: decisions.count)
        }
        
        return allMonths
            .sorted { $0.date < $1.date }
            .map { (month: $0.month, count: $0.count) }
    }
    
    private var maxCount: Int {
        monthlyData.map { $0.count }.max() ?? 1
    }
    
    var body: some View {
        if monthlyData.isEmpty {
            VStack {
                Text("No data available")
                    .font(DesignSystem.Typography.caption)
                    .foregroundColor(DesignSystem.Colors.secondaryText)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            VStack(spacing: DesignSystem.Spacing.sm) {
                HStack(alignment: .bottom, spacing: DesignSystem.Spacing.xs) {
                    ForEach(monthlyData, id: \.month) { data in
                        VStack(spacing: DesignSystem.Spacing.xs) {
                            Text("\(data.count)")
                                .font(DesignSystem.Typography.caption2)
                                .foregroundColor(DesignSystem.Colors.primaryText)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            DesignSystem.Colors.yellow,
                                            DesignSystem.Colors.yellow.opacity(0.7)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(height: maxCount > 0 ? CGFloat(data.count) / CGFloat(maxCount) * 120 : 0)
                                .shadow(color: DesignSystem.Colors.yellow.opacity(0.3), radius: 2, x: 0, y: 1)
                            
                            Text(data.month)
                                .font(DesignSystem.Typography.caption2)
                                .foregroundColor(DesignSystem.Colors.secondaryText)
                                .frame(width: 30)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .frame(height: 150)
            }
        }
    }
}

struct WeeklyDecisionsChart: View {
    let decisions: [Decision]
    
    private let weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    private var weeklyData: [(day: String, count: Int)] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: decisions) { decision in
            let weekday = calendar.component(.weekday, from: decision.date)
            return weekday == 1 ? 7 : weekday - 1
        }
        
        return weekdays.enumerated().map { index, day in
            let weekdayIndex = index + 1
            let count = grouped[weekdayIndex]?.count ?? 0
            return (day: day, count: count)
        }
    }
    
    private var maxCount: Int {
        weeklyData.map { $0.count }.max() ?? 1
    }
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            HStack(alignment: .bottom, spacing: DesignSystem.Spacing.xs) {
                ForEach(weeklyData, id: \.day) { data in
                    VStack(spacing: DesignSystem.Spacing.xs) {
                        Text("\(data.count)")
                            .font(DesignSystem.Typography.caption2)
                            .foregroundColor(DesignSystem.Colors.primaryText)
                        
                        RoundedRectangle(cornerRadius: 6)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        DesignSystem.Colors.success,
                                        DesignSystem.Colors.success.opacity(0.6)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 30, height: maxCount > 0 ? CGFloat(data.count) / CGFloat(maxCount) * 100 : 0)
                            .shadow(color: DesignSystem.Colors.success.opacity(0.3), radius: 2, x: 0, y: 1)
                        
                        Text(data.day)
                            .font(DesignSystem.Typography.caption2)
                            .foregroundColor(DesignSystem.Colors.secondaryText)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
                .frame(height: 130)
        }
    }
}

#Preview {
    AnalyticsView()
        .environmentObject(DecisionViewModel())
}
