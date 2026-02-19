import SwiftUI

struct ProgressView: View {
    @StateObject private var viewModel = ProgressViewModel()
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    headerSection
                    
                    timeFrameSelector
                    
                    completionRateCard
                    
                    habitsChartsSection
                    
                    achievementsSection
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
            }
        }
        .onAppear {
            viewModel.habits = appViewModel.habits
            viewModel.achievements = appViewModel.achievements
        }
        .onChange(of: appViewModel.habits, perform: { newHabits in
            if viewModel.habits != newHabits {
                viewModel.habits = newHabits
            }
        })
        .onChange(of: appViewModel.achievements, perform: { newAchievements in
            if viewModel.achievements != newAchievements {
                viewModel.achievements = newAchievements
            }
        })
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Progress")
                .font(AppFonts.title1())
                .foregroundColor(AppColors.textPrimary)
            
            Text("Track your journey to better habits")
                .font(AppFonts.body())
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var timeFrameSelector: some View {
        Picker("Time Frame", selection: $viewModel.selectedTimeFrame) {
            ForEach(ProgressViewModel.TimeFrame.allCases, id: \.self) { timeFrame in
                Text(timeFrame.rawValue).tag(timeFrame)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm)
        .background(Color.white.opacity(0.8))
        .cornerRadius(AppRadius.md)
    }
    
    private var completionRateCard: some View {
        VStack(spacing: AppSpacing.md) {
            Text("Today's Completion Rate")
                .font(AppFonts.headline())
                .foregroundColor(AppColors.textPrimary)
            
            ZStack {
                Circle()
                    .stroke(AppColors.primaryBlue.opacity(0.3), lineWidth: 12)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0, to: viewModel.completionRate)
                    .stroke(AppColors.primaryBlue, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1), value: viewModel.completionRate)
                
                VStack {
                    Text("\(Int(viewModel.completionRate * 100))%")
                        .font(AppFonts.title2())
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("Complete")
                        .font(AppFonts.caption())
                        .foregroundColor(AppColors.textSecondary)
                }
            }
        }
        .padding(AppSpacing.lg)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.9))
        .cornerRadius(AppRadius.lg)
        .shadow(color: AppShadows.light, radius: 4, x: 0, y: 2)
    }
    
    private var habitsChartsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Habits Overview")
                .font(AppFonts.headline())
                .foregroundColor(AppColors.textPrimary)
            
            if viewModel.habits.isEmpty {
                emptyChartsView
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: AppSpacing.md) {
                    ForEach(viewModel.habits) { habit in
                        HabitProgressChart(habit: habit)
                    }
                }
            }
        }
    }
    
    private var emptyChartsView: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 40))
                .foregroundColor(AppColors.textSecondary)
            
            Text("No data for analysis")
                .font(AppFonts.body())
                .foregroundColor(AppColors.textSecondary)
            
            Text("Start tracking habits to see your progress")
                .font(AppFonts.caption())
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(AppSpacing.xl)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color.white.opacity(0.8))
        .cornerRadius(AppRadius.lg)
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Achievements")
                .font(AppFonts.headline())
                .foregroundColor(AppColors.textPrimary)
            
            if viewModel.achievements.isEmpty {
                emptyAchievementsView
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: AppSpacing.md) {
                    ForEach(viewModel.achievements) { achievement in
                        AchievementCard(achievement: achievement)
                    }
                }
            }
        }
    }
    
    private var emptyAchievementsView: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "trophy")
                .font(.system(size: 40))
                .foregroundColor(AppColors.textSecondary)
            
            Text("No achievements yet")
                .font(AppFonts.body())
                .foregroundColor(AppColors.textSecondary)
            
            Text("Keep building habits to unlock achievements")
                .font(AppFonts.caption())
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(AppSpacing.xl)
        .background(Color.white.opacity(0.8))
        .cornerRadius(AppRadius.lg)
    }
}

struct HabitProgressChart: View {
    let habit: Habit
    @State private var animatedProgress: Double = 0
    
    private var progressData: [ChartDataPoint] {
        let calendar = Calendar.current
        let now = Date()
        let daysToShow = 7
        
        let baseProgress = habit.progress
        let variation = 0.15
        
        return (0..<daysToShow).map { dayOffset in
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: now) ?? now
            let dayProgress = max(0, min(1, baseProgress + Double.random(in: -variation...variation)))
            return ChartDataPoint(date: date, value: dayProgress)
        }.reversed()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                ZStack {
                    Circle()
                        .fill(habit.type.color.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: habit.type.icon)
                        .font(.system(size: 18))
                        .foregroundColor(habit.type.color)
                }
                
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(habit.name)
                        .font(AppFonts.bodyMedium())
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(1)
                    
