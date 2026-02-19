import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: AppViewModel
    
    private let calendar = Calendar.current
    
    private var streakDays: Int {
        var streak = 0
        var currentDate = Date()
        
        while streak < 365 {
            let startOfDay = calendar.startOfDay(for: currentDate)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            
            let hasActivity = viewModel.places.contains { place in
                guard let completionDate = place.completionDate else { return false }
                return completionDate >= startOfDay && completionDate < endOfDay
            } || viewModel.dailyTasks.contains { task in
                guard let completionDate = task.completionDate else { return false }
                return completionDate >= startOfDay && completionDate < endOfDay
            }
            
            if hasActivity {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            } else {
                break
            }
        }
        return streak
    }
    
    private var completedPlacesCount: Int {
        viewModel.places.filter { $0.isCompleted }.count
    }
    
    private var completedTasksCount: Int {
        viewModel.dailyTasks.filter { $0.isCompleted }.count
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        Text("Statistics")
                            .font(.playfairDisplay(.bold, size: 28))
                            .foregroundColor(.primaryBlue)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            StatCard(
                                title: "Streak",
                                value: "\(streakDays)",
                                subtitle: "days",
                                icon: "flame.fill",
                                color: .primaryYellow
                            )
                            StatCard(
                                title: "Places",
                                value: "\(completedPlacesCount)",
                                subtitle: "of \(viewModel.places.count)",
                                icon: "location.fill",
                                color: .primaryBlue
                            )
                        }
                        
                        HStack(spacing: 16) {
                            StatCard(
                                title: "Tasks",
                                value: "\(completedTasksCount)",
                                subtitle: "of \(viewModel.dailyTasks.count)",
                                icon: "checkmark.circle.fill",
                                color: .successGreen
                            )
                            StatCard(
                                title: "Challenges",
                                value: "\(viewModel.completedChallenges.count)",
                                subtitle: "completed",
                                icon: "star.fill",
                                color: .lavender
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Progress")
                            .font(.playfairDisplay(.semibold, size: 22))
                            .foregroundColor(.primaryBlue)
                        
                        VStack(spacing: 20) {
                            ProgressRow(
                                title: "Places visited",
                                current: completedPlacesCount,
                                total: max(viewModel.places.count, 1),
                                color: .primaryBlue
                            )
                            ProgressRow(
                                title: "Tasks completed",
                                current: completedTasksCount,
                                total: max(viewModel.dailyTasks.count, 1),
                                color: .successGreen
                            )
                            ProgressRow(
                                title: "Today's progress",
                                current: Int(viewModel.dailyProgress * 100),
                                total: 100,
                                color: .primaryYellow
                            )
                        }
                    }
                    .cardStyle()
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 20)
            }
        }
    }
}

struct ProgressRow: View {
    let title: String
    let current: Int
    let total: Int
    let color: Color
    
    private var progress: Double {
        guard total > 0 else { return 0 }
        return Double(current) / Double(total)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.playfairDisplay(.medium, size: 16))
                    .foregroundColor(.primaryBlue)
                Spacer()
                Text("\(current) / \(total)")
                    .font(.playfairDisplay(.regular, size: 14))
                    .foregroundColor(.textSecondary)
            }
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(color.opacity(0.2))
                        .frame(height: 10)
                    RoundedRectangle(cornerRadius: 6)
                        .fill(color)
                        .frame(width: geometry.size.width * progress, height: 10)
                }
            }
            .frame(height: 10)
        }
    }
}

#Preview {
    StatisticsView(viewModel: AppViewModel())
}
