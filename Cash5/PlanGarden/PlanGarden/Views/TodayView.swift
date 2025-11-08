import SwiftUI

struct TodayView: View {
    @EnvironmentObject var taskManager: TaskManager
    @State private var showingTaskForm = false
    @State private var showingFilters = false
    @State private var selectedTasks: Set<UUID> = []
    @State private var isMultiSelectMode = false
    @State private var showingDeleteConfirmation = false
    @State private var showingClearCompletedConfirmation = false
    @State private var selectedTaskForDetail: GardenTask?
    @State private var selectedTaskForEdit: GardenTask?
    @State private var refreshTrigger = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.universalGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                
                    if hasActiveFilters {
                        filterIndicatorView
                    }
    
                    if todayTasks.isEmpty {
                        emptyStateView
                    } else {
                        taskListView
                    }
                }
                .overlay(
                    fabView,
                    alignment: .bottomTrailing
                )
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingTaskForm) {
                TaskFormView(task: selectedTaskForEdit)
            }
            .sheet(item: $selectedTaskForDetail) { task in
                TaskDetailView(task: task)
            }
            .sheet(isPresented: $showingFilters) {
                FilterView()
            }
            .alert("Clear Completed Tasks", isPresented: $showingClearCompletedConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Clear", role: .destructive) {
                    taskManager.clearCompletedTasks()
                }
            } message: {
                Text("All completed tasks will be moved to archive. This action cannot be undone.")
            }
            .alert("Delete Selected Tasks", isPresented: $showingDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteSelectedTasks()
                }
            } message: {
                Text("Selected tasks will be moved to archive. This action cannot be undone.")
            }
        }
    }
    
    
    private var todayTasks: [GardenTask] {
        taskManager.tasksForToday()
    }
    
    private var hasActiveFilters: Bool {
        !taskManager.selectedCultures.isEmpty || !taskManager.selectedWorkTypes.isEmpty
    }
    
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Today")
                    .font(.appLargeTitle)
                    .foregroundColor(.appPrimary)
                
                Text(DateFormatter.displayDateFormatter.string(from: Date()))
                    .font(.appSubheadline)
                    .foregroundColor(.appMediumGray)
            }
            
            Spacer()
            
            if isMultiSelectMode {
                Button("Cancel") {
                    exitMultiSelectMode()
                }
                .font(.appCallout)
                .foregroundColor(.appPrimary)
            } else {
                Menu {
                    Button(action: { showingFilters = true }) {
                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                    }
                    
                    Button(action: { showingClearCompletedConfirmation = true }) {
                        Label("Clear Completed", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title2)
                        .foregroundColor(.appPrimary)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 16)
    }
    
    private var filterIndicatorView: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: "line.3.horizontal.decrease.circle.fill")
                    .foregroundColor(.appAccent)
                
                Text("Filters Active")
                    .font(.appCaption1)
                    .foregroundColor(.appDarkGray)
            }
            
            Spacer()
            
            Button("Clear") {
                taskManager.clearFilters()
            }
            .font(.appCaption1)
            .foregroundColor(.appPrimary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(AppColors.lightGray.opacity(0.5))
    }
    
    
    private var taskListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(todayTasks) { task in
                    TaskCardView(
                        task: task,
                        isSelected: selectedTasks.contains(task.id),
                        isMultiSelectMode: isMultiSelectMode,
                        onTap: {
                            if isMultiSelectMode {
                                toggleTaskSelection(task.id)
                            } else {
                                selectedTaskForDetail = task
                            }
                        },
                        onLongPress: {
                            enterMultiSelectMode(with: task.id)
                        },
                        onToggleComplete: {
                            toggleTaskCompletion(task)
                        },
                        onEdit: {
                            selectedTaskForEdit = task
                            showingTaskForm = true
                        },
                        onDelete: {
                            taskManager.deleteTask(task)
                        }
                    )
                    .id(task.id)
                    .animation(.easeInOut(duration: 0.3), value: task.isCompletedFor(date: Date()))
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
        .overlay(
            multiSelectBottomBar,
            alignment: .bottom
        )
        .animation(.easeInOut(duration: 0.3), value: todayTasks.count)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "leaf.fill")
                .font(.system(size: 60))
                .foregroundColor(.appAccent.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No Tasks Today")
                    .font(.appTitle2)
                    .foregroundColor(.appPrimary)
                
                Text("Add your first garden task to get started")
                    .font(.appBody)
                    .foregroundColor(.appMediumGray)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                selectedTaskForEdit = nil
                showingTaskForm = true
            }) {
                Text("Add Task")
                    .font(.appHeadline)
                    .foregroundColor(.white)
                    .frame(width: 120, height: 44)
                    .background(AppColors.primary)
                    .cornerRadius(22)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var multiSelectBottomBar: some View {
        Group {
            if isMultiSelectMode && !selectedTasks.isEmpty {
                HStack {
                    Text("\(selectedTasks.count) selected")
                        .font(.appCallout)
                        .foregroundColor(.appDarkGray)
                    
                    Spacer()
                    
                    Button("Delete Selected") {
                        showingDeleteConfirmation = true
                    }
                    .font(.appCallout)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(AppColors.error)
                    .cornerRadius(16)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
                .padding(.bottom, 100)
            }
        }
    }
    
    private var fabView: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    selectedTaskForEdit = nil
                    showingTaskForm = true
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .background(AppColors.primary)
                        .clipShape(Circle())
                        .shadow(color: AppColors.primary.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
        }
    }
    
    
    private func toggleTaskCompletion(_ task: GardenTask) {
        if task.isCompletedFor(date: Date()) {
            taskManager.markTaskNotCompleted(task)
        } else {
            taskManager.markTaskCompleted(task)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            withAnimation(.easeInOut(duration: 0.3)) {
                refreshTrigger.toggle()
            }
        }
    }
    
    private func enterMultiSelectMode(with taskId: UUID) {
        isMultiSelectMode = true
        selectedTasks.insert(taskId)
    }
    
    private func exitMultiSelectMode() {
        isMultiSelectMode = false
        selectedTasks.removeAll()
    }
    
    private func toggleTaskSelection(_ taskId: UUID) {
        if selectedTasks.contains(taskId) {
            selectedTasks.remove(taskId)
        } else {
            selectedTasks.insert(taskId)
        }
        
        if selectedTasks.isEmpty {
            exitMultiSelectMode()
        }
    }
    
    private func deleteSelectedTasks() {
        for taskId in selectedTasks {
            if let task = todayTasks.first(where: { $0.id == taskId }) {
                taskManager.deleteTask(task)
            }
        }
        exitMultiSelectMode()
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
            .environmentObject(TaskManager())
    }
}

