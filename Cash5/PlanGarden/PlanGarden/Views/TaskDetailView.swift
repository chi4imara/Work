import SwiftUI

struct TaskDetailView: View {
    @EnvironmentObject var taskManager: TaskManager
    @Environment(\.dismiss) private var dismiss
    
    let task: GardenTask
    @State private var showingEditForm = false
    @State private var showingDeleteConfirmation = false
    @State private var taskNotFound = false
    
    private var currentTask: GardenTask? {
        taskManager.tasks.first { $0.id == task.id }
    }
    
    private var isCompletedToday: Bool {
        currentTask?.isCompletedFor(date: Date()) ?? false
    }
    
    private var isRelevantToday: Bool {
        currentTask?.isRelevantFor(date: Date()) ?? false
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.universalGradient
                .ignoresSafeArea()
                
                if taskNotFound {
                    taskNotFoundView
                } else if let currentTask = currentTask {
                    taskDetailContent(currentTask)
                } else {
                    taskNotFoundView
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingEditForm) {
                if let currentTask = currentTask {
                    TaskFormView(task: currentTask)
                }
            }
            .alert("Delete Task", isPresented: $showingDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    if let currentTask = currentTask {
                        taskManager.deleteTask(currentTask)
                        dismiss()
                    }
                }
            } message: {
                Text("This task will be moved to archive. This action cannot be undone.")
            }
            .onAppear {
                checkTaskAvailability()
            }
        }
    }
    
    private func taskDetailContent(_ task: GardenTask) -> some View {
        VStack {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.appPrimary)
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 8)
            
            ScrollView {
                VStack(spacing: 24) {
                    headerView(task)
                    
                    VStack(spacing: 16) {
                        workTypeCard(task)
                        dateTimeCard(task)
                        frequencyCard(task)
                        
                        if !task.note.isEmpty {
                            noteCard(task)
                        }
                        
                        if isRelevantToday {
                            statusCard(task)
                        }
                    }
                    
                    actionButtons(task)
                }
                .padding(20)
                .padding(.bottom, 100)
            }
        }
    }
    
    private func headerView(_ task: GardenTask) -> some View {
        VStack(spacing: 16) {
            
            VStack(spacing: 12) {
                Image(systemName: task.workType.icon)
                    .font(.system(size: 50))
                    .foregroundColor(.appAccent)
                    .frame(width: 80, height: 80)
                    .background(
                        Circle()
                            .fill(AppColors.accent.opacity(0.1))
                    )
                
                Text(task.culture.name)
                    .font(.appLargeTitle)
                    .foregroundColor(.appPrimary)
                    .multilineTextAlignment(.center)
                
                Text(task.workType.rawValue)
                    .font(.appTitle3)
                    .foregroundColor(.appDarkGray)
            }
        }
    }
    
    private func workTypeCard(_ task: GardenTask) -> some View {
        InfoCard(
            title: "Work Type",
            content: {
                HStack(spacing: 12) {
                    Image(systemName: task.workType.icon)
                        .font(.title2)
                        .foregroundColor(.appAccent)
                    
                    Text(task.workType.rawValue)
                        .font(.appBody)
                        .foregroundColor(.appDarkGray)
                    
                    Spacer()
                }
            }
        )
    }
    
    private func dateTimeCard(_ task: GardenTask) -> some View {
        InfoCard(
            title: "Date & Time",
            content: {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 12) {
                        Image(systemName: "calendar")
                            .font(.title2)
                            .foregroundColor(.appAccent)
                        
                        Text(DateFormatter.displayDateFormatter.string(from: task.date))
                            .font(.appBody)
                            .foregroundColor(.appDarkGray)
                        
                        Spacer()
                    }
                    
                    if let time = task.time {
                        HStack(spacing: 12) {
                            Image(systemName: "clock")
                                .font(.title2)
                                .foregroundColor(.appAccent)
                            
                            Text(DateFormatter.displayTimeFormatter.string(from: time))
                                .font(.appBody)
                                .foregroundColor(.appDarkGray)
                            
                            Spacer()
                        }
                    }
                }
            }
        )
    }
    
    private func frequencyCard(_ task: GardenTask) -> some View {
        InfoCard(
            title: "Frequency",
            content: {
                HStack(spacing: 12) {
                    Image(systemName: frequencyIcon(task.frequency))
                        .font(.title2)
                        .foregroundColor(.appAccent)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(task.frequency.displayName)
                            .font(.appBody)
                            .foregroundColor(.appDarkGray)
                        
                        if task.frequency == .weekly, let weekDay = task.weekDay {
                            let dayName = Calendar.current.weekdaySymbols[weekDay - 1]
                            Text("Every \(dayName)")
                                .font(.appCaption1)
                                .foregroundColor(.appMediumGray)
                        }
                    }
                    
                    Spacer()
                }
            }
        )
    }
    
    private func noteCard(_ task: GardenTask) -> some View {
        InfoCard(
            title: "Note",
            content: {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "note.text")
                        .font(.title2)
                        .foregroundColor(.appAccent)
                    
                    Text(task.note)
                        .font(.appBody)
                        .foregroundColor(.appDarkGray)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
            }
        )
    }
    
    private func statusCard(_ task: GardenTask) -> some View {
        InfoCard(
            title: "Status Today",
            content: {
                HStack(spacing: 12) {
                    Image(systemName: isCompletedToday ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundColor(isCompletedToday ? .appSuccess : .appMediumGray)
                    
                    Text(isCompletedToday ? "Completed" : "Not completed")
                        .font(.appBody)
                        .foregroundColor(.appDarkGray)
                    
                    Spacer()
                }
            }
        )
    }
    
    private func actionButtons(_ task: GardenTask) -> some View {
        VStack(spacing: 16) {
            if isRelevantToday {
                Button(action: {
                    toggleCompletion(task)
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: isCompletedToday ? "xmark.circle" : "checkmark.circle")
                            .font(.title3)
                        
                        Text(isCompletedToday ? "Mark as Not Completed" : "Mark as Completed")
                            .font(.appHeadline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(isCompletedToday ? AppColors.warning : AppColors.success)
                    .cornerRadius(25)
                }
            }
            
            Button(action: {
                showingEditForm = true
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "pencil")
                        .font(.title3)
                    
                    Text("Edit Task")
                        .font(.appHeadline)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(AppColors.primary)
                .cornerRadius(25)
            }
            
            Button(action: {
                showingDeleteConfirmation = true
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "trash")
                        .font(.title3)
                    
                    Text("Delete Task")
                        .font(.appHeadline)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(AppColors.error)
                .cornerRadius(25)
            }
        }
    }
    
    private var taskNotFoundView: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.appWarning)
            
            VStack(spacing: 8) {
                Text("Task Not Available")
                    .font(.appTitle2)
                    .foregroundColor(.appPrimary)
                
                Text("This task has been moved to archive or is no longer available.")
                    .font(.appBody)
                    .foregroundColor(.appMediumGray)
                    .multilineTextAlignment(.center)
            }
            
            Button("Back to List") {
                dismiss()
            }
            .font(.appHeadline)
            .foregroundColor(.white)
            .frame(width: 150, height: 44)
            .background(AppColors.primary)
            .cornerRadius(22)
        }
        .padding(.horizontal, 40)
    }
    
    private func frequencyIcon(_ frequency: Frequency) -> String {
        switch frequency {
        case .once: return "1.circle"
        case .daily: return "arrow.clockwise"
        case .weekly: return "calendar.badge.clock"
        }
    }
    
    private func toggleCompletion(_ task: GardenTask) {
        if isCompletedToday {
            taskManager.markTaskNotCompleted(task)
        } else {
            taskManager.markTaskCompleted(task)
        }
    }
    
    private func checkTaskAvailability() {
        if currentTask == nil {
            taskNotFound = true
        }
    }
}

struct InfoCard<Content: View>: View {
    let title: String
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.appCallout)
                .foregroundColor(.appMediumGray)
                .textCase(.uppercase)
            
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(
            task: GardenTask(
                culture: Culture(name: "Tomatoes"),
                workType: .watering,
                date: Date(),
                time: Date(),
                frequency: .daily,
                note: "1 liter per plant, check soil moisture first"
            )
        )
        .environmentObject(TaskManager())
    }
}
