import SwiftUI

struct TasksView: View {
    @ObservedObject var viewModel: TaskViewModel
    @State private var showingAddTask = false
    @State private var selectedTask: Task?
    @State private var showingTaskDetail = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    dateSelector
                    
                    if filteredTasks.isEmpty {
                        emptyStateView
                    } else {
                        tasksList
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView(viewModel: viewModel)
        }
        .sheet(item: $selectedTask) { task in
            TaskDetailView(taskId: task.id, viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("My Tasks")
                    .font(AppTypography.largeTitle)
                    .foregroundColor(AppColors.primaryText)
                
                Text(viewModel.selectedDate.displayDate)
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            Button(action: { showingAddTask = true }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(AppColors.lightBlue)
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.top, AppSpacing.md)
        .padding(.bottom, AppSpacing.sm)
    }
    
    private var dateSelector: some View {
        HStack(spacing: AppSpacing.sm) {
            ForEach(TaskDate.allCases, id: \.self) { date in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.selectedDate = date
                    }
                }) {
                    Text(date.rawValue)
                        .font(AppTypography.body)
                        .foregroundColor(viewModel.selectedDate == date ? AppColors.primaryText : AppColors.secondaryText)
                        .padding(.horizontal, AppSpacing.md)
                        .padding(.vertical, AppSpacing.sm)
                        .background(
                            viewModel.selectedDate == date ?
                            AppColors.lightBlue.opacity(0.3) :
                            Color.clear
                        )
                        .cornerRadius(AppRadius.small)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, AppSpacing.lg)
        .padding(.bottom, AppSpacing.md)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()
            
            Image(systemName: "checkmark.circle")
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText)
            
            Text("Add your first task for today")
                .font(AppTypography.headline)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
            
            Button {
                showingAddTask = true
            } label: {
                Text("Add Task")
                    .primaryButtonStyle()
            }
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.lg)
    }
    
    private var tasksList: some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.md) {
                ForEach(filteredTasks) { task in
                    TaskRowView(
                        task: task,
                        onToggle: { viewModel.toggleTaskCompletion(task) },
                        onTap: {
                            selectedTask = task
                            showingTaskDetail = true
                        }
                    )
                }
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.bottom, AppSpacing.xl)
        }
    }
    
    private var filteredTasks: [Task] {
        viewModel.tasksForDate(viewModel.selectedDate)
    }
}

struct TaskRowView: View {
    let task: Task
    let onToggle: () -> Void
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AppSpacing.md) {
                Button(action: onToggle) {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundColor(task.isCompleted ? AppColors.success : AppColors.secondaryText)
                }
                .buttonStyle(PlainButtonStyle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title)
                        .font(AppTypography.headline)
                        .foregroundColor(AppColors.primaryText)
                        .strikethrough(task.isCompleted)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: task.category.icon)
                                .font(.caption)
                            Text(task.category.rawValue)
                                .font(AppTypography.caption)
                        }
                        .foregroundColor(task.category.color)
                        
                        Spacer()
                        
                        Text(task.isCompleted ? "Completed" : "Pending")
                            .font(AppTypography.small)
                            .foregroundColor(task.isCompleted ? AppColors.success : AppColors.secondaryText)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(AppSpacing.md)
            .cardStyle()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    TasksView(viewModel: TaskViewModel())
}
