import SwiftUI

struct StatisticsView: View {
    @ObservedObject var statisticsViewModel: StatisticsViewModel
    @ObservedObject var tasksViewModel: TasksViewModel
    @State private var showAddTask = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("Statistics")
                            .font(.nunitoBold(size: 32))
                            .foregroundColor(Color.theme.primaryText)
                        
                        Text("Your task collection insights")
                            .font(.nunitoRegular(size: 16))
                            .foregroundColor(Color.theme.secondaryText)
                    }
                    .padding(.top, 20)
                    
                    if statisticsViewModel.totalTasks == 0 {
                        Spacer()
                        
                        EmptyStatisticsView(showAddTask: $showAddTask)
                    } else {
                        VStack(spacing: 24) {
                            OverviewCardsView(statisticsViewModel: statisticsViewModel)
                            
                            CategoryDistributionView(statisticsViewModel: statisticsViewModel)
                            
                            TimelineChartView(statisticsViewModel: statisticsViewModel)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
        .sheet(isPresented: $showAddTask) {
            AddEditTaskView(tasksViewModel: tasksViewModel)
        }
        .onAppear {
            statisticsViewModel.updateStatistics()
        }
        .onChange(of: tasksViewModel.tasks.count) { _ in
            statisticsViewModel.updateStatistics()
        }
    }
}

struct OverviewCardsView: View {
    @ObservedObject var statisticsViewModel: StatisticsViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            StatCard(
                title: "Total Tasks",
                value: "\(statisticsViewModel.totalTasks)",
                icon: "list.bullet",
                color: Color.theme.accentOrange
            )
            
            StatCard(
                title: "Last Added",
                value: lastAddedText,
                icon: "clock",
                color: Color.theme.accentYellow
            )
        }
    }
    
    private var lastAddedText: String {
        guard let lastDate = statisticsViewModel.lastAddedDate else {
            return "Never"
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: lastDate)
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
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.nunitoBold(size: 20))
                    .foregroundColor(Color.theme.primaryText)
                
                Text(title)
                    .font(.nunitoRegular(size: 12))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.theme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.theme.cardBorder, lineWidth: 1)
                )
        )
    }
}

struct CategoryDistributionView: View {
    @ObservedObject var statisticsViewModel: StatisticsViewModel
    @State private var selectedSegment: TaskCategory? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Category Distribution")
                .font(.nunitoBold(size: 20))
                .foregroundColor(Color.theme.primaryText)
            
            CustomPieChart(distribution: statisticsViewModel.categoryDistribution)
            
            if let selected = selectedSegment,
               let count = statisticsViewModel.categoryDistribution[selected] {
                SegmentDetailView(
                    category: selected,
                    value: count,
                    total: statisticsViewModel.totalTasks,
                    color: categoryColor(for: selected)
                )
                .transition(.asymmetric(
                    insertion: .scale.combined(with: .opacity),
                    removal: .scale.combined(with: .opacity)
                ))
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(Array(statisticsViewModel.categoryDistribution.keys), id: \.self) { category in
                    CategoryLegendItem(
                        category: category,
                        count: statisticsViewModel.categoryDistribution[category] ?? 0,
                        total: statisticsViewModel.totalTasks,
                        isSelected: selectedSegment == category
                    )
                }
            }
        }
        .padding(.all, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.theme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.theme.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private func categoryColor(for category: TaskCategory) -> Color {
        switch category {
        case .singing:
            return Color.theme.accentPurple
        case .dancing:
            return Color.theme.accentOrange
        case .animals:
            return Color.theme.accentGreen
        case .funny:
            return Color.theme.accentYellow
        case .other:
            return Color.theme.accentPink
        }
    }
}

struct CategoryLegendItem: View {
    let category: TaskCategory
    let count: Int
    let total: Int
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(categoryColor)
                .frame(width: isSelected ? 16 : 12, height: isSelected ? 16 : 12)
                .overlay(
                    Circle()
                        .stroke(Color.theme.primaryText, lineWidth: isSelected ? 2 : 0)
                )
                .animation(.easeInOut(duration: 0.2), value: isSelected)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(category.displayName)
                    .font(.nunitoMedium(size: isSelected ? 14 : 12))
                    .foregroundColor(isSelected ? categoryColor : Color.theme.primaryText)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
                
