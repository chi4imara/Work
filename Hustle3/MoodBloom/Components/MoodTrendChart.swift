import SwiftUI

struct MoodTrendChart: View {
    let entries: [MoodEntry]
    let period: AnalyticsPeriod
    
    private var chartPoints: [TrendPoint] {
        entries.map { entry in
            TrendPoint(
                date: entry.date,
                value: entry.moodValue,
                mood: entry.mood,
                comment: entry.comment
            )
        }.sorted { $0.date < $1.date }
    }
    
    @State private var selectedPoint: TrendPoint?
    @State private var showingDetail = false
    
    var body: some View {
        VStack(spacing: 16) {
            if chartPoints.isEmpty {
                emptyChartView
            } else {
                chartView
            }
        }
    }
    
    private var emptyChartView: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 40, weight: .light))
                .foregroundColor(Color.textSecondary.opacity(0.5))
            
            Text("No data for selected period")
                .font(FontManager.body)
                .foregroundColor(Color.textSecondary)
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.backgroundGray.opacity(0.3))
        )
    }
    
    private var chartView: some View {
        VStack(spacing: 12) {
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                let padding: CGFloat = 20
                let chartWidth = width - padding * 2
                let chartHeight = height - padding * 2
                
                ZStack {
                    gridView(width: chartWidth, height: chartHeight, padding: padding)
                    
                    if chartPoints.count > 1 {
                        trendLine(width: chartWidth, height: chartHeight, padding: padding)
                    }
                    
                    ForEach(Array(chartPoints.enumerated()), id: \.offset) { index, point in
                        let x = padding + (chartWidth / CGFloat(max(chartPoints.count - 1, 1))) * CGFloat(index)
                        let y = padding + chartHeight - ((CGFloat(point.value + 2) / 4.0) * chartHeight)
                        
                        Button(action: {
                            selectedPoint = point
                            showingDetail = true
                        }) {
                            Circle()
                                .fill(moodColor(for: point.mood))
                                .frame(width: 12, height: 12)
                                .overlay(
                                    Circle()
                                        .stroke(Color.backgroundWhite, lineWidth: 2)
                                )
                                .shadow(color: moodColor(for: point.mood).opacity(0.3), radius: 4)
                        }
                        .position(x: x, y: y)
                    }
                }
            }
            .frame(height: 200)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.backgroundGray.opacity(0.1))
            )
            
            yAxisLabels
        }
        .sheet(item: $selectedPoint) { point in
                MoodDetailSheet(point: point)
        }
    }
    
    private func gridView(width: CGFloat, height: CGFloat, padding: CGFloat) -> some View {
        ZStack {
            ForEach(-2...2, id: \.self) { value in
                let y = padding + height - ((CGFloat(value + 2) / 4.0) * height)
                Path { path in
                    path.move(to: CGPoint(x: padding, y: y))
                    path.addLine(to: CGPoint(x: padding + width, y: y))
                }
                .stroke(Color.textSecondary.opacity(0.2), lineWidth: 1)
            }
        }
    }
    
    private func trendLine(width: CGFloat, height: CGFloat, padding: CGFloat) -> some View {
        Path { path in
            for (index, point) in chartPoints.enumerated() {
                let x = padding + (width / CGFloat(max(chartPoints.count - 1, 1))) * CGFloat(index)
                let y = padding + height - ((CGFloat(point.value + 2) / 4.0) * height)
                
                if index == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
        }
        .stroke(
            LinearGradient(
                gradient: Gradient(colors: [Color.primaryBlue, Color.lightBlue]),
                startPoint: .leading,
                endPoint: .trailing
            ),
            lineWidth: 2
        )
    }
    
    private var yAxisLabels: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(stride(from: 2, through: -2, by: -1)), id: \.self) { value in
                    HStack {
                        Text(moodLabel(for: value))
                            .font(FontManager.small)
                            .foregroundColor(Color.textSecondary)
                        
                        Text(moodEmoji(for: value))
                            .font(.system(size: 12))
                    }
                    .frame(height: 40)
                }
            }
            
            Spacer()
        }
    }
    
    private func moodColor(for mood: MoodType) -> Color {
        switch mood {
        case .veryBad: return Color.moodVeryBad
        case .bad: return Color.moodBad
        case .neutral: return Color.moodNeutral
        case .good: return Color.moodGood
        case .veryGood: return Color.moodVeryGood
        }
    }
    
    private func moodLabel(for value: Int) -> String {
        switch value {
        case 2: return "Great"
        case 1: return "Good"
        case 0: return "Neutral"
        case -1: return "Bad"
        case -2: return "Awful"
        default: return ""
        }
    }
    
    private func moodEmoji(for value: Int) -> String {
        switch value {
        case 2: return "😀"
        case 1: return "😊"
        case 0: return "😐"
        case -1: return "😟"
        case -2: return "😢"
        default: return ""
        }
    }
}

struct TrendPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Int
    let mood: MoodType
    let comment: String
}

struct MoodDetailSheet: View {
    let point: TrendPoint
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 20) {
                    Text(formatDate(point.date))
                        .font(FontManager.headline)
                        .foregroundColor(Color.textPrimary)
                    
                    VStack(spacing: 8) {
                        Text(point.mood.emoji)
                            .font(.system(size: 60))
                        
                        Text(point.mood.description)
                            .font(FontManager.subheadline)
                            .foregroundColor(Color.textPrimary)
                    }
                    
                    if !point.comment.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Note:")
                                .font(FontManager.subheadline)
                                .foregroundColor(Color.textPrimary)
                            
                            Text(point.comment)
                                .font(FontManager.body)
                                .foregroundColor(Color.textSecondary)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.backgroundGray.opacity(0.5))
                                )
                        }
                    }
                    
                    Spacer()
                }
                .padding(20)
                .navigationTitle("Mood Details")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}

#Preview {
    MoodTrendChart(entries: [], period: .month)
        .padding()
}
