import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let subtitle: String?
    
    init(title: String, value: String, icon: String, color: Color, subtitle: String? = nil) {
        self.title = title
        self.value = value
        self.icon = icon
        self.color = color
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
                
                Text(value)
                    .font(.appTitle)
                    .foregroundColor(.appText)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.appSubheadline)
                    .foregroundColor(.appText)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.appCaption)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
        }
        .padding(20)
        .frame(maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .shadow(color: color.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

struct ProgressBar: View {
    let progress: Double
    let color: Color
    let height: CGFloat
    
    init(progress: Double, color: Color, height: CGFloat = 8) {
        self.progress = progress
        self.color = color
        self.height = height
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(AppColors.lightBlue)
                    .frame(height: height)
                
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(color)
                    .frame(width: geometry.size.width * progress, height: height)
                    .animation(.easeInOut(duration: 0.8), value: progress)
            }
        }
        .frame(height: height)
    }
}

struct SubjectStatsRow: View {
    let subject: Subject
    let taskCount: Int
    let maxTasks: Int
    
    private var progress: Double {
        guard maxTasks > 0 else { return 0 }
        return Double(taskCount) / Double(maxTasks)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(subject.name)
                    .font(.appSubheadline)
                    .foregroundColor(.appText)
                
                Spacer()
                
                Text("\(taskCount) tasks")
                    .font(.appBody)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            ProgressBar(
                progress: progress,
                color: AppColors.primaryBlue,
                height: 6
            )
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
        )
    }
}

struct TaskTypeChart: View {
    let homeworkCount: Int
    let testCount: Int
    
    private var totalTasks: Int {
        homeworkCount + testCount
    }
    
    private var homeworkPercentage: Double {
        guard totalTasks > 0 else { return 0 }
        return Double(homeworkCount) / Double(totalTasks)
    }
    
    private var testPercentage: Double {
        guard totalTasks > 0 else { return 0 }
        return Double(testCount) / Double(totalTasks)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tasks by Type")
                .font(.appHeadline)
                .foregroundColor(.appText)
            
            if totalTasks == 0 {
                Text("No tasks yet")
                    .font(.appBody)
                    .foregroundColor(AppColors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 12) {
                    HStack {
                        Circle()
                            .fill(AppColors.primaryBlue)
                            .frame(width: 12, height: 12)
                        
                        Text("Homework")
                            .font(.appBody)
                            .foregroundColor(.appText)
                        
                        Spacer()
                        
                        Text("\(homeworkCount)")
                            .font(.appBody)
                            .foregroundColor(AppColors.textSecondary)
                        
                        Text("(\(Int(homeworkPercentage * 100))%)")
                            .font(.appCaption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    ProgressBar(
                        progress: homeworkPercentage,
                        color: AppColors.primaryBlue
                    )
                    
                    HStack {
                        Circle()
                            .fill(AppColors.accent)
                            .frame(width: 12, height: 12)
                        
                        Text("Tests")
                            .font(.appBody)
                            .foregroundColor(.appText)
                        
                        Spacer()
                        
                        Text("\(testCount)")
                            .font(.appBody)
                            .foregroundColor(AppColors.textSecondary)
                        
                        Text("(\(Int(testPercentage * 100))%)")
                            .font(.appCaption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    ProgressBar(
                        progress: testPercentage,
                        color: AppColors.accent
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

struct WeeklyTasksChart: View {
    let lastWeekTasks: [Task]
    let nextWeekTasks: [Task]
    
    private var lastWeekCount: Int {
        lastWeekTasks.count
    }
    
    private var nextWeekCount: Int {
        nextWeekTasks.count
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Overview")
                .font(.appHeadline)
                .foregroundColor(.appText)
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Last 7 Days")
                        .font(.appSubheadline)
                        .foregroundColor(.appText)
                    
                    Text("\(lastWeekCount)")
                        .font(.appTitle)
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text("completed")
                        .font(.appCaption)
                        .foregroundColor(AppColors.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.lightBlue.opacity(0.3))
                )
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Next 7 Days")
                        .font(.appSubheadline)
                        .foregroundColor(.appText)
                    
                    Text("\(nextWeekCount)")
                        .font(.appTitle)
                        .foregroundColor(AppColors.primaryBlue)
                    
                    Text("upcoming")
                        .font(.appCaption)
                        .foregroundColor(AppColors.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.primaryBlue.opacity(0.1))
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}
