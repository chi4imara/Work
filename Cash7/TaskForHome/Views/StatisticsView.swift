import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: TaskViewModel
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 20) {
                        todayProgressSection
                        
                        weeklyOverviewSection
                        
                        roomStatisticsSection
                        
                        frequencyStatsSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(20)
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Statistics")
                .font(.customTitle())
                .foregroundColor(.pureWhite)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var todayProgressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Today's Progress")
                .font(.customHeadline())
                .foregroundColor(.pureWhite)
            
            let todayTasks = viewModel.todayTasks
            let completedToday = todayTasks.filter { $0.isCompleted }.count
            let totalToday = todayTasks.count
            let progressPercentage = totalToday > 0 ? Double(completedToday) / Double(totalToday) : 0.0
            
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .stroke(Color.pureWhite.opacity(0.3), lineWidth: 8)
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .trim(from: 0, to: progressPercentage)
                        .stroke(
                            LinearGradient(
                                colors: [.successGreen, .lightBlue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 1), value: progressPercentage)
                    
                    VStack {
                        Text("\(Int(progressPercentage * 100))%")
                            .font(.customTitle())
                            .foregroundColor(.pureWhite)
                        
                        Text("\(completedToday)/\(totalToday)")
                            .font(.customCaption())
                            .foregroundColor(.pureWhite.opacity(0.8))
                    }
                }
                
                HStack(spacing: 12) {
                    StatCard(
                        title: "Completed",
                        value: "\(completedToday)",
                        color: .successGreen
                    )
                    
                    StatCard(
                        title: "Remaining",
                        value: "\(totalToday - completedToday)",
                        color: .warningOrange
                    )
                    
                    StatCard(
                        title: "Total",
                        value: "\(totalToday)",
                        color: .primaryBlue
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.pureWhite.opacity(0.1))
        )
    }
    
    private var weeklyOverviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Overview")
                .font(.customHeadline())
                .foregroundColor(.pureWhite)
            
            let weeklyStats = calculateWeeklyStats()
            
            VStack(spacing: 12) {
                ForEach(Array(weeklyStats.enumerated()), id: \.offset) { index, dayStat in
                    WeeklyProgressBar(
                        dayName: dayStat.dayName,
                        completed: dayStat.completed,
                        total: dayStat.total,
                        isToday: dayStat.isToday
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.pureWhite.opacity(0.1))
        )
    }
    
    private var roomStatisticsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Room Statistics")
                .font(.customHeadline())
                .foregroundColor(.pureWhite)
            
            let roomStats = calculateRoomStats()
            
            VStack(spacing: 12) {
                ForEach(roomStats, id: \.room) { stat in
                    RoomStatRow(
                        room: stat.room,
                        completed: stat.completed,
                        total: stat.total,
                        icon: roomIcon(for: stat.room)
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.pureWhite.opacity(0.1))
        )
    }
    
    private var frequencyStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Task Types")
                .font(.customHeadline())
                .foregroundColor(.pureWhite)
            
            let dailyTasks = viewModel.tasks.filter { !$0.isArchived && $0.frequency == .daily }.count
            let weeklyTasks = viewModel.tasks.filter { !$0.isArchived && $0.frequency == .weekly }.count
            let archivedTasks = viewModel.archivedTasks.count
            
            HStack(spacing: 12) {
                StatCard(
                    title: "Daily Tasks",
                    value: "\(dailyTasks)",
                    color: .lightBlue
                )
                
                StatCard(
                    title: "Weekly Tasks",
                    value: "\(weeklyTasks)",
                    color: .primaryBlue
                )
                
                StatCard(
                    title: "Archived",
                    value: "\(archivedTasks)",
                    color: .mediumGray
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.pureWhite.opacity(0.1))
        )
    }
    
    private var achievementSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Achievements")
                .font(.customHeadline())
                .foregroundColor(.pureWhite)
            
            let achievements = calculateAchievements()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(achievements, id: \.title) { achievement in
                    AchievementCard(achievement: achievement)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.pureWhite.opacity(0.1))
        )
    }
    
    private func calculateWeeklyStats() -> [DayStatistic] {
        let calendar = Calendar.current
        let today = Date()
        var stats: [DayStatistic] = []
        
        for i in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: -i, to: today) else { continue }
            let weekday = calendar.component(.weekday, from: date)
            let dayName = calendar.shortWeekdaySymbols[weekday - 1]
            
            let tasksForDay = viewModel.tasks.filter { task in
                !task.isArchived && (
                    task.frequency == .daily ||
                    (task.frequency == .weekly && task.weekDay?.dayNumber == weekday)
                )
            }
            
            let completedTasks = tasksForDay.filter { task in
                if let completedDate = task.completedDate {
                    return calendar.isDate(completedDate, inSameDayAs: date)
                }
                return false
            }.count
            
            stats.append(DayStatistic(
                dayName: dayName,
                completed: completedTasks,
                total: tasksForDay.count,
                isToday: calendar.isDate(date, inSameDayAs: today)
            ))
        }
        
        return stats.reversed()
    }
    
    private func calculateRoomStats() -> [RoomStatistic] {
        var stats: [RoomStatistic] = []
        
        for room in Room.allCases {
            let roomTasks = viewModel.tasks.filter { !$0.isArchived && $0.room == room }
            let completedTasks = roomTasks.filter { $0.isCompleted }.count
            
            if !roomTasks.isEmpty {
                stats.append(RoomStatistic(
                    room: room,
                    completed: completedTasks,
                    total: roomTasks.count
                ))
            }
        }
        
        return stats.sorted { $0.total > $1.total }
    }
    
    private func calculateAchievements() -> [Achievement] {
        var achievements: [Achievement] = []
        
        let totalTasks = viewModel.tasks.filter { !$0.isArchived }.count
        let completedToday = viewModel.todayTasks.filter { $0.isCompleted }.count
        let totalCompleted = viewModel.tasks.filter { $0.isCompleted }.count
        let archivedCount = viewModel.archivedTasks.count
        
        if totalTasks >= 10 {
            achievements.append(Achievement(
                title: "Task Master",
                description: "Created \(totalTasks) tasks",
                icon: "plus.circle.fill",
                isUnlocked: true,
                color: .primaryBlue
            ))
        }
        
        if completedToday >= 5 {
            achievements.append(Achievement(
                title: "Daily Hero",
                description: "Completed \(completedToday) tasks today",
                icon: "star.fill",
                isUnlocked: true,
                color: .successGreen
            ))
        }
        
        let completionRate = totalTasks > 0 ? Double(totalCompleted) / Double(totalTasks) : 0
        if completionRate >= 0.8 {
            achievements.append(Achievement(
                title: "Perfectionist",
                description: "\(Int(completionRate * 100))% completion rate",
                icon: "checkmark.seal.fill",
                isUnlocked: true,
                color: .warningOrange
            ))
        }
        
        if archivedCount >= 20 {
            achievements.append(Achievement(
                title: "Organizer",
                description: "Archived \(archivedCount) tasks",
                icon: "archivebox.fill",
                isUnlocked: true,
                color: .mediumGray
            ))
        }
        
        return achievements
    }
    
    private func roomIcon(for room: Room) -> String {
        switch room {
        case .kitchen: return "fork.knife"
        case .bedroom: return "bed.double"
        case .livingRoom: return "sofa"
        case .bathroom: return "bathtub"
        case .hallway: return "door.left.hand.open"
        case .other: return "house"
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.customHeadline())
                .foregroundColor(color)
            
            Text(title)
                .font(.customCaption())
                .foregroundColor(.pureWhite.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.pureWhite.opacity(0.1))
        )
    }
}

