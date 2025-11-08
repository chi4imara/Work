import SwiftUI

struct TaskEditorView: View {
    @ObservedObject var viewModel: AppViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var newTaskText = ""
    @State private var editingTask: PartyTask?
    @State private var editingText = ""
    @State private var showDeleteAlert = false
    @State private var taskToDelete: PartyTask?
    
    var body: some View {
        NavigationView {
            ZStack {
                StaticBackground()
                
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Add New Task")
                            .font(.theme.headline)
                            .foregroundColor(ColorTheme.textPrimary)
                        
                        HStack {
                            TextField("Enter task description", text: $newTaskText)
                                .font(.theme.body)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(ColorTheme.backgroundWhite)
                                        .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
                                )
                            
                            Button(action: addTask) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(newTaskText.isEmpty ? ColorTheme.lightBlue : ColorTheme.primaryBlue)
                            }
                            .disabled(newTaskText.isEmpty)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Current Tasks (\(viewModel.tasks.count))")
                            .font(.theme.headline)
                            .foregroundColor(ColorTheme.textPrimary)
                            .padding(.horizontal, 20)
                        
                        if viewModel.tasks.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "list.bullet.circle")
                                    .font(.system(size: 40, weight: .light))
                                    .foregroundColor(ColorTheme.lightBlue)
                                
                                Text("No tasks yet")
                                    .font(.theme.body)
                                    .foregroundColor(ColorTheme.textSecondary)
                                
                                Text("Add your first task above to get started")
                                    .font(.theme.callout)
                                    .foregroundColor(ColorTheme.textSecondary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                        } else {
                            ScrollView {
                                LazyVStack(spacing: 12) {
                                    ForEach(viewModel.tasks) { task in
                                        TaskRow(
                                            task: task,
                                            isEditing: editingTask?.id == task.id,
                                            editingText: $editingText,
                                            onEdit: { startEditing(task) },
                                            onSave: { saveEdit(task) },
                                            onCancel: { cancelEdit() },
                                            onDelete: { deleteTask(task) }
                                        )
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Edit Tasks")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.theme.headline)
                    .foregroundColor(ColorTheme.primaryBlue)
                }
            }
        }
        .alert("Delete Task", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let task = taskToDelete {
                    viewModel.removeTask(task)
                    taskToDelete = nil
                }
            }
        } message: {
            Text("Are you sure you want to delete this task?")
        }
    }
    
    private func addTask() {
        guard !newTaskText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        viewModel.addTask(newTaskText.trimmingCharacters(in: .whitespacesAndNewlines))
        newTaskText = ""
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func startEditing(_ task: PartyTask) {
        editingTask = task
        editingText = task.text
    }
    
    private func saveEdit(_ task: PartyTask) {
        guard !editingText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        viewModel.updateTask(task, newText: editingText.trimmingCharacters(in: .whitespacesAndNewlines))
        editingTask = nil
        editingText = ""
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func cancelEdit() {
        editingTask = nil
        editingText = ""
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func deleteTask(_ task: PartyTask) {
        taskToDelete = task
        showDeleteAlert = true
    }
}

struct TaskRow: View {
    let task: PartyTask
    let isEditing: Bool
    @Binding var editingText: String
    let onEdit: () -> Void
    let onSave: () -> Void
    let onCancel: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            if isEditing {
                TextField("Task description", text: $editingText)
                    .font(.theme.body)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                Text(task.text)
                    .font(.theme.body)
                    .foregroundColor(ColorTheme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            HStack(spacing: 8) {
                if isEditing {
                    Button(action: onSave) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(ColorTheme.accentGreen)
                    }
                    
                    Button(action: onCancel) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(ColorTheme.textSecondary)
                    }
                } else {
                    Button(action: onEdit) {
                        Image(systemName: "pencil.circle")
                            .font(.system(size: 20))
                            .foregroundColor(ColorTheme.primaryBlue)
                    }
                    
                    Button(action: onDelete) {
                        Image(systemName: "trash.circle")
                            .font(.system(size: 20))
                            .foregroundColor(ColorTheme.accentPink)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorTheme.backgroundWhite)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

#Preview {
    TaskEditorView(viewModel: AppViewModel())
}
