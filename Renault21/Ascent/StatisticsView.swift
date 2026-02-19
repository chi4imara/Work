import SwiftUI
import Charts
import Combine

struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    @ObservedObject private var dataManager = DataManager.shared
    @State private var selectedTimeRange: TimeRange = .week
    
    var body: some View {
        VStack {
            HStack {
                Text("Statistics")
                    .font(FontManager.playfairBold(size: 26))
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            
            ScrollView {
                LazyVStack(spacing: 24) {
                    timeRangeSelector
                    
                    overviewCards
                    
                    activityChart
                    
                    categoryBreakdown
                    
                    weeklyProgress
                    
                    achievementsSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
        .primaryBackground()
        .onAppear {
            viewModel.loadStatistics()
        }
        .onChange(of: dataManager.itemsVersion) { _ in
            viewModel.loadStatistics()
        }
    }
    
    private var timeRangeSelector: some View {
        HStack(spacing: 0) {
            ForEach(TimeRange.allCases, id: \.self) { range in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTimeRange = range
                        viewModel.updateTimeRange(range)
                    }
                }) {
                    Text(range.rawValue)
                        .font(FontManager.playfairMedium(size: 14))
                        .foregroundColor(selectedTimeRange == range ? ColorTheme.primaryText : ColorTheme.primaryAccent)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(selectedTimeRange == range ? ColorTheme.primaryAccent : Color.clear)
                        .cornerRadius(10)
                }
            }
        }
        .padding(4)
        .cardBackground()
        .cornerRadius(14)
        .padding(.top, 10)
    }
    
    private var overviewCards: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
            StatCard(
                title: "Total Workouts",
                value: "\(viewModel.statistics.totalWorkouts)",
                icon: "dumbbell.fill",
                color: ColorTheme.primaryAccent,
                trend: viewModel.statistics.workoutTrend
            )
            
            StatCard(
                title: "Calories Tracked",
                value: "\(viewModel.statistics.totalCalories)",
                icon: "flame.fill",
                color: ColorTheme.success,
                trend: viewModel.statistics.caloriesTrend
            )
            
            StatCard(
                title: "Tasks Completed",
                value: "\(viewModel.statistics.totalTasks)",
                icon: "checkmark.circle.fill",
                color: ColorTheme.warning,
                trend: viewModel.statistics.tasksTrend
            )
            
            StatCard(
                title: "Challenges Won",
                value: "\(viewModel.statistics.totalChallenges)",
                icon: "trophy.fill",
                color: ColorTheme.error,
                trend: viewModel.statistics.challengesTrend
            )
        }
    }
    
    private var activityChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Activity Overview")
                .font(FontManager.playfairSemiBold(size: 20))
                .foregroundColor(ColorTheme.primaryText)
            
            if #available(iOS 16.0, *) {
                Chart(viewModel.chartData) { item in
                    LineMark(
                        x: .value("Date", item.date),
                        y: .value("Count", item.count)
                    )
                    .foregroundStyle(ColorTheme.primaryAccent)
                    .lineStyle(StrokeStyle(lineWidth: 3))
                    
                    AreaMark(
                        x: .value("Date", item.date),
                        y: .value("Count", item.count)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [ColorTheme.primaryAccent.opacity(0.3), ColorTheme.primaryAccent.opacity(0.0)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { _ in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                            .foregroundStyle(ColorTheme.secondaryText.opacity(0.3))
                        AxisTick(stroke: StrokeStyle(lineWidth: 0.5))
                            .foregroundStyle(ColorTheme.secondaryText.opacity(0.5))
                        AxisValueLabel()
                            .foregroundStyle(ColorTheme.secondaryText)
                            .font(FontManager.playfairRegular(size: 12))
                    }
                }
                .chartYAxis {
                    AxisMarks { _ in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                            .foregroundStyle(ColorTheme.secondaryText.opacity(0.3))
                        AxisTick(stroke: StrokeStyle(lineWidth: 0.5))
                            .foregroundStyle(ColorTheme.secondaryText.opacity(0.5))
                        AxisValueLabel()
                            .foregroundStyle(ColorTheme.secondaryText)
                            .font(FontManager.playfairRegular(size: 12))
                    }
                }
            } else {
                CustomLineChart(data: viewModel.chartData)
                    .frame(height: 200)
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .cardBackground()
        .cornerRadius(20)
    }
    
    private var categoryBreakdown: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Category Breakdown")
                .font(FontManager.playfairSemiBold(size: 20))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 12) {
                CategoryProgressBar(
                    title: "Workouts",
                    progress: viewModel.statistics.workoutProgress,
                    color: ColorTheme.primaryAccent
                )
                
                CategoryProgressBar(
                    title: "Nutrition",
                    progress: viewModel.statistics.nutritionProgress,
                    color: ColorTheme.success
                )
                
                CategoryProgressBar(
                    title: "Tasks",
                    progress: viewModel.statistics.tasksProgress,
                    color: ColorTheme.warning
                )
                
                CategoryProgressBar(
                    title: "Challenges",
                    progress: viewModel.statistics.challengesProgress,
                    color: ColorTheme.error
                )
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .cardBackground()
        .cornerRadius(20)
    }
    
    private var weeklyProgress: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Progress")
                .font(FontManager.playfairSemiBold(size: 20))
                .foregroundColor(ColorTheme.primaryText)
            
            HStack(spacing: 8) {
                ForEach(viewModel.weeklyData, id: \.day) { dayData in
                    VStack(spacing: 8) {
                        Text(dayData.day)
                            .font(FontManager.playfairRegular(size: 12))
                            .foregroundColor(ColorTheme.secondaryText)
                        
                        ZStack {
                            Circle()
                                .fill(ColorTheme.primaryAccent.opacity(0.2))
                                .frame(width: 40, height: 40)
                            
                            Circle()
                                .trim(from: 0, to: dayData.progress)
                                .stroke(ColorTheme.primaryAccent, lineWidth: 3)
                                .frame(width: 40, height: 40)
                                .rotationEffect(.degrees(-90))
                            
                            Text("\(Int(dayData.progress * 100))")
                                .font(FontManager.playfairSemiBold(size: 10))
                                .foregroundColor(ColorTheme.primaryText)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .cardBackground()
        .cornerRadius(20)
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Achievements")
                .font(FontManager.playfairSemiBold(size: 20))
                .foregroundColor(ColorTheme.primaryText)
            
            LazyVStack(spacing: 12) {
                ForEach(viewModel.achievements) { achievement in
                    AchievementRow(achievement: achievement)
                }
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .cardBackground()
        .cornerRadius(20)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let trend: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: trend >= 0 ? "arrow.up" : "arrow.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(trend >= 0 ? ColorTheme.success : ColorTheme.error)
                    
                    Text(String(format: "%.1f%%", abs(trend)))
                        .font(FontManager.playfairRegular(size: 12))
                        .foregroundColor(trend >= 0 ? ColorTheme.success : ColorTheme.error)
                }
                .id("\(value)-\(trend)")
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(FontManager.playfairBold(size: 24))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text(title)
                    .font(FontManager.playfairRegular(size: 14))
                    .foregroundColor(ColorTheme.secondaryText)
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .cardBackground()
        .cornerRadius(16)
    }
}

struct CategoryProgressBar: View {
    let title: String
    let progress: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(FontManager.playfairMedium(size: 16))
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(FontManager.playfairSemiBold(size: 14))
                    .foregroundColor(color)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(color.opacity(0.2))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [color, color.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress, height: 8)
                        .cornerRadius(4)
                        .animation(.easeInOut(duration: 1.0), value: progress)
                }
            }
            .frame(height: 8)
        }
    }
}

