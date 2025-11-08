import SwiftUI

struct ProjectProgressView: View {
    @ObservedObject var viewModel: TaskViewModel
    @State private var selectedSegment: TaskStatus?
    @State private var animateChart = false
    
    private var statistics: TaskStatistics {
        viewModel.taskStatistics()
    }
    
    var body: some View {
        ZStack {
            StaticBackground()
            
            ScrollView {
                VStack(spacing: 32) {
                    ProgressHeader(statistics: statistics)
                    
                    if statistics.total > 0 {
                        PieChartView(
                            statistics: statistics,
                            selectedSegment: $selectedSegment,
                            animateChart: $animateChart
                        )
                        
                        StatisticsCards(statistics: statistics)
                        
                        AchievementsView(statistics: statistics)
                        
                        ProductivityInsightsView(viewModel: viewModel)
                        
                        if let selectedSegment = selectedSegment {
                            TasksByStatusView(
                                status: selectedSegment,
                                tasks: viewModel.tasksForStatus(selectedSegment)
                            )
                        }
                    } else {
                        EmptyProgressView()
                    }
                    
                    Spacer(minLength: 50)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animateChart = true
            }
        }
    }
}

struct ProgressHeader: View {
    let statistics: TaskStatistics
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Project Progress")
                .font(AppFonts.title2)
                .foregroundColor(AppColors.primaryText)
            
            Text("Track your home project completion")
                .font(AppFonts.body)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
    }
}

struct PieChartView: View {
    let statistics: TaskStatistics
    @Binding var selectedSegment: TaskStatus?
    @Binding var animateChart: Bool
    
    private var chartData: [ChartSegment] {
        [
            ChartSegment(
                status: .completed,
                value: Double(statistics.completed),
                percentage: statistics.completedPercentage,
                color: AppColors.completedGreen
            ),
            ChartSegment(
                status: .inProgress,
                value: Double(statistics.inProgress),
                percentage: statistics.inProgressPercentage,
                color: AppColors.inProgressYellow
            ),
            ChartSegment(
                status: .overdue,
                value: Double(statistics.overdue),
                percentage: statistics.overduePercentage,
                color: AppColors.overdueRed
            )
        ].filter { $0.value > 0 }
    }
    
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                PieChart(
                    segments: chartData,
                    selectedSegment: $selectedSegment,
                    animate: animateChart
                )
                .frame(width: 200, height: 200)
                
                VStack(spacing: 4) {
                    Text("\(statistics.total)")
                        .font(AppFonts.title1)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Total Tasks")
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            
            HStack(spacing: 20) {
                ForEach(chartData, id: \.status) { segment in
                    LegendItem(
                        segment: segment,
                        isSelected: selectedSegment == segment.status
                    ) {
                        selectedSegment = selectedSegment == segment.status ? nil : segment.status
                    }
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

struct PieChart: View {
    let segments: [ChartSegment]
    @Binding var selectedSegment: TaskStatus?
    let animate: Bool
    
    var body: some View {
        ZStack {
            ForEach(Array(segments.enumerated()), id: \.element.status) { index, segment in
                PieSlice(
                    startAngle: startAngle(for: index),
                    endAngle: endAngle(for: index),
                    color: segment.color,
                    isSelected: selectedSegment == segment.status,
                    animate: animate
                )
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedSegment = selectedSegment == segment.status ? nil : segment.status
                    }
                }
            }
        }
    }
    
    private func startAngle(for index: Int) -> Angle {
        let previousPercentages = segments.prefix(index).reduce(0) { $0 + $1.percentage }
        return .degrees(previousPercentages * 360 - 90)
    }
    
    private func endAngle(for index: Int) -> Angle {
        let currentPercentage = segments.prefix(index + 1).reduce(0) { $0 + $1.percentage }
        return .degrees(currentPercentage * 360 - 90)
    }
}

struct PieSlice: View {
    let startAngle: Angle
    let endAngle: Angle
    let color: Color
    let isSelected: Bool
    let animate: Bool
    
    @State private var animatedEndAngle: Angle = .degrees(-90)
    
    var body: some View {
        Path { path in
            let center = CGPoint(x: 100, y: 100)
            let radius: CGFloat = isSelected ? 105 : 90
            
            path.move(to: center)
            path.addArc(
                center: center,
                radius: radius,
                startAngle: startAngle,
                endAngle: animatedEndAngle,
                clockwise: false
            )
            path.closeSubpath()
        }
        .fill(color)
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: isSelected)
        .onAppear {
            if animate {
                withAnimation(.easeInOut(duration: 1.0)) {
                    animatedEndAngle = endAngle
                }
            } else {
                animatedEndAngle = endAngle
            }
        }
        .onChange(of: animate) { newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 1.0)) {
                    animatedEndAngle = endAngle
                }
            }
        }
    }
}

