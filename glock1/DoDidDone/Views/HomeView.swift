import SwiftUI

struct AddTaskItem: Identifiable {
    let id = UUID()
}

struct HomeView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    @State private var showingFilterMenu = false
    @State private var taskToDelete: Task?
    @State private var showingDeleteAlert = false
    @State private var taskToEdit: Task?
    @State private var selectedTask: Task?
    @State private var addTaskItem: AddTaskItem?
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                if taskViewModel.filteredTasks.isEmpty {
                    emptyStateView
                } else {
                    taskListView
                }
                
                Spacer()
            }
        }
        .sheet(item: $addTaskItem) { _ in
            AddEditTaskView(taskViewModel: taskViewModel)
        }
        .sheet(item: $taskToEdit) { task in
            AddEditTaskView(taskViewModel: taskViewModel, taskToEdit: task)
        }
        .sheet(item: $selectedTask) { task in
            TaskDetailView(taskViewModel: taskViewModel, taskId: task.id)
        }
        .actionSheet(isPresented: $showingFilterMenu) {
            filterActionSheet
        }
        .alert("Delete Task", isPresented: $showingDeleteAlert, presenting: taskToDelete) { task in
            Button("Delete", role: .destructive) {
                taskViewModel.deleteTask(task)
            }
            Button("Cancel", role: .cancel) { }
        } message: { task in
            Text("Are you sure you want to delete '\(task.title)'?")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Home Tasks")
                .font(AppFonts.title2())
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: { addTaskItem = AddTaskItem() }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(AppColors.accentYellow)
                }
                
                Button(action: { showingFilterMenu = true }) {
                    Image(systemName: "ellipsis")
                        .font(.title2)
                        .foregroundColor(AppColors.accentYellow)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "list.bullet")
                .font(.system(size: 80))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: 12) {
                Text("No tasks yet")
                    .font(AppFonts.title3())
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add your first task to get started")
                    .font(AppFonts.body())
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { addTaskItem = AddTaskItem() }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add First Task")
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
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var taskListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(taskViewModel.filteredTasks) { task in
                    TaskRowView(
                        task: task,
                        onToggle: { taskViewModel.toggleTaskCompletion(task) },
                        onEdit: { 
                            taskToEdit = task
                        },
                        onDelete: { 
                            taskToDelete = task
                            showingDeleteAlert = true
                        },
                        onTap: {
                            selectedTask = task
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var filterActionSheet: ActionSheet {
        ActionSheet(
            title: Text("Filter Tasks"),
            buttons: [
                .default(Text("All")) { taskViewModel.setFilter(.all) },
                .default(Text("Active")) { taskViewModel.setFilter(.active) },
                .default(Text("Completed")) { taskViewModel.setFilter(.completed) },
                .cancel()
            ]
        )
    }
}

struct TaskRowView: View {
    let task: Task
    let onToggle: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 15) {
                Button(action: onToggle) {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundColor(task.isCompleted ? AppColors.successGreen : AppColors.secondaryText)
                }
                .buttonStyle(PlainButtonStyle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title)
                        .font(AppFonts.callout())
                        .foregroundColor(AppColors.primaryText)
                        .strikethrough(task.isCompleted)
                    
                    Text(task.category.displayName)
                        .font(AppFonts.footnote())
                        .foregroundColor(AppColors.tertiaryText)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(AppColors.cardBackground)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button("Delete", role: .destructive, action: onDelete)
        }
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button("Edit", action: onEdit)
                .tint(AppColors.accentYellow)
        }
    }
}

#Preview {
    HomeView(taskViewModel: TaskViewModel())
}
