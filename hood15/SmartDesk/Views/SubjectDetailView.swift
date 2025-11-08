import SwiftUI

struct SubjectDetailView: View {
    @ObservedObject var subjectStore: SubjectStore
    @Environment(\.dismiss) private var dismiss
    
    let subject: Subject
    @State private var showingAddTask = false
    
    private var currentSubject: Subject? {
        subjectStore.subjects.first { $0.id == subject.id }
    }
    
    private var homeworkTasks: [Task] {
        currentSubject?.tasks.filter { $0.type == .homework }.sorted { task1, task2 in
            if task1.isCompleted != task2.isCompleted {
                return !task1.isCompleted && task2.isCompleted
            }
            return task1.dueDate < task2.dueDate
        } ?? []
    }
    
    private var testTasks: [Task] {
        currentSubject?.tasks.filter { $0.type == .test }.sorted { task1, task2 in
            if task1.isCompleted != task2.isCompleted {
                return !task1.isCompleted && task2.isCompleted
            }
            return task1.dueDate < task2.dueDate
        } ?? []
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            if currentSubject == nil {
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 60))
                        .foregroundColor(.red)
                    
                    Text("Subject Not Found")
                        .font(.appHeadline)
                        .foregroundColor(.appText)
                    
                    Text("This subject may have been deleted.")
                        .font(.appBody)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                    
                    Button("Go Back") {
                        dismiss()
                    }
                    .font(.appSubheadline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppColors.primaryBlue)
                    )
                }
                .padding(.horizontal, 40)
            } else {
                VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.appText)
                    }
                    
                    Spacer()
                    
                    Text(currentSubject?.name ?? subject.name)
                        .font(.appTitle)
                        .foregroundColor(.appText)
                    
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.appText)
                    }
                    .opacity(0)
                    .disabled(true)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        TaskSection(
                            title: "Homework",
                            tasks: homeworkTasks,
                            emptyMessage: "No homework tasks",
                            subjectStore: subjectStore
                        )
                        
                        TaskSection(
                            title: "Tests",
                            tasks: testTasks,
                            emptyMessage: "No test tasks",
                            subjectStore: subjectStore
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    .padding(.bottom, 100)
                }
                
                Spacer()
            }
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        showingAddTask = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                            Text("Add Task")
                        }
                        .font(.appSubheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(AppColors.primaryBlue)
                                .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                        )
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 30)
            }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingAddTask) {
            AddTaskView(subjectStore: subjectStore, subject: subject)
        }
    }
}

struct TaskSection: View {
    let title: String
    let tasks: [Task]
    let emptyMessage: String
    @ObservedObject var subjectStore: SubjectStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.appHeadline)
                .foregroundColor(.appText)
            
            if tasks.isEmpty {
                Text(emptyMessage)
                    .font(.appBody)
                    .foregroundColor(AppColors.textSecondary)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 12) {
                    ForEach(tasks) { task in
                        TaskCard(task: task, subjectStore: subjectStore)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct TaskCard: View {
    let task: Task
    @ObservedObject var subjectStore: SubjectStore
    
    private var isOverdue: Bool {
        !task.isCompleted && task.dueDate < Date().startOfDay
    }
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(task.dueDate)
    }
    
    private var dateText: String {
        let formatter = DateFormatter()
        
        if isToday {
            return "Today"
        } else if Calendar.current.isDateInTomorrow(task.dueDate) {
            return "Tomorrow"
        } else {
            formatter.dateStyle = .medium
            return formatter.string(from: task.dueDate)
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                subjectStore.toggleTaskCompletion(task)
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(task.isCompleted ? AppColors.success : AppColors.textSecondary)
                    .animation(.easeInOut(duration: 0.2), value: task.isCompleted)
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(task.title)
                            .font(.appSubheadline)
                            .foregroundColor(task.isCompleted ? AppColors.textSecondary : .appText)
                            .strikethrough(task.isCompleted)
                        
                        Text(task.type.rawValue)
                            .font(.appCaption)
                            .foregroundColor(AppColors.textSecondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(task.type == .homework ? AppColors.lightBlue : AppColors.accent.opacity(0.2))
                            )
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(dateText)
                            .font(.appBody)
                            .foregroundColor(
                                task.isCompleted ? AppColors.textSecondary :
                                isOverdue ? .red :
                                (isToday ? AppColors.primaryBlue : AppColors.textSecondary)
                            )
                        
                        if isOverdue {
                            Text("Overdue")
                                .font(.appCaption)
                                .foregroundColor(.red)
                        } else if task.isCompleted {
                            Text("Completed")
                                .font(.appCaption)
                                .foregroundColor(AppColors.success)
                        }
                    }
                }
                
                if let description = task.description, !description.isEmpty {
                    Text(description)
                        .font(.appBody)
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(3)
                        .opacity(task.isCompleted ? 0.7 : 1.0)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(task.isCompleted ? AppColors.lightBlue.opacity(0.3) : AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            task.isCompleted ? AppColors.success.opacity(0.3) :
                            isOverdue ? Color.red.opacity(0.3) :
                            (isToday ? AppColors.primaryBlue.opacity(0.3) : Color.clear),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
        .opacity(task.isCompleted ? 0.8 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: task.isCompleted)
    }
}

#Preview {
    let store = SubjectStore()
    let subject = Subject(name: "Mathematics")
    return SubjectDetailView(subjectStore: store, subject: subject)
}