struct LegendItem: View {
    let segment: ChartSegment
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Circle()
                    .fill(segment.color)
                    .frame(width: 16, height: 16)
                    .scaleEffect(isSelected ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: isSelected)
                
                VStack(spacing: 2) {
                    Text("\(Int(segment.value))")
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(segment.status.displayName)
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StatisticsCards: View {
    let statistics: TaskStatistics
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Statistics")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                StatCard(
                    title: "Completed",
                    value: "\(statistics.completed)",
                    percentage: statistics.completedPercentage,
                    color: AppColors.completedGreen
                )
                
                StatCard(
                    title: "In Progress",
                    value: "\(statistics.inProgress)",
                    percentage: statistics.inProgressPercentage,
                    color: AppColors.inProgressYellow
                )
                
                StatCard(
                    title: "Overdue",
                    value: "\(statistics.overdue)",
                    percentage: statistics.overduePercentage,
                    color: AppColors.overdueRed
                )
                
                StatCard(
                    title: "Total",
                    value: "\(statistics.total)",
                    percentage: 1.0,
                    color: AppColors.primaryBlue
                )
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let percentage: Double
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(AppFonts.callout)
                .foregroundColor(AppColors.secondaryText)
            
            Text(value)
                .font(AppFonts.title1)
                .foregroundColor(color)
            
            Text("\(Int(percentage * 100))%")
                .font(AppFonts.caption1)
                .foregroundColor(AppColors.lightText)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct TasksByStatusView: View {
    let status: TaskStatus
    let tasks: [Task]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("\(status.displayName) Tasks")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)
            
            if tasks.isEmpty {
                Text("No \(status.displayName.lowercased()) tasks")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 8) {
                    ForEach(tasks.prefix(5)) { task in
                        TaskProgressRow(task: task)
                    }
                    
                    if tasks.count > 5 {
                        Text("And \(tasks.count - 5) more...")
                            .font(AppFonts.caption1)
                            .foregroundColor(AppColors.secondaryText)
                            .padding(.top, 8)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.statusColor(for: status).opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct TaskProgressRow: View {
    let task: Task
    
    private var deadlineText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: task.deadline)
    }
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.statusColor(for: task.actualStatus))
                .frame(width: 8, height: 8)
            
            Text(task.title)
                .font(AppFonts.callout)
                .foregroundColor(AppColors.primaryText)
                .lineLimit(1)
            
            Spacer()
            
            Text(deadlineText)
                .font(AppFonts.caption1)
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(.vertical, 4)
    }
}

struct EmptyProgressView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "chart.pie")
                .font(.system(size: 64, weight: .light))
                .foregroundColor(AppColors.lightBlue)
            
            VStack(spacing: 8) {
                Text("No Tasks to Track")
                    .font(AppFonts.title3)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add some tasks to see your progress")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

struct ChartSegment {
    let status: TaskStatus
    let value: Double
    let percentage: Double
    let color: Color
}

struct ProgressTimelineView: View {
    @ObservedObject var viewModel: TaskViewModel
    @State private var selectedWeek = 0
    @State private var weeklyData: [WeeklyProgress] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Weekly Progress")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Text("Last 4 weeks")
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            if weeklyData.allSatisfy({ $0.totalTasks == 0 }) {
                VStack(spacing: 12) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 32, weight: .light))
                        .foregroundColor(AppColors.lightBlue)
                    
                    Text("No tasks scheduled for the last 4 weeks")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                    
                    Text("Add tasks with deadlines to see weekly progress")
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.lightText)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Array(weeklyData.enumerated()), id: \.offset) { index, week in
                            WeeklyProgressCard(
                                week: week,
                                isSelected: selectedWeek == index
                            ) {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedWeek = index
                                }
                            }
                        }
                    }
                    .padding(10)
                }
                .padding(.horizontal, -10)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .onAppear {
            generateWeeklyData()
        }
        .onChange(of: viewModel.tasks) { _ in
            generateWeeklyData()
        }
    }
    
    private func generateWeeklyData() {
        weeklyData = generateWeeklyProgress()
    }
    
    private func generateWeeklyProgress() -> [WeeklyProgress] {
        let calendar = Calendar.current
        let today = Date()
        var weeks: [WeeklyProgress] = []
        
        for i in 0..<4 {
            let weekStart = calendar.date(byAdding: .weekOfYear, value: -i, to: today)!
            let weekEnd = calendar.date(byAdding: .day, value: 6, to: weekStart)!
            
            let weekTasks = viewModel.tasks.filter { task in
                let taskDeadline = task.deadline
                return taskDeadline >= weekStart && taskDeadline <= weekEnd
            }
            
            let completed = weekTasks.filter { $0.actualStatus == .completed }.count
            let total = weekTasks.count
            
            let finalCompleted = total > 0 ? completed : 0
            let finalTotal = total > 0 ? total : 0
            
            weeks.append(WeeklyProgress(
                weekNumber: 4 - i,
                completedTasks: finalCompleted,
                totalTasks: finalTotal,
                weekStart: weekStart
            ))
        }
        
        return weeks.reversed()
    }
}

