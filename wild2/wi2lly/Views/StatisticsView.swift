import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: WordsViewModel
    
    init(viewModel: WordsViewModel = WordsViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if viewModel.words.isEmpty {
                        emptyStateView
                    } else {
                        statisticsContent
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Statistics")
                    .font(.playfair(28, weight: .bold))
                    .foregroundColor(Color.theme.primaryBlue)
                
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var statisticsContent: some View {
        ScrollView {
            VStack(spacing: 30) {
                chartSection
                
                recentWordsSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 5)
        }
    }
    
    private var chartSection: some View {
        VStack(spacing: 20) {
            Text("Words by Category")
                .font(.playfair(22, weight: .semibold))
                .foregroundColor(Color.theme.primaryBlue)
            
            ZStack {
                PieChartView(statistics: viewModel.getStatistics())
                
                VStack(spacing: 4) {
                    Text("Total")
                        .font(.playfair(14, weight: .medium))
                        .foregroundColor(Color.theme.textGray)
                    
                    Text("\(viewModel.words.count)")
                        .font(.playfair(32, weight: .bold))
                        .foregroundColor(Color.white)
                    
                    Text("word\(viewModel.words.count == 1 ? "" : "s")")
                        .font(.playfair(14, weight: .medium))
                        .foregroundColor(Color.theme.textGray)
                }
            }
            .frame(width: 250, height: 250)
            .frame(maxWidth: .infinity)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(viewModel.getStatistics(), id: \.category.id) { statistic in
                    LegendItem(statistic: statistic)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.theme.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    private var recentWordsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Words")
                .font(.playfair(22, weight: .semibold))
                .foregroundColor(Color.theme.primaryBlue)
            
            VStack(spacing: 12) {
                ForEach(viewModel.getRecentWords()) { word in
                    RecentWordRow(word: word, viewModel: viewModel)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.theme.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "chart.pie")
                .font(.system(size: 80))
                .foregroundColor(Color.theme.primaryBlue.opacity(0.6))
            
            VStack(spacing: 16) {
                Text("No data for statistics yet")
                    .font(.playfair(24, weight: .semibold))
                    .foregroundColor(Color.theme.primaryBlue)
                    .multilineTextAlignment(.center)
                
                Text("Add some words to see your statistics")
                    .font(.playfair(16, weight: .regular))
                    .foregroundColor(Color.theme.textGray)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
    }
}

struct PieChartView: View {
    let statistics: [CategoryStatistic]
    @State private var animationProgress: CGFloat = 0
    
    var body: some View {
        ZStack {
            ForEach(Array(statistics.enumerated()), id: \.element.category.id) { index, statistic in
                PieSlice(
                    startAngle: startAngle(for: index),
                    endAngle: endAngle(for: index),
                    color: ColorTheme.categoryColors[statistic.category.colorIndex % ColorTheme.categoryColors.count]
                )
                .scaleEffect(animationProgress)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animationProgress = 1.0
            }
        }
    }
    
    private func startAngle(for index: Int) -> Angle {
        let previousPercentages = statistics.prefix(index).map { $0.percentage }.reduce(0, +)
        return .degrees(previousPercentages * 360 - 90)
    }
    
    private func endAngle(for index: Int) -> Angle {
        let previousPercentages = statistics.prefix(index + 1).map { $0.percentage }.reduce(0, +)
        return .degrees(previousPercentages * 360 - 90)
    }
}

struct PieSlice: View {
    let startAngle: Angle
    let endAngle: Angle
    let color: Color
    
    var body: some View {
        Path { path in
            let center = CGPoint(x: 125, y: 125)
            let radius: CGFloat = 100
            
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
        .overlay(
            Path { path in
                let center = CGPoint(x: 125, y: 125)
                let radius: CGFloat = 100
                
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
            .stroke(Color.white, lineWidth: 2)
        )
    }
}

struct LegendItem: View {
    let statistic: CategoryStatistic
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(ColorTheme.categoryColors[statistic.category.colorIndex % ColorTheme.categoryColors.count])
                .frame(width: 12, height: 12)
            
            Text(statistic.category.name)
                .font(.playfair(14, weight: .medium))
                .foregroundColor(Color.theme.textGray)
            
            Spacer()
            
            Text("\(statistic.count)")
                .font(.playfair(14, weight: .semibold))
                .foregroundColor(Color.theme.primaryBlue)
        }
        .frame(maxWidth: .infinity)
    }
}

struct RecentWordRow: View {
    let word: WordModel
    @ObservedObject var viewModel: WordsViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(word.word)
                    .font(.playfair(16, weight: .semibold))
                    .foregroundColor(Color.theme.primaryBlue)
                
                Text(word.categoryName)
                    .font(.playfair(12, weight: .medium))
                    .foregroundColor(Color.theme.textGray)
            }
            
            Spacer()
            
            Text(DateFormatter.shortDate.string(from: word.dateAdded))
                .font(.playfair(12, weight: .medium))
                .foregroundColor(Color.theme.textGray)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    StatisticsView()
}
