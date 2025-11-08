import SwiftUI

struct TaskListView: View {
    @ObservedObject var viewModel: TaskViewModel
    @State private var showingTaskForm = false
    @State private var editingTask: Task?
    @State private var selectedTask: Task?
    
    private var filteredTasks: [Task] {
        viewModel.allFilteredTasks()
    }
    
    var body: some View {
        ZStack {
            StaticBackground()
            
            VStack(spacing: 0) {
                TaskListHeader(
                    taskCount: filteredTasks.count,
                    onAddTask: {
                        editingTask = nil
                        showingTaskForm = true
                    }
                )
                
                if filteredTasks.isEmpty {
                    EmptyTaskListView {
                        editingTask = nil
                        showingTaskForm = true
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredTasks) { task in
                                TaskListCardView(
                                    task: task,
                                    onTap: {
                                        selectedTask = task
                                    },
                                    onEdit: {
                                        editingTask = task
                                        showingTaskForm = true
                                    },
                                    onDelete: {
                                        viewModel.deleteTask(task)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                }
            }
        }
        .sheet(isPresented: $showingTaskForm) {
            TaskFormView(
                viewModel: viewModel,
                editingTask: $editingTask
            )
        }
        .sheet(item: $selectedTask) { task in
            TaskDetailView(
                task: task,
                viewModel: viewModel,
                onEdit: {
                    selectedTask = nil
                    editingTask = task
                    showingTaskForm = true
                },
                onDelete: {
                    viewModel.deleteTask(task)
                    selectedTask = nil
                }
            )
        }
    }
}

struct TaskListHeader: View {
    let taskCount: Int
    let onAddTask: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: {
                }) {
                    Image(systemName: "line.3.horizontal")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.primaryBlue)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.9))
                                .shadow(color: AppColors.primaryBlue.opacity(0.2), radius: 4, x: 0, y: 2)
                        )
                }
                .padding(.leading, 20)
                .opacity(0)
                .disabled(true)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("All Tasks")
                        .font(AppFonts.title2)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("\(taskCount) task\(taskCount == 1 ? "" : "s")")
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                Button(action: onAddTask) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(AppColors.primaryBlue)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 20)
            
            Divider()
                .background(AppColors.lightBlue)
        }
        .padding(.vertical, 16)
        .background(Color.white.opacity(0.9))
    }
}

struct TaskListCardView: View {
    let task: Task
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var offset = CGSize.zero
    @State private var showingDeleteAlert = false
    
    private var deadlineText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: task.deadline)
    }
    
    private var isOverdue: Bool {
        task.actualStatus == .overdue
    }
    
    var body: some View {
        ZStack {
            HStack {
                if offset.width > 0 {
                    Button(action: onEdit) {
                        VStack {
                            Image(systemName: "pencil")
                                .font(.system(size: 20, weight: .medium))
                            Text("Edit")
                                .font(AppFonts.caption1)
                        }
                        .foregroundColor(.white)
                        .frame(width: 80)
                        .frame(maxHeight: .infinity)
                        .background(AppColors.primaryBlue)
                        .cornerRadius(12)
                    }
                }
                
                Spacer()
                
                if offset.width < 0 {
                    Button(action: {
                        showingDeleteAlert = true
                    }) {
                        VStack {
                            Image(systemName: "trash")
                                .font(.system(size: 20, weight: .medium))
                            Text("Delete")
                                .font(AppFonts.caption1)
                        }
                        .foregroundColor(.white)
                        .frame(width: 80)
                        .frame(maxHeight: .infinity)
                        .background(AppColors.overdueRed)
                        .cornerRadius(12)
                    }
                }
            }
            
            VStack(spacing: 12) {
                HStack(alignment: .top, spacing: 16) {
                    Circle()
                        .fill(Color.statusColor(for: task.actualStatus))
                        .frame(width: 12, height: 12)
                        .padding(.top, 4)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(task.title)
                            .font(AppFonts.cardTitle)
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.leading)
                        
                        if !task.description.isEmpty {
                            Text(task.description)
                                .font(AppFonts.cardSubtitle)
                                .foregroundColor(AppColors.secondaryText)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                        }
                        
                        HStack {
                            HStack(spacing: 4) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(isOverdue ? AppColors.overdueRed : AppColors.secondaryText)
                                
                                Text(deadlineText)
                                    .font(AppFonts.caption1)
                                    .foregroundColor(isOverdue ? AppColors.overdueRed : AppColors.secondaryText)
                            }
                            
                            Spacer()
                            
                            StatusBadge(status: task.actualStatus)
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppColors.lightText)
                        .padding(.top, 4)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isOverdue ? AppColors.overdueRed.opacity(0.3) : Color.clear,
                                lineWidth: 1
                            )
                    )
                    .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
            )
            .offset(x: offset.width, y: 0)
            .highPriorityGesture(
                DragGesture(minimumDistance: 20)
                    .onChanged { value in
                        offset = value.translation
                    }
                    .onEnded { value in
                        withAnimation(.spring()) {
                            if abs(value.translation.width) > 100 {
                                if value.translation.width > 0 {
                                    onEdit()
                                } else {
                                    showingDeleteAlert = true
                                }
                            }
                            offset = .zero
                        }
                    }
            )
            .onTapGesture {
                onTap()
            }
        }
        .alert("Delete Task", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete '\(task.title)'? This action cannot be undone.")
        }
    }
}

struct EmptyTaskListView: View {
    let onAddTask: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: "list.bullet.clipboard")
                    .font(.system(size: 64, weight: .light))
                    .foregroundColor(AppColors.lightBlue)
                
                VStack(spacing: 8) {
                    Text("No Tasks Added")
                        .font(AppFonts.title3)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Start organizing your home projects by adding your first task")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            
            Button(action: onAddTask) {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .medium))
                    
                    Text("Add Task")
                        .font(AppFonts.buttonText)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(
                        colors: [AppColors.primaryBlue, AppColors.darkBlue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    TaskListView(viewModel: TaskViewModel())
}
