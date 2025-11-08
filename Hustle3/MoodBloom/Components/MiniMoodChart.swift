import SwiftUI

struct MiniMoodChart: View {
    let entries: [MoodEntry]
    let selectedDate: Date
    let selectedMood: MoodType?
    
    private let calendar = Calendar.current
    
    private var chartData: [ChartPoint] {
        let last7Days = (0..<7).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: -dayOffset, to: selectedDate)
        }.reversed()
        
        return last7Days.map { date in
            let entry = entries.first { calendar.isDate($0.date, inSameDayAs: date) }
            let mood = calendar.isDate(date, inSameDayAs: selectedDate) ? selectedMood : entry?.mood
            
            return ChartPoint(
                date: date,
                mood: mood,
                isSelected: calendar.isDate(date, inSameDayAs: selectedDate)
            )
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                let pointSpacing = width / CGFloat(max(chartData.count - 1, 1))
                
                ZStack {
                    ForEach(-2...2, id: \.self) { value in
                        let y = yPosition(for: value, in: height)
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: width, y: y))
                        }
                        .stroke(Color.textSecondary.opacity(0.2), lineWidth: 1)
                    }
                    
                    if chartData.count > 1 {
                        Path { path in
                            let validPoints = chartData.enumerated().compactMap { index, point -> CGPoint? in
                                guard let mood = point.mood else { return nil }
                                let x = CGFloat(index) * pointSpacing
                                let y = yPosition(for: mood.rawValue, in: height)
                                return CGPoint(x: x, y: y)
                            }
                            
                            if let firstPoint = validPoints.first {
                                path.move(to: firstPoint)
                                for point in validPoints.dropFirst() {
                                    path.addLine(to: point)
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
                    
                    ForEach(Array(chartData.enumerated()), id: \.offset) { index, point in
                        if let mood = point.mood {
                            let x = CGFloat(index) * pointSpacing
                            let y = yPosition(for: mood.rawValue, in: height)
                            
                            Circle()
                                .fill(point.isSelected ? Color.primaryBlue : moodColor(for: mood))
                                .frame(width: point.isSelected ? 12 : 8, height: point.isSelected ? 12 : 8)
                                .position(x: x, y: y)
                                .overlay(
                                    Circle()
                                        .stroke(Color.backgroundWhite, lineWidth: 2)
                                        .frame(width: point.isSelected ? 12 : 8, height: point.isSelected ? 12 : 8)
                                        .position(x: x, y: y)
                                )
                        }
                    }
                }
            }
            .frame(height: 120)
            
            HStack {
                ForEach(Array(chartData.enumerated()), id: \.offset) { index, point in
                    VStack(spacing: 4) {
                        Text(dayLabel(for: point.date))
                            .font(FontManager.small)
                            .foregroundColor(point.isSelected ? Color.primaryBlue : Color.textSecondary)
                        
                        if let mood = point.mood {
                            Text(mood.emoji)
                                .font(.system(size: 12))
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.backgroundGray.opacity(0.3))
        )
    }
    
    private func yPosition(for value: Int, in height: CGFloat) -> CGFloat {
        let normalizedValue = CGFloat(value + 2) / 4.0 
        return height - (normalizedValue * height)
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
    
    private func dayLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
}

struct ChartPoint {
    let date: Date
    let mood: MoodType?
    let isSelected: Bool
}

#Preview {
    MiniMoodChart(
        entries: [],
        selectedDate: Date(),
        selectedMood: .good
    )
    .padding()
}
