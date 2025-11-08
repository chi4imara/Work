import SwiftUI

struct TaskListView: View {
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
                            Text("Task List")
                                .font(.nunitoBold(size: 24))
                                .foregroundColor(Color.theme.primaryText)
                            
                            Text("\(tasksViewModel.tasks.count) tasks")
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
                    
                    if tasksViewModel.tasks.isEmpty {
                        EmptyTaskListView()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(tasksViewModel.tasks, id: \.id) { task in
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
                AddEditTaskView(tasksViewModel: tasksViewModel)
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
        .onAppear {
            tasksViewModel.fetchTasks()
        }
    }
}

struct TaskRowView: View {
    let task: PartyTask
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(categoryColor(for: task.category))
                    .frame(width: 4, height: 60)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(task.text)
                        .font(.nunitoMedium(size: 16))
                        .foregroundColor(Color.theme.primaryText)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        Text(task.category)
                            .font(.nunitoRegular(size: 12))
                            .foregroundColor(Color.theme.secondaryText)
                        
                        Spacer()
                        
                        Text(formatDate(task.dateCreated))
                            .font(.nunitoRegular(size: 12))
                            .foregroundColor(Color.theme.tertiaryText)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.theme.tertiaryText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.theme.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.theme.cardBorder, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .contextMenu {
            Button(action: onEdit) {
                Label("Edit", systemImage: "pencil")
            }
            
            Button(action: onDelete) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    private func categoryColor(for category: String) -> Color {
        switch category {
        case TaskCategory.singing.rawValue:
            return Color.theme.accentPurple
        case TaskCategory.dancing.rawValue:
            return Color.theme.accentOrange
        case TaskCategory.animals.rawValue:
            return Color.theme.accentGreen
        case TaskCategory.funny.rawValue:
            return Color.theme.accentYellow
        default:
            return Color.theme.accentPink
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct EmptyTaskListView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "list.bullet.clipboard")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(Color.theme.secondaryText)
            
            VStack(spacing: 12) {
                Text("No Tasks Yet")
                    .font(.nunitoBold(size: 24))
                    .foregroundColor(Color.theme.primaryText)
                
                Text("Your tasks will appear here. Start by adding your first fun challenge!")
                    .font(.nunitoRegular(size: 16))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

struct TaskDetailView: View {
    let taskId: UUID
    @ObservedObject var tasksViewModel: TasksViewModel
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @Environment(\.presentationMode) var presentationMode
    
    private var task: PartyTask? {
        tasksViewModel.tasks.first { $0.id == taskId }
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            if let task = task {
                VStack(spacing: 30) {
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
                        
                        Text("Task Details")
                            .font(.nunitoBold(size: 20))
                            .foregroundColor(Color.theme.primaryText)
                        
                        Spacer()
                        
                        Color.clear
                            .frame(width: 40, height: 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    VStack(spacing: 24) {
                        Text(task.category)
                            .font(.nunitoMedium(size: 14))
                            .foregroundColor(Color.theme.accentOrange)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.theme.accentOrange.opacity(0.2))
                            .cornerRadius(20)
                        
                        Text(task.text)
                            .font(.nunitoSemiBold(size: 22))
                            .foregroundColor(Color.theme.primaryText)
                            .multilineTextAlignment(.center)
                            .lineSpacing(6)
                            .padding(.horizontal, 30)
                        
                        Text("Created on \(formatFullDate(task.dateCreated))")
                            .font(.nunitoRegular(size: 14))
                            .foregroundColor(Color.theme.tertiaryText)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.theme.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.theme.cardBorder, lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    VStack(spacing: 12) {
                        Button(action: onEdit) {
                            HStack(spacing: 12) {
                                Image(systemName: "pencil")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Edit Task")
                                    .font(.nunitoSemiBold(size: 16))
                            }
                            .foregroundColor(Color.theme.buttonText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color.theme.buttonPrimary)
                            .cornerRadius(26)
                        }
                        
                        Button(action: onDelete) {
                            HStack(spacing: 12) {
                                Image(systemName: "trash")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Delete Task")
                                    .font(.nunitoMedium(size: 16))
                            }
                            .foregroundColor(Color.red)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.theme.buttonSecondary)
                            .cornerRadius(24)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
                }
            } else {
                VStack(spacing: 24) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Text("Task Not Found")
                        .font(.nunitoBold(size: 24))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Text("This task may have been deleted.")
                        .font(.nunitoRegular(size: 16))
                        .foregroundColor(Color.theme.secondaryText)
                        .multilineTextAlignment(.center)
                    
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Text("Close")
                            .font(.nunitoSemiBold(size: 16))
                            .foregroundColor(Color.theme.buttonText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.theme.buttonPrimary)
                            .cornerRadius(24)
                    }
                    .padding(.horizontal, 30)
                }
            }
        }
    }
    
    private func formatFullDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

