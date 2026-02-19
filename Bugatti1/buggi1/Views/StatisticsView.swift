import SwiftUI
import Charts

struct StatisticsView: View {
    @ObservedObject var viewModel: ConversationViewModel
    @State private var isAnimating = false
    
    private var totalCount: Int {
        viewModel.conversations.count
    }
    
    private var thisWeekCount: Int {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) ?? Date()
        return viewModel.conversations.filter { $0.createdAt >= startOfWeek }.count
    }
    
    private var thisMonthCount: Int {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date())) ?? Date()
        return viewModel.conversations.filter { $0.createdAt >= startOfMonth }.count
    }
    
    private var uniquePeopleCount: Int {
        Set(viewModel.conversations.map { $0.personName }).count
    }
    
    private var dailyCounts: [(date: Date, count: Int)] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (0..<7).reversed().compactMap { offset -> (Date, Int)? in
            guard let day = calendar.date(byAdding: .day, value: -offset, to: today) else { return nil }
            let count = viewModel.conversations.filter { calendar.isDate($0.createdAt, inSameDayAs: day) }.count
            return (day, count)
        }
    }
    
    private var topPeopleCounts: [(name: String, count: Int)] {
        let grouped = Dictionary(grouping: viewModel.conversations, by: { $0.personName })
        return grouped
            .map { ($0.key, $0.value.count) }
            .sorted { $0.1 > $1.1 }
            .prefix(5)
            .map { (name: $0.0, count: $0.1) }
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.hasConversations {
                    statisticsContent
                } else {
                    emptyStateView
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                isAnimating = true
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: AppSpacing.md) {
            HStack {
                Text("Statistics")
                    .font(AppFonts.title(24))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.top, AppSpacing.md)
            
            Divider()
                .background(AppColors.textTertiary)
        }
        .offset(y: isAnimating ? 0 : -50)
        .opacity(isAnimating ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.8), value: isAnimating)
    }
    
    private var statisticsContent: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                StatCardView(
                    title: "Total conversations",
                    value: "\(totalCount)",
                    icon: "bubble.left.and.bubble.right.fill",
                    color: Color.purple,
                    animationDelay: 0.2,
                    isAnimating: isAnimating
                )
                
                StatCardView(
                    title: "This week",
                    value: "\(thisWeekCount)",
                    icon: "calendar",
                    color: AppColors.secondary,
                    animationDelay: 0.3,
                    isAnimating: isAnimating
                )
                
                StatCardView(
                    title: "This month",
                    value: "\(thisMonthCount)",
                    icon: "calendar.circle.fill",
                    color: AppColors.accent,
                    animationDelay: 0.4,
                    isAnimating: isAnimating
                )
                
                StatCardView(
                    title: "Unique people",
                    value: "\(uniquePeopleCount)",
                    icon: "person.2.fill",
                    color: AppColors.success,
                    animationDelay: 0.5,
                    isAnimating: isAnimating
                )
                
                dailyChartSection
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.lg)
        }
    }
    
    private var dailyChartSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Conversations per day")
                .font(AppFonts.headline(16))
                .foregroundColor(AppColors.textPrimary)
            
            Chart(dailyCounts, id: \.date) { item in
                BarMark(
                    x: .value("Day", item.date),
                    y: .value("Count", item.count)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [AppColors.secondary, AppColors.warning],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .cornerRadius(4)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { _ in
                    AxisValueLabel(format: .dateTime.day().month(.abbreviated))
                        .foregroundStyle(AppColors.textSecondary)
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(AppColors.textTertiary.opacity(0.5))
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                    AxisValueLabel()
                        .foregroundStyle(AppColors.textSecondary)
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(AppColors.textTertiary.opacity(0.5))
                }
            }
            .frame(height: 200)
        }
        .padding(AppSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.md)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppCornerRadius.md)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
        .offset(y: isAnimating ? 0 : 50)
        .opacity(isAnimating ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.6).delay(0.6), value: isAnimating)
    }
    
    private var topPeopleChartSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Conversations by person (top 5)")
                .font(AppFonts.headline(16))
                .foregroundColor(AppColors.textPrimary)
            
            if topPeopleCounts.isEmpty {
                Text("No data")
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.textSecondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 160)
            } else {
                Chart(topPeopleCounts, id: \.name) { item in
                    BarMark(
                        x: .value("Count", item.count),
                        y: .value("Person", item.name)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [AppColors.primary, AppColors.accent],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(4)
                }
                .chartXAxis {
                    AxisMarks { _ in
                        AxisValueLabel()
                            .foregroundStyle(AppColors.textSecondary)
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                            .foregroundStyle(AppColors.textTertiary.opacity(0.5))
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { _ in
                        AxisValueLabel()
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
                .frame(height: max(160, CGFloat(topPeopleCounts.count) * 44))
            }
        }
        .padding(AppSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.md)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppCornerRadius.md)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
        .offset(y: isAnimating ? 0 : 50)
        .opacity(isAnimating ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.6).delay(0.7), value: isAnimating)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: AppSpacing.xl) {
            Spacer()
            
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.textSecondary)
            
            VStack(spacing: AppSpacing.md) {
                Text("No statistics yet")
                    .font(AppFonts.headline(20))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Add conversations to see your statistics here")
                    .font(AppFonts.body())
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.xl)
        .offset(y: isAnimating ? 0 : 50)
        .opacity(isAnimating ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.8).delay(0.2), value: isAnimating)
    }
}

struct StatCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let animationDelay: Double
    let isAnimating: Bool
    
    var body: some View {
        HStack(spacing: AppSpacing.lg) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 56, height: 56)
                
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(title)
                    .font(AppFonts.caption(14))
                    .foregroundColor(AppColors.textSecondary)
                
                Text(value)
                    .font(AppFonts.title(28))
                    .foregroundColor(AppColors.textPrimary)
            }
            
            Spacer()
        }
        .padding(AppSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.md)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppCornerRadius.md)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
        .offset(y: isAnimating ? 0 : 50)
        .opacity(isAnimating ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.6).delay(animationDelay), value: isAnimating)
    }
}

#Preview {
    StatisticsView(viewModel: ConversationViewModel())
}
