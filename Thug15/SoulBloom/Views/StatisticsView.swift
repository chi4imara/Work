import SwiftUI
#if canImport(Charts)
import Charts
#endif

struct StatisticsView: View {
    @ObservedObject var viewModel: GratitudeViewModel
    @State private var selectedPeriod: StatisticsPeriod = .month
    @State private var showingNewEntry = false
    
    var body: some View {
        ZStack {
            LinearGradient.appBackground
                .ignoresSafeArea()
            
            GridPatternView()
                .opacity(0.1)
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.entries.isEmpty {
                    emptyStateView
                } else {
                    statisticsContentView
                }
            }
        }
        .sheet(isPresented: $showingNewEntry) {
            NavigationView {
                NewEntryView(viewModel: viewModel, selectedDate: Date())
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Statistics")
                .font(FontManager.title)
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 15)
        .padding(.top, 8)
        .padding(.bottom, 15)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 15) {
            Spacer()
            
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 40))
                .foregroundColor(ColorTheme.accentYellow)
            
            Text("No data for statistics yet")
                .font(FontManager.callout)
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
            
            Button {
                showingNewEntry = true
            } label: {
                Text("Add Entry")
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.buttonText)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(ColorTheme.buttonBackground)
                    )
            }
            
            Spacer()
        }
        .padding(.horizontal, 30)
    }
    
    private var statisticsContentView: some View {
        ScrollView {
            VStack(spacing: 20) {
                generalInfoSection
                
                dynamicsSection
                
                stabilitySection
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 80)
        }
    }
    
    private var generalInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("General Information")
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
            
            HStack(spacing: 15) {
                StatInfoCard(
                    title: "Total Days",
                    value: "\(viewModel.totalDaysWithEntries)",
                    icon: "calendar",
                    color: ColorTheme.accentOrange
                )
                
                StatInfoCard(
                    title: "Last Entry",
                    value: viewModel.lastEntryDate?.shortDateString ?? "None",
                    icon: "clock",
                    color: ColorTheme.accentYellow
                )
            }
        }
    }
    
    private var dynamicsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Dynamics")
                    .font(FontManager.headline)
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Picker("Period", selection: $selectedPeriod) {
                    ForEach(StatisticsPeriod.allCases, id: \.self) { period in
                        Text(period.rawValue).tag(period)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 160)
            }
            
            chartView
        }
    }
    
    private var chartView: some View {
        let dataPoints = viewModel.getEntriesCount(for: selectedPeriod, in: Date())
        
        return VStack {
            #if canImport(Charts)
            if #available(iOS 16.0, *) {
                Chart(dataPoints) { point in
                    LineMark(
                        x: .value("Date", point.date),
                        y: .value("Count", point.count)
                    )
                    .foregroundStyle(ColorTheme.accentOrange)
                    .lineStyle(StrokeStyle(lineWidth: 3))
                    
                    AreaMark(
                        x: .value("Date", point.date),
                        y: .value("Count", point.count)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                ColorTheme.accentOrange.opacity(0.3),
                                ColorTheme.accentOrange.opacity(0.1)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                .frame(height: 150)
                .chartXAxis {
                    AxisMarks(values: .automatic) { _ in
                        AxisGridLine()
                            .foregroundStyle(ColorTheme.gridPattern)
                        AxisTick()
                            .foregroundStyle(ColorTheme.secondaryText)
                        AxisValueLabel()
                            .font(FontManager.caption)
                            .foregroundStyle(ColorTheme.secondaryText)
                    }
                }
                .chartYAxis {
                    AxisMarks(values: .automatic) { _ in
                        AxisGridLine()
                            .foregroundStyle(ColorTheme.gridPattern)
                        AxisTick()
                            .foregroundStyle(ColorTheme.secondaryText)
                        AxisValueLabel()
                            .font(FontManager.caption)
                            .foregroundStyle(ColorTheme.secondaryText)
                    }
                }
            } else {
                SimpleChartView(dataPoints: dataPoints)
                    .frame(height: 150)
            }
            #else
            SimpleChartView(dataPoints: dataPoints)
                .frame(height: 150)
            #endif
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorTheme.cardBackground)
        )
    }
    
    private var stabilitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Stability")
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
            
            HStack(spacing: 15) {
                StatInfoCard(
                    title: "Max Streak",
                    value: "\(viewModel.maxStreak)",
                    icon: "flame",
                    color: ColorTheme.successGreen
                )
                
                StatInfoCard(
                    title: "Current Streak",
                    value: "\(viewModel.currentStreak)",
                    icon: "bolt",
                    color: ColorTheme.warningRed
                )
            }
        }
    }
}

struct StatInfoCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(value)
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
            
            Text(title)
                .font(FontManager.caption2)
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorTheme.cardBackground)
        )
    }
}

struct SimpleChartView: View {
    let dataPoints: [StatisticsDataPoint]
    
    var body: some View {
        GeometryReader { geometry in
            let maxCount = dataPoints.map(\.count).max() ?? 1
            let width = geometry.size.width
            let height = geometry.size.height
            
            ZStack {
                ForEach(0..<5) { i in
                    let y = height * CGFloat(i) / 4
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: width, y: y))
                    }
                    .stroke(ColorTheme.gridPattern, lineWidth: 1)
                }
                
                if dataPoints.count > 1 {
                    Path { path in
                        for (index, point) in dataPoints.enumerated() {
                            let x = width * CGFloat(index) / CGFloat(dataPoints.count - 1)
                            let y = height - (height * CGFloat(point.count) / CGFloat(maxCount))
                            
                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                    .stroke(ColorTheme.accentOrange, lineWidth: 3)
                }
                
                ForEach(Array(dataPoints.enumerated()), id: \.offset) { index, point in
                    let x = width * CGFloat(index) / CGFloat(max(dataPoints.count - 1, 1))
                    let y = height - (height * CGFloat(point.count) / CGFloat(maxCount))
                    
                    Circle()
                        .fill(ColorTheme.accentOrange)
                        .frame(width: 6, height: 6)
                        .position(x: x, y: y)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(ColorTheme.cardBackground.opacity(0.5))
        )
    }
}

#Preview {
    StatisticsView(viewModel: GratitudeViewModel())
}
