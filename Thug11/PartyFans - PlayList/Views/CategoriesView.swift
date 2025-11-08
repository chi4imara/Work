import SwiftUI

struct CategoriesView: View {
    @ObservedObject var tasksViewModel: TasksViewModel
    @State private var selectedCategory: TaskCategory?
    @State private var showCategoryTasks = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text("Categories")
                        .font(.nunitoBold(size: 32))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Text("Browse tasks by category")
                        .font(.nunitoRegular(size: 16))
                        .foregroundColor(Color.theme.secondaryText)
                }
                .padding(.top, 20)
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(TaskCategory.allCases, id: \.self) { category in
                            CategoryRowView(
                                category: category,
                                taskCount: tasksViewModel.getCategoryCount(category),
                                onTap: {
                                    selectedCategory = category
                                    showCategoryTasks = true
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }
            }
        }
        .sheet(item: $selectedCategory) { category in
                CategoryTasksView(
                    category: category,
                    tasksViewModel: tasksViewModel
                )
        }
        .onAppear {
            tasksViewModel.fetchTasks()
        }
    }
}

struct CategoryRowView: View {
    let category: TaskCategory
    let taskCount: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(categoryColor.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: categoryIcon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(categoryColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.displayName)
                        .font(.nunitoSemiBold(size: 18))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Text("\(taskCount) \(taskCount == 1 ? "task" : "tasks")")
                        .font(.nunitoRegular(size: 14))
                        .foregroundColor(Color.theme.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.theme.tertiaryText)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.theme.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.theme.cardBorder, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var categoryColor: Color {
        switch category {
        case .singing:
            return Color.theme.accentPurple
        case .dancing:
            return Color.theme.accentOrange
        case .animals:
            return Color.theme.accentGreen
        case .funny:
            return Color.theme.accentYellow
        case .other:
            return Color.theme.accentPink
        }
    }
    
    private var categoryIcon: String {
        switch category {
        case .singing:
            return "music.note"
        case .dancing:
            return "figure.dance"
        case .animals:
            return "pawprint.fill"
        case .funny:
            return "face.smiling"
        case .other:
            return "star.fill"
        }
    }
}

struct CategoryTasksView: View {
    let category: TaskCategory
    @ObservedObject var tasksViewModel: TasksViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var taskToDelete: PartyTask?
    @State private var showDeleteAlert = false
    @State private var presentedSheet: PresentedSheet?
    
    enum PresentedSheet: Identifiable {
        case addTask
        case editTask(PartyTask)
        case taskDetail(PartyTask)
        
        var id: String {
            switch self {
            case .addTask:
                return "addTask"
            case .editTask(let task):
                return "editTask_\(task.id)"
            case .taskDetail(let task):
                return "taskDetail_\(task.id)"
            }
        }
    }
    
    private var categoryTasks: [PartyTask] {
        tasksViewModel.getTasksByCategory(category)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 0) {
                    HStack {
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color.theme.primaryText)
                                .frame(width: 40, height: 40)
                                .background(Color.theme.buttonSecondary)
                                .cornerRadius(20)
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 4) {
                            Text(category.displayName)
                                .font(.nunitoBold(size: 24))
                                .foregroundColor(Color.theme.primaryText)
                            
                            Text("\(categoryTasks.count) tasks")
                                .font(.nunitoRegular(size: 14))
                                .foregroundColor(Color.theme.secondaryText)
                        }
                        
                        Spacer()
                        
                        Button(action: { presentedSheet = .addTask }) {
                            Image(systemName: "plus")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color.theme.primaryText)
                                .frame(width: 40, height: 40)
                                .background(Color.theme.buttonPrimary)
                                .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    
                    if categoryTasks.isEmpty {
                        EmptyCategoryView(category: category)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(categoryTasks, id: \.id) { task in
                                    TaskRowView(
                                        task: task,
                                        onTap: {
                                            presentedSheet = .taskDetail(task)
                                        },
                                        onEdit: {
                                            presentedSheet = .editTask(task)
                                        },
                                        onDelete: {
                                            taskToDelete = task
                                            showDeleteAlert = true
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(item: $presentedSheet) { sheet in
            switch sheet {
            case .addTask:
                AddEditTaskView(tasksViewModel: tasksViewModel, preSelectedCategory: category)
            case .editTask(let task):
                AddEditTaskView(tasksViewModel: tasksViewModel, taskToEdit: task)
            case .taskDetail(let task):
                TaskDetailView(
                    taskId: task.id,
                    tasksViewModel: tasksViewModel,
                    onEdit: {
                        presentedSheet = .editTask(task)
                    },
                    onDelete: {
                        taskToDelete = task
                        showDeleteAlert = true
                        presentedSheet = nil
                    }
                )
            }
        }
        .alert("Delete Task", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { 
                taskToDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let task = taskToDelete {
                    tasksViewModel.deleteTask(task)
                    taskToDelete = nil
                }
            }
        } message: {
            Text("Are you sure you want to delete this task? This action cannot be undone.")
        }
    }
}

struct EmptyCategoryView: View {
    let category: TaskCategory
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: categoryIcon)
                .font(.system(size: 60, weight: .light))
                .foregroundColor(Color.theme.secondaryText)
            
            VStack(spacing: 12) {
                Text("No \(category.displayName) Tasks")
                    .font(.nunitoBold(size: 24))
                    .foregroundColor(Color.theme.primaryText)
                
                Text("This category is empty. Add some \(category.displayName.lowercased()) tasks to get started!")
                    .font(.nunitoRegular(size: 16))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
    
    private var categoryIcon: String {
        switch category {
        case .singing:
            return "music.note"
        case .dancing:
            return "figure.dance"
        case .animals:
            return "pawprint.fill"
        case .funny:
            return "face.smiling"
        case .other:
            return "star.fill"
        }
    }
}


