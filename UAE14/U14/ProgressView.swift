import SwiftUI
import Charts

struct PullUpProgressView: View {
    @ObservedObject var viewModel: PullUpViewModel
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                headerView
                
                periodFilterView
                
                if viewModel.filteredEntries.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            chartView
                            
                            statisticsView
                        }
                        .padding(.bottom, 120)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Progress")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
        .padding(.vertical, 10)
    }
    
    private var periodFilterView: some View {
        HStack(spacing: 12) {
            ForEach(TimePeriod.allCases, id: \.self) { period in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.selectedPeriod = period
                    }
                }) {
                    Text(period.rawValue)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(viewModel.selectedPeriod == period ? .white : AppColors.secondaryText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(viewModel.selectedPeriod == period ? AppColors.lightBlue : Color.clear)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(AppColors.cardBorder, lineWidth: 1)
                        )
                }
            }
            
            Spacer()
        }
        .padding(.bottom, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 80))
                .foregroundColor(AppColors.lightBlue.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No data to display progress")
                    .font(.ubuntu(20, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Add some workout entries to see your progress")
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
    }
    
    private var chartView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pull-ups Over Time")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            CustomLineChart(data: viewModel.chartData)
                .frame(height: 200)
                .cardStyle()
        }
    }
    
    private var statisticsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Statistics")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            let stats = viewModel.statistics
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ProgressStatCard(
                    title: "Max in One Day",
                    value: "\(stats.maxInOneDay)",
                    icon: "trophy.fill"
                )
                
                ProgressStatCard(
                    title: "Total Entries",
                    value: "\(stats.totalEntries)",
                    icon: "calendar"
                )
                
                ProgressStatCard(
                    title: "Total Pull-ups",
                    value: "\(stats.totalPullUps)",
                    icon: "sum"
                )
                
                ProgressStatCard(
                    title: "Average per Day",
                    value: String(format: "%.1f", stats.averagePerDay),
                    icon: "chart.bar.fill"
                )
            }
        }
    }
}

struct ProgressStatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(AppColors.lightBlue)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text(title)
                    .font(.ubuntu(12))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(16)
        .cardStyle()
    }
}

struct CustomLineChart: View {
    let data: [(Date, Int)]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppColors.cardBackground)
                
                if !data.isEmpty {
                    chartContent(in: geometry)
                } else {
                    Text("No data")
                        .font(.ubuntu(16))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
        }
        .padding(16)
    }
    
    private func chartContent(in geometry: GeometryProxy) -> some View {
        let maxValue = data.map { $0.1 }.max() ?? 1
        let minValue = data.map { $0.1 }.min() ?? 0
        let range = max(maxValue - minValue, 1)
        
        let width = geometry.size.width - 40
        let height = geometry.size.height - 40
        
        return ZStack {
            ForEach(0..<5) { i in
                let y = height - (CGFloat(i) / 4.0) * height + 20
                Path { path in
                    path.move(to: CGPoint(x: 20, y: y))
                    path.addLine(to: CGPoint(x: width + 20, y: y))
                }
                .stroke(AppColors.cardBorder, lineWidth: 0.5)
            }
            
            Path { path in
                for (index, point) in data.enumerated() {
                    let x = 20 + (CGFloat(index) / CGFloat(max(data.count - 1, 1))) * width
                    let y = height - (CGFloat(point.1 - minValue) / CGFloat(range)) * height + 20
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(AppColors.lightBlue, lineWidth: 2)
            
            ForEach(Array(data.enumerated()), id: \.offset) { index, point in
                let x = 20 + (CGFloat(index) / CGFloat(max(data.count - 1, 1))) * width
                let y = height - (CGFloat(point.1 - minValue) / CGFloat(range)) * height + 20
                
                Circle()
                    .fill(AppColors.lightBlue)
                    .frame(width: 6, height: 6)
                    .position(x: x, y: y)
            }
        }
    }
}

#Preview {
    PullUpProgressView(viewModel: PullUpViewModel())
}
