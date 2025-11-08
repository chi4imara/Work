import SwiftUI

struct ArchiveView: View {
    @EnvironmentObject var taskManager: TaskManager
    @State private var selectedTasks: Set<UUID> = []
    @State private var isMultiSelectMode = false
    @State private var showingClearArchiveConfirmation = false
    @State private var showingDeleteConfirmation = false
    @State private var showingRestoreConfirmation = false
    @State private var selectedTaskForDetail: GardenTask?
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.universalGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    searchAndFilterView
                    
                    if archivedTasks.isEmpty {
                        emptyStateView
                    } else {
                        archiveListView
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(item: $selectedTaskForDetail) { task in
                ArchivedTaskDetailView(task: task)
            }
            .alert("Clear Archive", isPresented: $showingClearArchiveConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Clear", role: .destructive) {
                    taskManager.clearArchive()
                }
            } message: {
                Text("All archived tasks will be permanently deleted. This action cannot be undone.")
            }
            .alert("Delete Selected Tasks", isPresented: $showingDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteSelectedTasks()
                }
            } message: {
                Text("Selected tasks will be permanently deleted. This action cannot be undone.")
            }
            .alert("Restore Selected Tasks", isPresented: $showingRestoreConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Restore") {
                    restoreSelectedTasks()
                }
            } message: {
                Text("Selected tasks will be restored to active status.")
            }
        }
    }
    
    
    private var archivedTasks: [GardenTask] {
        taskManager.archivedTasks()
    }
    
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Archive")
                    .font(.appLargeTitle)
                    .foregroundColor(.appPrimary)
                
                if !archivedTasks.isEmpty {
                    Text("\(archivedTasks.count) archived tasks")
                        .font(.appSubheadline)
                        .foregroundColor(.appMediumGray)
                }
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
                    Button(action: { showingClearArchiveConfirmation = true }) {
                        Label("Clear Archive", systemImage: "trash")
                    }
                    .disabled(archivedTasks.isEmpty)
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
    
    private var searchAndFilterView: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.appMediumGray)
                
                TextField("Search by culture or note", text: $taskManager.searchText)
                    .font(.appBody)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !taskManager.searchText.isEmpty {
                    Button(action: {
                        taskManager.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.appMediumGray)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(10)
            
            if !WorkType.allCases.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(WorkType.allCases, id: \.self) { workType in
                            FilterChip(
                                title: workType.rawValue,
                                icon: workType.icon,
                                isSelected: taskManager.selectedWorkTypes.contains(workType)
                            ) {
                                toggleWorkTypeFilter(workType)
                            }
                        }
                    }
                    .padding(.horizontal, 5)
                }
            }
            
            if !taskManager.selectedWorkTypes.isEmpty || !taskManager.searchText.isEmpty {
                HStack {
                    Text("Filters active")
                        .font(.appCaption1)
                        .foregroundColor(.appDarkGray)
                    
                    Spacer()
                    
                    Button("Clear All") {
                        taskManager.clearFilters()
                    }
                    .font(.appCaption1)
                    .foregroundColor(.appPrimary)
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    
    private var archiveListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(archivedTasks) { task in
                    ArchivedTaskCardView(
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
                        onRestore: {
                            taskManager.restoreTask(task)
                        },
                        onDelete: {
                            taskManager.permanentlyDeleteTask(task)
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
        .overlay(
            multiSelectBottomBar,
            alignment: .bottom
        )
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "archivebox")
                .font(.system(size: 60))
                .foregroundColor(.appMediumGray.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("Archive is Empty")
                    .font(.appTitle2)
                    .foregroundColor(.appPrimary)
                
                Text("Completed and deleted tasks will appear here")
                    .font(.appBody)
                    .foregroundColor(.appMediumGray)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var multiSelectBottomBar: some View {
        Group {
            if isMultiSelectMode && !selectedTasks.isEmpty {
                HStack(spacing: 16) {
                    Text("\(selectedTasks.count) selected")
                        .font(.appCallout)
                        .foregroundColor(.appDarkGray)
                    
                    Spacer()
                    
                    Button("Restore") {
                        showingRestoreConfirmation = true
                    }
                    .font(.appCallout)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(AppColors.success)
                    .cornerRadius(16)
                    
                    Button("Delete") {
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
    
    private func toggleWorkTypeFilter(_ workType: WorkType) {
        if taskManager.selectedWorkTypes.contains(workType) {
            taskManager.selectedWorkTypes.remove(workType)
        } else {
            taskManager.selectedWorkTypes.insert(workType)
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
    
    private func restoreSelectedTasks() {
        for taskId in selectedTasks {
            if let task = archivedTasks.first(where: { $0.id == taskId }) {
                taskManager.restoreTask(task)
            }
        }
        exitMultiSelectMode()
    }
    
    private func deleteSelectedTasks() {
        for taskId in selectedTasks {
            if let task = archivedTasks.first(where: { $0.id == taskId }) {
                taskManager.permanentlyDeleteTask(task)
            }
        }
        exitMultiSelectMode()
    }
}

struct ArchivedTaskCardView: View {
    @EnvironmentObject var taskManager: TaskManager
    @Environment(\.dismiss) private var dismiss
    
    let task: GardenTask
    let isSelected: Bool
    let isMultiSelectMode: Bool
    let onTap: () -> Void
    let onLongPress: () -> Void
    let onRestore: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGSize = .zero
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        ZStack {
            cardContent
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .alert("Delete Permanently", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("This task will be permanently deleted. This action cannot be undone.")
        }
    }
    
    private var cardContent: some View {
        HStack(spacing: 16) {
            if isMultiSelectMode {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isSelected ? .appPrimary : .appMediumGray)
            } else {
                Image(systemName: task.workType.icon)
                    .font(.title2)
                    .foregroundColor(.appMediumGray)
                    .frame(width: 24, height: 24)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                    Text(task.culture.name)
                        .font(.appHeadline)
                        .foregroundColor(.appMediumGray)
                    
                    Text(task.workType.rawValue)
                        .font(.appSubheadline)
                        .foregroundColor(.appMediumGray)
                
                if !task.note.isEmpty {
                    Text(task.note)
                        .font(.appCaption1)
                        .foregroundColor(.appMediumGray)
                        .lineLimit(1)
                }
                
                HStack(spacing: 8) {
                    Text(task.frequency.displayName)
                        .font(.appCaption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(AppColors.lightGray)
                        .cornerRadius(8)
                        .foregroundColor(.appMediumGray)
                    
                    if let archivedDate = task.archivedDate {
                        Text("Archived \(DateFormatter.displayDateFormatter.string(from: archivedDate))")
                            .font(.appCaption2)
                            .foregroundColor(.appMediumGray)
                    }
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Button(action: {
                    showingDeleteConfirmation = true
                }) {
                    Image(systemName: "trash")
                        .font(.title3)
                        .foregroundColor(.red)
                        .frame(width: 30)
                        .frame(height: 30)
                        .cornerRadius(25)
                }
                .padding(8)
                
                Button(action: {
                    taskManager.restoreTask(task)
                    dismiss()
                }) {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.title3)
                        .foregroundColor(.green)
                        .frame(width: 30)
                        .frame(height: 30)
                        .cornerRadius(25)
                }
                .padding(8)
            }
        }
        .padding(16)
        .background(AppColors.lightGray.opacity(0.3))
        .cornerRadius(12)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
        .onLongPressGesture {
            onLongPress()
        }
    }
}

struct ArchivedTaskDetailView: View {
    @EnvironmentObject var taskManager: TaskManager
    @Environment(\.dismiss) private var dismiss
    
    let task: GardenTask
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            Image(systemName: task.workType.icon)
                                .font(.system(size: 50))
                                .foregroundColor(.appMediumGray)
                                .frame(width: 80, height: 80)
                                .background(
                                    Circle()
                                        .fill(AppColors.lightGray)
                                )
                            
                            Text(task.culture.name)
                                .font(.appLargeTitle)
                                .foregroundColor(.appMediumGray)
                                .multilineTextAlignment(.center)
                            
                            Text(task.workType.rawValue)
                                .font(.appTitle3)
                                .foregroundColor(.appMediumGray)
                            
                            Text("ARCHIVED")
                                .font(.appCaption1)
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(AppColors.mediumGray)
                                .cornerRadius(8)
                        }
                        
                        VStack(spacing: 16) {
                            InfoCard(title: "Work Type") {
                                HStack(spacing: 12) {
                                    Image(systemName: task.workType.icon)
                                        .font(.title2)
                                        .foregroundColor(.appMediumGray)
                                    
                                    Text(task.workType.rawValue)
                                        .font(.appBody)
                                        .foregroundColor(.appMediumGray)
                                    
                                    Spacer()
                                }
                            }
                            
                            InfoCard(title: "Original Date") {
                                HStack(spacing: 12) {
                                    Image(systemName: "calendar")
                                        .font(.title2)
                                        .foregroundColor(.appMediumGray)
                                    
                                    Text(DateFormatter.displayDateFormatter.string(from: task.date))
                                        .font(.appBody)
                                        .foregroundColor(.appMediumGray)
                                    
                                    Spacer()
                                }
                            }
                            
                            InfoCard(title: "Frequency") {
                                HStack(spacing: 12) {
                                    Image(systemName: "arrow.clockwise")
                                        .font(.title2)
                                        .foregroundColor(.appMediumGray)
                                    
                                    Text(task.frequency.displayName)
                                        .font(.appBody)
                                        .foregroundColor(.appMediumGray)
                                    
                                    Spacer()
                                }
                            }
                            
                            if !task.note.isEmpty {
                                InfoCard(title: "Note") {
                                    HStack(alignment: .top, spacing: 12) {
                                        Image(systemName: "note.text")
                                            .font(.title2)
                                            .foregroundColor(.appMediumGray)
                                        
                                        Text(task.note)
                                            .font(.appBody)
                                            .foregroundColor(.appMediumGray)
                                            .multilineTextAlignment(.leading)
                                        
                                        Spacer()
                                    }
                                }
                            }
                            
                            if let archivedDate = task.archivedDate {
                                InfoCard(title: "Archived") {
                                    HStack(spacing: 12) {
                                        Image(systemName: "archivebox")
                                            .font(.title2)
                                            .foregroundColor(.appMediumGray)
                                        
                                        Text(DateFormatter.displayDateTimeFormatter.string(from: archivedDate))
                                            .font(.appBody)
                                            .foregroundColor(.appMediumGray)
                                        
                                        Spacer()
                                    }
                                }
                            }
                        }
                        
                        VStack(spacing: 16) {
                            Button(action: {
                                taskManager.restoreTask(task)
                                dismiss()
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "arrow.uturn.backward")
                                        .font(.title3)
                                    
                                    Text("Restore Task")
                                        .font(.appHeadline)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(AppColors.success)
                                .cornerRadius(25)
                            }
                            
                            Button(action: {
                                showingDeleteConfirmation = true
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "trash")
                                        .font(.title3)
                                    
                                    Text("Delete Permanently")
                                        .font(.appHeadline)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(AppColors.error)
                                .cornerRadius(25)
                            }
                        }
                    }
                    .padding(20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Archived Task")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.appPrimary)
                }
            }
        }
        .alert("Delete Permanently", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                taskManager.permanentlyDeleteTask(task)
                dismiss()
            }
        } message: {
            Text("This task will be permanently deleted. This action cannot be undone.")
        }
    }
}

struct ArchiveView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveView()
            .environmentObject(TaskManager())
    }
}
