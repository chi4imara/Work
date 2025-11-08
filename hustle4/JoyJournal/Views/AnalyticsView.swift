import SwiftUI
import Charts

struct AnalyticsView: View {
    @ObservedObject var viewModel: HobbyViewModel
    @State private var selectedPeriod: AnalyticsPeriod = .month
    @State private var selectedHobby: Hobby?
    
    var body: some View {
        ZStack {
            WebPatternBackground()
                
                ScrollView {
                    VStack(spacing: 20) {
                        headerView
                        
                        periodSelectorView
                        
                        if viewModel.totalSessions < 3 {
                            emptyAnalyticsView
                        } else {
                            activityChartView
                            
                            hobbyDistributionView
                            
                            summaryStatsView
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Analytics")
                    .font(FontManager.title)
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Track your progress and insights")
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.secondaryText)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 10)
    }
    
    private var periodSelectorView: some View {
        HStack(spacing: 0) {
            ForEach(AnalyticsPeriod.allCases, id: \.self) { period in
                Button(action: {
                    selectedPeriod = period
                }) {
                    Text(period.rawValue)
                        .font(FontManager.body)
                        .foregroundColor(selectedPeriod == period ? .white : ColorTheme.primaryBlue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(selectedPeriod == period ? ColorTheme.primaryBlue : Color.clear)
                }
            }
        }
        .background(ColorTheme.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(ColorTheme.lightBlue.opacity(0.3), lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.2), value: selectedPeriod)
    }
    
    private var activityChartView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Activity Over Time")
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
                .fontWeight(.semibold)
            
            let chartData = viewModel.getSessionsData(for: selectedPeriod)
            
            if #available(iOS 16.0, *) {
                Chart {
                    ForEach(chartData) { dataPoint in
                        LineMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Time", dataPoint.totalTime)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [ColorTheme.primaryBlue, ColorTheme.darkBlue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .interpolationMethod(.catmullRom)
                        
                        AreaMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Time", dataPoint.totalTime)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    ColorTheme.primaryBlue.opacity(0.3),
                                    ColorTheme.primaryBlue.opacity(0.1)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .interpolationMethod(.catmullRom)
                    }
                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks(values: .stride(by: getAxisStride())) { _ in
                        AxisGridLine()
                        AxisValueLabel(format: getAxisFormat())
                    }
                }
                .chartYAxis {
                    AxisMarks { _ in
                        AxisGridLine()
                        AxisValueLabel()
                    }
                }
            } else {
                SimpleAreaChart(data: chartData)
                    .frame(height: 200)
            }
        }
        .padding(20)
        .background(ColorTheme.cardGradient)
        .cornerRadius(16)
        .shadow(color: ColorTheme.lightBlue.opacity(0.15), radius: 8, x: 0, y: 4)
    }
    
    private var hobbyDistributionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Time Distribution by Hobby")
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
                .fontWeight(.semibold)
            
            let distribution = viewModel.getHobbyDistribution()
            
