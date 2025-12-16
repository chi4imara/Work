import SwiftUI
import Charts

struct StatisticsView: View {
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var colorTheme = ColorTheme.shared
    @State private var showingNewDayView: IdentifiableID<DayEntry.ID>?
    
    private var statistics: Statistics {
        dataManager.getStatistics()
    }
    
    private var todaysQuote: DailyQuote {
        DailyQuote.todaysQuote()
    }
    
    private var chartData: [ChartDataPoint] {
        let calendar = Calendar.current
        let now = Date()
        
        var data: [ChartDataPoint] = []
        
        for i in 0..<7 {
            let targetDate = calendar.date(byAdding: .day, value: -i, to: now)!
            let entry = dataManager.dayEntries.first { calendar.isDate($0.date, inSameDayAs: targetDate) }
            
            data.append(ChartDataPoint(
                date: targetDate,
                color: entry?.color,
                hasEntry: entry != nil
            ))
        }
        
        return data.reversed()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 25) {
                        headerView
                        statisticsCards
                        chartSection
                        colorDistributionChart
                        quoteSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
            .sheet(item: $showingNewDayView) { identifiableId in
                if let entry = dataManager.dayEntries.first(where: { $0.id == identifiableId.wrappedId }) {
                    EditDayView(entry: entry)
                }
            }
        }
    }
    
    private var headerView: some View {
        Text("Statistics")
            .font(.playfairDisplay(24, weight: .bold))
            .foregroundColor(colorTheme.primaryWhite)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    
    private var statisticsCards: some View {
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                StatCard(
                    title: "Total Days",
                    value: "\(statistics.totalDays)",
                    icon: "calendar",
                    color: colorTheme.primaryPurple
                )
                
                StatCard(
                    title: "Current Streak",
                    value: "\(statistics.currentStreak)",
                    icon: "flame",
                    color: colorTheme.warningOrange
                )
            }
            
            if let lastColor = statistics.lastSelectedColor {
                StatCard(
                    title: "Last Color",
                    value: lastColor.name,
                    icon: "paintbrush",
                    color: lastColor.color
                )
            }
            
            if let mostFrequentColor = statistics.mostFrequentColor {
                StatCard(
                    title: "Most Frequent",
                    value: mostFrequentColor.name,
                    icon: "star",
                    color: mostFrequentColor.color
                )
            }
        }
    }
    
    private var chartSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Weekly Mood Timeline")
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(colorTheme.primaryWhite)
            
            if #available(iOS 16.0, *) {
                Chart(chartData) { dataPoint in
                    if dataPoint.hasEntry {
                        BarMark(
                            x: .value("Date", dataPoint.date, unit: .day),
                            y: .value("Count", 1)
                        )
                        .foregroundStyle(dataPoint.color?.color ?? colorTheme.mediumGray)
                        .cornerRadius(4)
                    } else {
                        BarMark(
                            x: .value("Date", dataPoint.date, unit: .day),
                            y: .value("Count", 0.1)
                        )
                        .foregroundStyle(colorTheme.mediumGray.opacity(0.3))
                        .cornerRadius(4)
                    }
                }
                .frame(height: 120)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day, count: 1)) { _ in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                            .foregroundStyle(colorTheme.primaryWhite.opacity(0.3))
                        AxisTick(stroke: StrokeStyle(lineWidth: 0.5))
                            .foregroundStyle(colorTheme.primaryWhite.opacity(0.5))
                        AxisValueLabel()
                            .foregroundStyle(colorTheme.primaryWhite.opacity(0.7))
                            .font(.playfairDisplay(10, weight: .regular))
                    }
                }
                .chartYAxis {
                    AxisMarks { _ in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                            .foregroundStyle(colorTheme.primaryWhite.opacity(0.3))
                        AxisTick(stroke: StrokeStyle(lineWidth: 0.5))
                            .foregroundStyle(colorTheme.primaryWhite.opacity(0.5))
                    }
                }
            } else {
                VStack(spacing: 10) {
                    Text("Charts require iOS 16+")
                        .font(.playfairDisplay(14, weight: .medium))
                        .foregroundColor(colorTheme.primaryWhite.opacity(0.7))
                    
                    HStack(alignment: .bottom, spacing: 2) {
                        ForEach(Array(chartData.enumerated()), id: \.offset) { index, dataPoint in
                            Rectangle()
                                .fill(dataPoint.hasEntry ? (dataPoint.color?.color ?? colorTheme.mediumGray) : colorTheme.mediumGray.opacity(0.3))
                                .frame(width: 8, height: dataPoint.hasEntry ? 40 : 8)
                                .cornerRadius(2)
                        }
                    }
                    .frame(height: 50)
                }
                .frame(height: 120)
            }
        }
        .padding()
        .background(colorTheme.primaryWhite.opacity(0.1))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(colorTheme.primaryWhite.opacity(0.2), lineWidth: 1)
        )
    }
    
    private var colorDistributionChart: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Color Distribution")
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(colorTheme.primaryWhite)
            
            let colorCounts = Dictionary(grouping: dataManager.dayEntries, by: { $0.color.name })
                .mapValues { $0.count }
                .sorted { $0.value > $1.value }
            
            VStack(spacing: 8) {
                ForEach(Array(colorCounts.prefix(5)), id: \.key) { colorName, count in
                    if let color = colorTheme.moodColors.first(where: { $0.name == colorName }) {
                        HStack {
                            Circle()
                                .fill(color.color)
                                .frame(width: 20, height: 20)
                            
                            Text(colorName)
                                .font(.playfairDisplay(14, weight: .medium))
                                .foregroundColor(colorTheme.primaryWhite)
                            
                            Spacer()
                            
                            Text("\(count)")
                                .font(.playfairDisplay(14, weight: .semibold))
                                .foregroundColor(colorTheme.primaryWhite.opacity(0.8))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(colorTheme.primaryWhite.opacity(0.05))
                        .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(colorTheme.primaryWhite.opacity(0.1))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(colorTheme.primaryWhite.opacity(0.2), lineWidth: 1)
        )
    }
    
    private var quoteSection: some View {
        VStack(spacing: 10) {
            Text(todaysQuote.text)
                .font(.playfairDisplayItalic(16, weight: .medium))
                .foregroundColor(colorTheme.primaryWhite)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)
            
            if let author = todaysQuote.author {
                Text("— \(author)")
                    .font(.playfairDisplay(14, weight: .light))
                    .foregroundColor(colorTheme.primaryWhite.opacity(0.7))
            }
            
            Text("Quote updates every morning")
                .font(.playfairDisplay(12, weight: .light))
                .foregroundColor(colorTheme.primaryWhite.opacity(0.5))
                .padding(.top, 5)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(colorTheme.primaryPurple.opacity(0.2))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(colorTheme.primaryPurple.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var actionButtonSection: some View {
        Button(action: {
            if let todayEntry = dataManager.getTodayEntry() {
                showingNewDayView = IdentifiableID(todayEntry.id)
            } else {
                let dummyEntry = DayEntry(date: Date(), color: colorTheme.moodColors[0], description: "")
                dataManager.addDayEntry(dummyEntry)
                showingNewDayView = IdentifiableID(dummyEntry.id)
            }
        }) {
            Text(dataManager.getTodayEntry() != nil ? "Edit Today's Color" : "Choose Color of the Day")
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(colorTheme.primaryPurple)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(colorTheme.primaryWhite)
                .cornerRadius(25)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

struct ChartDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let color: MoodColor?
    let hasEntry: Bool
}


struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    @StateObject private var colorTheme = ColorTheme.shared
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(spacing: 2) {
                Text(value)
                    .font(.playfairDisplay(16, weight: .bold))
                    .foregroundColor(colorTheme.primaryWhite)
                
                Text(title)
                    .font(.playfairDisplay(12, weight: .medium))
                    .foregroundColor(colorTheme.primaryWhite.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(colorTheme.primaryWhite.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(colorTheme.primaryWhite.opacity(0.2), lineWidth: 1)
        )
    }
}

struct EmptyStatisticsView: View {
    @StateObject private var colorTheme = ColorTheme.shared
    @StateObject private var dataManager = DataManager.shared
    @State private var showingNewDayView: IdentifiableID<DayEntry.ID>?
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "chart.bar")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(colorTheme.primaryWhite.opacity(0.6))
            
            VStack(spacing: 15) {
                Text("No data yet. Start tracking your mood colors to see statistics.")
                    .font(.playfairDisplay(18, weight: .medium))
                    .foregroundColor(colorTheme.primaryWhite.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Button(action: {
                    let dummyEntry = DayEntry(date: Date(), color: colorTheme.moodColors[0], description: "")
                    dataManager.addDayEntry(dummyEntry)
                    showingNewDayView = IdentifiableID(dummyEntry.id)
                }) {
                    Text("Choose First Color")
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(colorTheme.primaryPurple)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(colorTheme.primaryWhite)
                        .cornerRadius(25)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
                .padding(.horizontal, 40)
            }
            
            Spacer()
        }
        .sheet(item: $showingNewDayView) { identifiableId in
            if let entry = dataManager.dayEntries.first(where: { $0.id == identifiableId.wrappedId }) {
                EditDayView(entry: entry)
            }
        }
    }
}

#Preview {
    StatisticsView()
}
