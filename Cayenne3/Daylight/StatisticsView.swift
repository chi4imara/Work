import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: TaskViewModel
    
    var body: some View {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    ScrollView {
                        VStack(spacing: AppSpacing.lg) {
                            overallStatsSection
                            
                            categoryStatsSection
                            
                            dailyStatsSection
                            
                            completionRateSection
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.bottom, AppSpacing.xl)
                    }
                }
            }
    }
    
    private var headerView: some View {
        HStack {
            Text("Statistics")
                .font(AppTypography.largeTitle)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, 10)
    }
    
    private var overallStatsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Overview")
                .font(AppTypography.title)
                .foregroundColor(AppColors.primaryText)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: AppSpacing.md) {
                StatCardView(
                    title: "Total Tasks",
                    value: "\(viewModel.tasks.count)",
                    icon: "list.bullet",
                    color: AppColors.lightBlue
                )
                
                StatCardView(
                    title: "Completed",
                    value: "\(viewModel.completedTasks().count)",
                    icon: "checkmark.circle.fill",
                    color: AppColors.success
                )
                
                StatCardView(
                    title: "Pending",
                    value: "\(viewModel.incompleteTasks().count)",
                    icon: "clock.fill",
                    color: AppColors.warning
                )
                
                StatCardView(
                    title: "Notes",
                    value: "\(viewModel.notes.count)",
                    icon: "note.text",
                    color: AppColors.orange
                )
            }
        }
    }
    
    private var categoryStatsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Categories")
                .font(AppTypography.title)
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: AppSpacing.sm) {
                ForEach(TaskCategory.allCases, id: \.self) { category in
                    CategoryStatRowView(
                        category: category,
                        totalCount: viewModel.taskCountForCategory(category),
                        completedCount: viewModel.tasksForCategory(category).filter { $0.isCompleted }.count
                    )
                }
            }
        }
    }
    
    private var dailyStatsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Daily Breakdown")
                .font(AppTypography.title)
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: AppSpacing.sm) {
                ForEach(TaskDate.allCases, id: \.self) { date in
                    DailyStatRowView(
                        date: date,
                        totalCount: viewModel.tasksForDate(date).count,
                        completedCount: viewModel.tasksForDate(date).filter { $0.isCompleted }.count
                    )
                }
            }
        }
    }
    
    private var completionRateSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Completion Rate")
                .font(AppTypography.title)
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: AppSpacing.md) {
                let totalTasks = viewModel.tasks.count
                let completedTasks = viewModel.completedTasks().count
                let completionRate = totalTasks > 0 ? Double(completedTasks) / Double(totalTasks) : 0.0
                
                VStack(spacing: AppSpacing.sm) {
                    HStack {
                        Text("Overall Progress")
                            .font(AppTypography.headline)
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Text("\(Int(completionRate * 100))%")
                            .font(AppTypography.headline)
                            .foregroundColor(AppColors.success)
                    }
                    
                    ProgressView(value: completionRate)
                        .progressViewStyle(LinearProgressViewStyle(tint: AppColors.success))
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                    
                    HStack {
                        Text("\(completedTasks) of \(totalTasks) tasks completed")
                            .font(AppTypography.body)
                            .foregroundColor(AppColors.secondaryText)
                        
                        Spacer()
                    }
                }
                .padding(AppSpacing.lg)
                .cardStyle()
            }
        }
    }
}

struct StatCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(AppTypography.largeTitle)
                    .foregroundColor(AppColors.primaryText)
                
                Text(title)
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.secondaryText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(AppSpacing.md)
        .cardStyle()
    }
}

struct CategoryStatRowView: View {
    let category: TaskCategory
    let totalCount: Int
    let completedCount: Int
    
    private var completionRate: Double {
        totalCount > 0 ? Double(completedCount) / Double(totalCount) : 0.0
    }
    
    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            HStack {
                HStack(spacing: AppSpacing.sm) {
                    Image(systemName: category.icon)
                        .font(.title3)
                        .foregroundColor(category.color)
                    
                    Text(category.rawValue)
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.primaryText)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(completedCount)/\(totalCount)")
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("\(Int(completionRate * 100))%")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            
            if totalCount > 0 {
                ProgressView(value: completionRate)
                    .progressViewStyle(LinearProgressViewStyle(tint: category.color))
                    .scaleEffect(x: 1, y: 1.5, anchor: .center)
            }
        }
        .padding(AppSpacing.md)
        .cardStyle()
    }
}

struct DailyStatRowView: View {
    let date: TaskDate
    let totalCount: Int
    let completedCount: Int
    
    private var completionRate: Double {
        totalCount > 0 ? Double(completedCount) / Double(totalCount) : 0.0
    }
    
    private var dateColor: Color {
        switch date {
        case .yesterday: return AppColors.secondaryText
        case .today: return AppColors.lightBlue
        case .tomorrow: return AppColors.orange
        }
    }
    
    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            HStack {
                Text(date.rawValue)
                    .font(AppTypography.body)
                    .foregroundColor(dateColor)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(completedCount)/\(totalCount)")
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.primaryText)
                    
                    if totalCount > 0 {
                        Text("\(Int(completionRate * 100))%")
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.secondaryText)
                    } else {
                        Text("No tasks")
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
            }
            
            if totalCount > 0 {
                ProgressView(value: completionRate)
                    .progressViewStyle(LinearProgressViewStyle(tint: dateColor))
                    .scaleEffect(x: 1, y: 1.5, anchor: .center)
            }
        }
        .padding(AppSpacing.md)
        .cardStyle()
    }
}

#Preview {
    StatisticsView(viewModel: TaskViewModel())
}
