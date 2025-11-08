import SwiftUI

struct ArchiveView: View {
    @ObservedObject var viewModel: TaskViewModel
    @State private var searchText = ""
    @State private var selectedRoomFilter: Room? = nil
    @State private var selectedTasks: Set<CleaningTask> = []
    @State private var isMultiSelectMode = false
    @State private var showingTaskDetail: CleaningTask? = nil
    
    var filteredArchivedTasks: [CleaningTask] {
        var tasks = viewModel.archivedTasks
        
        if !searchText.isEmpty {
            tasks = tasks.filter { task in
                task.title.localizedCaseInsensitiveContains(searchText) ||
                task.displayRoom.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let selectedRoom = selectedRoomFilter {
            tasks = tasks.filter { $0.room == selectedRoom }
        }
        
        return tasks
    }
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                searchAndFilterView
                
                if filteredArchivedTasks.isEmpty {
                    emptyStateView
                } else {
                    archivedTasksListView
                }
                
                Spacer()
                
                if isMultiSelectMode {
                    multiSelectToolbar
                }
            }
        }
        .sheet(item: $showingTaskDetail) { task in
            ArchivedTaskDetailView(
                task: task,
                onRestore: {
                    viewModel.restoreTask(task)
                    showingTaskDetail = nil
                },
                onPermanentDelete: {
                    viewModel.permanentlyDeleteTask(task)
                    showingTaskDetail = nil
                }
            )
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Archive")
                .font(.customTitle())
                .foregroundColor(.pureWhite)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchAndFilterView: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.mediumGray)
                
                TextField("Search tasks...", text: $searchText)
                    .font(.customBody())
                
                if !searchText.isEmpty {
                    Button("Clear") {
                        searchText = ""
                    }
                    .font(.customCaption())
                    .foregroundColor(.primaryBlue)
                }
            }
            .padding()
            .background(Color.pureWhite)
            .cornerRadius(12)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    Button("All Rooms") {
                        selectedRoomFilter = nil
                    }
                    .font(.customCaption())
                    .foregroundColor(selectedRoomFilter == nil ? .pureWhite : .primaryBlue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(selectedRoomFilter == nil ? Color.primaryBlue : Color.pureWhite)
                    .cornerRadius(15)
                    
                    ForEach(Room.allCases, id: \.self) { room in
                        Button(room.displayName) {
                            selectedRoomFilter = selectedRoomFilter == room ? nil : room
                        }
                        .font(.customCaption())
                        .foregroundColor(selectedRoomFilter == room ? .pureWhite : .primaryBlue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(selectedRoomFilter == room ? Color.primaryBlue : Color.pureWhite)
                        .cornerRadius(15)
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, -20)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var archivedTasksListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredArchivedTasks) { task in
                    ArchivedTaskCardView(
                        task: task,
                        isSelected: selectedTasks.contains(task),
                        isMultiSelectMode: isMultiSelectMode,
                        onTap: {
                            if isMultiSelectMode {
                                toggleTaskSelection(task)
                            } else {
                                showingTaskDetail = task
                            }
                        },
                        onRestore: {
                            viewModel.restoreTask(task)
                        },
                        onPermanentDelete: {
                            viewModel.permanentlyDeleteTask(task)
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
            
            Image(systemName: "archivebox")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.pureWhite.opacity(0.7))
            
            Text(searchText.isEmpty && selectedRoomFilter == nil ? "Archive is empty" : "No matching tasks")
                .font(.customHeadline())
                .foregroundColor(.pureWhite)
            
            if !searchText.isEmpty || selectedRoomFilter != nil {
                Button("Clear Filters") {
                    searchText = ""
                    selectedRoomFilter = nil
                }
                .font(.customBody())
                .foregroundColor(.primaryBlue)
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .background(Color.pureWhite)
                .cornerRadius(25)
            }
            
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
            
            HStack(spacing: 16) {
                Button("Restore (\(selectedTasks.count))") {
                    viewModel.restoreSelectedTasks(selectedTasks)
                    isMultiSelectMode = false
                    selectedTasks.removeAll()
                }
                .foregroundColor(.successGreen)
                .disabled(selectedTasks.isEmpty)
                
                Button("Delete Forever (\(selectedTasks.count))") {
                    viewModel.permanentlyDeleteSelectedTasks(selectedTasks)
                    isMultiSelectMode = false
                    selectedTasks.removeAll()
                }
                .foregroundColor(.dangerRed)
                .disabled(selectedTasks.isEmpty)
            }
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

struct ArchivedTaskCardView: View {
    let task: CleaningTask
    let isSelected: Bool
    let isMultiSelectMode: Bool
    let onTap: () -> Void
    let onRestore: () -> Void
    let onPermanentDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            if isMultiSelectMode {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .primaryBlue : .mediumGray)
                    .font(.system(size: 20))
            }
            
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "archivebox.fill")
                .foregroundColor(task.isCompleted ? .successGreen : .mediumGray)
                .font(.system(size: 16))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.customBody())
                    .foregroundColor(.darkGray)
                
                HStack {
                    Text("Room: \(task.displayRoom)")
                        .font(.customCaption())
                        .foregroundColor(.mediumGray)
                    
                    Spacer()
                    
                    Text(task.frequencyDisplay)
                        .font(.customSmall())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.mediumGray.opacity(0.2))
                        .foregroundColor(.mediumGray)
                        .cornerRadius(8)
                }
                
                if let archivedDate = task.archivedDate {
                    Text("Archived: \(archivedDate, style: .date)")
                        .font(.customSmall())
                        .foregroundColor(.mediumGray.opacity(0.8))
                }
                
                HStack(spacing: 4) {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(task.isCompleted ? .successGreen : .mediumGray)
                        .font(.system(size: 10))
                    
                    Text(task.isCompleted ? "Completed" : "Not Completed")
                        .font(.customSmall())
                        .foregroundColor(task.isCompleted ? .successGreen : .mediumGray)
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(task.isCompleted ? AnyShapeStyle(Color.successGreen.opacity(0.1)) : AnyShapeStyle(Color.cardGradient))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.primaryBlue : (task.isCompleted ? Color.successGreen.opacity(0.3) : Color.clear), lineWidth: 2)
                )
        )
        .shadow(color: .black.opacity(task.isCompleted ? 0.08 : 0.05), radius: 3, x: 0, y: 1)
        .onTapGesture {
            onTap()
        }
        .swipeActions(edge: .leading) {
            Button("Restore") {
                onRestore()
            }
            .tint(.successGreen)
        }
        .swipeActions(edge: .trailing) {
            Button("Delete Forever") {
                onPermanentDelete()
            }
            .tint(.dangerRed)
        }
    }
}

