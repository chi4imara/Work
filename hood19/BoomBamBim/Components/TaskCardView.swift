import SwiftUI

struct TaskCardView: View {
    let task: Task
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var offset = CGSize.zero
    @State private var showingDeleteAlert = false
    
    private var deadlineText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: task.deadline)
    }
    
    private var statusBadgeColor: Color {
        Color.statusColor(for: task.actualStatus)
    }
    
    var body: some View {
        ZStack {
            HStack {
                if offset.width > 0 {
                    Button(action: onEdit) {
                        VStack {
                            Image(systemName: "pencil")
                                .font(.system(size: 20, weight: .medium))
                            Text("Edit")
                                .font(AppFonts.caption1)
                        }
                        .foregroundColor(.white)
                        .frame(width: 80)
                        .frame(maxHeight: .infinity)
                        .background(AppColors.primaryBlue)
                        .cornerRadius(12)
                    }
                }
                
                Spacer()
                
                if offset.width < 0 {
                    Button(action: {
                        showingDeleteAlert = true
                    }) {
                        VStack {
                            Image(systemName: "trash")
                                .font(.system(size: 20, weight: .medium))
                            Text("Delete")
                                .font(AppFonts.caption1)
                        }
                        .foregroundColor(.white)
                        .frame(width: 80)
                        .frame(maxHeight: .infinity)
                        .background(AppColors.overdueRed)
                        .cornerRadius(12)
                    }
                }
            }
            
            HStack(spacing: 16) {
                Circle()
                    .fill(statusBadgeColor)
                    .frame(width: 12, height: 12)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(task.title)
                        .font(AppFonts.cardTitle)
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(2)
                    
                    HStack {
                        Text(deadlineText)
                            .font(AppFonts.cardSubtitle)
                            .foregroundColor(AppColors.secondaryText)
                        
                        Spacer()
                        
                        StatusBadge(status: task.actualStatus)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.lightText)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardGradient)
                    .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
            )
            .offset(x: offset.width, y: 0)
            .highPriorityGesture(
                DragGesture(minimumDistance: 20)
                    .onChanged { value in
                        offset = value.translation
                    }
                    .onEnded { value in
                        withAnimation(.spring()) {
                            if abs(value.translation.width) > 100 {
                                if value.translation.width > 0 {
                                    onEdit()
                                } else {
                                    showingDeleteAlert = true
                                }
                            }
                            offset = .zero
                        }
                    }
            )
            .onTapGesture {
                HapticFeedback.light()
                onTap()
            }
        }
        .alert("Delete Task", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete '\(task.title)'? This action cannot be undone.")
        }
    }
}

struct StatusBadge: View {
    let status: TaskStatus
    
    var body: some View {
        Text(status.displayName)
            .font(AppFonts.caption1)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(Color.statusColor(for: status))
            )
    }
}

#Preview {
    VStack(spacing: 16) {
        TaskCardView(
            task: Task.sampleTasks[0],
            onTap: { },
            onEdit: { },
            onDelete: { }
        )
        
        TaskCardView(
            task: Task.sampleTasks[1],
            onTap: { },
            onEdit: { },
            onDelete: { }
        )
    }
    .padding()
    .background(AppColors.backgroundGradient)
}