                Text("\(count) (\(percentage)%)")
                    .font(.nunitoRegular(size: 10))
                    .foregroundColor(Color.theme.secondaryText)
            }
            
            Spacer()
        }
        .padding(.vertical, isSelected ? 8 : 4)
        .padding(.horizontal, isSelected ? 12 : 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? categoryColor.opacity(0.1) : Color.clear)
                .animation(.easeInOut(duration: 0.2), value: isSelected)
        )
    }
    
    private var categoryColor: Color {
        switch category {
        case .singing:
            return Color.theme.accentPurple
        case .dancing:
            return Color.theme.accentOrange
        case .animals:
            return Color.theme.accentGreen
        case .funny:
            return Color.theme.accentYellow
        case .other:
            return Color.theme.accentPink
        }
    }
    
    private var percentage: Int {
        guard total > 0 else { return 0 }
        return Int(round(Double(count) / Double(total) * 100))
    }
}

struct TimelineChartView: View {
    @ObservedObject var statisticsViewModel: StatisticsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Activity")
                        .font(.nunitoBold(size: 20))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Text(periodDescription)
                        .font(.nunitoRegular(size: 14))
                        .foregroundColor(Color.theme.secondaryText)
                }
                
                Spacer()
                
                HStack(spacing: 6) {
                    ForEach(StatisticsViewModel.TimePeriod.allCases, id: \.self) { period in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                statisticsViewModel.updatePeriod(period)
                            }
                        }) {
                            Text(periodDisplayName(period))
                                .font(.nunitoMedium(size: 9))
                                .foregroundColor(
                                    statisticsViewModel.selectedPeriod == period ?
                                    Color.theme.buttonText : Color.theme.secondaryText
                                )
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(
                                            statisticsViewModel.selectedPeriod == period ?
                                            Color.theme.accentOrange : Color.theme.cardBackground
                                        )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(
                                            statisticsViewModel.selectedPeriod == period ?
                                            Color.theme.accentOrange : Color.theme.cardBorder,
                                            lineWidth: 1
                                        )
                                )
                        }
                    }
                }
            }
            
            HumanTimelineView(data: statisticsViewModel.timelineData, period: statisticsViewModel.selectedPeriod)
        }
        .padding(.all, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.theme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.theme.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var periodDescription: String {
        switch statisticsViewModel.selectedPeriod {
        case .week:
            return "Last 7 days"
        case .month:
            return "Last month"
        case .year:
            return "Last year"
        }
    }
    
    private func periodDisplayName(_ period: StatisticsViewModel.TimePeriod) -> String {
        switch period {
        case .week:
            return "Week"
        case .month:
            return "Month"
        case .year:
            return "Year"
        }
    }
}

struct EmptyStatisticsView: View {
    @Binding var showAddTask: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "chart.bar")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(Color.theme.secondaryText)
            
            VStack(spacing: 12) {
                Text("No Data Yet")
                    .font(.nunitoBold(size: 24))
                    .foregroundColor(Color.theme.primaryText)
                
                Text("Add some tasks to see your statistics and insights here!")
                    .font(.nunitoRegular(size: 16))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: { showAddTask = true }) {
                HStack(spacing: 12) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                    Text("Add First Task")
                        .font(.nunitoSemiBold(size: 16))
                }
                .foregroundColor(Color.theme.buttonText)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.theme.buttonPrimary)
                .cornerRadius(20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 100)
    }
}

struct HumanTimelineView: View {
    let data: [StatisticsViewModel.TimelineData]
    let period: StatisticsViewModel.TimePeriod
    @State private var animationProgress: Double = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if data.isEmpty {
                EmptyTimelineView()
            } else {
                TimelineSummaryView(data: data, period: period)
                
                TimelineVisualizationView(data: data, period: period, animationProgress: animationProgress)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2)) {
                animationProgress = 1.0
            }
        }
    }
}

