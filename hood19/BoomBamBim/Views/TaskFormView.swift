import SwiftUI

struct TaskFormView: View {
    @ObservedObject var viewModel: TaskViewModel
    @Binding var editingTask: Task?
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var deadline = Date()
    @State private var status = TaskStatus.inProgress
    @State private var showingDatePicker = false
    
    @State private var titleError = ""
    @State private var dateError = ""
    
    private var isEditing: Bool {
        editingTask != nil
    }
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                StaticBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text(isEditing ? "Edit Task" : "New Task")
                                .font(AppFonts.title2)
                                .foregroundColor(AppColors.primaryText)
                            
                            Text(isEditing ? "Update your project details" : "Create a new home project")
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.secondaryText)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 20) {
                            FormField(
                                title: "Project Title",
                                text: $title,
                                placeholder: "e.g., Paint the living room",
                                errorMessage: titleError,
                                characterLimit: 50
                            )
                            
                            FormTextArea(
                                title: "Description (Optional)",
                                text: $description,
                                placeholder: "Add details about your project...",
                                characterLimit: 200
                            )
                            
                            FormDateField(
                                title: "Deadline",
                                date: $deadline,
                                errorMessage: dateError,
                                showingDatePicker: $showingDatePicker
                            )
                            
                            FormStatusField(
                                title: "Status",
                                status: $status
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 100)
                    }
                }
                
                VStack {
                    Spacer()
                    
                    Button(action: saveTask) {
                        Text(isEditing ? "Update Task" : "Create Task")
                            .font(AppFonts.buttonText)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: isFormValid ? 
                                        [AppColors.primaryBlue, AppColors.darkBlue] :
                                        [AppColors.lightText, AppColors.secondaryText],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                    }
                    .disabled(!isFormValid)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.primaryBlue)
                }
            }
        }
        .onAppear {
            loadTaskData()
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerView(selectedDate: $deadline)
        }
    }
    
    private func loadTaskData() {
        if let task = editingTask {
            title = task.title
            description = task.description
            deadline = task.deadline
            status = task.status
        } else {
            deadline = Date()
        }
    }
    
    private func saveTask() {
        titleError = ""
        dateError = ""
        
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedTitle.isEmpty {
            titleError = "Please enter a project title"
            return
        }
        
        if let existingTask = editingTask {
            var updatedTask = existingTask
            updatedTask.title = trimmedTitle
            updatedTask.description = description.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedTask.deadline = deadline
            updatedTask.status = status
            
            viewModel.updateTask(updatedTask)
        } else {
            let newTask = Task(
                title: trimmedTitle,
                description: description.trimmingCharacters(in: .whitespacesAndNewlines),
                deadline: deadline,
                status: status
            )
            
            viewModel.addTask(newTask)
        }
        
        dismiss()
    }
}

struct FormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    let errorMessage: String
    let characterLimit: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)
            
            TextField(placeholder, text: $text)
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryText)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    errorMessage.isEmpty ? AppColors.lightBlue : AppColors.overdueRed,
                                    lineWidth: 1
                                )
                        )
                )
                .onChange(of: text) { newValue in
                    if newValue.count > characterLimit {
                        text = String(newValue.prefix(characterLimit))
                    }
                }
            
            HStack {
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.overdueRed)
                }
                
                Spacer()
                
                Text("\(text.count)/\(characterLimit)")
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.secondaryText)
            }
        }
    }
}

struct FormTextArea: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    let characterLimit: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.lightBlue, lineWidth: 1)
                    )
                    .frame(minHeight: 100)
                
                if text.isEmpty {
                    Text(placeholder)
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.lightText)
                        .padding(16)
                        .allowsHitTesting(false)
                }
        
                TextEditor(text: $text)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryText)
                    .padding(12)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .onChange(of: text) { newValue in
                        if newValue.count > characterLimit {
                            text = String(newValue.prefix(characterLimit))
                        }
                    }
            }
            .frame(minHeight: 100)
            
            HStack {
                Spacer()
                
                Text("\(text.count)/\(characterLimit)")
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.secondaryText)
            }
        }
    }
}

struct FormDateField: View {
    let title: String
    @Binding var date: Date
    let errorMessage: String
    @Binding var showingDatePicker: Bool
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)
            
            Button(action: {
                showingDatePicker = true
            }) {
                HStack {
                    Text(dateString)
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Image(systemName: "calendar")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.primaryBlue)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    errorMessage.isEmpty ? AppColors.lightBlue : AppColors.overdueRed,
                                    lineWidth: 1
                                )
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.overdueRed)
            }
        }
    }
}

struct FormStatusField: View {
    let title: String
    @Binding var status: TaskStatus
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)
            
            HStack(spacing: 12) {
                ForEach([TaskStatus.inProgress, TaskStatus.completed], id: \.self) { taskStatus in
                    Button(action: {
                        status = taskStatus
                    }) {
                        HStack {
                            Circle()
                                .fill(status == taskStatus ? Color.statusColor(for: taskStatus) : Color.clear)
                                .overlay(
                                    Circle()
                                        .stroke(Color.statusColor(for: taskStatus), lineWidth: 2)
                                )
                                .frame(width: 16, height: 16)
                            
                            Text(taskStatus.displayName)
                                .font(AppFonts.callout)
                                .foregroundColor(AppColors.primaryText)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(status == taskStatus ? Color.statusColor(for: taskStatus).opacity(0.1) : Color.clear)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Spacer()
            }
        }
    }
}

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                
                Spacer()
            }
            .navigationTitle("Select Deadline")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.primaryBlue)
                }
            }
        }
    }
}


