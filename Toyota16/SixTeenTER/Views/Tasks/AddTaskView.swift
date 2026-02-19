import SwiftUI

struct AddTaskView: View {
    @Binding var isPresented: Bool
    let taskType: TaskType
    var taskToEdit: TaskModel? = nil
    var onSave: (TaskModel) -> Void
    var onUpdate: ((TaskModel) -> Void)? = nil
    
    @State private var title: String = ""
    @State private var selectedType: TaskType = .task
    @State private var selectedPriority: TaskPriority = .medium
    @State private var selectedFrequency: TaskFrequency = .once
    @State private var note: String = ""
    @State private var whyImportant: String = ""
    
    private var isEditing: Bool { taskToEdit != nil }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppConstants.largeSpacing) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title")
                                .font(.ubuntu(.semiBold, size: AppConstants.mediumFontSize))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter task title", text: $title)
                                .font(.ubuntu(.regular, size: AppConstants.mediumFontSize))
                                .foregroundColor(AppColors.primaryText)
                                .padding(12)
                                .background(AppColors.cardBackground)
                                .cornerRadius(AppConstants.smallCornerRadius)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppConstants.smallCornerRadius)
                                        .stroke(AppColors.separatorColor, lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Type")
                                .font(.ubuntu(.semiBold, size: AppConstants.mediumFontSize))
                                .foregroundColor(AppColors.primaryText)
                            
                            HStack(spacing: 12) {
                                ForEach(TaskType.allCases, id: \.self) { type in
                                    TypeSelectionButton(
                                        type: type,
                                        isSelected: selectedType == type
                                    ) {
                                        selectedType = type
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Priority")
                                .font(.ubuntu(.semiBold, size: AppConstants.mediumFontSize))
                                .foregroundColor(AppColors.primaryText)
                            
                            HStack(spacing: 12) {
                                ForEach(TaskPriority.allCases, id: \.self) { priority in
                                    PrioritySelectionButton(
                                        priority: priority,
                                        isSelected: selectedPriority == priority
                                    ) {
                                        selectedPriority = priority
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Frequency")
                                .font(.ubuntu(.semiBold, size: AppConstants.mediumFontSize))
                                .foregroundColor(AppColors.primaryText)
                            
                            VStack(spacing: 8) {
                                ForEach(TaskFrequency.allCases, id: \.self) { frequency in
                                    FrequencySelectionButton(
                                        frequency: frequency,
                                        isSelected: selectedFrequency == frequency
                                    ) {
                                        selectedFrequency = frequency
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Note (Optional)")
                                .font(.ubuntu(.semiBold, size: AppConstants.mediumFontSize))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Add any additional notes", text: $note, axis: .vertical)
                                .font(.ubuntu(.regular, size: AppConstants.mediumFontSize))
                                .foregroundColor(AppColors.primaryText)
                                .padding(12)
                                .background(AppColors.cardBackground)
                                .cornerRadius(AppConstants.smallCornerRadius)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppConstants.smallCornerRadius)
                                        .stroke(AppColors.separatorColor, lineWidth: 1)
                                )
                                .lineLimit(3...6)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Why is this important? (Optional)")
                                .font(.ubuntu(.semiBold, size: AppConstants.mediumFontSize))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Explain why this matters to you", text: $whyImportant, axis: .vertical)
                                .font(.ubuntu(.regular, size: AppConstants.mediumFontSize))
                                .foregroundColor(AppColors.primaryText)
                                .padding(12)
                                .background(AppColors.cardBackground)
                                .cornerRadius(AppConstants.smallCornerRadius)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppConstants.smallCornerRadius)
                                        .stroke(AppColors.separatorColor, lineWidth: 1)
                                )
                                .lineLimit(3...6)
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, AppConstants.mediumSpacing)
                    .padding(.top, AppConstants.mediumSpacing)
                }
            }
            .navigationTitle(isEditing ? "Edit" : (taskType == .task ? "Add Task" : "Add Challenge"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(AppColors.secondaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTask()
                    }
                    .foregroundColor(AppColors.primaryOrange)
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .preferredColorScheme(.dark)
        }
        .onAppear {
            if let existing = taskToEdit {
                title = existing.title
                selectedType = existing.type
                selectedPriority = existing.priority
                selectedFrequency = existing.frequency
                note = existing.note
                whyImportant = existing.whyImportant
            } else {
                selectedType = taskType
            }
        }
    }
    
    private func saveTask() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }
        
        if let existing = taskToEdit, let update = onUpdate {
            let updatedTask = TaskModel(
                id: existing.id,
                title: trimmedTitle,
                type: selectedType,
                priority: selectedPriority,
                frequency: selectedFrequency,
                note: note.trimmingCharacters(in: .whitespacesAndNewlines),
                whyImportant: whyImportant.trimmingCharacters(in: .whitespacesAndNewlines),
                isCompleted: existing.isCompleted,
                completedDates: existing.completedDates,
                createdDate: existing.createdDate,
                streakDays: existing.streakDays
            )
            update(updatedTask)
        } else {
            let newTask = TaskModel(
                title: trimmedTitle,
                type: selectedType,
                priority: selectedPriority,
                frequency: selectedFrequency,
                note: note.trimmingCharacters(in: .whitespacesAndNewlines),
                whyImportant: whyImportant.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            onSave(newTask)
        }
        isPresented = false
    }
}

struct TypeSelectionButton: View {
    let type: TaskType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(type.displayName)
                .font(.ubuntu(.medium, size: AppConstants.smallFontSize))
                .foregroundColor(isSelected ? AppColors.primaryText : AppColors.secondaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: AppConstants.smallCornerRadius)
                        .fill(isSelected ? AppColors.primaryOrange : AppColors.cardBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: AppConstants.smallCornerRadius)
                        .stroke(isSelected ? AppColors.primaryOrange : AppColors.separatorColor, lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: AppConstants.shortAnimation), value: isSelected)
    }
}