struct WeeklyProgressCard: View {
    let week: WeeklyProgress
    let isSelected: Bool
    let onTap: () -> Void
    
    @State private var animateProgress = false
    
    private var progressPercentage: Double {
        week.totalTasks > 0 ? Double(week.completedTasks) / Double(week.totalTasks) : 0
    }
    
    private var weekDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: week.weekStart)
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                onTap()
            }
        }) {
            VStack(spacing: 8) {
                Text("Week \(week.weekNumber)")
                    .font(AppFonts.callout)
                    .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.primaryText)
                    .fontWeight(isSelected ? .semibold : .regular)
                
                Text(weekDateString)
                    .font(AppFonts.caption2)
                    .foregroundColor(isSelected ? AppColors.primaryBlue.opacity(0.7) : AppColors.lightText)
                    .multilineTextAlignment(.center)
            }
                
                ZStack {
                    Circle()
                        .stroke(
                            isSelected ? AppColors.primaryBlue.opacity(0.2) : AppColors.lightBlue.opacity(0.3), 
                            lineWidth: isSelected ? 8 : 6
                        )
                        .frame(width: isSelected ? 70 : 60, height: isSelected ? 70 : 60)
                        .animation(.easeInOut(duration: 0.3), value: isSelected)
                    
                    Circle()
                        .trim(from: 0, to: animateProgress ? progressPercentage : 0)
                        .stroke(
                            LinearGradient(
                                colors: isSelected ? 
                                    [AppColors.primaryBlue, AppColors.accent] :
                                    [AppColors.primaryBlue.opacity(0.7), AppColors.accent.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(
                                lineWidth: isSelected ? 8 : 6, 
                                lineCap: .round
                            )
                        )
                        .frame(width: isSelected ? 70 : 60, height: isSelected ? 70 : 60)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 1.0), value: animateProgress)
                        .animation(.easeInOut(duration: 0.3), value: isSelected)
                    
                    Text("\(Int(progressPercentage * 100))%")
                        .font(isSelected ? AppFonts.callout : AppFonts.caption1)
                        .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.primaryText)
                        .fontWeight(isSelected ? .semibold : .regular)
                }
                
                VStack(spacing: 2) {
                    if week.totalTasks > 0 {
                        Text("\(week.completedTasks)/\(week.totalTasks)")
                            .font(AppFonts.caption1)
                            .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.secondaryText)
                            .fontWeight(isSelected ? .medium : .regular)
                        
                        Text("tasks")
                            .font(AppFonts.caption2)
                            .foregroundColor(isSelected ? AppColors.primaryBlue.opacity(0.7) : AppColors.lightText)
                    } else {
                        Text("No tasks")
                            .font(AppFonts.caption1)
                            .foregroundColor(isSelected ? AppColors.primaryBlue.opacity(0.6) : AppColors.lightText)
                            .fontWeight(isSelected ? .medium : .regular)
                        
                        Text("scheduled")
                            .font(AppFonts.caption2)
                            .foregroundColor(isSelected ? AppColors.primaryBlue.opacity(0.5) : AppColors.lightText)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        isSelected ? 
                            LinearGradient(
                                colors: [AppColors.primaryBlue.opacity(0.15), AppColors.accent.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                colors: [AppColors.cardBackground, AppColors.cardBackground],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? 
                                    LinearGradient(
                                        colors: [AppColors.primaryBlue, AppColors.accent],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ) : 
                                    LinearGradient(
                                        colors: [Color.clear, Color.clear],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                lineWidth: isSelected ? 2 : 0
                            )
                    )
            )
            .scaleEffect(isSelected ? 1.08 : 1.0)
            .shadow(
                color: isSelected ? AppColors.primaryBlue.opacity(0.3) : Color.clear,
                radius: isSelected ? 12 : 0,
                x: 0,
                y: isSelected ? 6 : 0
            )
            .animation(.easeInOut(duration: 0.3), value: isSelected)
            .buttonStyle(PlainButtonStyle())
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        animateProgress = true
                    }
                }
            }
        }
    }

struct AchievementsView: View {
    let statistics: TaskStatistics
    @State private var showCelebration = false
    
