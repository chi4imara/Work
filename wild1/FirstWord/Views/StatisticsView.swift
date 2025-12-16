import SwiftUI

struct StatisticsView: View {
    @StateObject private var entryStore = EntryStore()
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Statistics")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(Color.theme.textPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                if entryStore.entries.isEmpty {
                    EmptyStatisticsView()
                } else {
                    StatisticsContentView(entryStore: entryStore)
                }
                
                Spacer()
            }
        }
    }
}

struct StatisticsContentView: View {
    let entryStore: EntryStore
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                PieChartView(statistics: entryStore.categoryStatistics())
                
                RecentEntriesView(entries: entryStore.recentEntries())
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 200)
        }
        .padding(.bottom, -100)
    }
}

struct PieChartView: View {
    let statistics: [CategoryStat]
    
    private var totalEntries: Int {
        statistics.reduce(0) { $0 + $1.count }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Phrases by Categories")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(Color.theme.textPrimary)
            
            ZStack {
                PieChart(statistics: statistics)
                    .frame(width: 200, height: 200)
                
                VStack(spacing: 4) {
                    Text("Total")
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(Color.theme.textSecondary)
                    
                    Text("\(totalEntries)")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(Color.theme.textPrimary)
                    
                    Text("entries")
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(Color.theme.textSecondary)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(statistics) { stat in
                    HStack(spacing: 8) {
                        Circle()
                            .fill(stat.category.color)
                            .frame(width: 12, height: 12)
                        
                        Text(stat.category.displayName)
                            .font(.ubuntu(14, weight: .regular))
                            .foregroundColor(Color.theme.textPrimary)
                        
                        Spacer()
                        
                        Text("\(stat.count)")
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(Color.theme.textSecondary)
                    }
                }
            }
        }
        .padding(20)
        .background(Color.theme.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.theme.cardBorder, lineWidth: 1)
        )
    }
}

struct PieChart: View {
    let statistics: [CategoryStat]
    
    private var totalCount: Double {
        Double(statistics.reduce(0) { $0 + $1.count })
    }
    
    var body: some View {
        ZStack {
            ForEach(Array(statistics.enumerated()), id: \.offset) { index, stat in
                PieSlice(
                    startAngle: startAngle(for: index),
                    endAngle: endAngle(for: index),
                    color: stat.category.color
                )
            }
        }
    }
    
    private func startAngle(for index: Int) -> Angle {
        let previousCount = statistics.prefix(index).reduce(0) { $0 + $1.count }
        return Angle.degrees(Double(previousCount) / totalCount * 360 - 90)
    }
    
    private func endAngle(for index: Int) -> Angle {
        let currentCount = statistics.prefix(index + 1).reduce(0) { $0 + $1.count }
        return Angle.degrees(Double(currentCount) / totalCount * 360 - 90)
    }
}

struct PieSlice: View {
    let startAngle: Angle
    let endAngle: Angle
    let color: Color
    
    var body: some View {
        Path { path in
            let center = CGPoint(x: 100, y: 100)
            let radius: CGFloat = 80
            
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

struct RecentEntriesView: View {
    let entries: [Entry]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Entries")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(Color.theme.textPrimary)
            
            VStack(spacing: 12) {
                ForEach(entries.prefix(5)) { entry in
                    RecentEntryRow(entry: entry)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color.theme.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.theme.cardBorder, lineWidth: 1)
        )
    }
}

struct RecentEntryRow: View {
    let entry: Entry
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(entry.category.color)
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.phrase)
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(Color.theme.textPrimary)
                    .lineLimit(1)
                
                HStack {
                    Text(entry.category.displayName)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(Color.theme.textSecondary)
                    
                    Text("•")
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(Color.theme.textSecondary)
                    
                    Text(entry.date.formattedShort())
                        .font(.ubuntu(12, weight: .regular))
                        .foregroundColor(Color.theme.textSecondary)
                }
            }
            
            Spacer()
        }
    }
}

struct EmptyStatisticsView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "chart.pie")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(Color.theme.textSecondary)
            
            Text("No data for statistics yet")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(Color.theme.textPrimary)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    StatisticsView()
}
