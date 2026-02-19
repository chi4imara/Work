import SwiftUI

struct TasksView: View {
    @StateObject private var viewModel = TasksViewModel()
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    headerSection
                    
                    filterBar
                    
                    if viewModel.filteredTasks.isEmpty {
                        emptyStateView
                    } else {
                        tasksGrid
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
            }
        }
        .onAppear {
            viewModel.tasks = appViewModel.tasks
        }
        .onChange(of: appViewModel.tasks, perform: { newTasks in
            if viewModel.tasks != newTasks {
                viewModel.tasks = newTasks
            }
        })
        .sheet(isPresented: $viewModel.showingFilters) {
            FilterView(filter: $viewModel.filter)
        }
        .sheet(isPresented: $viewModel.showingAddTask) {
            AddTaskView { task in
                viewModel.addTask(task)
                appViewModel.addTask(task)
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Today's Tasks")
                    .font(AppFonts.title1())
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Follow your habits and goals")
                    .font(AppFonts.body())
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Button(action: { viewModel.showingAddTask = true }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundColor(AppColors.accentYellow)
            }
        }
    }
    
    private var filterBar: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.textSecondary)
                
                TextField("Search tasks...", text: $viewModel.filter.searchText)
                    .font(AppFonts.body())
                    .foregroundColor(AppColors.textPrimary)
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
            .background(Color.white.opacity(0.8))
            .cornerRadius(AppRadius.md)
            .shadow(color: AppShadows.light, radius: 2, x: 0, y: 1)
            
            Button(action: { viewModel.showingFilters = true }) {
                Image(systemName: "slider.horizontal.3")
                    .font(.title2)
                    .foregroundColor(viewModel.filter.isActive ? AppColors.accentYellow : AppColors.textPrimary)
                    .padding(AppSpacing.sm)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(AppRadius.md)
                    .shadow(color: AppShadows.light, radius: 2, x: 0, y: 1)
            }
        }
    }
    
    private var tasksGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: AppSpacing.md),
            GridItem(.flexible(), spacing: AppSpacing.md)
        ], spacing: AppSpacing.md) {
            ForEach(viewModel.filteredTasks) { task in
                TaskCard(task: task) {
                    viewModel.completeTask(task)
                    if let index = appViewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                        appViewModel.tasks[index].markCompleted()
                    }
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: AppSpacing.lg) {
            Image(systemName: viewModel.tasks.isEmpty ? "plus.circle" : "checkmark.circle")
                .font(.system(size: 60))
                .foregroundColor(AppColors.textSecondary)
            
            Text(viewModel.tasks.isEmpty ? "No tasks yet" : "No suitable tasks")
                .font(AppFonts.title3())
                .foregroundColor(AppColors.textPrimary)
            
            Text(viewModel.tasks.isEmpty ? 
                 "Create your first task to get started" :
                    "Try adjusting your filters or check back later for new tasks")
            .font(AppFonts.body())
            .foregroundColor(AppColors.textSecondary)
            .multilineTextAlignment(.center)
            
            if viewModel.tasks.isEmpty {
                Button {
                    viewModel.showingAddTask = true
                } label: {
                    Text("Add Task")
                        .font(AppFonts.button())
                        .foregroundColor(AppColors.textLight)
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.vertical, AppSpacing.md)
                        .background(AppColors.accentYellow)
                        .cornerRadius(AppRadius.lg)
                        .shadow(color: AppShadows.medium, radius: 4, x: 0, y: 2)
                }
            } else if viewModel.filter.isActive {
                Button {
                    viewModel.resetFilters()
                } label: {
                    Text("Reset Filters")
                        .font(AppFonts.button())
                        .foregroundColor(AppColors.textLight)
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.vertical, AppSpacing.md)
                        .background(AppColors.accentYellow)
                        .cornerRadius(AppRadius.lg)
                        .shadow(color: AppShadows.medium, radius: 4, x: 0, y: 2)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, AppSpacing.xxl)
    }
}

struct TaskCard: View {
    let task: TaskForBuild
    let onComplete: () -> Void
    @State private var isCompleted = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                HStack(spacing: AppSpacing.xs) {
                    Image(systemName: task.type.icon)
                        .font(.caption)
                        .foregroundColor(task.type.color)
                    
                    Text(task.type.rawValue)
                        .font(AppFonts.caption())
                        .foregroundColor(task.type.color)
                }
                
                Spacer()
                
                Text(task.duration.rawValue)
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Text(task.title)
                .font(AppFonts.headline())
                .foregroundColor(AppColors.textPrimary)
                .lineLimit(2)
            
            Text(task.description)
                .font(AppFonts.body())
                .foregroundColor(AppColors.textSecondary)
                .lineLimit(3)
            
            Text("Goal: \(task.goal)")
                .font(AppFonts.caption())
                .foregroundColor(AppColors.textSecondary)
                .italic()
            
            Spacer()
            
            Button(action: {
                withAnimation(.spring()) {
                    isCompleted = true
                    onComplete()
                }
            }) {
                HStack {
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                    
                    Text(isCompleted ? "Completed" : "Mark Done")
                        .font(AppFonts.button())
                }
                .foregroundColor(isCompleted ? AppColors.lightGreen : AppColors.textLight)
                .padding(.vertical, AppSpacing.sm)
                .frame(maxWidth: .infinity)
                .background(isCompleted ? AppColors.lightGreen.opacity(0.3) : AppColors.accentYellow)
                .cornerRadius(AppRadius.md)
            }
            .disabled(isCompleted)
        }
        .padding(AppSpacing.md)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.9))
        .cornerRadius(AppRadius.lg)
        .shadow(color: AppShadows.light, radius: 4, x: 0, y: 2)
        .scaleEffect(isCompleted ? 0.95 : 1.0)
        .onAppear {
            isCompleted = task.isCompleted
        }
    }
}