struct ArchivedTaskDetailView: View {
    let task: CleaningTask
    let onRestore: () -> Void
    let onPermanentDelete: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGradient
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Button("Close") {
                            dismiss()
                        }
                        .foregroundColor(.pureWhite)
                        
                        Spacer()
                        Spacer()
                        
                        Text("Archived Task")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                    .padding(16)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            Text(task.title)
                                .font(.customTitle())
                                .foregroundColor(.pureWhite)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(spacing: 16) {
                                DetailCard(
                                    icon: "door.left.hand.open",
                                    title: "Room",
                                    content: task.displayRoom
                                )
                                
                                DetailCard(
                                    icon: "calendar",
                                    title: "Frequency",
                                    content: task.frequencyDisplay
                                )
                                
                                if let note = task.note, !note.isEmpty {
                                    DetailCard(
                                        icon: "note.text",
                                        title: "Note",
                                        content: note
                                    )
                                }
                                
                                DetailCard(
                                    icon: task.isCompleted ? "checkmark.circle.fill" : "exclamationmark.circle.fill",
                                    title: "Status",
                                    content: task.isCompleted ? "Completed" : "Not Completed",
                                    contentColor: task.isCompleted ? .successGreen : .warningOrange
                                )
                                
                                if let archivedDate = task.archivedDate {
                                    DetailCard(
                                        icon: "archivebox.fill",
                                        title: "Archived Date",
                                        content: DateFormatter.localizedString(from: archivedDate, dateStyle: .medium, timeStyle: .none)
                                    )
                                }
                            }
                            
                            VStack(spacing: 12) {
                                Button(action: onRestore) {
                                    HStack {
                                        Image(systemName: "arrow.counterclockwise")
                                        Text("Restore Task")
                                    }
                                    .font(.customBody())
                                    .foregroundColor(.pureWhite)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.successGreen)
                                    .cornerRadius(12)
                                }
                                
                                Button(action: {
                                    showingDeleteAlert = true
                                }) {
                                    HStack {
                                        Image(systemName: "trash.fill")
                                        Text("Delete Forever")
                                    }
                                    .font(.customBody())
                                    .foregroundColor(.dangerRed)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.pureWhite)
                                    .cornerRadius(12)
                                }
                            }
                            
                            Spacer(minLength: 50)
                        }
                        .padding(20)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .alert("Delete Forever", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete Forever", role: .destructive) {
                    onPermanentDelete()
                }
            } message: {
                Text("This task will be permanently deleted and cannot be recovered.")
            }
        }
    }
}

#Preview {
    ArchiveView(viewModel: TaskViewModel())
}

