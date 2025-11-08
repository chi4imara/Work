import SwiftUI

struct ExperienceChart: View {
    let experiences: [FirstExperience]
    let period: StatisticsPeriod
    
    @State private var selectedDataPoint: Int? = nil
    @State private var animateChart = false
    
    private var chartData: [ChartDataPoint] {
        let days: Int
        switch period {
        case .week: days = 7
        case .month: days = 30
        case .year: days = 365
        }
        
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -days, to: endDate) ?? endDate
        
        var dataPoints: [ChartDataPoint] = []
        
        for i in 0..<days {
            let date = Calendar.current.date(byAdding: .day, value: -i, to: endDate) ?? endDate
            let dayStart = Calendar.current.startOfDay(for: date)
            let dayEnd = Calendar.current.date(byAdding: .day, value: 1, to: dayStart) ?? dayStart
            
            let count = experiences.filter { experience in
                experience.date >= dayStart && experience.date < dayEnd
            }.count
            
            dataPoints.append(ChartDataPoint(
                date: date,
                count: count,
                dayOffset: i
            ))
        }
        
        return dataPoints.reversed()
    }
    
    private var maxCount: Int {
        max(1, chartData.map(\.count).max() ?? 1)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Activity Chart")
                    .font(FontManager.title3)
                    .foregroundColor(AppColors.pureWhite)
                
                Spacer()
                
                Text("Last \(period.rawValue)")
                    .font(FontManager.caption1)
                    .foregroundColor(AppColors.pureWhite.opacity(0.7))
            }
            
            VStack(spacing: 12) {
                HStack(alignment: .bottom, spacing: 0) {
                    VStack(alignment: .trailing, spacing: 0) {
                        ForEach((0...maxCount).reversed(), id: \.self) { value in
                            Text("\(value)")
                                .font(FontManager.caption2)
                                .foregroundColor(AppColors.pureWhite.opacity(0.6))
                                .frame(height: 20)
                        }
                    }
                    .frame(width: 20)
                    
                    HStack(alignment: .bottom, spacing: 2) {
                        ForEach(Array(chartData.enumerated()), id: \.offset) { index, dataPoint in
                            VStack(spacing: 0) {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                AppColors.accentYellow,
                                                AppColors.peachOrange
                                            ],
                                            startPoint: .bottom,
                                            endPoint: .top
                                        )
                                    )
                                    .frame(width: 8, height: max(2, CGFloat(dataPoint.count) / CGFloat(maxCount) * 120))
                                    .scaleEffect(y: animateChart ? 1 : 0, anchor: .bottom)
                                    .animation(
                                        .easeOut(duration: 0.8).delay(Double(index) * 0.05),
                                        value: animateChart
                                    )
                                
                                if shouldShowDateLabel(for: index) {
                                    Text(formatDateLabel(dataPoint.date))
                                        .font(FontManager.caption2)
                                        .foregroundColor(AppColors.pureWhite.opacity(0.6))
                                        .rotationEffect(.degrees(-45))
                                        .frame(height: 30)
                                } else {
                                    Spacer()
                                        .frame(height: 30)
                                }
                            }
                            .onTapGesture {
                                selectedDataPoint = selectedDataPoint == index ? nil : index
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(height: 150)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.pureWhite.opacity(0.1))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)

                        .stroke(AppColors.pureWhite.opacity(0.2), lineWidth: 1)
                    }
            )
            
            if let selectedIndex = selectedDataPoint,
               selectedIndex < chartData.count {
                let dataPoint = chartData[selectedIndex]
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(formatDateLabel(dataPoint.date))
                            .font(FontManager.caption1)
                            .foregroundColor(AppColors.pureWhite)
                        
                        Text("\(dataPoint.count) experience\(dataPoint.count == 1 ? "" : "s")")
                            .font(FontManager.caption2)
                            .foregroundColor(AppColors.pureWhite.opacity(0.7))
                    }
                    
                    Spacer()
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.accentYellow.opacity(0.2))
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                            .stroke(AppColors.accentYellow.opacity(0.3), lineWidth: 1)
                        }
                )
            }
        }
        .onAppear {
            animateChart = true
        }
    }
    
    private func shouldShowDateLabel(for index: Int) -> Bool {
        let interval: Int
        switch period {
        case .week: interval = 1
        case .month: interval = 3
        case .year: interval = 30
        }
        return index % interval == 0
    }
    
    private func formatDateLabel(_ date: Date) -> String {
        let formatter = DateFormatter()
        switch period {
        case .week:
            formatter.dateFormat = "E"
        case .month:
            formatter.dateFormat = "d"
        case .year:
            formatter.dateFormat = "MMM"
        }
        return formatter.string(from: date)
    }
}

struct ChartDataPoint {
    let date: Date
    let count: Int
    let dayOffset: Int
}


