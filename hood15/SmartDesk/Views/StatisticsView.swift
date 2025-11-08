import SwiftUI

struct StatisticsView: View {
    @ObservedObject var subjectStore: SubjectStore
    @State private var animateStats = false
    
    private var totalSubjects: Int {
        subjectStore.getTotalSubjects()
    }
    
    private var totalTasks: Int {
        subjectStore.getTotalTasks()
    }
    
    private var completedTasks: Int {
        subjectStore.getCompletedTasks()
    }
    
    private var upcomingTasks: Int {
        subjectStore.getUpcomingTasks()
    }
    
    private var tasksByType: [TaskType: Int] {
        subjectStore.getTasksByType()
    }
    
    private var tasksBySubject: [(Subject, Int)] {
        subjectStore.getTasksBySubject()
    }
    
    private var lastWeekTasks: [Task] {
        subjectStore.getCompletedTasksForLast7Days()
    }
    
    private var nextWeekTasks: [Task] {
        subjectStore.getPendingTasksForNext7Days()
    }
    
    private var completionRate: Double {
        guard totalTasks > 0 else { return 0 }
        return Double(completedTasks) / Double(totalTasks)
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 24) {
                    Text("Statistics")
                        .font(.appTitle)
                        .foregroundColor(.appText)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        StatCard(
                            title: "Total Subjects",
                            value: "\(totalSubjects)",
                            icon: "book.fill",
                            color: AppColors.primaryBlue
                        )
                        
                        StatCard(
                            title: "Total Tasks",
                            value: "\(totalTasks)",
                            icon: "list.bullet",
                            color: AppColors.accent
                        )
                        
                        StatCard(
                            title: "Completed",
                            value: "\(completedTasks)",
                            icon: "checkmark.circle.fill",
                            color: AppColors.success,
                            subtitle: "\(Int(completionRate * 100))% completion rate"
                        )
                        
                        StatCard(
                            title: "Upcoming",
                            value: "\(upcomingTasks)",
                            icon: "clock.fill",
                            color: AppColors.warning,
                            subtitle: ""
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    TaskTypeChart(
                        homeworkCount: tasksByType[.homework] ?? 0,
                        testCount: tasksByType[.test] ?? 0
                    )
                    .padding(.horizontal, 20)
                    
                    WeeklyTasksChart(
                        lastWeekTasks: lastWeekTasks,
                        nextWeekTasks: nextWeekTasks
                    )
                    .padding(.horizontal, 20)
                    
                    if !tasksBySubject.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Tasks by Subject")
                                .font(.appHeadline)
                                .foregroundColor(.appText)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                ForEach(tasksBySubject.prefix(5), id: \.0.id) { subject, taskCount in
                                    SubjectStatsRow(
                                        subject: subject,
                                        taskCount: taskCount,
                                        maxTasks: tasksBySubject.first?.1 ?? 1
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    if totalTasks > 0 {
                        VStack(spacing: 12) {
                            Image(systemName: completionRate > 0.7 ? "star.fill" : "target")
                                .font(.system(size: 40))
                                .foregroundColor(completionRate > 0.7 ? AppColors.warning : AppColors.primaryBlue)
                            
                            Text(motivationalMessage)
                                .font(.appSubheadline)
                                .foregroundColor(.appText)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        .padding(.vertical, 30)
                        .padding(.horizontal, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(AppColors.cardBackground)
                                .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
                        )
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).delay(0.2)) {
                animateStats = true
            }
        }
    }
    
    private var motivationalMessage: String {
        if totalTasks == 0 {
            return "Start adding subjects and tasks to see your progress!"
        } else if completionRate >= 0.9 {
            return "Outstanding! You're completing almost all your tasks. Keep up the excellent work!"
        } else if completionRate >= 0.7 {
            return "Great job! You're staying on top of most of your tasks. Keep it up!"
        } else if completionRate >= 0.5 {
            return "Good progress! You're completing more than half of your tasks. Try to improve your completion rate."
        } else {
            return "You have room for improvement. Focus on completing more tasks to boost your productivity!"
        }
    }
}

#Preview {
    StatisticsView(subjectStore: SubjectStore())
}
