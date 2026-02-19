import SwiftUI

enum StatisticsPeriod: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
    case all = "All"
    
    var days: Int? {
        switch self {
        case .week: return 7
        case .month: return 30
        case .year: return 365
        case .all: return nil
        }
    }
}

struct StatisticsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedPeriod: StatisticsPeriod = .month
    
    private var filteredProcedures: [Procedure] {
        if let days = selectedPeriod.days {
            return dataManager.getProceduresForPeriod(days: days)
        } else {
            return dataManager.procedures
        }
    }
    
    private var chartData: [ChartDataPoint] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: filteredProcedures) { procedure in
            calendar.startOfDay(for: procedure.date)
        }
        
        return grouped.map { date, procedures in
            ChartDataPoint(date: date, count: procedures.count)
        }.sorted { $0.date < $1.date }
    }
    
    var body: some View {
        ZStack {
            ColorManager.shared.primaryBackground
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Statistics")
                        .font(FontManager.playfairBold(size: 32))
                        .foregroundColor(ColorManager.shared.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        if dataManager.procedures.isEmpty {
                            EmptyStatisticsView()
                            
                            Spacer()
                        } else {
                            VStack(spacing: 20) {
                                LazyVGrid(columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ], spacing: 16) {
                                    StatCard(
                                        title: "Total Procedures",
                                        value: "\(dataManager.getTotalProceduresCount())",
                                        icon: "scissors"
                                    )
                                    
                                    StatCard(
                                        title: "Last Visit",
                                        value: lastVisitText,
                                        icon: "calendar"
                                    )
                                }
                                .padding(.horizontal, 20)
                                
                                PopularServicesView()
                                
                                PeriodSelector(selectedPeriod: $selectedPeriod)
                                
                                if !chartData.isEmpty {
                                    VisitFrequencyChart(data: chartData, period: selectedPeriod)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private var lastVisitText: String {
        guard let lastDate = dataManager.getLastProcedureDate() else {
            return "Never"
        }
        
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: lastDate, relativeTo: Date())
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(ColorManager.shared.accentBlue)
            
            Text(value)
                .font(FontManager.playfairBold(size: 20))
                .foregroundColor(ColorManager.shared.primaryText)
            
            Text(title)
                .font(FontManager.playfairRegular(size: 12))
                .foregroundColor(ColorManager.shared.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorManager.shared.cardBackground)
        )
    }
}

struct PopularServicesView: View {
    @EnvironmentObject var dataManager: DataManager
    
    private var serviceCounts: [(ServiceCategory, Int)] {
        let counts = dataManager.getCategoryCounts()
        return counts.sorted { $0.value > $1.value }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Popular Services")
                    .font(FontManager.playfairSemiBold(size: 18))
                    .foregroundColor(ColorManager.shared.primaryText)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            if serviceCounts.isEmpty {
                Text("No data available")
                    .font(FontManager.playfairRegular(size: 14))
                    .foregroundColor(ColorManager.shared.secondaryText)
                    .padding(.horizontal, 20)
            } else {
                VStack(spacing: 8) {
                    ForEach(Array(serviceCounts.enumerated()), id: \.offset) { index, item in
                        ServiceBar(
                            category: item.0,
                            count: item.1,
                            maxCount: serviceCounts.first?.1 ?? 1,
                            rank: index + 1
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct ServiceBar: View {
    let category: ServiceCategory
    let count: Int
    let maxCount: Int
    let rank: Int
    
    private var fillPercentage: Double {
        return Double(count) / Double(maxCount)
    }
    
    var body: some View {
        HStack {
            Text("\(rank).")
                .font(FontManager.playfairMedium(size: 14))
                .foregroundColor(ColorManager.shared.secondaryText)
                .frame(width: 20, alignment: .leading)
            
            Text(category.rawValue)
                .font(FontManager.playfairRegular(size: 14))
                .foregroundColor(ColorManager.shared.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("\(count)")
                .font(FontManager.playfairMedium(size: 14))
                .foregroundColor(ColorManager.shared.accentBlue)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            GeometryReader { geometry in
                HStack {
                    Rectangle()
                        .fill(ColorManager.shared.accentBlue.opacity(0.2))
                        .frame(width: geometry.size.width * fillPercentage)
                    
                    Spacer(minLength: 0)
                }
            }
        )
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(ColorManager.shared.cardBackground)
        )
    }
}

struct PeriodSelector: View {
    @Binding var selectedPeriod: StatisticsPeriod
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(StatisticsPeriod.allCases, id: \.self) { period in
                    Button(action: { selectedPeriod = period }) {
                        Text(period.rawValue)
                            .font(FontManager.playfairMedium(size: 14))
                            .foregroundColor(selectedPeriod == period ? ColorManager.shared.primaryText : ColorManager.shared.secondaryText)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(selectedPeriod == period ? ColorManager.shared.accentOrange : ColorManager.shared.cardBackground)
                            )
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct ChartDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}

struct VisitFrequencyChart: View {
    let data: [ChartDataPoint]
    let period: StatisticsPeriod
    
    private var maxValue: Int {
        data.map { $0.count }.max() ?? 1
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        switch period {
        case .week:
            formatter.dateFormat = "EEE"
        case .month:
            formatter.dateFormat = "d"
        case .year:
            formatter.dateFormat = "MMM"
        case .all:
            formatter.dateFormat = "MMM"
        }
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Visit Frequency")
                        .font(FontManager.playfairSemiBold(size: 18))
                        .foregroundColor(ColorManager.shared.primaryText)
                    
                    if !data.isEmpty {
                        Text("\(data.count) visits tracked")
                            .font(FontManager.playfairRegular(size: 12))
                            .foregroundColor(ColorManager.shared.secondaryText)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 12) {
                if data.isEmpty {
                    Text("No data available")
                        .font(FontManager.playfairRegular(size: 14))
                        .foregroundColor(ColorManager.shared.secondaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                } else {
                    GeometryReader { geometry in
                        let barWidth = max(geometry.size.width / CGFloat(data.count) - 4, 8)
                        let chartHeight = geometry.size.height - 40
                        
                        HStack(alignment: .bottom, spacing: 4) {
                            ForEach(data) { point in
                                VStack(spacing: 4) {
                                    Spacer()
                                    
                                    let barHeight = max(CGFloat(point.count) / CGFloat(maxValue) * chartHeight, 4)
                                    
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    ColorManager.shared.accentBlue,
                                                    ColorManager.shared.accentOrange
                                                ]),
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .frame(width: barWidth, height: barHeight)
                                    
                                    Text(dateFormatter.string(from: point.date))
                                        .font(FontManager.playfairRegular(size: 9))
                                        .foregroundColor(ColorManager.shared.secondaryText)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.7)
                                    
                                    if point.count > 0 {
                                        Text("\(point.count)")
                                            .font(FontManager.playfairMedium(size: 10))
                                            .foregroundColor(ColorManager.shared.primaryText)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.horizontal, 8)
                        .padding(.top, 8)
                    }
                    .frame(height: 180)
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black.opacity(0.1))
                        .blur(radius: 8)
                        .offset(x: 0, y: 4)
                        .opacity(0.5)
                    
                    RoundedRectangle(cornerRadius: 16)
                        .fill(ColorManager.shared.cardBackground)
                }
            )
            .padding(.horizontal, 20)
        }
    }
}

struct EmptyStatisticsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "chart.bar")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(ColorManager.shared.secondaryText)
            
            Text("Not enough data for statistics")
                .font(FontManager.playfairSemiBold(size: 18))
                .foregroundColor(ColorManager.shared.primaryText)
            
            Text("Add some procedures to see your statistics")
                .font(FontManager.playfairRegular(size: 14))
                .foregroundColor(ColorManager.shared.secondaryText)
            
            Spacer()
        }
    }
}

#Preview {
    StatisticsView()
        .environmentObject(DataManager.shared)
}
