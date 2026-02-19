import SwiftUI

struct AddTaskView: View {
    @ObservedObject var viewModel: TaskViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var selectedCategory: TaskCategory = .home
    @State private var selectedDate: TaskDate = .today
    @State private var comment = ""
    
    var body: some View {
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
                            saveTask()
                        } label: {
                            Text("Save Task")
                                .primaryButtonStyle(isEnabled: !title.isEmpty)
                        }
                        .disabled(title.isEmpty)
                        .padding(.top, AppSpacing.lg)
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.md)
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(AppColors.accentText)
            )
        }
    }
    
    private func saveTask() {
        let newTask = Task(
            title: title,
            category: selectedCategory,
            date: selectedDate,
            comment: comment
        )
        
        viewModel.addTask(newTask)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddTaskView(viewModel: TaskViewModel())
}