            if distribution.isEmpty {
                Text("No data available")
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
            } else {
                VStack(spacing: 12) {
                    ForEach(distribution) { item in
                        HobbyDistributionRow(
                            hobby: item.hobby,
                            percentage: item.percentage,
                            totalTime: item.totalTime,
                            color: getHobbyColor(for: item.hobby)
                        )
                    }
                }
            }
        }
        .padding(20)
        .background(ColorTheme.cardGradient)
        .cornerRadius(16)
        .shadow(color: ColorTheme.lightBlue.opacity(0.15), radius: 8, x: 0, y: 4)
    }
    
    private var summaryStatsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Summary")
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
                .fontWeight(.semibold)
            
            let chartData = viewModel.getSessionsData(for: selectedPeriod)
            let totalSessions = chartData.reduce(0) { $0 + $1.sessionCount }
            let totalTime = chartData.reduce(0) { $0 + $1.totalTime }
            let bestDay = chartData.max(by: { $0.totalTime < $1.totalTime })
            let mostActiveHobby = viewModel.getHobbyDistribution().first
            
            VStack(spacing: 12) {
                SummaryRow(
                    icon: "star.fill",
                    label: "Sessions in \(selectedPeriod.rawValue.lowercased())",
                    value: "\(totalSessions)",
                    color: ColorTheme.primaryBlue
                )
                
                SummaryRow(
                    icon: "clock.fill",
                    label: "Total time",
                    value: formatMinutes(totalTime),
                    color: ColorTheme.accent
                )
                
                if let mostActiveHobby = mostActiveHobby {
                    SummaryRow(
                        icon: "heart.fill",
                        label: "Most active hobby",
                        value: mostActiveHobby.hobby.name,
                        color: ColorTheme.success
                    )
                }
                
                if let bestDay = bestDay, bestDay.totalTime > 0 {
                    SummaryRow(
                        icon: "calendar.circle.fill",
                        label: "Best day",
                        value: formatBestDay(bestDay),
                        color: ColorTheme.warning
                    )
                }
            }
        }
        .padding(20)
        .background(ColorTheme.cardGradient)
        .cornerRadius(16)
        .shadow(color: ColorTheme.lightBlue.opacity(0.15), radius: 8, x: 0, y: 4)
    }
    
    private var emptyAnalyticsView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(ColorTheme.lightBlue.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 48, weight: .light))
                    .foregroundColor(ColorTheme.lightBlue)
            }
            
            VStack(spacing: 12) {
                Text("Not enough data for analysis")
                    .font(FontManager.headline)
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Add at least three sessions to see detailed analytics and progress information about your hobby.")
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 15)
            }
            
            Spacer()
        }
        .padding(20)
        .background(ColorTheme.cardGradient)
        .cornerRadius(16)
        .shadow(color: ColorTheme.lightBlue.opacity(0.15), radius: 8, x: 0, y: 4)
    }
    
    private func getAxisStride() -> Calendar.Component {
        switch selectedPeriod {
        case .week:
            return .day
        case .month:
            return .weekOfYear
        case .year:
            return .month
        }
    }
    
    private func getAxisFormat() -> Date.FormatStyle {
        switch selectedPeriod {
        case .week:
            return .dateTime.weekday(.abbreviated)
        case .month:
            return .dateTime.month(.abbreviated).day()
        case .year:
            return .dateTime.month(.abbreviated)
        }
    }
    
    private func getHobbyColor(for hobby: Hobby) -> Color {
        let colors = [
            ColorTheme.primaryBlue,
            ColorTheme.accent,
            ColorTheme.success,
            ColorTheme.warning,
            ColorTheme.darkBlue,
            ColorTheme.lightBlue
        ]
        
        let index = abs(hobby.name.hashValue) % colors.count
        return colors[index]
    }
    
    private func formatMinutes(_ minutes: Int) -> String {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        
        if hours > 0 {
            return "\(hours)h \(remainingMinutes)m"
        } else {
            return "\(remainingMinutes)m"
        }
    }
    
    private func formatBestDay(_ dataPoint: SessionDataPoint) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: dataPoint.date)
    }
}

struct HobbyDistributionRow: View {
    let hobby: Hobby
    let percentage: Double
    let totalTime: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: hobby.icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(color)
                        .frame(width: 20)
                    
                    Text(hobby.name)
                        .font(FontManager.body)
                        .foregroundColor(ColorTheme.primaryText)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(Int(percentage * 100))%")
                        .font(FontManager.body)
                        .foregroundColor(ColorTheme.primaryText)
                        .fontWeight(.semibold)
                    
                    Text(formatMinutes(totalTime))
                        .font(FontManager.small)
                        .foregroundColor(ColorTheme.secondaryText)
                }
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(ColorTheme.lightBlue.opacity(0.2))
                        .frame(height: 6)
                        .cornerRadius(3)
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * percentage, height: 6)
                        .cornerRadius(3)
                        .animation(.easeInOut(duration: 1.0), value: percentage)
                }
            }
            .frame(height: 6)
        }
    }
    
    private func formatMinutes(_ minutes: Int) -> String {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        
        if hours > 0 {
            return "\(hours)h \(remainingMinutes)m"
        } else {
            return "\(remainingMinutes)m"
        }
    }
}

struct SummaryRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(label)
                .font(FontManager.body)
                .foregroundColor(ColorTheme.secondaryText)
            
            Spacer()
            
            Text(value)
                .font(FontManager.body)
                .foregroundColor(ColorTheme.primaryText)
                .fontWeight(.semibold)
        }
    }
}

struct SimpleAreaChart: View {
    let data: [SessionDataPoint]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    guard !data.isEmpty else { return }
                    
                    let maxTime = data.map(\.totalTime).max() ?? 1
                    let width = geometry.size.width
                    let height = geometry.size.height
                    
                    path.move(to: CGPoint(x: 0, y: height))
                    
                    for (index, point) in data.enumerated() {
                        let x = CGFloat(index) / CGFloat(data.count - 1) * width
                        let y = height - (CGFloat(point.totalTime) / CGFloat(maxTime) * height)
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                    
                    path.addLine(to: CGPoint(x: width, y: height))
                    path.closeSubpath()
                }
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            ColorTheme.primaryBlue.opacity(0.3),
                            ColorTheme.primaryBlue.opacity(0.1)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                Path { path in
                    guard !data.isEmpty else { return }
                    
                    let maxTime = data.map(\.totalTime).max() ?? 1
                    let width = geometry.size.width
                    let height = geometry.size.height
                    
                    for (index, point) in data.enumerated() {
                        let x = CGFloat(index) / CGFloat(data.count - 1) * width
                        let y = height - (CGFloat(point.totalTime) / CGFloat(maxTime) * height)
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(ColorTheme.primaryBlue, lineWidth: 2)
            }
        }
    }
}