struct PrioritySelectionButton: View {
    let priority: TaskPriority
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Circle()
                    .fill(getPriorityColor(priority))
                    .frame(width: 8, height: 8)
                
                Text(priority.displayName)
                    .font(.ubuntu(.medium, size: AppConstants.smallFontSize))
                    .foregroundColor(isSelected ? AppColors.primaryText : AppColors.secondaryText)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: AppConstants.smallCornerRadius)
                    .fill(isSelected ? AppColors.primaryOrange.opacity(0.2) : AppColors.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppConstants.smallCornerRadius)
                    .stroke(isSelected ? AppColors.primaryOrange : AppColors.separatorColor, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: AppConstants.shortAnimation), value: isSelected)
    }
    
    private func getPriorityColor(_ priority: TaskPriority) -> Color {
        switch priority {
        case .low:
            return AppConstants.lowPriorityColor
        case .medium:
            return AppConstants.mediumPriorityColor
        case .high:
            return AppConstants.highPriorityColor
        }
    }
}

struct FrequencySelectionButton: View {
    let frequency: TaskFrequency
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.primaryOrange : AppColors.secondaryText)
                
                Text(frequency.displayName)
                    .font(.ubuntu(.medium, size: AppConstants.mediumFontSize))
                    .foregroundColor(isSelected ? AppColors.primaryText : AppColors.secondaryText)
                
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: AppConstants.smallCornerRadius)
                    .fill(isSelected ? AppColors.primaryOrange.opacity(0.1) : AppColors.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppConstants.smallCornerRadius)
                    .stroke(isSelected ? AppColors.primaryOrange : AppColors.separatorColor, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: AppConstants.shortAnimation), value: isSelected)
    }
}

#Preview {
    AddTaskView(
        isPresented: .constant(true),
        taskType: .task,
        onSave: { _ in }
    )
}
