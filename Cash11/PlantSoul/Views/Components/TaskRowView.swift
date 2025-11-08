import SwiftUI

struct TaskRowView: View {
    let task: Task
    @ObservedObject var taskViewModel: TaskViewModel
    let onTap: () -> Void
    
    @State private var offset: CGSize = .zero
    @State private var showingArchiveConfirmation = false
    
    var body: some View {
        HStack(spacing: DesignConstants.mediumPadding) {
            Image(systemName: task.type.icon)
                .font(.title3)
                .foregroundColor(colorForTaskType(task.type))
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.plantName)
                    .font(FontManager.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(task.isCompleted ? ColorScheme.mediumGray : ColorScheme.primaryText)
                    .strikethrough(task.isCompleted)
                
                Text(task.type.rawValue)
                    .font(FontManager.caption)
                    .foregroundColor(ColorScheme.secondaryText)
                
                if !task.description.isEmpty {
                    Text(task.description)
                        .font(FontManager.caption)
                        .foregroundColor(ColorScheme.secondaryText)
                        .lineLimit(2)
                }
                
                if let time = task.time {
                    Text(time, style: .time)
                        .font(FontManager.caption)
                        .foregroundColor(ColorScheme.accent)
                }
            }
            
            Spacer()
            
            Button(action: {
                taskViewModel.toggleTaskFavorite(task)
            }) {
                Image(systemName: task.isFavorite ? "heart.fill" : "heart")
                    .font(.title3)
                    .foregroundColor(task.isFavorite ? ColorScheme.accent : ColorScheme.mediumGray)
            }
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    taskViewModel.toggleTaskCompletion(task)
                }
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(task.isCompleted ? ColorScheme.success : ColorScheme.mediumGray)
            }
        }
        .padding(DesignConstants.mediumPadding)
        .background(
            RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                .fill(task.isCompleted ? AnyShapeStyle(ColorScheme.lightGray.opacity(0.5)) : AnyShapeStyle(ColorScheme.cardGradient))
                .shadow(
                    color: ColorScheme.darkBlue.opacity(task.isCompleted ? 0.05 : DesignConstants.shadowOpacity),
                    radius: DesignConstants.shadowRadius / 2,
                    x: 0,
                    y: 2
                )
        )
        .opacity(task.isCompleted ? 0.7 : 1.0)
        .onTapGesture {
            onTap()
        }
        .alert("Archive Task", isPresented: $showingArchiveConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Archive", role: .destructive) {
                taskViewModel.archiveTask(task)
            }
        } message: {
            Text("This task will be moved to the archive.")
        }
    }
    
    private func colorForTaskType(_ type: TaskType) -> Color {
        switch type {
        case .watering:
            return ColorScheme.softGreen
        case .fertilizing:
            return ColorScheme.softGreen
        case .repotting:
            return ColorScheme.warmYellow
        case .cleaning:
            return ColorScheme.warmYellow
        case .generalCare:
            return ColorScheme.softGreen
        }
    }
}

#Preview {
    VStack {
        TaskRowView(
            task: Task(
                plantId: UUID(),
                plantName: "Monstera Deliciosa",
                type: .watering,
                date: Date(),
                description: "Water thoroughly until it drains"
            ),
            taskViewModel: TaskViewModel()
        ) {
        }
        
        TaskRowView(
            task: Task(
                plantId: UUID(),
                plantName: "Snake Plant",
                type: .fertilizing,
                date: Date(),
                description: "Monthly fertilizing"
            ),
            taskViewModel: TaskViewModel()
        ) {
        }
    }
    .padding()
    .background(ColorScheme.backgroundGradient)
}

