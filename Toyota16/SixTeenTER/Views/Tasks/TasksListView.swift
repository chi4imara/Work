import SwiftUI

fileprivate struct TaskIdItem: Identifiable {
    let id: UUID
}

struct TasksListView: View {
    @StateObject private var viewModel = TasksViewModel()
    @State fileprivate var selectedTaskIdItem: TaskIdItem?
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("My Tasks & Challenges")
                        .font(.ubuntu(.bold, size: AppConstants.headerFontSize))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.showingAddItem = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(AppColors.primaryOrange)
                    }
                }
                .padding(.horizontal, AppConstants.mediumSpacing)
                .padding(.vertical, AppConstants.mediumSpacing)
                
                if viewModel.allItems.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "list.bullet")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(AppColors.secondaryText)
                        
                        VStack(spacing: 8) {
                            Text("No tasks or challenges yet")
                                .font(.ubuntu(.semiBold, size: AppConstants.largeFontSize))
                                .foregroundColor(AppColors.primaryText)
                            
                            Text("Add your first task or challenge and start your day productively")
                                .font(.ubuntu(.regular, size: AppConstants.mediumFontSize))
                                .foregroundColor(AppColors.secondaryText)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        
                        Button {
                            viewModel.showingAddItem = true
                        } label: {
                            Text("Add Task or Challenge")
                                .font(.ubuntu(.semiBold, size: AppConstants.mediumFontSize))
                                .foregroundColor(AppColors.primaryText)
                                .frame(width: 200, height: AppConstants.buttonHeight)
                                .background(AppColors.buttonGradient)
                                .cornerRadius(AppConstants.mediumCornerRadius)
                        }
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: AppConstants.mediumSpacing) {
                            if !viewModel.activeTasks.isEmpty {
                                TasksSectionView(
                                    title: "Tasks",
                                    tasks: viewModel.activeTasks,
                                    viewModel: viewModel,
                                    selectedTaskIdItem: $selectedTaskIdItem
                                )
                            }
                            
                            if !viewModel.activeChallenges.isEmpty {
                                TasksSectionView(
                                    title: "Mini-Challenges",
                                    tasks: viewModel.activeChallenges,
                                    viewModel: viewModel,
                                    selectedTaskIdItem: $selectedTaskIdItem
                                )
                            }
                        }
                        .padding(.horizontal, AppConstants.mediumSpacing)
                        .padding(.top, AppConstants.mediumSpacing)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.showingAddItem) {
            AddTaskView(
                isPresented: $viewModel.showingAddItem,
                taskType: .task,
                onSave: { viewModel.addTask($0) }
            )
        }
        .sheet(item: $selectedTaskIdItem) { item in
            TaskDetailView(
                taskId: item.id,
                viewModel: viewModel,
                isPresented: Binding(
                    get: { selectedTaskIdItem != nil },
                    set: { if !$0 { selectedTaskIdItem = nil } }
                )
            )
        }
        .onAppear {
            viewModel.loadTasks()
        }
    }
}

struct TasksSectionView: View {
    let title: String
    let tasks: [TaskModel]
    @ObservedObject var viewModel: TasksViewModel
    @Binding fileprivate var selectedTaskIdItem: TaskIdItem?
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.mediumSpacing) {
            Text(title)
                .font(.ubuntu(.semiBold, size: AppConstants.largeFontSize))
                .foregroundColor(AppColors.primaryText)
            
            ForEach(tasks) { task in
                TaskCardView(
                    task: task,
                    viewModel: viewModel
                ) {
                    selectedTaskIdItem = TaskIdItem(id: task.id)
                }
            }
        }
    }
}