struct WeeklyProgressBar: View {
    let dayName: String
    let completed: Int
    let total: Int
    let isToday: Bool
    
    private var progress: Double {
        total > 0 ? Double(completed) / Double(total) : 0
    }
    
    var body: some View {
        HStack {
            Text(dayName)
                .font(.customBody())
                .foregroundColor(isToday ? .successGreen : .pureWhite)
                .fontWeight(isToday ? .semibold : .regular)
                .frame(width: 40, alignment: .leading)
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.pureWhite.opacity(0.2))
                    .frame(height: 8)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(isToday ? Color.successGreen : Color.lightBlue)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white, lineWidth: 1.5)
                    )
                    .frame(width: max(0, progress * 200), height: 8)
                    .animation(.easeInOut(duration: 0.5), value: progress)
            }
            .frame(width: 200)
            
            Text("\(completed)/\(total)")
                .font(.customCaption())
                .foregroundColor(.pureWhite.opacity(0.8))
                .frame(width: 40, alignment: .trailing)
        }
    }
}

struct RoomStatRow: View {
    let room: Room
    let completed: Int
    let total: Int
    let icon: String
    
    private var progress: Double {
        total > 0 ? Double(completed) / Double(total) : 0
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.lightBlue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(room.displayName)
                        .font(.customBody())
                        .foregroundColor(.pureWhite)
                    
                    Spacer()
                    
                    Text("\(completed)/\(total)")
                        .font(.customCaption())
                        .foregroundColor(.pureWhite.opacity(0.8))
                }
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.pureWhite.opacity(0.2))
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.successGreen)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white, lineWidth: 1.5)
                        )
                        .frame(width: max(0, progress * 260), height: 6)
                        .animation(.easeInOut(duration: 0.5), value: progress)
                }
            }
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: achievement.icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(achievement.isUnlocked ? achievement.color : .mediumGray)
            
            Text(achievement.title)
                .font(.customCaption())
                .fontWeight(.semibold)
                .foregroundColor(achievement.isUnlocked ? .pureWhite : .mediumGray)
            
            Text(achievement.description)
                .font(.customSmall())
                .foregroundColor(achievement.isUnlocked ? .pureWhite.opacity(0.8) : .mediumGray.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.pureWhite.opacity(achievement.isUnlocked ? 0.1 : 0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(achievement.isUnlocked ? achievement.color.opacity(0.3) : Color.clear, lineWidth: 1)
                )
        )
        .opacity(achievement.isUnlocked ? 1.0 : 0.6)
    }
}

struct DayStatistic {
    let dayName: String
    let completed: Int
    let total: Int
    let isToday: Bool
}

struct RoomStatistic {
    let room: Room
    let completed: Int
    let total: Int
}

struct Achievement {
    let title: String
    let description: String
    let icon: String
    let isUnlocked: Bool
    let color: Color
}

#Preview {
    StatisticsView(viewModel: TaskViewModel())
}
