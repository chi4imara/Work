import SwiftUI

struct ChartsView: View {
    @EnvironmentObject var manicureStore: ManicureStore
    @State private var selectedChartType: ChartType = .colors
    
    enum ChartType: String, CaseIterable {
        case colors = "Top Colors"
        case monthly = "Monthly Trend"
        case seasonal = "Seasonal"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if manicureStore.manicures.isEmpty {
                emptyStateView
            } else {
                chartSelector
                chartContent
            }
        }
    }
    
    private var chartSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ChartType.allCases, id: \.self) { type in
                    Button(action: { selectedChartType = type }) {
                        Text(type.rawValue)
                            .font(.playfairDisplay(14, weight: .medium))
                            .foregroundColor(selectedChartType == type ? AppColors.contrastText : AppColors.blueText)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                selectedChartType == type ?
                                AnyShapeStyle(AppColors.purpleGradient) :
                                AnyShapeStyle(AppColors.backgroundWhite.opacity(0.6))
                            )
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 10)
    }
    
    private var chartContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                switch selectedChartType {
                case .colors:
                    topColorsChart
                case .monthly:
                    monthlyTrendChart
                case .seasonal:
                    seasonalChart
                }
                
                Spacer(minLength: 20)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
    }
    
    private var topColorsChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Top Colors")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            let topColors = getTopColors(limit: 5)
            
            if !topColors.isEmpty {
                PieChartView(data: topColors)
                    .frame(height: 300)
                
                VStack(spacing: 12) {
                    ForEach(topColors, id: \.color) { item in
                        ColorChartRow(color: item.color, count: item.count, percentage: item.percentage)
                    }
                }
            }
        }
        .padding(20)
        .background(AppColors.backgroundWhite.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private var monthlyTrendChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Monthly Trend")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            let monthlyData = getMonthlyData()
            
            if !monthlyData.isEmpty {
                BarChartView(data: monthlyData)
                    .frame(height: 250)
                
                VStack(spacing: 8) {
                    ForEach(monthlyData.suffix(6), id: \.month) { item in
                        MonthlyChartRow(month: item.month, count: item.count)
                    }
                }
            }
        }
        .padding(20)
        .background(AppColors.backgroundWhite.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private var seasonalChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Seasonal Preferences")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            let seasonalData = getSeasonalData()
            
            VStack(spacing: 16) {
                ForEach(seasonalData, id: \.season) { item in
                    SeasonalChartRow(season: item.season, count: item.count, colors: item.topColors)
                }
            }
        }
        .padding(20)
        .background(AppColors.backgroundWhite.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "chart.pie")
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText.opacity(0.6))
            
            VStack(spacing: 16) {
                Text("No data for analytics")
                    .font(.playfairDisplay(22, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add some manicure records to see beautiful charts and insights.")
                    .font(.playfairDisplay(16))
                    .foregroundColor(AppColors.blueText)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private func getTopColors(limit: Int) -> [ColorChartData] {
        let colorCounts = Dictionary(grouping: manicureStore.manicures) { $0.color.lowercased() }
        let total = manicureStore.manicures.count
        
        let sorted = colorCounts.map { (color, manicures) in
            ColorChartData(
                color: color.capitalized,
                count: manicures.count,
                percentage: Double(manicures.count) / Double(total) * 100
            )
        }.sorted { $0.count > $1.count }
        
        return Array(sorted.prefix(limit))
    }
    
    private func getMonthlyData() -> [MonthlyChartData] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: manicureStore.manicures) { manicure in
            calendar.dateInterval(of: .month, for: manicure.date)?.start ?? manicure.date
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        
        return grouped.map { (date, manicures) in
            MonthlyChartData(month: formatter.string(from: date), count: manicures.count)
        }.sorted { $0.month < $1.month }
    }
    
    private func getSeasonalData() -> [SeasonalChartData] {
        let calendar = Calendar.current
        var seasonalGroups: [String: [Manicure]] = [:]
        
        for manicure in manicureStore.manicures {
            let month = calendar.component(.month, from: manicure.date)
            let season: String
            
            switch month {
            case 12, 1, 2: season = "Winter"
            case 3, 4, 5: season = "Spring"
            case 6, 7, 8: season = "Summer"
            case 9, 10, 11: season = "Autumn"
            default: season = "Unknown"
            }
            
            seasonalGroups[season, default: []].append(manicure)
        }
        
        return ["Winter", "Spring", "Summer", "Autumn"].compactMap { season in
            guard let manicures = seasonalGroups[season], !manicures.isEmpty else { return nil }
            
            let colorCounts = Dictionary(grouping: manicures) { $0.color.lowercased() }
            let topColors = colorCounts.map { (color, manicures) in
                (color.capitalized, manicures.count)
            }.sorted { $0.1 > $1.1 }.prefix(3).map { $0.0 }
            
            return SeasonalChartData(season: season, count: manicures.count, topColors: Array(topColors))
        }
    }
}

struct ColorChartData {
    let color: String
    let count: Int
    let percentage: Double
}

struct MonthlyChartData {
    let month: String
    let count: Int
}

struct SeasonalChartData {
    let season: String
    let count: Int
    let topColors: [String]
}

struct PieChartView: View {
    let data: [ColorChartData]
    @State private var animatedPercentages: [Double] = []
    
    private let colors: [Color] = [
        AppColors.primaryPurple,
        AppColors.yellowAccent,
        Color.orange,
        AppColors.softPink,
        AppColors.mintGreen
    ]
    
    var body: some View {
        ZStack {
            Circle()
                .fill(AppColors.backgroundGray.opacity(0.3))
            
            ForEach(Array(data.enumerated()), id: \.element.color) { index, item in
                PieSlice(
                    startAngle: startAngle(for: index),
                    endAngle: endAngle(for: index),
                    color: colors[index % colors.count]
                )
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: animatedPercentages)
            }
            
            ForEach(Array(data.enumerated()), id: \.element.color) { index, item in
                if index < data.count - 1 {
                    PieDivider(angle: endAngle(for: index))
                }
            }
        }
        .onAppear {
            animatedPercentages = data.map { $0.percentage }
        }
    }
    
    private func startAngle(for index: Int) -> Angle {
        let previous = data.prefix(index).reduce(0.0) { $0 + $1.percentage }
        return Angle(degrees: previous * 3.6 - 90)
    }
    
    private func endAngle(for index: Int) -> Angle {
        let current = data.prefix(index + 1).reduce(0.0) { $0 + $1.percentage }
        return Angle(degrees: current * 3.6 - 90)
    }
}

