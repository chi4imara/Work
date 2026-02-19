import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: TaskViewModel
    @State private var selectedTask: Task?
    @State private var showingTaskDetail = false
    @State private var expandedCategory: TaskCategory?
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    headerView
                    
                    categoriesSection
                    
                    statusSection
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, AppSpacing.xl)
            }
        }
        .sheet(item: $selectedTask) { task in
            TaskDetailView(taskId: task.id, viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Categories")
                .font(AppTypography.largeTitle)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
        .padding(.vertical, 10)
    }
    
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("By Categories")
                .font(AppTypography.title)
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: AppSpacing.md) {
                ForEach(TaskCategory.allCases, id: \.self) { category in
                    CategoryCardView(
                        category: category,
                        count: viewModel.taskCountForCategory(category),
                        tasks: viewModel.tasksForCategory(category),
                        isExpanded: expandedCategory == category,
                        onTap: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                if expandedCategory == category {
                                    expandedCategory = nil
                                } else {
                                    expandedCategory = category
                                }
                            }
                        },
                        onTaskTap: { task in
                            selectedTask = task
                            showingTaskDetail = true
                        }
                    )
                }
            }
        }
    }
    
    private var statusSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("By Status")
                .font(AppTypography.title)
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: AppSpacing.md) {
                StatusCardView(
                    title: "Completed",
                    count: viewModel.completedTasks().count,
                    color: AppColors.success,
                    icon: "checkmark.circle.fill",
                    tasks: viewModel.completedTasks(),
                    onTaskTap: { task in
                        selectedTask = task
                        showingTaskDetail = true
                    }
                )
                
                StatusCardView(
                    title: "Pending",
                    count: viewModel.incompleteTasks().count,
                    color: AppColors.warning,
                    icon: "clock.fill",
                    tasks: viewModel.incompleteTasks(),
                    onTaskTap: { task in
                        selectedTask = task
                        showingTaskDetail = true
                    }
                )
            }
        }
    }
}

struct CategoryCardView: View {
    let category: TaskCategory
    let count: Int
    let tasks: [Task]
    let isExpanded: Bool
    let onTap: () -> Void
    let onTaskTap: (Task) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: onTap) {
                HStack {
                    HStack(spacing: AppSpacing.sm) {
                        Image(systemName: category.icon)
                            .font(.title2)
                            .foregroundColor(category.color)
                        
                        Text(category.rawValue)
                            .font(AppTypography.headline)
                            .foregroundColor(AppColors.primaryText)
                    }
                    
                    Spacer()
                    
                    Text("\(count)")
                        .font(AppTypography.headline)
                        .foregroundColor(AppColors.primaryText)
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
                .padding(AppSpacing.md)
            }
            
            if isExpanded && !tasks.isEmpty {
                VStack(spacing: AppSpacing.sm) {
                    Divider()
                        .background(AppColors.secondaryText.opacity(0.3))
                    
                    ForEach(tasks.prefix(5)) { task in
                        Button(action: {
                            onTaskTap(task)
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(task.title)
                                        .font(AppTypography.body)
                                        .foregroundColor(AppColors.primaryText)
                                        .multilineTextAlignment(.leading)
                                    
                                    HStack(spacing: AppSpacing.sm) {
                                        Text(task.date.rawValue)
                                            .font(AppTypography.caption)
                                            .foregroundColor(AppColors.secondaryText)
                                        
                                        Text("•")
                                            .font(AppTypography.caption)
                                            .foregroundColor(AppColors.secondaryText)
                                        
                                        Text(task.isCompleted ? "Completed" : "Pending")
                                            .font(AppTypography.caption)
                                            .foregroundColor(task.isCompleted ? AppColors.success : AppColors.secondaryText)
                                    }
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(AppColors.secondaryText)
                            }
                            .padding(.horizontal, AppSpacing.md)
                            .padding(.vertical, AppSpacing.sm)
                        }
                    }
                    
                    if tasks.count > 5 {
                        Text("And \(tasks.count - 5) more...")
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.secondaryText)
                            .padding(.bottom, AppSpacing.sm)
                    }
                }
            } else if isExpanded && tasks.isEmpty {
                VStack {
                    Divider()
                        .background(AppColors.secondaryText.opacity(0.3))
                    
                    Text("No tasks in this category")
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.secondaryText)
                        .padding(AppSpacing.md)
                }
            }
        }
        .cardStyle()
    }
}

struct StatusCardView: View {
    let title: String
    let count: Int
    let color: Color
    let icon: String
    let tasks: [Task]
    let onTaskTap: (Task) -> Void
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    HStack(spacing: AppSpacing.sm) {
                        Image(systemName: icon)
                            .font(.title2)
                            .foregroundColor(color)
                        
                        Text(title)
                            .font(AppTypography.headline)
                            .foregroundColor(AppColors.primaryText)
                    }
                    
                    Spacer()
                    
                    Text("\(count)")
                        .font(AppTypography.headline)
                        .foregroundColor(AppColors.primaryText)
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
                .padding(AppSpacing.md)
            }
            
            if isExpanded && !tasks.isEmpty {
                VStack(spacing: AppSpacing.sm) {
                    Divider()
                        .background(AppColors.secondaryText.opacity(0.3))
                    
                    ForEach(tasks.prefix(5)) { task in
                        Button(action: {
                            onTaskTap(task)
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(task.title)
                                        .font(AppTypography.body)
                                        .foregroundColor(AppColors.primaryText)
                                        .multilineTextAlignment(.leading)
                                    
                                    HStack(spacing: AppSpacing.sm) {
                                        Image(systemName: task.category.icon)
                                            .font(.caption)
                                            .foregroundColor(task.category.color)
                                        
                                        Text(task.category.rawValue)
                                            .font(AppTypography.caption)
                                            .foregroundColor(task.category.color)
                                        
                                        Text("•")
                                            .font(AppTypography.caption)
                                            .foregroundColor(AppColors.secondaryText)
                                        
                                        Text(task.date.rawValue)
                                            .font(AppTypography.caption)
                                            .foregroundColor(AppColors.secondaryText)
                                    }
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(AppColors.secondaryText)
                            }
                            .padding(.horizontal, AppSpacing.md)
                            .padding(.vertical, AppSpacing.sm)
                        }
                    }
                    
                    if tasks.count > 5 {
                        Text("And \(tasks.count - 5) more...")
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.secondaryText)
                            .padding(.bottom, AppSpacing.sm)
                    }
                }
            } else if isExpanded && tasks.isEmpty {
                VStack {
                    Divider()
                        .background(AppColors.secondaryText.opacity(0.3))
                    
                    Text("No tasks in this category")
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.secondaryText)
                        .padding(AppSpacing.md)
                }
            }
        }
        .cardStyle()
    }
}

#Preview {
    CategoriesView(viewModel: TaskViewModel())
}