                    HStack(spacing: AppSpacing.xs) {
                        Text("\(habit.progressPercentage)%")
                            .font(AppFonts.bodyMedium())
                            .foregroundColor(habit.type.color)
                        
                        Text("complete")
                            .font(AppFonts.caption())
                            .foregroundColor(AppColors.textSecondary)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
            }
            
            VStack(spacing: AppSpacing.xs) {
                GeometryReader { geometry in
                    ZStack(alignment: .bottomLeading) {
                        ChartGrid()
                            .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                        
                        LineChartShape(data: progressData, animatedProgress: animatedProgress)
                            .stroke(
                                LinearGradient(
                                    colors: [habit.type.color, habit.type.color.opacity(0.5)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round)
                            )
                            .shadow(color: habit.type.color.opacity(0.3), radius: 2, x: 0, y: 1)
                        
                        ForEach(Array(progressData.enumerated()), id: \.element.date) { index, dataPoint in
                            Circle()
                                .fill(habit.type.color)
                                .frame(width: 6, height: 6)
                                .position(
                                    x: CGFloat(index) * (geometry.size.width / CGFloat(max(1, progressData.count - 1))),
                                    y: geometry.size.height - (CGFloat(dataPoint.value) * geometry.size.height * CGFloat(animatedProgress))
                                )
                                .shadow(color: habit.type.color.opacity(0.5), radius: 2)
                        }
                        
                        AreaChartShape(data: progressData, animatedProgress: animatedProgress)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        habit.type.color.opacity(0.3),
                                        habit.type.color.opacity(0.1),
                                        Color.clear
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                }
                .frame(height: 60)
                
                HStack(spacing: 0) {
                    ForEach(Array(progressData.enumerated()), id: \.element.date) { index, dataPoint in
                        Text(dayLabel(for: dataPoint.date))
                            .font(.system(size: 9, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .padding(AppSpacing.md)
        .background(Color.white.opacity(0.9))
        .cornerRadius(AppRadius.md)
        .shadow(color: AppShadows.light, radius: 3, x: 0, y: 2)
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                animatedProgress = 1.0
            }
        }
    }
    
    private func dayLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return String(formatter.string(from: date).prefix(1))
    }
}

struct LineChartShape: Shape {
    let data: [ChartDataPoint]
    var animatedProgress: Double = 1.0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard !data.isEmpty else { return path }
        
        let stepX = rect.width / CGFloat(max(1, data.count - 1))
        let maxValue: Double = 1.0
        
        for (index, point) in data.enumerated() {
            let x = CGFloat(index) * stepX
            let normalizedValue = point.value / maxValue
            let y = rect.height - (CGFloat(normalizedValue) * rect.height * CGFloat(animatedProgress))
            
            if index == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        return path
    }
}

struct AreaChartShape: Shape {
    let data: [ChartDataPoint]
    var animatedProgress: Double = 1.0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard !data.isEmpty else { return path }
        
        let stepX = rect.width / CGFloat(max(1, data.count - 1))
        let maxValue: Double = 1.0
        
        path.move(to: CGPoint(x: 0, y: rect.height))
        
        for (index, point) in data.enumerated() {
            let x = CGFloat(index) * stepX
            let normalizedValue = point.value / maxValue
            let y = rect.height - (CGFloat(normalizedValue) * rect.height * CGFloat(animatedProgress))
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}

struct ChartGrid: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        for i in 0...4 {
            let y = rect.height * CGFloat(i) / 4
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: rect.width, y: y))
        }
        
        return path
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? achievement.type.color.opacity(0.2) : Color.gray.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: achievement.isUnlocked ? "trophy.fill" : "lock.fill")
                    .font(.title2)
                    .foregroundColor(achievement.isUnlocked ? achievement.type.color : Color.gray)
            }
            
            VStack(spacing: AppSpacing.xs) {
                Text(achievement.title)
                    .font(AppFonts.bodyMedium())
                    .foregroundColor(achievement.isUnlocked ? AppColors.textPrimary : AppColors.textSecondary)
                    .lineLimit(1)
                
                Text(achievement.description)
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.textSecondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            
            if achievement.isUnlocked, let unlockedDate = achievement.unlockedAt {
                Text("Unlocked \(unlockedDate, style: .date)")
                    .font(.system(size: 10))
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .padding(AppSpacing.md)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(achievement.isUnlocked ? 0.9 : 0.6))
        .cornerRadius(AppRadius.md)
        .shadow(color: AppShadows.light, radius: 2, x: 0, y: 1)
        .scaleEffect(achievement.isUnlocked ? 1.0 : 0.95)
        .opacity(achievement.isUnlocked ? 1.0 : 0.7)
    }
}

struct ChartDataPoint {
    let date: Date
    let value: Double
}

#Preview {
    ProgressView()
        .environmentObject(AppViewModel())
}
