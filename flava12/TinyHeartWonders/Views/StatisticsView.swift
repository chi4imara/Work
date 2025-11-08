import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: WonderViewModel
    @State private var selectedPeriod: TimePeriod = .month
    @State private var showingMenu = false
    @State private var selectedDataPoint: DailyData?
    
    private var pieChartData: [PieChartSegment] {
        guard !statistics.dailyData.isEmpty else { return [] }
        
        var segments: [PieChartSegment] = []
        var currentAngle: Double = 0
        
        let highActivityDays = statistics.dailyData.filter { $0.count >= 3 }.count
        let mediumActivityDays = statistics.dailyData.filter { $0.count == 2 }.count
        let lowActivityDays = statistics.dailyData.filter { $0.count == 1 }.count
        let noActivityDays = statistics.dailyData.filter { $0.count == 0 }.count
        
        let totalDays = statistics.dailyData.count
        
        let colors: [Color] = [AppColors.primaryBlue, AppColors.accent, AppColors.warning, AppColors.lightBlue]
        let labels = ["High Activity (3+)", "Medium Activity (2)", "Low Activity (1)", "No Activity (0)"]
        let counts = [highActivityDays, mediumActivityDays, lowActivityDays, noActivityDays]
        
        for (index, count) in counts.enumerated() {
            if count > 0 {
                let percentage = Double(count) / Double(totalDays)
                let angle = percentage * 360
                
                segments.append(PieChartSegment(
                    startAngle: .degrees(currentAngle),
                    endAngle: .degrees(currentAngle + angle),
                    color: colors[index],
                    label: labels[index],
                    count: count,
                    data: DailyData(date: Date(), count: count)
                ))
                
                currentAngle += angle
            }
        }
        
        return segments
    }
    
    private var statistics: WonderStatistics {
        viewModel.getStatistics(for: selectedPeriod)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if statistics.totalEntries == 0 {
                        emptyStateView
                    } else {
                        statisticsContentView
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Statistics")
                .font(.appTitle)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: {
                showingMenu = true
            }) {
                Image(systemName: "ellipsis")
                    .font(.title2)
                    .foregroundColor(AppColors.primaryBlue)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .actionSheet(isPresented: $showingMenu) {
            ActionSheet(
                title: Text("Select Period"),
                buttons: [
                    .default(Text("Week")) {
                        selectedPeriod = .week
                    },
                    .default(Text("Month")) {
                        selectedPeriod = .month
                    },
                    .default(Text("All Time")) {
                        selectedPeriod = .all
                    },
                    .cancel()
                ]
            )
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "chart.bar")
                .font(.system(size: 60))
                .foregroundColor(AppColors.lightBlue)
            
            Text("No data for selected period")
                .font(.appHeadline)
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(.horizontal, 32)
    }
    
    private var statisticsContentView: some View {
        ScrollView {
            VStack(spacing: 24) {
                statisticsCardsView
                
                chartView
                
                Spacer(minLength: 40)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
    }
    
    private var statisticsCardsView: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                StatisticCard(
                    title: "Total Entries",
                    value: "\(statistics.totalEntries)",
                    icon: "doc.text"
                )
                
                StatisticCard(
                    title: "Active Days",
                    value: "\(statistics.activeDays)",
                    icon: "calendar"
                )
            }
            
            HStack(spacing: 12) {
                StatisticCard(
                    title: "Average per Day",
                    value: "\(statistics.averagePerDay)",
                    icon: "chart.line.uptrend.xyaxis"
                )
                
                StatisticCard(
                    title: "Success Rate",
                    value: "\(Int(Double(statistics.activeDays) / Double(max(statistics.totalEntries, 1)) * 100))%",
                    icon: "checkmark.circle"
                )
            }
            
            HStack(spacing: 12) {
                StatisticCard(
                    title: "Longest Streak",
                    value: "\(calculateLongestStreak())",
                    icon: "flame"
                )
                
                StatisticCard(
                    title: "Most Active Day",
                    value: "\(getMostActiveDay())",
                    icon: "star"
                )
            }
        }
    }
    
    private var chartView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Activity Distribution")
                    .font(.appHeadline)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Text(selectedPeriod.rawValue)
                    .font(.appCaption)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            pieChartView
        }
    }
    
    private var pieChartView: some View {
        VStack(spacing: 16) {
            ZStack {
                ForEach(Array(pieChartData.enumerated()), id: \.offset) { index, segment in
                    PieSlice(
                        startAngle: segment.startAngle,
                        endAngle: segment.endAngle,
                        color: segment.color
                    )
                    .onTapGesture {
                        selectedDataPoint = segment.data
                    }
                }
            }
            .frame(width: 200, height: 200)
            
            VStack(spacing: 8) {
                ForEach(Array(pieChartData.enumerated()), id: \.offset) { index, segment in
                    HStack {
                        Circle()
                            .fill(segment.color)
                            .frame(width: 12, height: 12)
                        
                        Text(segment.label)
                            .font(.appCaption)
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Text("\(segment.count) days")
                            .font(.appCaption)
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
            }
            .padding(.horizontal, 16)
            
            if let selectedData = selectedDataPoint {
                Text("Selected: \(selectedData.count) days")
                    .font(.appCaption)
                    .foregroundColor(AppColors.primaryText)
                    .padding(.top, 8)
            }
        }
        .padding(16)
        .concaveCard(cornerRadius: 8, depth: -5, color: AppColors.cardBackground)

    }
    
    private func calculateLongestStreak() -> Int {
        let calendar = Calendar.current
        let sortedDates = statistics.dailyData
            .filter { $0.count > 0 }
            .map { $0.date }
            .sorted()
        
        guard !sortedDates.isEmpty else { return 0 }
        
        var maxStreak = 1
        var currentStreak = 1
        
        for i in 1..<sortedDates.count {
            let daysBetween = calendar.dateComponents([.day], from: sortedDates[i-1], to: sortedDates[i]).day ?? 0
            if daysBetween == 1 {
                currentStreak += 1
                maxStreak = max(maxStreak, currentStreak)
            } else {
                currentStreak = 1
            }
        }
        
        return maxStreak
    }
    
    private func getMostActiveDay() -> String {
        let mostActive = statistics.dailyData.max { $0.count < $1.count }
        return mostActive?.displayDate ?? "N/A"
    }
}

struct PieChartSegment {
    let startAngle: Angle
    let endAngle: Angle
    let color: Color
    let label: String
    let count: Int
    let data: DailyData
}

struct PieSlice: View {
    let startAngle: Angle
    let endAngle: Angle
    let color: Color
    
    var body: some View {
        Path { path in
            let center = CGPoint(x: 100, y: 100)
            let radius: CGFloat = 80
            
            path.addArc(
                center: center,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: false
            )
            path.addLine(to: center)
            path.closeSubpath()
        }
        .fill(color)
        .overlay(
            Path { path in
                let center = CGPoint(x: 100, y: 100)
                let radius: CGFloat = 80
                
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false
                )
            }
            .stroke(Color.white, lineWidth: 2)
        )
    }
}

struct StatisticCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(AppColors.primaryBlue)
            
            Text(value)
                .font(.appTitle)
                .foregroundColor(AppColors.primaryText)
                .fontWeight(.bold)
            
            Text(title)
                .font(.appCaption)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .concaveCard(cornerRadius: 8, depth: -5, color: AppColors.cardBackground)
    }
}

