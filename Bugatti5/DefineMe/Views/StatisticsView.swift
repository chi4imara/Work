import SwiftUI
import Charts

struct StatisticsView: View {
    @EnvironmentObject var dataManager: TermsDataManager
    
    private var totalTerms: Int {
        dataManager.terms.count
    }
    
    private var totalCharacters: Int {
        dataManager.terms.reduce(0) { $0 + $1.name.count + $1.explanation.count }
    }
    
    private var averageExplanationLength: Int {
        guard !dataManager.terms.isEmpty else { return 0 }
        let total = dataManager.terms.reduce(0) { $0 + $1.explanation.count }
        return total / dataManager.terms.count
    }
    
    private var termsThisWeek: Int {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) ?? Date()
        return dataManager.terms.filter { $0.dateCreated >= startOfWeek }.count
    }
    
    private var termsThisMonth: Int {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date())) ?? Date()
        return dataManager.terms.filter { $0.dateCreated >= startOfMonth }.count
    }
    
    private var termsByDayChartData: [TermsByDayItem] {
        let calendar = Calendar.current
        var result: [TermsByDayItem] = []
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        
        for dayOffset in (0..<7).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) else { continue }
            let startOfDay = calendar.startOfDay(for: date)
            let count = dataManager.terms.filter { calendar.startOfDay(for: $0.dateCreated) == startOfDay }.count
            result.append(TermsByDayItem(
                date: startOfDay,
                dayLabel: formatter.string(from: startOfDay),
                count: count
            ))
        }
        return result
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
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
                    VStack(spacing: 16) {
                        termsChartSection
                        
                        StatCardView(
                            icon: "book.fill",
                            title: "Total terms",
                            value: "\(totalTerms)"
                        )
                        
                        StatCardView(
                            icon: "calendar",
                            title: "Added this week",
                            value: "\(termsThisWeek)"
                        )
                        
                        StatCardView(
                            icon: "calendar.badge.clock",
                            title: "Added this month",
                            value: "\(termsThisMonth)"
                        )
                        
                        StatCardView(
                            icon: "character.cursor.ibeam",
                            title: "Total characters",
                            value: "\(totalCharacters)"
                        )
                        
                        StatCardView(
                            icon: "text.alignleft",
                            title: "Avg. explanation length",
                            value: "\(averageExplanationLength) chars"
                        )
                        
                        if !dataManager.terms.isEmpty {
                            longestTermCard
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                }
            }
        }
    }
    
    private var termsChartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .font(.title3)
                    .foregroundColor(AppColors.accentYellow)
                Text("Terms added (last 7 days)")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
            }
            
            let data = termsByDayChartData
            let maxCount = max(data.map(\.count).max() ?? 1, 1)
            
            Chart(data) { item in
                BarMark(
                    x: .value("Day", item.dayLabel),
                    y: .value("Terms", item.count)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [AppColors.accentYellow, AppColors.brightYellow],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .cornerRadius(6)
            }
            .chartYScale(domain: 0...(maxCount + 1))
            .chartXAxis {
                AxisMarks(values: .automatic) { _ in
                    AxisValueLabel()
                        .foregroundStyle(AppColors.secondaryText)
                        .font(.ubuntu(12))
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading, values: .automatic) { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(AppColors.gridPattern)
                    AxisValueLabel()
                        .foregroundStyle(AppColors.secondaryText)
                        .font(.ubuntu(12))
                }
            }
            .frame(height: 200)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.primaryText.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private var longestTermCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "arrow.up.right")
                    .font(.title3)
                    .foregroundColor(AppColors.accentYellow)
                Text("Longest explanation")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
            }
            
            if let longest = dataManager.terms.max(by: { $0.explanation.count < $1.explanation.count }) {
                Text(longest.name)
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.secondaryText)
                Text("\(longest.explanation.count) characters")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.accentYellow)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.primaryText.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct TermsByDayItem: Identifiable {
    let id = UUID()
    let date: Date
    let dayLabel: String
    let count: Int
}

struct StatCardView: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(AppColors.accentYellow)
                .frame(width: 44, height: 44)
                .background(Circle().fill(AppColors.accentYellow.opacity(0.2)))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.secondaryText)
                Text(value)
                    .font(.ubuntu(22, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.primaryText.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#Preview {
    StatisticsView()
        .environmentObject(TermsDataManager())
}