struct TimelineSummaryView: View {
    let data: [StatisticsViewModel.TimelineData]
    let period: StatisticsViewModel.TimePeriod
    
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(totalTasks)")
                    .font(.nunitoBold(size: 24))
                    .foregroundColor(Color.theme.accentOrange)
                
                Text("tasks added")
                    .font(.nunitoRegular(size: 12))
                    .foregroundColor(Color.theme.secondaryText)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(averagePerDay)")
                    .font(.nunitoBold(size: 24))
                    .foregroundColor(Color.yellow)
                
                Text("average per day")
                    .font(.nunitoRegular(size: 12))
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.theme.cardBackground.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.theme.cardBorder.opacity(0.5), lineWidth: 1)
                )
        )
    }
    
    private var totalTasks: Int {
        data.reduce(0) { $0 + $1.count }
    }
    
    private var averagePerDay: String {
        let days = period == .week ? 7 : (period == .month ? 30 : 365)
        let average = Double(totalTasks) / Double(days)
        return String(format: "%.1f", average)
    }
}

struct TimelineVisualizationView: View {
    let data: [StatisticsViewModel.TimelineData]
    let period: StatisticsViewModel.TimePeriod
    let animationProgress: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Daily Details")
                .font(.nunitoSemiBold(size: 16))
                .foregroundColor(Color.theme.primaryText)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(Array(data.enumerated()), id: \.element.id) { index, dataPoint in
                        TimelineBarView(
                            dataPoint: dataPoint,
                            period: period,
                            animationProgress: animationProgress,
                            delay: Double(index) * 0.1
                        )
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
}

struct TimelineBarView: View {
    let dataPoint: StatisticsViewModel.TimelineData
    let period: StatisticsViewModel.TimePeriod
    let animationProgress: Double
    let delay: Double
    @State private var isHovered = false
    
    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 4)
                .fill(barColor)
                .frame(width: 24, height: max(4, barHeight * animationProgress))
                .shadow(
                    color: barColor.opacity(0.3),
                    radius: isHovered ? 4 : 2,
                    x: 0,
                    y: isHovered ? 2 : 1
                )
                .scaleEffect(isHovered ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isHovered)
                .onHover { hovering in
                    isHovered = hovering
                }
            
            Text(dateLabel)
                .font(.nunitoRegular(size: 10))
                .foregroundColor(Color.theme.secondaryText)
                .rotationEffect(.degrees(-45))
                .frame(width: 40)
            
            Text("\(dataPoint.count)")
                .font(.nunitoMedium(size: 12))
                .foregroundColor(Color.theme.primaryText)
                .opacity(animationProgress)
        }
    }
    
    private var barHeight: CGFloat {
        let maxCount = dataPoint.count
        return min(120, CGFloat(maxCount) * 8 + 20)
    }
    
    private var barColor: Color {
        switch dataPoint.count {
        case 0:
            return Color.theme.secondaryText.opacity(0.3)
        case 1...2:
            return Color.theme.accentYellow
        case 3...5:
            return Color.theme.accentOrange
        default:
            return Color.theme.accentGreen
        }
    }
    
    private var dateLabel: String {
        let formatter = DateFormatter()
        switch period {
        case .week:
            formatter.dateFormat = "dd/MM"
        case .month:
            formatter.dateFormat = "dd"
        case .year:
            formatter.dateFormat = "MMM"
        }
        return formatter.string(from: dataPoint.date)
    }
}

struct EmptyTimelineView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 40, weight: .light))
                .foregroundColor(Color.theme.secondaryText)
            
            VStack(spacing: 8) {
                Text("No Activity Yet")
                    .font(.nunitoSemiBold(size: 16))
                    .foregroundColor(Color.theme.primaryText)
                
                Text("Add some tasks to see your activity over time")
                    .font(.nunitoRegular(size: 14))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(height: 150)
        .frame(maxWidth: .infinity)
    }
}

