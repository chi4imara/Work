import SwiftUI
import Charts

struct StatisticsView: View {
    @ObservedObject var viewModel: MatchViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                AppGradient.background
                    .ignoresSafeArea()
                
                if viewModel.matches.isEmpty {
                    emptyStateView
                } else {
                    statisticsContentView
                }
            }
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Image(systemName: "chart.bar")
                .font(.custom("Poppins-Light", size: 80))
                .foregroundColor(.secondaryText)
            
            VStack(spacing: 12) {
                Text("No Data Available")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primaryText)
                
                Text("Start adding matches to see your statistics")
                    .font(.body)
                    .foregroundColor(.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
    }
    
    private var statisticsContentView: some View {
        ScrollView {
            VStack(spacing: 24) {
                overallStatsView
                
                resultsChartView
                
                mvpFrequencyView
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
    
    private var overallStatsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overall Statistics")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primaryText)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                StatCard(
                    title: "Total Matches",
                    value: "\(viewModel.totalMatches)",
                    icon: "list.bullet",
                    color: .infoColor
                )
                
                StatCard(
                    title: "Victories",
                    value: "\(viewModel.wins)",
                    icon: "trophy.fill",
                    color: .successColor
                )
                
                StatCard(
                    title: "Defeats",
                    value: "\(viewModel.losses)",
                    icon: "xmark.circle.fill",
                    color: .errorColor
                )
                
                StatCard(
                    title: "Draws",
                    value: "\(viewModel.draws)",
                    icon: "equal.circle.fill",
                    color: .warningColor
                )
            }
        }
    }
    
    private var resultsChartView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Match Results Timeline")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primaryText)
            
            VStack(spacing: 12) {
                if #available(iOS 16.0, *) {
                    Chart(viewModel.matches.sorted(by: { $0.date < $1.date })) { match in
                        LineMark(
                            x: .value("Date", match.date),
                            y: .value("Score Difference", match.scoreDifference)
                        )
                        .foregroundStyle(match.scoreDifference >= 0 ? Color.successColor : Color.errorColor)
                        
                        PointMark(
                            x: .value("Date", match.date),
                            y: .value("Score Difference", match.scoreDifference)
                        )
                        .foregroundStyle(match.scoreDifference >= 0 ? Color.successColor : Color.errorColor)
                    }
                    .frame(height: 200)
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day, count: 7)) { _ in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel(format: .dateTime.month().day())
                        }
                    }
                } else {
                    SimpleChartView(matches: viewModel.matches)
                        .frame(height: 200)
                }
                
                HStack {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.successColor)
                            .frame(width: 8, height: 8)
                        Text("Positive")
                            .font(.caption)
                            .foregroundColor(.secondaryText)
                    }
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.errorColor)
                            .frame(width: 8, height: 8)
                        Text("Negative")
                            .font(.caption)
                            .foregroundColor(.secondaryText)
                    }
                    
                    Spacer()
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.cardBackground)
                    .shadow(color: Color.shadowColor, radius: 8, x: 0, y: 4)
            )
        }
    }
    
    private var mvpFrequencyView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("MVP Frequency")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primaryText)
            
            VStack(spacing: 12) {
                if viewModel.mvpFrequency.isEmpty {
                    Text("No MVP data available")
                        .font(.body)
                        .foregroundColor(.secondaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                } else {
                    ForEach(Array(viewModel.mvpFrequency.enumerated()), id: \.offset) { index, mvpData in
                        HStack {
                            HStack(spacing: 8) {
                                if index == 0 {
                                    Image(systemName: "crown.fill")
                                        .foregroundColor(.warningColor)
                                        .font(.caption)
                                } else {
                                    Text("\(index + 1)")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.secondaryText)
                                        .frame(width: 20)
                                }
                                
                                Text(mvpData.0)
                                    .font(.body)
                                    .foregroundColor(.primaryText)
                            }
                            
                            Spacer()
                            
                            Text("\(mvpData.1) MVP\(mvpData.1 == 1 ? "" : "s")")
                                .font(.caption)
                                .foregroundColor(.secondaryText)
                        }
                        .padding(.vertical, 8)
                        
                        if index < viewModel.mvpFrequency.count - 1 {
                            Divider()
                        }
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.cardBackground)
                    .shadow(color: Color.shadowColor, radius: 8, x: 0, y: 4)
            )
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryText)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackground)
                .shadow(color: Color.shadowColor, radius: 4, x: 0, y: 2)
        )
    }
}

struct SimpleChartView: View {
    let matches: [Match]
    
    private var sortedMatches: [Match] {
        matches.sorted(by: { $0.date < $1.date })
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    ForEach(0..<5) { _ in
                        Rectangle()
                            .fill(Color.secondaryBackground)
                            .frame(height: 1)
                        Spacer()
                    }
                }
                
                if !sortedMatches.isEmpty {
                    Path { path in
                        let width = geometry.size.width
                        let height = geometry.size.height
                        let maxDiff = sortedMatches.map { abs($0.scoreDifference) }.max() ?? 1
                        
                        for (index, match) in sortedMatches.enumerated() {
                            let x = width * CGFloat(index) / CGFloat(max(sortedMatches.count - 1, 1))
                            let y = height / 2 - (CGFloat(match.scoreDifference) / CGFloat(maxDiff)) * (height / 2 - 20)
                            
                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                    .stroke(Color.primaryAccent, lineWidth: 2)
                    
                    ForEach(Array(sortedMatches.enumerated()), id: \.offset) { index, match in
                        let width = geometry.size.width
                        let height = geometry.size.height
                        let maxDiff = sortedMatches.map { abs($0.scoreDifference) }.max() ?? 1
                        let x = width * CGFloat(index) / CGFloat(max(sortedMatches.count - 1, 1))
                        let y = height / 2 - (CGFloat(match.scoreDifference) / CGFloat(maxDiff)) * (height / 2 - 20)
                        
                        Circle()
                            .fill(match.scoreDifference >= 0 ? Color.successColor : Color.errorColor)
                            .frame(width: 6, height: 6)
                            .position(x: x, y: y)
                    }
                }
            }
        }
        .background(Color.cardBackground)
        .cornerRadius(8)
    }
}

#Preview {
    StatisticsView(viewModel: MatchViewModel())
}
