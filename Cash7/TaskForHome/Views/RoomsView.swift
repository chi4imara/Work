import SwiftUI

struct RoomsView: View {
    @ObservedObject var viewModel: TaskViewModel
    @State private var showingAddTask = false
    @State private var tab: TabItem = .archive
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.roomsWithTasks.isEmpty {
                    emptyStateView
                } else {
                    roomsListView
                }
                
                Spacer()
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FloatingActionButton {
                        showingAddTask = true
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
                CustomTabBar(selectedTab: $tab)
                    .opacity(0)
            }
        }
        .sheet(isPresented: $showingAddTask) {
            AddEditTaskView(viewModel: viewModel, isPresented: $showingAddTask)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Rooms")
                .font(.customTitle())
                .foregroundColor(.pureWhite)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var roomsListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.roomsWithTasks, id: \.self) { room in
                    NavigationLink(destination: RoomDetailView(viewModel: viewModel, room: room)) {
                        RoomCardView(
                            room: room,
                            taskCount: viewModel.taskCountForRoom(room),
                            previewTasks: Array(viewModel.tasksForRoom(room).prefix(3))
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "door.left.hand.open")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.pureWhite.opacity(0.7))
            
            Text("No rooms with tasks")
                .font(.customHeadline())
                .foregroundColor(.pureWhite)
            
            Text("Create your first task to get started")
                .font(.customBody())
                .foregroundColor(.pureWhite.opacity(0.8))
                .multilineTextAlignment(.center)
            
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
}

struct RoomCardView: View {
    let room: Room
    let taskCount: Int
    let previewTasks: [CleaningTask]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: roomIcon(for: room))
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.primaryBlue)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(room.displayName)
                        .font(.customHeadline())
                        .foregroundColor(.darkGray)
                    
                    Text("\(taskCount) task\(taskCount == 1 ? "" : "s")")
                        .font(.customCaption())
                        .foregroundColor(.mediumGray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.mediumGray)
            }
            
            if !previewTasks.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(previewTasks) { task in
                        HStack {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 14))
                                .foregroundColor(task.isCompleted ? .successGreen : .mediumGray)
                            
                            Text(task.title)
                                .font(.customCaption())
                                .foregroundColor(.darkGray)
                                .strikethrough(task.isCompleted)
                            
                            Spacer()
                            
                            Text(task.frequency.displayName)
                                .font(.customSmall())
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.lightBlue.opacity(0.2))
                                .foregroundColor(.primaryBlue)
                                .cornerRadius(6)
                        }
                    }
                    
                    if taskCount > 3 {
                        Text("and \(taskCount - 3) more...")
                            .font(.customSmall())
                            .foregroundColor(.mediumGray)
                            .padding(.leading, 20)
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.cardGradient)
        )
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
    
    private func roomIcon(for room: Room) -> String {
        switch room {
        case .kitchen: return "fork.knife"
        case .bedroom: return "bed.double"
        case .livingRoom: return "sofa"
        case .bathroom: return "bathtub"
        case .hallway: return "door.left.hand.open"
        case .other: return "house"
        }
    }
}

struct RoomDetailView: View {
    @ObservedObject var viewModel: TaskViewModel
    let room: Room
    @State private var showingAddTask = false
    @State private var selectedTasks: Set<CleaningTask> = []
    @State private var isMultiSelectMode = false
    @State private var taskToEdit: CleaningTask? = nil
    @State private var taskToView: CleaningTask? = nil
    @State private var showingEditSheet = false
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                filterToggleView
                
                if viewModel.tasksForRoom(room).isEmpty {
                    emptyStateView
                } else {
                    taskListView
                }
                
                Spacer()
                
                if isMultiSelectMode {
                    multiSelectToolbar
                }
            }
            .navigationTitle(room.displayName)
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
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
    }
    
    private var filterToggleView: some View {
        HStack {
            Text("Show:")
                .font(.customCaption())
                .foregroundColor(.pureWhite.opacity(0.8))
            
            Button(viewModel.showOnlyTodayTasks ? "Today Only" : "All Active") {
                viewModel.showOnlyTodayTasks.toggle()
            }
            .font(.customCaption())
            .foregroundColor(.primaryBlue)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.pureWhite)
            .cornerRadius(15)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var taskListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.tasksForRoom(room)) { task in
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
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "plus.circle")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.pureWhite.opacity(0.7))
            
            Text("No tasks for this room")
                .font(.customHeadline())
                .foregroundColor(.pureWhite)
            
            Text("Tasks for this room are not assigned")
                .font(.customBody())
                .foregroundColor(.pureWhite.opacity(0.8))
                .multilineTextAlignment(.center)
            
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

#Preview {
    NavigationView {
        RoomsView(viewModel: TaskViewModel())
    }
}
