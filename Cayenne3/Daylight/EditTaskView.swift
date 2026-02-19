import SwiftUI

struct EditTaskView: View {
    let taskId: UUID
    @ObservedObject var viewModel: TaskViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    @State private var selectedCategory: TaskCategory = .home
    @State private var selectedDate: TaskDate = .today
    @State private var comment: String = ""
    
    private var task: Task? {
        viewModel.getTask(byId: taskId)
    }
    
    var body: some View {
        Group {
            if let task = task {
                editTaskContent(task: task)
            } else {
                EmptyView()
            }
        }
        .onChange(of: task) { newTask in
            if let task = newTask {
                title = task.title
                selectedCategory = task.category
                selectedDate = task.date
                comment = task.comment
            }
        }
        .onAppear {
            if let task = task {
                title = task.title
                selectedCategory = task.category
                selectedDate = task.date
                comment = task.comment
            }
        }
    }
    
    private func editTaskContent(task: Task) -> some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Task Title")
                                .font(AppTypography.headline)
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter task title", text: $title)
                                .font(AppTypography.body)
                                .foregroundColor(AppColors.primaryText)
                                .padding(AppSpacing.md)
                                .background(AppColors.cardBackground)
                                .cornerRadius(AppRadius.medium)
                        }
                        
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Category")
                                .font(AppTypography.headline)
                                .foregroundColor(AppColors.primaryText)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: AppSpacing.sm) {
                                ForEach(TaskCategory.allCases, id: \.self) { category in
                                    Button(action: {
                                        selectedCategory = category
                                    }) {
                                        HStack {
                                            Image(systemName: category.icon)
                                                .foregroundColor(category.color)
                                            Text(category.rawValue)
                                                .font(AppTypography.body)
                                                .foregroundColor(AppColors.primaryText)
                                            Spacer()
                                        }
                                        .padding(AppSpacing.md)
                                        .background(
                                            selectedCategory == category ?
                                            category.color.opacity(0.2) :
                                            AppColors.cardBackground
                                        )
                                        .cornerRadius(AppRadius.medium)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: AppRadius.medium)
                                                .stroke(
                                                    selectedCategory == category ? category.color : Color.clear,
                                                    lineWidth: 2
                                                )
                                        )
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Date")
                                .font(AppTypography.headline)
                                .foregroundColor(AppColors.primaryText)
                            
                            HStack(spacing: AppSpacing.sm) {
                                ForEach(TaskDate.allCases, id: \.self) { date in
                                    Button(action: {
                                        selectedDate = date
                                    }) {
                                        Text(date.rawValue)
                                            .font(AppTypography.body)
                                            .foregroundColor(selectedDate == date ? AppColors.primaryText : AppColors.secondaryText)
                                            .padding(.horizontal, AppSpacing.md)
                                            .padding(.vertical, AppSpacing.sm)
                                            .background(
                                                selectedDate == date ?
                                                AppColors.lightBlue.opacity(0.3) :
                                                AppColors.cardBackground
                                            )
                                            .cornerRadius(AppRadius.small)
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Comment (Optional)")
                                .font(AppTypography.headline)
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Add a comment", text: $comment, axis: .vertical)
                                .font(AppTypography.body)
                                .foregroundColor(AppColors.primaryText)
                                .padding(AppSpacing.md)
                                .background(AppColors.cardBackground)
                                .cornerRadius(AppRadius.medium)
                                .lineLimit(3...6)
                        }
                        
                        Button {
                            saveChanges()
                        } label: {
                            Text("Save Changes")
                                .primaryButtonStyle(isEnabled: !title.isEmpty)
                        }
                        .disabled(title.isEmpty)
                        .padding(.top, AppSpacing.lg)
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.md)
                }
            }
            .navigationTitle("Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(AppColors.accentText)
            )
        }
    }
    
    private func saveChanges() {
        guard var updatedTask = task else { return }
        updatedTask.title = title
        updatedTask.category = selectedCategory
        updatedTask.date = selectedDate
        updatedTask.comment = comment
        
        viewModel.updateTask(updatedTask)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    let sampleTask = Task(title: "Sample Task", category: .home, date: .today, comment: "Sample comment")
    return EditTaskView(
        taskId: sampleTask.id,
        viewModel: TaskViewModel()
    )
}
