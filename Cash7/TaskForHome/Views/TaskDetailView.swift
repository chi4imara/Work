import SwiftUI

struct TaskDetailView: View {
    @ObservedObject var viewModel: TaskViewModel
    @Environment(\.dismiss) private var dismiss
    
    let task: CleaningTask
    
    init(viewModel: TaskViewModel, task: CleaningTask) {
        self.viewModel = viewModel
        self.task = task
        self._currentTask = State(initialValue: task)
    }
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @State private var taskNotFound = false
    @State private var currentTask: CleaningTask
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            if taskNotFound {
                taskNotFoundView
            } else {
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(currentTask.title)
                                .font(.customTitle())
                                .foregroundColor(.pureWhite)
                                .multilineTextAlignment(.leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 16) {
                            DetailCard(
                                icon: "door.left.hand.open",
                                title: "Room",
                                content: currentTask.displayRoom
                            )
                            
                            DetailCard(
                                icon: "calendar",
                                title: "Frequency",
                                content: currentTask.frequencyDisplay
                            )
                            
                            DetailCard(
                                icon: currentTask.isCompleted ? "checkmark.circle.fill" : "circle",
                                title: "Status for Today",
                                content: currentTask.isCompleted ? "Completed" : "Not Completed",
                                contentColor: currentTask.isCompleted ? .successGreen : .warningOrange
                            )
                            
                            if let note = currentTask.note, !note.isEmpty {
                                DetailCard(
                                    icon: "note.text",
                                    title: "Note",
                                    content: note
                                )
                            }
                        }
                        
                        VStack(spacing: 12) {
                            if currentTask.isRelevantForToday() {
                                Button(action: {
                                    viewModel.toggleTaskCompletion(currentTask)
                                    dismiss()
                                }) {
                                    HStack {
                                        Image(systemName: currentTask.isCompleted ? "xmark.circle" : "checkmark.circle")
                                        Text(currentTask.isCompleted ? "Mark as Incomplete" : "Mark as Completed")
                                    }
                                    .font(.customBody())
                                    .foregroundColor(.pureWhite)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(currentTask.isCompleted ? Color.warningOrange : Color.successGreen)
                                    .cornerRadius(12)
                                }
                            }
                            
                            Button(action: {
                                showingEditView = true
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                    Text("Edit Task")
                                }
                                .font(.customBody())
                                .foregroundColor(.primaryBlue)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.pureWhite)
                                .cornerRadius(12)
                            }
                            
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "trash")
                                    Text("Delete Task")
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
        .sheet(isPresented: $showingEditView) {
            AddEditTaskView(
                viewModel: viewModel,
                isPresented: $showingEditView,
                taskToEdit: currentTask
            )
            .onDisappear {
                if let updatedTask = viewModel.tasks.first(where: { $0.id == currentTask.id }) {
                    currentTask = updatedTask
                }
            }
        }
        .alert("Delete Task", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteTask(currentTask)
                dismiss()
            }
        } message: {
            Text("This task will be moved to archive and removed from your lists.")
        }
        .onAppear {
            checkTaskAvailability()
        }
        .onChange(of: viewModel.tasks) { _ in
            if let updatedTask = viewModel.tasks.first(where: { $0.id == currentTask.id }) {
                currentTask = updatedTask
            }
        }
    }
    
    private var taskNotFoundView: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.warningOrange)
            
            Text("Task Not Available")
                .font(.customHeadline())
                .foregroundColor(.pureWhite)
            
            Text("This task has been moved to archive or deleted.")
                .font(.customBody())
                .foregroundColor(.pureWhite.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Button("Back to List") {
                dismiss()
            }
            .font(.customBody())
            .foregroundColor(.primaryBlue)
            .padding(.horizontal, 30)
            .padding(.vertical, 12)
            .background(Color.pureWhite)
            .cornerRadius(25)
        }
        .padding(40)
    }
    
    private func checkTaskAvailability() {
        let taskExists = viewModel.tasks.contains { $0.id == task.id && !$0.isArchived }
        taskNotFound = !taskExists
    }
}

struct DetailCard: View {
    let icon: String
    let title: String
    let content: String
    var contentColor: Color = .darkGray
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.primaryBlue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.customCaption())
                    .foregroundColor(.mediumGray)
                
                Text(content)
                    .font(.customBody())
                    .foregroundColor(contentColor)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.cardGradient)
        )
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

#Preview {
    NavigationView {
        TaskDetailView(
            viewModel: TaskViewModel(),
            task: CleaningTask(
                title: "Vacuum Living Room",
                room: .livingRoom,
                frequency: .daily,
                note: "Use the new vacuum cleaner"
            )
        )
    }
}
