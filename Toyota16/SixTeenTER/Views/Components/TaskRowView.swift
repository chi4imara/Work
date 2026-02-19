import SwiftUI

struct TaskRowView: View {
    let task: TaskModel
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(task.isCompleted ? AppColors.success : AppColors.secondaryText)
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.ubuntu(.medium, size: AppConstants.mediumFontSize))
                    .foregroundColor(task.isCompleted ? AppColors.secondaryText : AppColors.primaryText)
                    .strikethrough(task.isCompleted)
                
                HStack {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(getPriorityColor(task.priority))
                            .frame(width: 8, height: 8)
                        
                        Text(task.priority.displayName)
                            .font(.ubuntu(.regular, size: AppConstants.smallFontSize))
                            .foregroundColor(AppColors.tertiaryText)
                    }
                    
                    if !task.note.isEmpty {
                        Spacer()
                        
                        Image(systemName: "note.text")
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.tertiaryText)
                    }
                }
            }
            
            Spacer()
            
            Text(task.type.displayName)
                .font(.ubuntu(.medium, size: 10))
                .foregroundColor(AppColors.primaryOrange)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(AppColors.primaryOrange.opacity(0.1))
                .cornerRadius(AppConstants.smallCornerRadius)
        }
        .padding(.vertical, 8)
        .animation(.easeInOut(duration: AppConstants.shortAnimation), value: task.isCompleted)
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

#Preview {
    VStack {
        TaskRowView(
            task: TaskModel(
                title: "Complete project proposal",
                type: .task,
                priority: .high,
                note: "Include budget analysis"
            )
        ) {
        }
        
        TaskRowView(
            task: TaskModel(
                title: "10 minutes meditation",
                type: .challenge,
                priority: .medium
            )
        ) {
        }
    }
    .padding()
    .background(AppColors.backgroundGradient)
}