struct FilterView: View {
    @Binding var filter: TaskFilter
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: AppSpacing.lg) {
                        filterSection(
                            title: "Task Types",
                            items: HabitType.allCases,
                            selectedItems: $filter.selectedTypes
                        ) { type in
                            HStack {
                                Image(systemName: type.icon)
                                    .foregroundColor(type.color)
                                Text(type.rawValue)
                                    .font(AppFonts.body())
                                    .foregroundColor(AppColors.textPrimary)
                            }
                        }
                        
                        filterSection(
                            title: "Duration",
                            items: TaskDuration.allCases,
                            selectedItems: $filter.selectedDurations
                        ) { duration in
                            Text(duration.rawValue)
                                .font(AppFonts.body())
                                .foregroundColor(AppColors.textPrimary)
                        }
                    }
                    .padding(AppSpacing.md)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                leading: Button("Reset") {
                    filter.reset()
                },
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private func filterSection<T: Hashable & Identifiable, Content: View>(
        title: String,
        items: [T],
        selectedItems: Binding<Set<T>>,
        @ViewBuilder content: @escaping (T) -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text(title)
                .font(AppFonts.headline())
                .foregroundColor(AppColors.textPrimary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: AppSpacing.sm) {
                ForEach(items) { item in
                    Button(action: {
                        if selectedItems.wrappedValue.contains(item) {
                            selectedItems.wrappedValue.remove(item)
                        } else {
                            selectedItems.wrappedValue.insert(item)
                        }
                    }) {
                        content(item)
                            .padding(AppSpacing.md)
                            .frame(maxWidth: .infinity)
                            .background(
                                selectedItems.wrappedValue.contains(item) ?
                                AppColors.accentYellow.opacity(0.3) :
                                Color.white.opacity(0.8)
                            )
                            .cornerRadius(AppRadius.md)
                            .overlay(
                                RoundedRectangle(cornerRadius: AppRadius.md)
                                    .stroke(
                                        selectedItems.wrappedValue.contains(item) ?
                                        AppColors.accentYellow : Color.clear,
                                        lineWidth: 2
                                    )
                            )
                    }
                }
            }
        }
    }
}

struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    let onAdd: (TaskForBuild) -> Void
    
    @State private var title = ""
    @State private var description = ""
    @State private var selectedType: HabitType = .sleep
    @State private var selectedDuration: TaskDuration = .short
    @State private var goal = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: AppSpacing.lg) {
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Task Title")
                                .font(AppFonts.headline())
                                .foregroundColor(AppColors.textPrimary)
                            
                            TextField("Enter task title", text: $title)
                                .font(AppFonts.body())
                                .padding(AppSpacing.md)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(AppRadius.md)
                        }
                        
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Description")
                                .font(AppFonts.headline())
                                .foregroundColor(AppColors.textPrimary)
                            
                            TextField("Enter task description", text: $description, axis: .vertical)
                                .font(AppFonts.body())
                                .lineLimit(3...6)
                                .padding(AppSpacing.md)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(AppRadius.md)
                        }
                        
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Type")
                                .font(AppFonts.headline())
                                .foregroundColor(AppColors.textPrimary)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: AppSpacing.sm) {
                                ForEach(HabitType.allCases) { type in
                                    Button(action: { selectedType = type }) {
                                        HStack {
                                            Image(systemName: type.icon)
                                                .foregroundColor(type.color)
                                            Text(type.rawValue)
                                                .font(AppFonts.body())
                                                .foregroundColor(AppColors.textPrimary)
                                        }
                                        .padding(AppSpacing.md)
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            selectedType == type ?
                                            type.color.opacity(0.3) :
                                            Color.white.opacity(0.8)
                                        )
                                        .cornerRadius(AppRadius.md)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: AppRadius.md)
                                                .stroke(
                                                    selectedType == type ? type.color : Color.clear,
                                                    lineWidth: 2
                                                )
                                        )
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Duration")
                                .font(AppFonts.headline())
                                .foregroundColor(AppColors.textPrimary)
                            
                            Picker("Duration", selection: $selectedDuration) {
                                ForEach(TaskDuration.allCases) { duration in
                                    Text(duration.rawValue).tag(duration)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Goal")
                                .font(AppFonts.headline())
                                .foregroundColor(AppColors.textPrimary)
                            
                            TextField("Enter goal for this task", text: $goal)
                                .font(AppFonts.body())
                                .padding(AppSpacing.md)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(AppRadius.md)
                        }
                    }
                    .padding(AppSpacing.md)
                }
            }
            .navigationTitle("Add Task")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    let task = TaskForBuild(
                        title: title,
                        description: description,
                        type: selectedType,
                        duration: selectedDuration,
                        goal: goal.isEmpty ? "Improve wellness" : goal
                    )
                    onAdd(task)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(title.isEmpty || description.isEmpty)
            )
        }
    }
}

#Preview {
    TasksView()
        .environmentObject(AppViewModel())
}