struct AchievementRow: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(achievement.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(achievement.color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(FontManager.playfairSemiBold(size: 16))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text(achievement.description)
                    .font(FontManager.playfairRegular(size: 14))
                    .foregroundColor(ColorTheme.secondaryText)
                
                Text(achievement.date, style: .date)
                    .font(FontManager.playfairRegular(size: 12))
                    .foregroundColor(ColorTheme.secondaryText.opacity(0.7))
            }
            
            Spacer()
            
            if achievement.isNew {
                Circle()
                    .fill(ColorTheme.primaryAccent)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.vertical, 8)
    }
}

struct CustomLineChart: View {
    let data: [ChartDataPoint]
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                guard !data.isEmpty else { return }
                
                let maxValue = max(data.map(\.count).max() ?? 1, 1)
                let stepX = data.count > 1 ? geometry.size.width / CGFloat(data.count - 1) : geometry.size.width
                let stepY = geometry.size.height / CGFloat(maxValue)
                
                for (index, point) in data.enumerated() {
                    let x = CGFloat(index) * stepX
                    let y = geometry.size.height - (CGFloat(point.count) * stepY)
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(ColorTheme.primaryAccent, lineWidth: 3)
        }
    }
}

class StatisticsViewModel: ObservableObject {
    @Published var statistics = StatisticsData()
    @Published var chartData: [ChartDataPoint] = []
    @Published var weeklyData: [WeeklyDataPoint] = []
    @Published var achievements: [Achievement] = []
    
