import SwiftUI

struct AddEditTaskView: View {
    @ObservedObject var tasksViewModel: TasksViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let taskToEdit: PartyTask?
    
    @State private var taskText: String = ""
    @State private var selectedCategory: TaskCategory = .singing
    @State private var showCategoryPicker = false
    
    private var isEditing: Bool {
        taskToEdit != nil
    }
    
    private var canSave: Bool {
        !taskText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    init(tasksViewModel: TasksViewModel, taskToEdit: PartyTask? = nil, preSelectedCategory: TaskCategory? = nil) {
        self.tasksViewModel = tasksViewModel
        self.taskToEdit = taskToEdit
        
        if let task = taskToEdit {
            _taskText = State(initialValue: task.text)
            _selectedCategory = State(initialValue: TaskCategory(rawValue: task.category) ?? .singing)
        } else if let category = preSelectedCategory {
            _selectedCategory = State(initialValue: category)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 30) {
                        VStack(spacing: 8) {
                            Text(isEditing ? "Edit Task" : "New Task")
                                .font(.nunitoBold(size: 28))
                                .foregroundColor(Color.theme.primaryText)
                            
                            Text(isEditing ? "Update your task details" : "Create a fun new challenge")
                                .font(.nunitoRegular(size: 16))
                                .foregroundColor(Color.theme.secondaryText)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 24) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Task Description")
                                    .font(.nunitoSemiBold(size: 18))
                                    .foregroundColor(Color.theme.primaryText)
                                
                                ZStack(alignment: .topLeading) {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.theme.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.theme.cardBorder, lineWidth: 1)
                                        )
                                        .frame(minHeight: 120)
                                    
                                    if taskText.isEmpty {
                                        Text("Enter your fun task here...")
                                            .font(.nunitoRegular(size: 16))
                                            .foregroundColor(Color.theme.tertiaryText)
                                            .padding(.horizontal, 16)
                                            .padding(.top, 16)
                                    }
                                    
                                    TextEditor(text: $taskText)
                                        .font(.nunitoRegular(size: 16))
                                        .foregroundColor(Color.theme.primaryText)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 12)
                                        .background(Color.clear)
                                        .scrollContentBackground(.hidden)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Category")
                                        .font(.nunitoSemiBold(size: 18))
                                        .foregroundColor(Color.theme.primaryText)
                                    
                                    if taskToEdit == nil {
                                        Text("(Pre-selected)")
                                            .font(.nunitoRegular(size: 12))
                                            .foregroundColor(Color.theme.accentOrange)
                                    }
                                }
                                
                                Button(action: { showCategoryPicker = true }) {
                                    HStack {
                                        Text(selectedCategory.displayName)
                                            .font(.nunitoMedium(size: 16))
                                            .foregroundColor(Color.theme.primaryText)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(Color.theme.secondaryText)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.theme.cardBackground)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(Color.theme.cardBorder, lineWidth: 1)
                                            )
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 30)
                        
                        Spacer(minLength: 100)
                    }
                }
                
                VStack(spacing: 16) {
                    Spacer()
                    
                    VStack(spacing: 12) {
                        Button(action: saveTask) {
                            Text(isEditing ? "Update Task" : "Save Task")
                                .font(.nunitoSemiBold(size: 18))
                                .foregroundColor(canSave ? Color.theme.buttonText : Color.theme.tertiaryText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(canSave ? Color.theme.buttonPrimary : Color.theme.buttonSecondary)
                                .cornerRadius(28)
                        }
                        .disabled(!canSave)
                        
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            Text("Cancel")
                                .font(.nunitoMedium(size: 16))
                                .foregroundColor(Color.theme.secondaryText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(Color.theme.buttonSecondary)
                                .cornerRadius(24)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationBarHidden(true)
        .actionSheet(isPresented: $showCategoryPicker) {
            ActionSheet(
                title: Text("Select Category"),
                buttons: TaskCategory.allCases.map { category in
                    .default(Text(category.displayName)) {
                        selectedCategory = category
                    }
                } + [.cancel()]
            )
        }
    }
    
    private func saveTask() {
        let trimmedText = taskText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let taskToEdit = taskToEdit {
            tasksViewModel.updateTask(taskToEdit, text: trimmedText, category: selectedCategory)
        } else {
            tasksViewModel.addTask(text: trimmedText, category: selectedCategory)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

