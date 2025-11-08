import SwiftUI

struct EditTaskItem: Identifiable {
    let id = UUID()
    let task: Task
}

struct TaskDetailView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    let taskId: UUID
    @Environment(\.presentationMode) var presentationMode
    @State private var editTaskItem: EditTaskItem?
    @State private var showingDeleteAlert = false
    
    private var task: Task? {
        taskViewModel.tasks.first { $0.id == taskId }
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            if let task = task {
                VStack {
                    HStack {
                        Button("Back") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(AppColors.secondaryText)
                        
                        Spacer()
                        
                        Text("Task Details")
                            .font(AppFonts.headline())
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Button("Back") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(AppColors.secondaryText)
                        .opacity(0)
                        .disabled(true)
                    }
                    .padding()
                    
                    ScrollView {
                        VStack(spacing: 30) {
                            statusCard(for: task)
                            
                            taskInfoCard(for: task)
                            
                            actionButtons(for: task)
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 60))
                        .foregroundColor(AppColors.warningOrange)
                    
                    Text("Task Not Found")
                        .font(AppFonts.title2())
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("This task may have been deleted")
                        .font(AppFonts.body())
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                    
                    Button("Go Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(AppFonts.callout())
                    .foregroundColor(AppColors.primaryText)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(AppColors.accentYellow)
                    )
                }
                .padding(.horizontal, 40)
            }
        }
        .sheet(item: $editTaskItem) { item in
            AddEditTaskView(taskViewModel: taskViewModel, taskToEdit: item.task)
        }
        .alert("Delete Task", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let task = task {
                    taskViewModel.deleteTask(task)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            if let task = task {
                Text("Are you sure you want to delete '\(task.title)'? This action cannot be undone.")
            }
        }
    }
    
    private func statusCard(for task: Task) -> some View {
        VStack(spacing: 16) {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 60))
                .foregroundColor(task.isCompleted ? AppColors.successGreen : AppColors.accentYellow)
            
            Text(task.isCompleted ? "Completed" : "Active")
                .font(AppFonts.title3())
                .foregroundColor(AppColors.primaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
        )
    }
    
    private func taskInfoCard(for task: Task) -> some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Title")
                    .font(AppFonts.footnote())
                    .foregroundColor(AppColors.tertiaryText)
                    .textCase(.uppercase)
                
                Text(task.title)
                    .font(AppFonts.title3())
                    .foregroundColor(AppColors.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Divider()
                .background(AppColors.secondaryText.opacity(0.3))
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Category")
                    .font(AppFonts.footnote())
                    .foregroundColor(AppColors.tertiaryText)
                    .textCase(.uppercase)
                
                HStack {
                    Image(systemName: categoryIcon(for: task.category))
                        .foregroundColor(AppColors.accentYellow)
                    
                    Text(task.category.displayName)
                        .font(AppFonts.callout())
                        .foregroundColor(AppColors.primaryText)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if !task.description.isEmpty {
                Divider()
                    .background(AppColors.secondaryText.opacity(0.3))
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(AppFonts.footnote())
                        .foregroundColor(AppColors.tertiaryText)
                        .textCase(.uppercase)
                    
                    Text(task.description)
                        .font(AppFonts.body())
                        .foregroundColor(AppColors.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            Divider()
                .background(AppColors.secondaryText.opacity(0.3))
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Created")
                    .font(AppFonts.footnote())
                    .foregroundColor(AppColors.tertiaryText)
                    .textCase(.uppercase)
                
                Text(formatDate(task.createdAt))
                    .font(AppFonts.callout())
                    .foregroundColor(AppColors.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 25)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
        )
    }
    
    private func actionButtons(for task: Task) -> some View {
        VStack(spacing: 16) {
            Button(action: { editTaskItem = EditTaskItem(task: task) }) {
                HStack {
                    Image(systemName: "pencil")
                    Text("Edit Task")
                }
                .font(AppFonts.callout())
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(AppColors.accentYellow)
                )
            }
            
            Button(action: { showingDeleteAlert = true }) {
                HStack {
                    Image(systemName: "trash")
                    Text("Delete Task")
                }
                .font(AppFonts.callout())
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(AppColors.errorRed)
                )
            }
        }
    }
    
    private func categoryIcon(for category: TaskCategory) -> String {
        switch category {
        case .electrical: return "bolt"
        case .plumbing: return "drop"
        case .shopping: return "cart"
        case .other: return "square.grid.2x2"
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    let sampleTask = Task(title: "Sample Task", description: "This is a sample task description", category: .electrical)
    let viewModel = TaskViewModel()
    viewModel.addTask(sampleTask)
    
    return TaskDetailView(
        taskViewModel: viewModel,
        taskId: sampleTask.id
    )
}