    private let calendar = Calendar.current
    
    func loadStatistics() {
        let dm = DataManager.shared
        
        let totalWorkouts = dm.workouts.count
        let totalCalories = dm.nutritionItems.reduce(0) { $0 + $1.calories }
        let totalTasks = dm.tasks.count
        
        let completedWorkouts = dm.workouts.filter(\.isCompleted).count
        let completedNutrition = dm.nutritionItems.filter(\.isCompleted).count
        let completedTasks = dm.tasks.filter(\.isCompleted).count
        
        let totalChallenges = dm.dailyProgress.values.reduce(0) { $0 + $1.challengesCompleted }
        
        let workoutProgress = totalWorkouts > 0 ? Double(completedWorkouts) / Double(totalWorkouts) : 0
        let nutritionProgress = dm.nutritionItems.count > 0 ? Double(completedNutrition) / Double(dm.nutritionItems.count) : 0
        let tasksProgress = totalTasks > 0 ? Double(completedTasks) / Double(totalTasks) : 0
        let maxPossibleChallenges = dm.dailyProgress.count
        let challengesProgress = maxPossibleChallenges > 0 ? Double(totalChallenges) / Double(max(1, maxPossibleChallenges)) : 0
        
        statistics = StatisticsData(
            totalWorkouts: totalWorkouts,
            totalCalories: totalCalories,
            totalTasks: totalTasks,
            totalChallenges: totalChallenges,
            workoutTrend: 0,
            caloriesTrend: 0,
            tasksTrend: 0,
            challengesTrend: 0,
            workoutProgress: min(workoutProgress, 1.0),
            nutritionProgress: min(nutritionProgress, 1.0),
            tasksProgress: min(tasksProgress, 1.0),
            challengesProgress: min(challengesProgress, 1.0)
        )
        
        chartData = buildChartData(from: dm)
        
        weeklyData = buildWeeklyData(from: dm)
        
        achievements = buildAchievements(
            totalWorkouts: totalWorkouts,
            completedWorkouts: completedWorkouts,
            totalCalories: totalCalories,
            nutritionCount: dm.nutritionItems.count,
            completedNutrition: completedNutrition,
            totalTasks: totalTasks,
            completedTasks: completedTasks,
            totalChallenges: totalChallenges
        )
    }
    
    private func buildChartData(from dm: DataManager) -> [ChartDataPoint] {
        let daysCount = 7
        let startOfToday = calendar.startOfDay(for: Date())
        var result: [ChartDataPoint] = []
        
        for dayOffset in (0..<daysCount).reversed() {
            guard let day = calendar.date(byAdding: .day, value: -dayOffset, to: startOfToday) else { continue }
            
            let workoutsCount = dm.workouts.filter { calendar.isDate($0.createdDate, inSameDayAs: day) }.count
            let nutritionCount = dm.nutritionItems.filter { calendar.isDate($0.createdDate, inSameDayAs: day) }.count
            let tasksCount = dm.tasks.filter { calendar.isDate($0.createdDate, inSameDayAs: day) }.count
            let total = workoutsCount + nutritionCount + tasksCount
            
            result.append(ChartDataPoint(date: day, count: total))
        }
        return result
    }
    
    private func buildWeeklyData(from dm: DataManager) -> [WeeklyDataPoint] {
        let weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        guard let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) else {
            return weekdays.map { WeeklyDataPoint(day: $0, progress: 0) }
        }
        
        var dayCounts: [Int] = []
        var maxCount = 0
        
        for dayOffset in 0..<7 {
            guard let day = calendar.date(byAdding: .day, value: dayOffset, to: weekStart) else { continue }
            
            let completed = dm.workouts.filter { $0.isCompleted && $0.completedDate != nil && calendar.isDate($0.completedDate!, inSameDayAs: day) }.count
                + dm.nutritionItems.filter { $0.isCompleted && $0.completedDate != nil && calendar.isDate($0.completedDate!, inSameDayAs: day) }.count
                + dm.tasks.filter { $0.isCompleted && $0.completedDate != nil && calendar.isDate($0.completedDate!, inSameDayAs: day) }.count
            
            dayCounts.append(completed)
            maxCount = max(maxCount, completed)
        }
        
