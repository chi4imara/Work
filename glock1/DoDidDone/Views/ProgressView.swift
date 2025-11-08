import SwiftUI

struct ProgressView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    @State private var selectedSegment: ProgressSegment = .all
    @State private var animateChart = false
    @State private var selectedTask: Task?
    
    enum ProgressSegment: String, CaseIterable {
        case all = "All"
        case completed = "Completed"
        case active = "Active"
    }
    
    var body: some View {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if taskViewModel.tasks.isEmpty {
                        emptyStateView
                    } else {
                        ScrollView {
                            VStack(spacing: 30) {
                                progressChartView
                                
                                statisticsView
                                
                                weeklyProgressView
                                
                                categoryBreakdownView
                                
                                achievementsView
                                
                                insightsView
                                
                                taskListView
                                
                                Spacer(minLength: 100)
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    Spacer()
                }
            }
        .sheet(item: $selectedTask) { task in
            TaskDetailView(taskViewModel: taskViewModel, taskId: task.id)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).delay(0.2)) {
                animateChart = true
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Progress")
                .font(AppFonts.title2())
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "chart.pie")
                .font(.system(size: 80))
                .foregroundColor(AppColors.secondaryText)
            
            Text("No tasks added yet")
                .font(AppFonts.title3())
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var progressChartView: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(AppColors.cardBackground, lineWidth: 20)
                    .frame(width: 200, height: 200)
                
                Circle()
                    .trim(from: 0, to: animateChart ? completedProgress : 0)
                    .stroke(AppColors.successGreen, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.0), value: animateChart)
                
                VStack(spacing: 4) {
                    Text("\(Int(completedProgress * 100))%")
                        .font(AppFonts.title1())
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Completed")
                        .font(AppFonts.footnote())
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            .onTapGesture {
                withAnimation(.spring()) {
                    selectedSegment = taskViewModel.completedTasksCount > 0 ? .completed : .active
                }
            }
        }
        .padding(.top, 20)
    }
    
    private var statisticsView: some View {
        HStack(spacing: 20) {
            StatCard(
                title: "Total",
                value: "\(taskViewModel.totalTasksCount)",
                color: AppColors.accentYellow,
                isSelected: selectedSegment == .all
            ) {
                selectedSegment = .all
            }
            
            StatCard(
                title: "Completed",
                value: "\(taskViewModel.completedTasksCount)",
                color: AppColors.successGreen,
                isSelected: selectedSegment == .completed
            ) {
                selectedSegment = .completed
            }
            
            StatCard(
                title: "Active",
                value: "\(taskViewModel.activeTasksCount)",
                color: AppColors.warningOrange,
                isSelected: selectedSegment == .active
            ) {
                selectedSegment = .active
            }
        }
    }
    
    private var taskListView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(selectedSegment.rawValue + " Tasks")
                .font(AppFonts.headline())
                .foregroundColor(AppColors.primaryText)
            
            LazyVStack(spacing: 12) {
                ForEach(filteredTasks) { task in
                    ProgressTaskRowView(
                        task: task,
                        onToggle: { taskViewModel.toggleTaskCompletion(task) },
                        onTap: {
                            selectedTask = task
                        }
                    )
                }
            }
        }
    }
    
    private var completedProgress: Double {
        guard taskViewModel.totalTasksCount > 0 else { return 0 }
        return Double(taskViewModel.completedTasksCount) / Double(taskViewModel.totalTasksCount)
    }
    
    private var filteredTasks: [Task] {
        switch selectedSegment {
        case .all:
            return taskViewModel.tasks.sorted { $0.createdAt > $1.createdAt }
        case .completed:
            return taskViewModel.tasks.filter { $0.isCompleted }.sorted { $0.createdAt > $1.createdAt }
        case .active:
            return taskViewModel.tasks.filter { !$0.isCompleted }.sorted { $0.createdAt > $1.createdAt }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Text(value)
                    .font(AppFonts.title2())
                    .foregroundColor(AppColors.primaryText)
                
                Text(title)
                    .font(AppFonts.footnote())
                    .foregroundColor(AppColors.secondaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? color.opacity(0.3) : AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(isSelected ? color : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ProgressTaskRowView: View {
    let task: Task
    let onToggle: () -> Void
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 15) {
                Button(action: onToggle) {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundColor(task.isCompleted ? AppColors.successGreen : AppColors.secondaryText)
                }
                .buttonStyle(PlainButtonStyle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title)
                        .font(AppFonts.callout())
                        .foregroundColor(AppColors.primaryText)
                        .strikethrough(task.isCompleted)
                        .lineLimit(1)
                    
                    Text(task.category.displayName)
                        .font(AppFonts.caption())
                        .foregroundColor(AppColors.tertiaryText)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

extension ProgressView {
    private var weeklyProgressView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("This Week")
                .font(AppFonts.headline())
                .foregroundColor(AppColors.primaryText)
            
            HStack(spacing: 20) {
                WeeklyStatCard(
                    title: "Created",
                    value: "\(taskViewModel.tasksCreatedThisWeek)",
                    icon: "plus.circle.fill",
                    color: AppColors.accentYellow
                )
                
                WeeklyStatCard(
                    title: "Completed",
                    value: "\(taskViewModel.tasksCompletedThisWeek)",
                    icon: "checkmark.circle.fill",
                    color: AppColors.successGreen
                )
                
                WeeklyStatCard(
                    title: "Streak",
                    value: "\(taskViewModel.streakDays)",
                    icon: "flame.fill",
                    color: AppColors.warningOrange
                )
            }
        }
    }
    
    private var categoryBreakdownView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("By Category")
                .font(AppFonts.headline())
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                ForEach(TaskCategory.allCases, id: \.self) { category in
                    CategoryProgressRow(
                        category: category,
                        completionRate: taskViewModel.completionRateByCategory[category] ?? 0,
                        totalTasks: taskViewModel.tasksForCategory(category).count,
                        completedTasks: taskViewModel.tasksForCategory(category).filter { $0.isCompleted }.count
                    )
                }
            }
        }
    }
    
    private var achievementsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Achievements")
                .font(AppFonts.headline())
                .foregroundColor(AppColors.primaryText)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                AchievementBadge(
                    title: "First Steps",
                    description: "Complete your first task",
                    isUnlocked: taskViewModel.completedTasksCount > 0,
                    icon: "star.fill",
                    color: AppColors.accentYellow
                )
                
                AchievementBadge(
                    title: "Productive Week",
                    description: "Complete 5 tasks this week",
                    isUnlocked: taskViewModel.tasksCompletedThisWeek >= 5,
                    icon: "calendar.badge.checkmark",
                    color: AppColors.successGreen
                )
                
                AchievementBadge(
                    title: "Streak Master",
                    description: "7-day completion streak",
                    isUnlocked: taskViewModel.streakDays >= 7,
                    icon: "flame.fill",
                    color: AppColors.warningOrange
                )
                
                AchievementBadge(
                    title: "Task Master",
                    description: "Complete 50 tasks total",
                    isUnlocked: taskViewModel.completedTasksCount >= 50,
                    icon: "crown.fill",
                    color: AppColors.primaryBlue
                )
            }
        }
    }
    
    private var insightsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Insights")
                .font(AppFonts.headline())
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                if let mostProductive = taskViewModel.mostProductiveCategory {
                    InsightCard(
                        icon: "chart.bar.fill",
                        title: "Most Productive Category",
                        description: "You're most successful with \(mostProductive.displayName) tasks",
                        color: AppColors.successGreen
                    )
                }
                
                if taskViewModel.averageTasksPerDay > 0 {
                    InsightCard(
                        icon: "chart.line.uptrend.xyaxis",
                        title: "Daily Average",
                        description: String(format: "You create %.1f tasks per day on average", taskViewModel.averageTasksPerDay),
                        color: AppColors.primaryBlue
                    )
                }
                
                if taskViewModel.completedTasksCount > 0 {
                    let completionRate = Double(taskViewModel.completedTasksCount) / Double(taskViewModel.totalTasksCount)
                    InsightCard(
                        icon: "percent",
                        title: "Completion Rate",
                        description: String(format: "You complete %.0f%% of your tasks", completionRate * 100),
                        color: completionRate > 0.7 ? AppColors.successGreen : AppColors.warningOrange
                    )
                }
            }
        }
    }
}

