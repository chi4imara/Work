import SwiftUI

struct TodayView: View {
    @ObservedObject var viewModel: TaskViewModel
    @State private var showingMenu = false
    @State private var showingRoomFilter = false
    @State private var showingAddTask = false
    @State private var selectedTasks: Set<CleaningTask> = []
    @State private var isMultiSelectMode = false
    @State private var showingClearConfirmation = false
    @State private var taskToEdit: CleaningTask? = nil
    @State private var taskToView: CleaningTask? = nil
    @State private var showingEditSheet = false
    @State private var tab: TabItem = .archive
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.todayTasks.isEmpty {
                    emptyStateView
                } else {
                    taskListView
                }
                
                Spacer()
                
                if isMultiSelectMode {
                    multiSelectToolbar
                }
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FloatingActionButton {
                        showingAddTask = true
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, isMultiSelectMode ? 80 : 20)
                }
                CustomTabBar(selectedTab: $tab)
                    .opacity(0)
            }
        }
        .sheet(isPresented: $showingRoomFilter) {
            RoomFilterView(
                selectedRooms: $viewModel.selectedRoomFilter,
                isPresented: $showingRoomFilter
            )
        }
        .sheet(isPresented: $showingAddTask) {
            AddEditTaskView(viewModel: viewModel, isPresented: $showingAddTask)
        }
        .sheet(isPresented: $showingEditSheet) {
            if let task = taskToEdit {
                AddEditTaskView(viewModel: viewModel, isPresented: $showingEditSheet, taskToEdit: task)
                    .onDisappear {
                        taskToEdit = nil
                    }
            }
        }
        .sheet(item: $taskToView) { task in
            NavigationView {
                TaskDetailView(viewModel: viewModel, task: task)
            }
        }
        .alert("Clear Completed Tasks", isPresented: $showingClearConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                viewModel.clearCompletedTasks()
            }
        } message: {
            Text("All completed tasks will be moved to archive and removed from today's list.")
        }
        .onAppear {
            viewModel.resetDailyTasks()
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Today")
                .font(.customTitle())
                .foregroundColor(.pureWhite)
            
            Spacer()
            
            Menu {
                Button("Clear Completed") {
                    showingClearConfirmation = true
                }
                
                Button("Filter by Rooms...") {
                    showingRoomFilter = true
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.pureWhite)
                    .padding(8)
                    .background(Circle().fill(Color.pureWhite.opacity(0.2)))
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var taskListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.todayTasks) { task in
                    TaskCardView(
                        task: task,
                        isSelected: selectedTasks.contains(task),
                        isMultiSelectMode: isMultiSelectMode,
                        onTap: {
                            if isMultiSelectMode {
                                toggleTaskSelection(task)
                            } else {
                                taskToView = task
                            }
                        },
                        onToggleCompletion: {
                            viewModel.toggleTaskCompletion(task)
                        },
                        onEdit: {
                            taskToEdit = task
                            showingEditSheet = true
                        },
                        onDelete: {
                            viewModel.deleteTask(task)
                        }
                    )
                    .onLongPressGesture {
                        if !isMultiSelectMode {
                            isMultiSelectMode = true
                            selectedTasks.insert(task)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "sparkles")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.pureWhite.opacity(0.7))
            
            Text("No tasks for today")
                .font(.customHeadline())
                .foregroundColor(.pureWhite)
            
            Button("Add Task") {
                showingAddTask = true
            }
            .font(.customBody())
            .foregroundColor(.primaryBlue)
            .padding(.horizontal, 30)
            .padding(.vertical, 12)
            .background(Color.pureWhite)
            .cornerRadius(25)
            
            Spacer()
        }
    }
    
    private var multiSelectToolbar: some View {
        HStack {
            Button("Cancel") {
                isMultiSelectMode = false
                selectedTasks.removeAll()
            }
            .foregroundColor(.mediumGray)
            
            Spacer()
            
            Button("Delete Selected (\(selectedTasks.count))") {
                viewModel.deleteSelectedTasks(selectedTasks)
                isMultiSelectMode = false
                selectedTasks.removeAll()
            }
            .foregroundColor(.dangerRed)
            .disabled(selectedTasks.isEmpty)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.pureWhite)
        .cornerRadius(12)
        .padding(.horizontal, 20)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: -2)
    }
    
    private func toggleTaskSelection(_ task: CleaningTask) {
        if selectedTasks.contains(task) {
            selectedTasks.remove(task)
        } else {
            selectedTasks.insert(task)
        }
        
        if selectedTasks.isEmpty {
            isMultiSelectMode = false
        }
    }
}

struct TaskCardView: View {
    let task: CleaningTask
    let isSelected: Bool
    let isMultiSelectMode: Bool
    let onTap: () -> Void
    let onToggleCompletion: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            if isMultiSelectMode {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .primaryBlue : .mediumGray)
                    .font(.system(size: 20))
            }
            
            Button(action: onToggleCompletion) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .successGreen : .mediumGray)
                    .font(.system(size: 20))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.customBody())
                    .foregroundColor(.darkGray)
                    .strikethrough(task.isCompleted)
                
                HStack {
                    Text("Room: \(task.displayRoom)")
                        .font(.customCaption())
                        .foregroundColor(.mediumGray)
                    
                    Spacer()
                    
                    Text(task.frequencyDisplay)
                        .font(.customSmall())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.lightBlue.opacity(0.2))
                        .foregroundColor(.primaryBlue)
                        .cornerRadius(8)
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.primaryBlue : Color.clear, lineWidth: 2)
                )
        )
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
        .onTapGesture {
            onTap()
        }
        .swipeActions(edge: .leading) {
            Button("Edit") {
                onEdit()
            }
            .tint(.warningOrange)
        }
        .swipeActions(edge: .trailing) {
            Button("Delete") {
                onDelete()
            }
            .tint(.dangerRed)
        }
    }
}

struct RoomFilterView: View {
    @Binding var selectedRooms: Set<Room>
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    ForEach(Room.allCases, id: \.self) { room in
                        HStack {
                            Text(room.displayName)
                                .font(.customBody())
                                .foregroundColor(.pureWhite)
                            
                            Spacer()
                            
                            Image(systemName: selectedRooms.contains(room) ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(selectedRooms.contains(room) ? .successGreen : .mediumGray)
                                .font(.system(size: 20))
                        }
                        .padding()
                        .background(Color.pureWhite.opacity(0.1))
                        .cornerRadius(12)
                        .onTapGesture {
                            if selectedRooms.contains(room) {
                                selectedRooms.remove(room)
                            } else {
                                selectedRooms.insert(room)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(20)
            }
            .navigationTitle("Filter by Rooms")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        selectedRooms = Set(Room.allCases)
                    }
                    .foregroundColor(.pureWhite)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        isPresented = false
                    }
                    .foregroundColor(.pureWhite)
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar) 
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

#Preview {
    TodayView(viewModel: TaskViewModel())
}