    private var achievements: [Achievement] {
        var achievements: [Achievement] = []
        
        if statistics.completed >= 1 {
            achievements.append(Achievement(
                title: "First Step",
                description: "Completed your first task",
                icon: "star.fill",
                color: AppColors.inProgressYellow,
                isUnlocked: true
            ))
        }
        
        if statistics.completed >= 5 {
            achievements.append(Achievement(
                title: "Getting Started",
                description: "Completed 5 tasks",
                icon: "trophy.fill",
                color: AppColors.completedGreen,
                isUnlocked: true
            ))
        }
        
        if statistics.completed >= 10 {
            achievements.append(Achievement(
                title: "Productivity Master",
                description: "Completed 10 tasks",
                icon: "crown.fill",
                color: AppColors.accent,
                isUnlocked: true
            ))
        }
        
        if statistics.completedPercentage >= 0.8 && statistics.total >= 5 {
            achievements.append(Achievement(
                title: "High Achiever",
                description: "80% completion rate",
                icon: "target",
                color: AppColors.purple,
                isUnlocked: true
            ))
        }
        
        return achievements
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Achievements")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                if !achievements.isEmpty {
                    Text("\(achievements.count) unlocked")
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            
            if achievements.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "star")
                        .font(.system(size: 32, weight: .light))
                        .foregroundColor(AppColors.lightBlue)
                    
                    Text("Keep working to unlock achievements!")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    ForEach(achievements, id: \.title) { achievement in
                        AchievementCard(achievement: achievement)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .onAppear {
            if !achievements.isEmpty {
                withAnimation(.easeInOut(duration: 0.5).delay(0.2)) {
                    showCelebration = true
                }
            }
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [achievement.color, achievement.color.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                    .shadow(color: achievement.color.opacity(0.3), radius: 8, x: 0, y: 4)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: isAnimating)
            }
            
            VStack(spacing: 4) {
                Text(achievement.title)
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(achievement.description)
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(achievement.color.opacity(0.2), lineWidth: 1)
                )
        )
        .onAppear {
            isAnimating = true
        }
    }
}

struct ProductivityInsightsView: View {
    @ObservedObject var viewModel: TaskViewModel
    @State private var insights: [ProductivityInsight] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Productivity Insights")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.inProgressYellow)
            }
            
            if insights.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 32, weight: .light))
                        .foregroundColor(AppColors.lightBlue)
                    
                    Text("Add more tasks to get personalized insights")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                VStack(spacing: 12) {
                    ForEach(insights, id: \.title) { insight in
                        InsightCard(insight: insight)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .onAppear {
            generateInsights()
        }
    }
    
    private func generateInsights() {
        let stats = viewModel.taskStatistics()
        var newInsights: [ProductivityInsight] = []
        
        if stats.total >= 3 {
            if stats.completedPercentage >= 0.7 {
                newInsights.append(ProductivityInsight(
                    title: "Great Progress!",
                    description: "You're completing 70% of your tasks. Keep up the excellent work!",
                    type: .positive,
                    icon: "checkmark.circle.fill"
                ))
            } else if stats.completedPercentage < 0.3 {
                newInsights.append(ProductivityInsight(
                    title: "Room for Improvement",
                    description: "Try breaking down large tasks into smaller, manageable steps.",
                    type: .suggestion,
                    icon: "lightbulb.fill"
                ))
            }
            
            if stats.overdue > stats.completed {
                newInsights.append(ProductivityInsight(
                    title: "Overdue Alert",
                    description: "You have more overdue tasks than completed ones. Consider adjusting deadlines.",
                    type: .warning,
                    icon: "exclamationmark.triangle.fill"
                ))
            }
            
            if stats.inProgress > 0 {
                newInsights.append(ProductivityInsight(
                    title: "Active Projects",
                    description: "You have \(stats.inProgress) active projects. Focus on completing them one by one.",
                    type: .info,
                    icon: "clock.fill"
                ))
            }
        }
        
        insights = newInsights
    }
}

struct InsightCard: View {
    let insight: ProductivityInsight
    
    private var iconColor: Color {
        switch insight.type {
        case .positive:
            return AppColors.completedGreen
        case .warning:
            return AppColors.overdueRed
        case .suggestion:
            return AppColors.inProgressYellow
        case .info:
            return AppColors.primaryBlue
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: insight.icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(iconColor)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(insight.title)
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.primaryText)
                
                Text(insight.description)
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(iconColor.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(iconColor.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct WeeklyProgress {
    let weekNumber: Int
    let completedTasks: Int
    let totalTasks: Int
    let weekStart: Date
}

struct Achievement {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let isUnlocked: Bool
}

struct ProductivityInsight {
    let title: String
    let description: String
    let type: InsightType
    let icon: String
}

enum InsightType {
    case positive
    case warning
    case suggestion
    case info
}

#Preview {
    ProjectProgressView(viewModel: TaskViewModel())
}