struct WeeklyStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(AppFonts.title2())
                .foregroundColor(AppColors.primaryText)
            
            Text(title)
                .font(AppFonts.caption())
                .foregroundColor(AppColors.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
        )
    }
}

struct CategoryProgressRow: View {
    let category: TaskCategory
    let completionRate: Double
    let totalTasks: Int
    let completedTasks: Int
    
    private var categoryColor: Color {
        switch category {
        case .electrical:
            return AppColors.warningOrange
        case .plumbing:
            return AppColors.primaryBlue
        case .shopping:
            return AppColors.successGreen
        case .other:
            return AppColors.accentYellow
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(category.displayName)
                    .font(AppFonts.callout())
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Text("\(completedTasks)/\(totalTasks)")
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.secondaryText)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.cardBackground)
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(categoryColor)
                        .frame(width: geometry.size.width * completionRate, height: 8)
                        .animation(.easeInOut(duration: 0.8), value: completionRate)
                }
            }
            .frame(height: 8)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
        )
    }
}

struct AchievementBadge: View {
    let title: String
    let description: String
    let isUnlocked: Bool
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(isUnlocked ? color : AppColors.tertiaryText)
            
            Text(title)
                .font(AppFonts.callout())
                .foregroundColor(isUnlocked ? AppColors.primaryText : AppColors.tertiaryText)
            
            Text(description)
                .font(AppFonts.caption2())
                .foregroundColor(isUnlocked ? AppColors.secondaryText : AppColors.tertiaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isUnlocked ? color.opacity(0.2) : AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isUnlocked ? color : Color.clear, lineWidth: 1)
                )
        )
        .opacity(isUnlocked ? 1.0 : 0.6)
    }
}

struct InsightCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppFonts.callout())
                    .foregroundColor(AppColors.primaryText)
                
                Text(description)
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
        )
    }
}

#Preview {
    ProgressView(taskViewModel: TaskViewModel())
}
