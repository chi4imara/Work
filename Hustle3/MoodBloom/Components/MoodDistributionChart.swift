import SwiftUI

struct MoodDistributionChart: View {
    let entries: [MoodEntry]
    let onMoodTapped: (MoodType) -> Void
    
    private var moodCounts: [MoodType: Int] {
        Dictionary(grouping: entries, by: { $0.mood })
            .mapValues { $0.count }
    }
    
    private var totalEntries: Int {
        entries.count
    }
    
    private var chartData: [PieSlice] {
        MoodType.allCases.compactMap { mood in
            let count = moodCounts[mood] ?? 0
            guard count > 0 else { return nil }
            
            let percentage = Double(count) / Double(totalEntries)
            return PieSlice(
                mood: mood,
                count: count,
                percentage: percentage,
                color: moodColor(for: mood)
            )
        }.sorted { $0.count > $1.count }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            if chartData.isEmpty {
                emptyChartView
            } else {
                HStack {
                    pieChartView
                    
                    legendView
                }
            }
        }
    }
    
    private var emptyChartView: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.pie")
                .font(.system(size: 40, weight: .light))
                .foregroundColor(Color.textSecondary.opacity(0.5))
            
            Text("No mood data available")
                .font(FontManager.body)
                .foregroundColor(Color.textSecondary)
        }
        .frame(height: 150)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.backgroundGray.opacity(0.3))
        )
    }
    
    private var pieChartView: some View {
        ZStack {
            ForEach(Array(chartData.enumerated()), id: \.offset) { index, slice in
                let startAngle = startAngle(for: index)
                let endAngle = endAngle(for: index)
                
                Button(action: {
                    onMoodTapped(slice.mood)
                }) {
                    PieSliceView(
                        startAngle: startAngle,
                        endAngle: endAngle,
                        color: slice.color
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(true)
            }
            
            Circle()
                .fill(Color.backgroundWhite)
                .frame(width: 60, height: 60)
            
            VStack(spacing: 2) {
                Text("\(totalEntries)")
                    .font(FontManager.subheadline)
                    .foregroundColor(Color.textPrimary)
                
                Text("entries")
                    .font(FontManager.small)
                    .foregroundColor(Color.textSecondary)
            }
        }
        .frame(width: 150, height: 150)
    }
    
    private var legendView: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(chartData, id: \.mood) { slice in
                    HStack(spacing: 12) {
                        Circle()
                            .fill(slice.color)
                            .frame(width: 12, height: 12)
                        
                        HStack(spacing: 4) {
                            Text(slice.mood.emoji)
                                .font(.system(size: 16))
                            
                            Text(slice.mood.description)
                                .font(FontManager.poppinsRegular(size: 10))
                                .foregroundColor(Color.textPrimary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("\(slice.count)")
                                .font(FontManager.body)
                                .foregroundColor(Color.textPrimary)
                            
                            Text("\(Int(slice.percentage * 100))%")
                                .font(FontManager.small)
                                .foregroundColor(Color.textSecondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    
    private func startAngle(for index: Int) -> Angle {
        let previousPercentages = chartData.prefix(index).reduce(0) { $0 + $1.percentage }
        return Angle(degrees: previousPercentages * 360 - 90)
    }
    
    private func endAngle(for index: Int) -> Angle {
        let previousPercentages = chartData.prefix(index + 1).reduce(0) { $0 + $1.percentage }
        return Angle(degrees: previousPercentages * 360 - 90)
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
}

struct PieSlice {
    let mood: MoodType
    let count: Int
    let percentage: Double
    let color: Color
}

struct PieSliceView: View {
    let startAngle: Angle
    let endAngle: Angle
    let color: Color
    
    var body: some View {
        Path { path in
            let center = CGPoint(x: 75, y: 75)
            let radius: CGFloat = 75
            let innerRadius: CGFloat = 30
            
            path.addArc(
                center: center,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: false
            )
            
            path.addArc(
                center: center,
                radius: innerRadius,
                startAngle: endAngle,
                endAngle: startAngle,
                clockwise: true
            )
            
            path.closeSubpath()
        }
        .fill(color)
        .overlay(
            Path { path in
                let center = CGPoint(x: 75, y: 75)
                let radius: CGFloat = 75
                let innerRadius: CGFloat = 30
                
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false
                )
                
                path.addArc(
                    center: center,
                    radius: innerRadius,
                    startAngle: endAngle,
                    endAngle: startAngle,
                    clockwise: true
                )
                
                path.closeSubpath()
            }
            .stroke(Color.backgroundWhite, lineWidth: 2)
        )
    }
}

#Preview {
    MoodDistributionChart(entries: []) { _ in }
        .padding()
}
