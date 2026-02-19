import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var selectedPeriod: StatsPeriod = .week
    
    var body: some View {
        ZStack {
            AnimatedBackgroundView()
            
            ScrollView {
                VStack(spacing: DesignConstants.Spacing.lg) {
                    HStack {
                        Text("Statistics")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(DesignConstants.Colors.white)
                        
                        Spacer()
                    }
                    .padding(.horizontal, DesignConstants.Spacing.lg)
                    .padding(.top, DesignConstants.Spacing.md)
                    
                    HStack(spacing: DesignConstants.Spacing.sm) {
                        ForEach(StatsPeriod.allCases, id: \.self) { period in
                            Button(action: { selectedPeriod = period }) {
                                Text(period.rawValue)
                                    .font(.ubuntu(14, weight: .medium))
                                    .foregroundColor(selectedPeriod == period ? DesignConstants.Colors.primaryBlue : DesignConstants.Colors.white)
                                    .padding(.horizontal, DesignConstants.Spacing.md)
                                    .padding(.vertical, DesignConstants.Spacing.sm)
                                    .background(
                                        RoundedRectangle(cornerRadius: DesignConstants.CornerRadius.medium)
                                            .fill(selectedPeriod == period ? DesignConstants.Colors.primaryYellow : DesignConstants.Colors.white.opacity(0.1))
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, DesignConstants.Spacing.lg)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: DesignConstants.Spacing.md) {
                        StatisticsCardView(
                            title: "Habits Completed",
                            value: "\(totalHabitsCompleted)",
                            subtitle: "in selected period",
                            icon: "checkmark.circle.fill",
                            color: DesignConstants.Colors.primaryYellow
                        )
                        
                        StatisticsCardView(
                            title: "Active Days",
                            value: "\(activeDaysCount)",
                            subtitle: "days with activity",
                            icon: "calendar",
                            color: DesignConstants.Colors.lightGreen
                        )
                        
                        StatisticsCardView(
                            title: "Completion Rate",
                            value: "\(Int(completionRate * 100))%",
                            subtitle: "average",
                            icon: "chart.line.uptrend.xyaxis",
                            color: DesignConstants.Colors.softPurple
                        )
                    }
                    .padding(.horizontal, DesignConstants.Spacing.lg)
                    
                    if !appViewModel.appState.habits.isEmpty {
                        VStack(alignment: .leading, spacing: DesignConstants.Spacing.md) {
                            Text("Habits Overview")
                                .font(.ubuntu(20, weight: .bold))
                                .foregroundColor(DesignConstants.Colors.white)
                            
                            ForEach(appViewModel.appState.habits) { habit in
                                HabitStatRowView(habit: habit)
                            }
                        }
                        .padding(.horizontal, DesignConstants.Spacing.lg)
                    }
                }
                .padding(.bottom, 120)
            }
        }
    }
    
    private var totalHabitsCompleted: Int {
        appViewModel.appState.habits.reduce(0) { sum, habit in
            sum + habit.completedDates.filter { isDateInPeriod($0) }.count
        }
    }
    
    private var activeDaysCount: Int {
        let calendar = Calendar.current
        let (start, end) = periodBounds
        var count = 0
        var date = start
        while date <= end {
            let hasActivity = appViewModel.appState.habits.contains { habit in
                habit.completedDates.contains { calendar.isDate($0, inSameDayAs: date) }
            }
            if hasActivity { count += 1 }
            date = calendar.date(byAdding: .day, value: 1, to: date) ?? date
        }
        return count
    }
    
    private var completionRate: Double {
        let totalPossible = appViewModel.appState.habits.count * daysInPeriod
        guard totalPossible > 0 else { return 0 }
        return Double(totalHabitsCompleted) / Double(totalPossible)
    }
    
    private var periodBounds: (Date, Date) {
        let calendar = Calendar.current
        let now = Date()
        switch selectedPeriod {
        case .week:
            let start = calendar.date(byAdding: .day, value: -6, to: now) ?? now
            return (calendar.startOfDay(for: start), now)
        case .month:
            let start = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            return (calendar.startOfDay(for: start), now)
        case .all:
            let start = calendar.date(byAdding: .year, value: -1, to: now) ?? now
            return (calendar.startOfDay(for: start), now)
        }
    }
    
    private var daysInPeriod: Int {
        let (start, end) = periodBounds
        return max(1, Calendar.current.dateComponents([.day], from: start, to: end).day ?? 1)
    }
    
    private func isDateInPeriod(_ date: Date) -> Bool {
        let (start, end) = periodBounds
        let calendar = Calendar.current
        return date >= start && date <= end
    }
}

enum StatsPeriod: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case all = "All"
}

struct StatisticsCardView: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: DesignConstants.Spacing.lg) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(Color.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ubuntu(14))
                    .foregroundColor(DesignConstants.Colors.white.opacity(0.8))
                
                Text(value)
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(DesignConstants.Colors.white)
                
                Text(subtitle)
                    .font(.ubuntu(12))
                    .foregroundColor(DesignConstants.Colors.white.opacity(0.6))
            }
            
            Spacer()
        }
        .padding(DesignConstants.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: DesignConstants.CornerRadius.large)
                .fill(DesignConstants.Colors.white.opacity(0.1))
        )
    }
}

struct HabitStatRowView: View {
    let habit: Habit
    
    var body: some View {
        HStack(spacing: DesignConstants.Spacing.md) {
            Image(systemName: habit.icon)
                .font(.system(size: 20))
                .foregroundColor(DesignConstants.Colors.primaryYellow)
                .frame(width: 36, alignment: .center)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(DesignConstants.Colors.white)
                
                Text("\(habit.completedDates.count) completions · \(habit.currentStreak) day streak")
                    .font(.ubuntu(12))
                    .foregroundColor(DesignConstants.Colors.white.opacity(0.6))
            }
            
            Spacer()
            
            Text("\(habit.completedDates.count)")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(DesignConstants.Colors.primaryYellow)
        }
        .padding(DesignConstants.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: DesignConstants.CornerRadius.medium)
                .fill(DesignConstants.Colors.white.opacity(0.08))
        )
    }
}

#Preview {
    StatisticsView()
        .environmentObject(AppViewModel())
}