struct TaskCardView: View {
    let task: TaskModel
    @ObservedObject var viewModel: TasksViewModel
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            CardView {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(task.title)
                                .font(.ubuntu(.semiBold, size: AppConstants.mediumFontSize))
                                .foregroundColor(AppColors.primaryText)
                                .multilineTextAlignment(.leading)
                            
                            HStack(spacing: 8) {
                                Text(task.type.displayName)
                                    .font(.ubuntu(.medium, size: 10))
                                    .foregroundColor(AppColors.primaryOrange)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(AppColors.primaryOrange.opacity(0.1))
                                    .cornerRadius(AppConstants.smallCornerRadius)
                                
                                HStack(spacing: 4) {
                                    Circle()
                                        .fill(viewModel.getPriorityColor(for: task.priority))
                                        .frame(width: 8, height: 8)
                                    
                                    Text(task.priority.displayName)
                                        .font(.ubuntu(.regular, size: AppConstants.smallFontSize))
                                        .foregroundColor(AppColors.tertiaryText)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.toggleTaskCompletion(task)
                        }) {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(task.isCompleted ? AppColors.success : AppColors.secondaryText)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    HStack {
                        Text(task.frequency.displayName)
                            .font(.ubuntu(.regular, size: AppConstants.smallFontSize))
                            .foregroundColor(AppColors.secondaryText)
                        
                        Spacer()
                        
                        if task.streakDays > 0 {
                            HStack(spacing: 4) {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(AppColors.primaryOrange)
                                
                                Text(viewModel.getStreakText(for: task))
                                    .font(.ubuntu(.medium, size: AppConstants.smallFontSize))
                                    .foregroundColor(AppColors.primaryOrange)
                            }
                        }
                    }
                    
                    if !task.note.isEmpty {
                        Text(task.note)
                            .font(.ubuntu(.regular, size: AppConstants.smallFontSize))
                            .foregroundColor(AppColors.tertiaryText)
                            .lineLimit(2)
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TaskDetailView: View {
    let taskId: UUID
    @ObservedObject var viewModel: TasksViewModel
    @Binding var isPresented: Bool
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var task: TaskModel? {
        viewModel.task(byId: taskId)
    }
    
    var body: some View {
        NavigationView {
            Group {
                if let task = task {
                    taskContent(task: task)
                } else {
                    VStack(spacing: 16) {
                        Text("Task not found")
                            .font(.ubuntu(.semiBold, size: AppConstants.largeFontSize))
                            .foregroundColor(AppColors.secondaryText)
                        Button("Done") { isPresented = false }
                            .foregroundColor(AppColors.primaryOrange)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .background(AppColors.backgroundGradient.ignoresSafeArea())
            .navigationTitle("Task Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { isPresented = false }
                        .foregroundColor(AppColors.primaryOrange)
                }
                if task != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button("Edit") { showingEditView = true }
                            Button("Delete", role: .destructive) { showingDeleteAlert = true }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .foregroundColor(AppColors.primaryOrange)
                        }
                    }
                }
            }
        }
        .alert("Delete Task", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let task = task {
                    viewModel.deleteTask(task)
                }
                isPresented = false
            }
        } message: {
            Text("Are you sure you want to delete this task? This action cannot be undone.")
        }
        .sheet(isPresented: $showingEditView) {
            Group {
                if let t = viewModel.task(byId: taskId) {
                    AddTaskView(
                        isPresented: $showingEditView,
                        taskType: t.type,
                        taskToEdit: t,
                        onSave: { _ in },
                        onUpdate: { viewModel.updateTask($0); showingEditView = false }
                    )
                } else {
                    EmptyView()
                }
            }
        }
    }
    
    private func taskContent(task: TaskModel) -> some View {
        ZStack {
            AppColors.backgroundGradient.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: AppConstants.largeSpacing) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(task.title)
                            .font(.ubuntu(.bold, size: AppConstants.titleFontSize))
                            .foregroundColor(AppColors.primaryText)
                        Text(task.type.displayName)
                            .font(.ubuntu(.medium, size: AppConstants.mediumFontSize))
                            .foregroundColor(AppColors.primaryOrange)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(AppColors.primaryOrange.opacity(0.1))
                            .cornerRadius(AppConstants.smallCornerRadius)
                    }
                    VStack(alignment: .leading, spacing: 16) {
                        DetailRow(title: "Priority", value: task.priority.displayName)
                        DetailRow(title: "Frequency", value: task.frequency.displayName)
                        DetailRow(title: "Streak", value: viewModel.getStreakText(for: task))
                        if !task.note.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Note")
                                    .font(.ubuntu(.semiBold, size: AppConstants.mediumFontSize))
                                    .foregroundColor(AppColors.primaryText)
                                Text(task.note)
                                    .font(.ubuntu(.regular, size: AppConstants.mediumFontSize))
                                    .foregroundColor(AppColors.secondaryText)
                            }
                        }
                        if !task.whyImportant.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Why Important")
                                    .font(.ubuntu(.semiBold, size: AppConstants.mediumFontSize))
                                    .foregroundColor(AppColors.primaryText)
                                Text(task.whyImportant)
                                    .font(.ubuntu(.regular, size: AppConstants.mediumFontSize))
                                    .foregroundColor(AppColors.secondaryText)
                            }
                        }
                    }
                    if !task.completedDates.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Completion History")
                                .font(.ubuntu(.semiBold, size: AppConstants.largeFontSize))
                                .foregroundColor(AppColors.primaryText)
                            ForEach(task.completedDates.suffix(5).reversed(), id: \.self) { date in
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(AppColors.success)
                                    Text(DateFormatter.shortDate.string(from: date))
                                        .font(.ubuntu(.regular, size: AppConstants.mediumFontSize))
                                        .foregroundColor(AppColors.secondaryText)
                                    Spacer()
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, AppConstants.mediumSpacing)
                .padding(.top, AppConstants.mediumSpacing)
            }
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.ubuntu(.semiBold, size: AppConstants.mediumFontSize))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Text(value)
                .font(.ubuntu(.regular, size: AppConstants.mediumFontSize))
                .foregroundColor(AppColors.secondaryText)
        }
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
}

#Preview {
    TasksListView()
}
