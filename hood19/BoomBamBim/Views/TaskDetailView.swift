import SwiftUI

struct TaskDetailView: View {
    let task: Task
    @ObservedObject var viewModel: TaskViewModel
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteAlert = false
    
    private var deadlineText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter.string(from: task.deadline)
    }
    
    private var createdText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: task.createdAt)
    }
    
    private var daysUntilDeadline: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let deadline = calendar.startOfDay(for: task.deadline)
        return calendar.dateComponents([.day], from: today, to: deadline).day ?? 0
    }
    
    private var deadlineStatus: String {
        let days = daysUntilDeadline
        
        if task.actualStatus == .completed {
            return "Completed"
        } else if days < 0 {
            return "Overdue by \(abs(days)) day\(abs(days) == 1 ? "" : "s")"
        } else if days == 0 {
            return "Due today"
        } else {
            return "\(days) day\(days == 1 ? "" : "s") remaining"
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                StaticBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        TaskDetailHeader(
                            task: task,
                            deadlineText: deadlineText,
                            deadlineStatus: deadlineStatus
                        )
                        
                        if !task.description.isEmpty {
                            TaskDetailSection(title: "Description") {
                                Text(task.description)
                                    .font(AppFonts.body)
                                    .foregroundColor(AppColors.primaryText)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        
                        TaskDetailSection(title: "Details") {
                            VStack(spacing: 16) {
                                DetailRow(
                                    icon: "calendar",
                                    title: "Deadline",
                                    value: deadlineText,
                                    color: task.actualStatus == .overdue ? AppColors.overdueRed : AppColors.primaryBlue
                                )
                                
                                DetailRow(
                                    icon: "clock",
                                    title: "Status",
                                    value: deadlineStatus,
                                    color: Color.statusColor(for: task.actualStatus)
                                )
                                
                                DetailRow(
                                    icon: "plus.circle",
                                    title: "Created",
                                    value: createdText,
                                    color: AppColors.secondaryText
                                )
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
                
                VStack {
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Button(action: {
                            showingDeleteAlert = true
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                    .font(.system(size: 14, weight: .medium))
                                Text("Delete")
                                    .font(AppFonts.buttonText)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppColors.overdueRed)
                            .cornerRadius(12)
                        }
                        
                        Button(action: onEdit) {
                            HStack {
                                Image(systemName: "pencil")
                                    .font(.system(size: 14, weight: .medium))
                                Text("Edit")
                                    .font(AppFonts.buttonText)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [AppColors.primaryBlue, AppColors.darkBlue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Task Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.primaryBlue)
                }
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

struct TaskDetailHeader: View {
    let task: Task
    let deadlineText: String
    let deadlineStatus: String
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Circle()
                    .fill(Color.statusColor(for: task.actualStatus))
                    .frame(width: 16, height: 16)
                
                Text(task.actualStatus.displayName)
                    .font(AppFonts.headline)
                    .foregroundColor(Color.statusColor(for: task.actualStatus))
                
                Spacer()
            }
            
            Text(task.title)
                .font(AppFonts.title1)
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "calendar")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.primaryBlue)
                    
                    Text("Deadline")
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.secondaryText)
                    
                    Spacer()
                }
                
                Text(deadlineText)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryText)
                
                Text(deadlineStatus)
                    .font(AppFonts.callout)
                    .foregroundColor(
                        task.actualStatus == .overdue ? AppColors.overdueRed :
                        task.actualStatus == .completed ? AppColors.completedGreen :
                        AppColors.inProgressYellow
                    )
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(
                                (task.actualStatus == .overdue ? AppColors.overdueRed :
                                 task.actualStatus == .completed ? AppColors.completedGreen :
                                 AppColors.inProgressYellow).opacity(0.1)
                            )
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

struct TaskDetailSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)
            
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.lightBlue.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.secondaryText)
                
                Text(value)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryText)
            }
            
            Spacer()
        }
    }
}

#Preview {
    TaskDetailView(
        task: Task.sampleTasks[0],
        viewModel: TaskViewModel(),
        onEdit: { },
        onDelete: { }
    )
}