        return zip(weekdays, dayCounts).map { day, count in
            let progress = maxCount > 0 ? Double(count) / Double(maxCount) : 0
            return WeeklyDataPoint(day: day, progress: progress)
        }
    }
    
    private func buildAchievements(
        totalWorkouts: Int,
        completedWorkouts: Int,
        totalCalories: Int,
        nutritionCount: Int,
        completedNutrition: Int,
        totalTasks: Int,
        completedTasks: Int,
        totalChallenges: Int
    ) -> [Achievement] {
        var list: [Achievement] = []
        let now = Date()
        
        if totalWorkouts >= 1 {
            list.append(Achievement(
                title: "First Workout",
                description: "Added your first workout",
                icon: "dumbbell.fill",
                color: ColorTheme.primaryAccent,
                date: now,
                isNew: totalWorkouts == 1
            ))
        }
        if totalWorkouts >= 5 {
            list.append(Achievement(
                title: "Workout Regular",
                description: "Added 5 workouts",
                icon: "dumbbell.fill",
                color: ColorTheme.primaryAccent,
                date: now,
                isNew: totalWorkouts == 5
            ))
        }
        if completedWorkouts >= 1 {
            list.append(Achievement(
                title: "Workout Done",
                description: "Completed your first workout",
                icon: "checkmark.circle.fill",
                color: ColorTheme.success,
                date: now,
                isNew: completedWorkouts == 1
            ))
        }
        
        if nutritionCount >= 1 {
            list.append(Achievement(
                title: "First Meal",
                description: "Tracked your first meal",
                icon: "leaf.fill",
                color: ColorTheme.success,
                date: now,
                isNew: nutritionCount == 1
            ))
        }
        if totalCalories >= 1000 {
            list.append(Achievement(
                title: "Calorie Tracker",
                description: "Tracked 1,000+ calories",
                icon: "flame.fill",
                color: ColorTheme.success,
                date: now,
                isNew: totalCalories < 2000
            ))
        }
        if completedNutrition >= 1 {
            list.append(Achievement(
                title: "Meal Logged",
                description: "Logged a completed meal",
                icon: "leaf.fill",
                color: ColorTheme.success,
                date: now,
                isNew: completedNutrition == 1
            ))
        }
        
        if totalTasks >= 1 {
            list.append(Achievement(
                title: "First Task",
                description: "Added your first task",
                icon: "checkmark.circle.fill",
                color: ColorTheme.warning,
                date: now,
                isNew: totalTasks == 1
            ))
        }
        if totalTasks >= 5 {
            list.append(Achievement(
                title: "Task Planner",
                description: "Added 5 tasks",
                icon: "list.bullet",
                color: ColorTheme.warning,
                date: now,
                isNew: totalTasks == 5
            ))
        }
        if completedTasks >= 1 {
            list.append(Achievement(
                title: "Task Done",
                description: "Completed your first task",
                icon: "checkmark.circle.fill",
                color: ColorTheme.warning,
                date: now,
                isNew: completedTasks == 1
            ))
        }
        
        if totalChallenges >= 1 {
            list.append(Achievement(
                title: "Challenge Completed",
                description: "Completed a daily challenge",
                icon: "trophy.fill",
                color: ColorTheme.error,
                date: now,
                isNew: totalChallenges == 1
            ))
        }
        
        return Array(list.suffix(8))
    }
    
    func updateTimeRange(_ range: TimeRange) {
        loadStatistics()
    }
}

struct StatisticsData {
    var totalWorkouts: Int = 0
    var totalCalories: Int = 0
    var totalTasks: Int = 0
    var totalChallenges: Int = 0
    
    var workoutTrend: Double = 0
    var caloriesTrend: Double = 0
    var tasksTrend: Double = 0
    var challengesTrend: Double = 0
    
    var workoutProgress: Double = 0
    var nutritionProgress: Double = 0
    var tasksProgress: Double = 0
    var challengesProgress: Double = 0
}

struct ChartDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}

struct WeeklyDataPoint {
    let day: String
    let progress: Double
}

struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let color: Color
    let date: Date
    let isNew: Bool
}

enum TimeRange: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
}

#Preview {
    StatisticsView()
}
