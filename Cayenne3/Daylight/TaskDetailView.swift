import SwiftUI

struct TaskDetailView: View {
    let taskId: UUID
    @ObservedObject var viewModel: TaskViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEditTask = false
    @State private var showingDeleteAlert = false
    
    private var task: Task? {
        viewModel.getTask(byId: taskId)
    }
    
    var body: some View {
        Group {
            if let task = task {
                taskDetailContent(task: task)
            } else {
                EmptyView()
            }
        }
    }
    
    private func taskDetailContent(task: Task) -> some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Task")
                                .font(AppTypography.caption)
                                .foregroundColor(AppColors.secondaryText)
                                .textCase(.uppercase)
                            
                            Text(task.title)
                                .font(AppTypography.largeTitle)
                                .foregroundColor(AppColors.primaryText)
                                .multilineTextAlignment(.leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(AppSpacing.lg)
                        .cardStyle()
                        
                        VStack(spacing: AppSpacing.md) {
                            HStack {
                                Text("Category")
                                    .font(AppTypography.headline)
                                    .foregroundColor(AppColors.primaryText)
                                
                                Spacer()
                                
                                HStack(spacing: AppSpacing.sm) {
                                    Image(systemName: task.category.icon)
                                        .foregroundColor(task.category.color)
                                    Text(task.category.rawValue)
                                        .font(AppTypography.body)
                                        .foregroundColor(task.category.color)
                                }
                            }
                            
                            Divider()
                                .background(AppColors.secondaryText.opacity(0.3))
                            
                            HStack {
                                Text("Date")
                                    .font(AppTypography.headline)
                                    .foregroundColor(AppColors.primaryText)
                                
                                Spacer()
                                
                                Text(task.date.displayDate)
                                    .font(AppTypography.body)
                                    .foregroundColor(AppColors.secondaryText)
                            }
                            
                            Divider()
                                .background(AppColors.secondaryText.opacity(0.3))
                            
                            HStack {
                                Text("Status")
                                    .font(AppTypography.headline)
                                    .foregroundColor(AppColors.primaryText)
                                
                                Spacer()
                                
                                Button(action: {
                                    if let task = self.task {
                                        viewModel.toggleTaskCompletion(task)
                                    }
                                }) {
                                    HStack(spacing: AppSpacing.sm) {
                                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(task.isCompleted ? AppColors.success : AppColors.secondaryText)
                                        Text(task.isCompleted ? "Completed" : "Pending")
                                            .font(AppTypography.body)
                                            .foregroundColor(task.isCompleted ? AppColors.success : AppColors.secondaryText)
                                    }
                                }
                            }
                        }
                        .padding(AppSpacing.lg)
                        .cardStyle()
                        
                        if !task.comment.isEmpty {
                            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                                Text("Comment")
                                    .font(AppTypography.caption)
                                    .foregroundColor(AppColors.secondaryText)
                                    .textCase(.uppercase)
                                
                                Text(task.comment)
                                    .font(AppTypography.body)
                                    .foregroundColor(AppColors.primaryText)
                                    .multilineTextAlignment(.leading)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(AppSpacing.lg)
                            .cardStyle()
                        }
                        
                        VStack(spacing: AppSpacing.md) {
                            Button {
                                showingEditTask = true
                            } label: {
                                Text("Edit Task")
                                    .primaryButtonStyle()
                            }
                            
                            Button {
                                showingDeleteAlert = true
                            } label: {
                                Text("Delete Task")
                                    .font(AppTypography.headline)
                                    .foregroundColor(AppColors.error)
                                    .padding(.horizontal, AppSpacing.lg)
                                    .padding(.vertical, AppSpacing.md)
                                    .frame(maxWidth: .infinity)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(AppRadius.medium)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AppRadius.medium)
                                            .stroke(AppColors.error, lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.top, AppSpacing.lg)
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.md)
                }
            }
            .navigationTitle("Task Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(AppColors.accentText)
            )
        }
        .sheet(isPresented: $showingEditTask) {
            if let task = self.task {
                EditTaskView(taskId: task.id, viewModel: viewModel)
            }
        }
        .alert("Delete Task", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let task = self.task {
                    viewModel.deleteTask(task)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this task? This action cannot be undone.")
        }
    }
}

#Preview {
    let sampleTask = Task(title: "Sample Task", category: .home, date: .today, comment: "This is a sample comment")
    return TaskDetailView(
        taskId: sampleTask.id,
        viewModel: TaskViewModel()
    )
}