struct PieSlice: View {
    let startAngle: Angle
    let endAngle: Angle
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let radius = min(geometry.size.width, geometry.size.height) / 2
            
            Path { path in
                path.move(to: center)
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false
                )
                path.closeSubpath()
            }
            .fill(color)
        }
    }
}

struct PieDivider: View {
    let angle: Angle
    
    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let radius = min(geometry.size.width, geometry.size.height) / 2
            
            Path { path in
                let radians = angle.radians
                let endX = center.x + radius * cos(radians)
                let endY = center.y + radius * sin(radians)
                
                path.move(to: center)
                path.addLine(to: CGPoint(x: endX, y: endY))
            }
            .stroke(AppColors.primaryText.opacity(0.3), lineWidth: 2)
        }
    }
}

struct BarChartView: View {
    let data: [MonthlyChartData]
    @State private var animatedHeights: [CGFloat] = []
    
    private var maxCount: Int {
        data.map { $0.count }.max() ?? 1
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .bottom, spacing: 12) {
                ForEach(Array(data.enumerated()), id: \.element.month) { index, item in
                    VStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [AppColors.primaryPurple, AppColors.secondaryPurple],
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            )
                            .frame(width: 40, height: animatedHeights.indices.contains(index) ? animatedHeights[index] : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(Double(index) * 0.05), value: animatedHeights)
                        
                        VStack(spacing: 2) {
                            Text(item.month.prefix(3))
                                .font(.playfairDisplay(11, weight: .medium))
                                .foregroundColor(AppColors.primaryText)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            
                            Text("\(item.count)")
                                .font(.playfairDisplay(9))
                                .foregroundColor(AppColors.secondaryText)
                        }
                        .frame(width: 40, height: 35)
                    }
                }
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 240)
        .onAppear {
            animatedHeights = data.map { CGFloat($0.count) / CGFloat(maxCount) * 180 }
        }
    }
}

struct ColorChartRow: View {
    let color: String
    let count: Int
    let percentage: Double
    
    var body: some View {
        HStack {
            Circle()
                .fill(AppColors.purpleGradient)
                .frame(width: 20, height: 20)
                .overlay(
                    Text(String(color.prefix(2)).uppercased())
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(AppColors.contrastText)
                )
            
            Text(color)
                .font(.playfairDisplay(14, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(count) times")
                    .font(.playfairDisplay(12))
                    .foregroundColor(AppColors.blueText)
                
                Text(String(format: "%.1f%%", percentage))
                    .font(.playfairDisplay(10))
                    .foregroundColor(AppColors.secondaryText)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(AppColors.backgroundGray.opacity(0.5))
        .cornerRadius(10)
    }
}

struct MonthlyChartRow: View {
    let month: String
    let count: Int
    
    var body: some View {
        HStack {
            Text(month)
                .font(.playfairDisplay(14, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Text("\(count) manicure\(count == 1 ? "" : "s")")
                .font(.playfairDisplay(12))
                .foregroundColor(AppColors.blueText)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(AppColors.backgroundGray.opacity(0.5))
        .cornerRadius(10)
    }
}

struct SeasonalChartRow: View {
    let season: String
    let count: Int
    let colors: [String]
    
    private var seasonIcon: String {
        switch season {
        case "Winter": return "snowflake"
        case "Spring": return "leaf"
        case "Summer": return "sun.max"
        case "Autumn": return "leaf.fill"
        default: return "calendar"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: seasonIcon)
                    .font(.title3)
                    .foregroundColor(AppColors.yellowAccent)
                
                Text(season)
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Text("\(count) manicure\(count == 1 ? "" : "s")")
                    .font(.playfairDisplay(14))
                    .foregroundColor(AppColors.blueText)
            }
            
            if !colors.isEmpty {
                HStack(spacing: 8) {
                    Text("Top colors:")
                        .font(.playfairDisplay(12))
                        .foregroundColor(AppColors.secondaryText)
                    
                    ForEach(colors, id: \.self) { color in
                        Text(color)
                            .font(.playfairDisplay(12, weight: .medium))
                            .foregroundColor(AppColors.blueText)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(AppColors.backgroundGray.opacity(0.5))
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding(16)
        .background(AppColors.backgroundGray.opacity(0.5))
        .cornerRadius(12)
    }
}
