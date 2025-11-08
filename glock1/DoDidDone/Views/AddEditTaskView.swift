import SwiftUI

struct AddEditTaskView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let taskToEdit: Task?
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var selectedCategory: TaskCategory = .other
    @State private var isCompleted: Bool = false
    
    init(taskViewModel: TaskViewModel, taskToEdit: Task? = nil) {
        self.taskViewModel = taskViewModel
        self.taskToEdit = taskToEdit
        
        if let task = taskToEdit {
            _title = State(initialValue: task.title)
            _description = State(initialValue: task.description)
            _selectedCategory = State(initialValue: task.category)
            _isCompleted = State(initialValue: task.isCompleted)
        }
    }
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            VStack {
                HStack {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.secondaryText)
                    
                    Spacer()
                    
                    Text(taskToEdit == nil ? "New Task" : "Edit Task")
                        .font(AppFonts.headline())
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button("Save") {
                        saveTask()
                    }
                    .foregroundColor(isFormValid ? AppColors.accentYellow : AppColors.tertiaryText)
                    .disabled(!isFormValid)
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 25) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Task Title")
                                .font(AppFonts.callout())
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter task title", text: $title)
                                .font(AppFonts.body())
                                .foregroundColor(AppColors.primaryText)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardBackground)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.accentYellow.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description (Optional)")
                                .font(AppFonts.callout())
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter task description", text: $description, axis: .vertical)
                                .font(AppFonts.body())
                                .foregroundColor(AppColors.primaryText)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .frame(minHeight: 80, alignment: .topLeading)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardBackground)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.accentYellow.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(AppFonts.callout())
                                .foregroundColor(AppColors.primaryText)
                            
                            Menu {
                                ForEach(TaskCategory.allCases, id: \.self) { category in
                                    Button(category.displayName) {
                                        selectedCategory = category
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedCategory.displayName)
                                        .font(AppFonts.body())
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.caption)
                                        .foregroundColor(AppColors.secondaryText)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardBackground)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.accentYellow.opacity(0.3), lineWidth: 1)
                                )
                            }
                        }
                        
                        if taskToEdit != nil {
                            HStack {
                                Text("Completed")
                                    .font(AppFonts.callout())
                                    .foregroundColor(AppColors.primaryText)
                                
                                Spacer()
                                
                                Toggle("", isOn: $isCompleted)
                                    .tint(AppColors.accentYellow)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.cardBackground)
                            )
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
    }
    
    private func saveTask() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let existingTask = taskToEdit {
            var updatedTask = existingTask
            updatedTask.title = trimmedTitle
            updatedTask.description = trimmedDescription
            updatedTask.category = selectedCategory
            updatedTask.isCompleted = isCompleted
            
            taskViewModel.updateTask(updatedTask)
        } else {
            let newTask = Task(
                title: trimmedTitle,
                description: trimmedDescription,
                category: selectedCategory,
                isCompleted: isCompleted
            )
            
            taskViewModel.addTask(newTask)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddEditTaskView(taskViewModel: TaskViewModel())
}
