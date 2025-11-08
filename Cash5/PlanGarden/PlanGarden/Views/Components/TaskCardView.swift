import SwiftUI

struct TaskCardView: View {
    let task: GardenTask
    let isSelected: Bool
    let isMultiSelectMode: Bool
    let onTap: () -> Void
    let onLongPress: () -> Void
    let onToggleComplete: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGSize = .zero
    @State private var showingDeleteConfirmation = false
    
    private var isCompleted: Bool {
        task.isCompletedFor(date: Date())
    }
    
    var body: some View {
        ZStack {
            cardContent
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .alert("Delete Task", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("This task will be moved to archive. This action cannot be undone.")
        }
    }
    
    private var cardContent: some View {
        HStack(spacing: 16) {
            if isMultiSelectMode {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isSelected ? .appPrimary : .appMediumGray)
            } else {
                Image(systemName: task.workType.icon)
                    .font(.title2)
                    .foregroundColor(.appAccent)
                    .frame(width: 24, height: 24)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.culture.name)
                    .font(.appHeadline)
                    .foregroundColor(isCompleted ? .appMediumGray : .appPrimary)
                    .strikethrough(isCompleted)
                
                Text(task.workType.rawValue)
                    .font(.appSubheadline)
                    .foregroundColor(isCompleted ? .appMediumGray : .appDarkGray)
                    .strikethrough(isCompleted)
                
                if !task.note.isEmpty {
                    Text(task.note)
                        .font(.appCaption1)
                        .foregroundColor(.appMediumGray)
                        .lineLimit(2)
                        .strikethrough(isCompleted)
                }
                
                HStack(spacing: 8) {
                    Text(task.frequency.displayName)
                        .font(.appCaption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(AppColors.lightGray)
                        .cornerRadius(8)
                        .foregroundColor(.appDarkGray)
                    
                    if let time = task.time {
                        Text(DateFormatter.displayTimeFormatter.string(from: time))
                            .font(.appCaption1)
                            .foregroundColor(.appMediumGray)
                    }

                    if task.frequency == .weekly, let weekDay = task.weekDay {
                        let dayName = Calendar.current.weekdaySymbols[weekDay - 1]
                        Text(dayName)
                            .font(.appCaption1)
                            .foregroundColor(.appMediumGray)
                    }
                }
            }
            
            Spacer()
            
            if !isMultiSelectMode {
                Button(action: onToggleComplete) {
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundColor(isCompleted ? .appSuccess : .appMediumGray)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .opacity(isCompleted ? 0.7 : 1.0)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
        .onLongPressGesture {
            onLongPress()
        }
    }
}

struct TaskCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            TaskCardView(
                task: GardenTask(
                    culture: Culture(name: "Tomatoes"),
                    workType: .watering,
                    date: Date(),
                    time: Date(),
                    frequency: .daily,
                    note: "1 liter per plant"
                ),
                isSelected: false,
                isMultiSelectMode: false,
                onTap: {},
                onLongPress: {},
                onToggleComplete: {},
                onEdit: {},
                onDelete: {}
            )
            
            TaskCardView(
                task: GardenTask(
                    culture: Culture(name: "Roses"),
                    workType: .fertilizing,
                    date: Date(),
                    frequency: .weekly,
                    weekDay: 1,
                    note: "Use rose fertilizer"
                ),
                isSelected: true,
                isMultiSelectMode: true,
                onTap: {},
                onLongPress: {},
                onToggleComplete: {},
                onEdit: {},
                onDelete: {}
            )
        }
        .padding()
        .background(AppColors.backgroundGradient)
    }
}
