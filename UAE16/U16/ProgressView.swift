import SwiftUI
import Charts

struct ProgressView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                headerView
                
                timePeriodFilterView
                
                ScrollView {
                    VStack(spacing: 24) {
                        if viewModel.workouts.isEmpty {
                            emptyStateView
                            
                            Spacer()
                        } else {
                            chartView
                            statisticsView
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Progress")
                .font(.ubuntu(size: 32, weight: .bold))
                .foregroundColor(AppColors.white)
            
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
    }
    
    private var timePeriodFilterView: some View {
        HStack(spacing: 12) {
            ForEach(TimePeriod.allCases, id: \.self) { period in
                Button(action: {
                    viewModel.selectedTimePeriod = period
                }) {
                    Text(period.displayName)
                        .font(.ubuntu(size: 14, weight: .medium))
                        .foregroundColor(viewModel.selectedTimePeriod == period ? AppColors.white : AppColors.gray)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(viewModel.selectedTimePeriod == period ? AppColors.lightBlue : AppColors.cardBackground)
                        )
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.gray)
            
            Text("No data to display progress")
                .font(.ubuntu(size: 18, weight: .medium))
                .foregroundColor(AppColors.gray)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(.top, 60)
    }
    
    private var chartView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Workout Frequency")
                .font(.ubuntu(size: 20, weight: .medium))
                .foregroundColor(AppColors.white)
            
            AdaptiveBarChart(data: chartData)
                .frame(minHeight: 200)
                .frame(maxHeight: 350)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                )
        }
    }
    
    private var statisticsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Statistics")
                .font(.ubuntu(size: 20, weight: .medium))
                .foregroundColor(AppColors.white)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                StatCard(
                    title: "Total Workouts",
                    value: "\(viewModel.progressStats.totalWorkouts)",
                    icon: "figure.strengthtraining.traditional",
                    color: AppColors.lightBlue
                )
                
                StatCard(
                    title: "Last Visit",
                    value: viewModel.progressStats.lastVisitDate != nil ? 
                        formatDate(viewModel.progressStats.lastVisitDate!) : "Never",
                    icon: "calendar",
                    color: AppColors.orange
                )
                
                StatCard(
                    title: "Most Trained",
                    value: viewModel.progressStats.mostTrainedMuscleGroup?.displayName ?? "None",
                    icon: "target",
                    color: AppColors.green
                )
                
                StatCard(
                    title: "Muscle Groups",
                    value: "\(viewModel.progressStats.uniqueMuscleGroups)",
                    icon: "list.bullet",
                    color: AppColors.red
                )
            }
        }
    }
    
    private var chartData: [ChartDataPoint] {
        let stats = viewModel.progressStats
        return stats.workoutsInPeriod.map { date, count in
            ChartDataPoint(date: date, value: Double(count))
        }.sorted { $0.date < $1.date }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.ubuntu(size: 20, weight: .bold))
                    .foregroundColor(AppColors.white)
                
                Text(title)
                    .font(.ubuntu(size: 12, weight: .regular))
                    .foregroundColor(AppColors.gray)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
        )
    }
}

struct ChartDataPoint {
    let date: Date
    let value: Double
}

struct AdaptiveBarChart: View {
    let data: [ChartDataPoint]
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        GeometryReader { geometry in
            if data.isEmpty {
                VStack {
                    Spacer()
                    Text("No data available")
                        .font(.ubuntu(size: 14, weight: .regular))
                        .foregroundColor(AppColors.gray)
                    Spacer()
                }
            } else {
                VStack(spacing: 0) {
                    chartBars(geometry: geometry)
                    
                    if data.count <= 15 {
                        dateLabels(geometry: geometry)
                            .padding(.top, 8)
                    }
                }
            }
        }
    }
    
    private func chartBars(geometry: GeometryProxy) -> some View {
        let maxValue = max(data.map(\.value).max() ?? 1, 1)
        let padding: CGFloat = horizontalSizeClass == .compact ? 8 : 12
        let chartHeight = data.count <= 15 ? geometry.size.height * 0.75 : geometry.size.height
        let barSpacing: CGFloat = horizontalSizeClass == .compact ? 4 : 6
        let totalSpacing = CGFloat(data.count - 1) * barSpacing
        let availableWidth = geometry.size.width - (padding * 2) - totalSpacing
        let barWidth = min(availableWidth / CGFloat(data.count), horizontalSizeClass == .compact ? 20 : 30)
        
        return ZStack(alignment: .bottomLeading) {
            gridLines(geometry: geometry, chartHeight: chartHeight)
            
            HStack(alignment: .bottom, spacing: barSpacing) {
                ForEach(Array(data.enumerated()), id: \.offset) { index, point in
                    VStack(spacing: 4) {
                        Spacer()
                        
                        let barHeight = CGFloat(point.value / maxValue) * chartHeight
                        
                        RoundedRectangle(cornerRadius: 6)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        AppColors.lightBlue,
                                        AppColors.orange.opacity(0.8)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: barWidth, height: max(barHeight, 4))
                            .overlay(
                                VStack {
                                    Spacer()
                                    if barHeight > 20 && data.count <= 10 {
                                        Text("\(Int(point.value))")
                                            .font(.ubuntu(size: 10, weight: .bold))
                                            .foregroundColor(AppColors.white)
                                            .padding(.bottom, 4)
                                    }
                                }
                            )
                    }
                }
            }
            .padding(.horizontal, padding)
            .padding(.bottom, data.count <= 15 ? 0 : padding)
        }
        .frame(height: chartHeight)
    }
    
    private func gridLines(geometry: GeometryProxy, chartHeight: CGFloat) -> some View {
        Path { path in
            let gridLines = 4
            let stepY = chartHeight / CGFloat(gridLines)
            
            for i in 0...gridLines {
                let y = CGFloat(i) * stepY
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: geometry.size.width, y: y))
            }
        }
        .stroke(AppColors.gray.opacity(0.2), lineWidth: 1)
    }
    
    private func dateLabels(geometry: GeometryProxy) -> some View {
        let labelCount = min(data.count, horizontalSizeClass == .compact ? 5 : 7)
        let step = max(1, data.count / labelCount)
        
        return HStack(spacing: 0) {
            ForEach(Array(data.enumerated()), id: \.offset) { index, point in
                if index % step == 0 || index == data.count - 1 {
                    Text(formatDateShort(point.date))
                        .font(.ubuntu(size: horizontalSizeClass == .compact ? 9 : 10, weight: .regular))
                        .foregroundColor(AppColors.gray)
                        .frame(maxWidth: .infinity)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                } else {
                    Spacer()
                }
            }
        }
        .frame(height: 20)
    }
    
    private func formatDateShort(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

#Preview {
    ProgressView(viewModel: WorkoutViewModel())
}
