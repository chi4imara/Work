import SwiftUI

struct CategoriesView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    @State private var selectedCategory: TaskCategory?
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                if taskViewModel.tasks.isEmpty {
                    emptyStateView
                } else {
                    categoriesListView
                }
                
                Spacer()
            }
        }
        .sheet(item: $selectedCategory) { category in
            CategoryTasksView(
                taskViewModel: taskViewModel,
                category: category
            )
        }
        
    }
    
    private var headerView: some View {
        HStack {
            Text("Categories")
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
            
            Image(systemName: "folder")
                .font(.system(size: 80))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: 12) {
                Text("No categories yet")
                    .font(AppFonts.title3())
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add some tasks to see categories here")
                    .font(AppFonts.body())
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var categoriesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(TaskCategory.allCases, id: \.self) { category in
                    let tasksInCategory = taskViewModel.tasksForCategory(category)
                    
                    if !tasksInCategory.isEmpty {
                        CategoryRowView(
                            category: category,
                            taskCount: tasksInCategory.count
                        ) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
}

struct CategoryRowView: View {
    let category: TaskCategory
    let taskCount: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 15) {
                Image(systemName: categoryIcon(for: category))
                    .font(.title2)
                    .foregroundColor(AppColors.accentYellow)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.displayName)
                        .font(AppFonts.callout())
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("\(taskCount) task\(taskCount == 1 ? "" : "s")")
                        .font(AppFonts.footnote())
                        .foregroundColor(AppColors.tertiaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(AppColors.cardBackground)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func categoryIcon(for category: TaskCategory) -> String {
        switch category {
        case .electrical: return "bolt"
        case .plumbing: return "drop"
        case .shopping: return "cart"
        case .other: return "square.grid.2x2"
        }
    }
}

struct CategoryTasksView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    let category: TaskCategory
    @Environment(\.presentationMode) var presentationMode
    @State private var taskToDelete: Task?
    @State private var showingDeleteAlert = false
    @State private var taskToEdit: Task?
    @State private var selectedTask: Task?
    
    var categoryTasks: [Task] {
        taskViewModel.tasksForCategory(category)
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.secondaryText)
                    
                    Spacer()
                    
                    Text(category.displayName)
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
                
                if categoryTasks.isEmpty {
                    emptyCategoryView
                } else {
                    categoryTasksListView
                }
                
                Spacer()
            }
        }
        .sheet(item: $taskToEdit) { task in
            AddEditTaskView(taskViewModel: taskViewModel, taskToEdit: task)
        }
        .sheet(item: $selectedTask) { task in
            TaskDetailView(taskViewModel: taskViewModel, taskId: task.id)
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
    
    private var emptyCategoryView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "folder")
                .font(.system(size: 80))
                .foregroundColor(AppColors.secondaryText)
            
            Text("No tasks in this category yet")
                .font(AppFonts.title3())
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var categoryTasksListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(categoryTasks) { task in
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
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
}

#Preview {
    CategoriesView(taskViewModel: TaskViewModel())
}
