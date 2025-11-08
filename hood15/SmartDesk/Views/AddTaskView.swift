import SwiftUI

struct AddTaskView: View {
    @ObservedObject var subjectStore: SubjectStore
    @Environment(\.dismiss) private var dismiss
    
    let subject: Subject
    
    private var currentSubject: Subject? {
        subjectStore.subjects.first { $0.id == subject.id }
    }
    
    @State private var taskTitle = ""
    @State private var selectedTaskType: TaskType = .homework
    @State private var dueDate = Date()
    @State private var taskDescription = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    
    private var isFormValid: Bool {
        !taskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Task Title")
                                .font(.appSubheadline)
                                .foregroundColor(.appText)
                            
                            TextField("e.g., Chapter 15, exercises 1-5", text: $taskTitle)
                                .font(.appBody)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(AppColors.lightBlue, lineWidth: 1)
                                        )
                                )
                                .foregroundColor(.appText)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Task Type")
                                .font(.appSubheadline)
                                .foregroundColor(.appText)
                            
                            HStack(spacing: 12) {
                                ForEach(TaskType.allCases, id: \.self) { type in
                                    TaskTypeButton(
                                        type: type,
                                        isSelected: selectedTaskType == type,
                                        action: {
                                            selectedTaskType = type
                                        }
                                    )
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Due Date")
                                .font(.appSubheadline)
                                .foregroundColor(.appText)
                            
                            DatePicker(
                                "Select date",
                                selection: $dueDate,
                                displayedComponents: .date
                            )
                            .datePickerStyle(CompactDatePickerStyle())
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.lightBlue, lineWidth: 1)
                                    )
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description (Optional)")
                                .font(.appSubheadline)
                                .foregroundColor(.appText)
                            
                            TextField("Additional comments...", text: $taskDescription, axis: .vertical)
                                .font(.appBody)
                                .padding(16)
                                .frame(minHeight: 80, alignment: .topLeading)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(AppColors.lightBlue, lineWidth: 1)
                                        )
                                )
                                .foregroundColor(.appText)
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
                
                VStack {
                    Spacer()
                    
                    Button(action: saveTask) {
                        Text("Save Task")
                            .font(.appSubheadline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(isFormValid ? AppColors.primaryBlue : AppColors.textSecondary)
                            )
                    }
                    .disabled(!isFormValid)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.appText)
                }
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func saveTask() {
        let trimmedTitle = taskTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty else {
            errorMessage = "Please enter a task title"
            showingError = true
            return
        }
        
        guard let currentSubject = currentSubject else {
            errorMessage = "Subject no longer exists"
            showingError = true
            return
        }
        
        let newTask = Task(
            title: trimmedTitle,
            type: selectedTaskType,
            dueDate: dueDate,
            description: taskDescription.isEmpty ? nil : taskDescription,
            subjectId: currentSubject.id
        )
        
        subjectStore.addTask(newTask)
        dismiss()
    }
}

struct TaskTypeButton: View {
    let type: TaskType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(type.rawValue)
                .font(.appBody)
                .foregroundColor(isSelected ? .white : .appText)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? AppColors.primaryBlue : AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(AppColors.lightBlue, lineWidth: isSelected ? 0 : 1)
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let store = SubjectStore()
    let subject = Subject(name: "Mathematics")
    return AddTaskView(subjectStore: store, subject: subject)
}
