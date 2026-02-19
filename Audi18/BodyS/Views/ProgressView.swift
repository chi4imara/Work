import SwiftUI

struct ProgressView: View {
    @ObservedObject var viewModel: ProcedureViewModel
    @State private var selectedPeriod: ProgressPeriod = .week
    
    enum ProgressPeriod: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case all = "All Time"
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Progress")
                        .font(.bellGothic(size: 28, weight: .bold))
                        .foregroundColor(AppColors.primaryBlue)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        PeriodSelectorView(selectedPeriod: $selectedPeriod)
                        
                        StatisticsCardsView(viewModel: viewModel, period: selectedPeriod)
                        
                        WeeklyProgressView(viewModel: viewModel)
                        
                        TopProceduresView(viewModel: viewModel, period: selectedPeriod)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
            }
        }
    }
}

struct PeriodSelectorView: View {
    @Binding var selectedPeriod: ProgressView.ProgressPeriod
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(ProgressView.ProgressPeriod.allCases, id: \.self) { period in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedPeriod = period
                    }
                }) {
                    Text(period.rawValue)
                        .font(.bellGothic(size: 14, weight: .bold))
                        .foregroundColor(selectedPeriod == period ? .white : AppColors.primaryBlue)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(selectedPeriod == period ? AppColors.primaryYellow : AppColors.lightGray.opacity(0.5))
                        .cornerRadius(20)
                }
            }
        }
    }
}

struct StatisticsCardsView: View {
    @ObservedObject var viewModel: ProcedureViewModel
    let period: ProgressView.ProgressPeriod
    
    private var statistics: ProgressStatistics {
        viewModel.getStatistics(for: period)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                StatCardView(
                    icon: "checkmark.circle.fill",
                    title: "Completed",
                    value: "\(statistics.completedProcedures)",
                    color: AppColors.softGreen
                )
                
                StatCardView(
                    icon: "list.bullet",
                    title: "Total Steps",
                    value: "\(statistics.totalSteps)",
                    color: AppColors.primaryBlue
                )
            }
            
            HStack(spacing: 16) {
                StatCardView(
                    icon: "percent",
                    title: "Completion",
                    value: "\(Int(statistics.completionRate))%",
                    color: AppColors.primaryYellow
                )
                
                StatCardView(
                    icon: "flame.fill",
                    title: "Streak",
                    value: "\(statistics.currentStreak)",
                    color: Color.orange
                )
            }
        }
    }
}

struct StatCardView: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(color)
            
            Text(value)
                .font(.bellGothic(size: 24, weight: .bold))
                .foregroundColor(AppColors.primaryBlue)
            
            Text(title)
                .font(.bellGothic(size: 12))
                .foregroundColor(AppColors.darkGray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: color.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

struct WeeklyProgressView: View {
    @ObservedObject var viewModel: ProcedureViewModel
    
    private var weeklyData: [WeekDayProgress] {
        viewModel.getWeeklyProgress()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Progress")
                .font(.bellGothic(size: 20, weight: .bold))
                .foregroundColor(AppColors.primaryBlue)
            
            VStack(spacing: 12) {
                ForEach(weeklyData, id: \.day) { data in
                    HStack(spacing: 12) {
                        Text(data.day.name.prefix(3))
                            .font(.bellGothic(size: 14, weight: .bold))
                            .foregroundColor(AppColors.primaryBlue)
                            .frame(width: 40, alignment: .leading)
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(AppColors.lightGray)
                                    .frame(height: 8)
                                    .cornerRadius(4)
                                
                                Rectangle()
                                    .fill(data.completionRate > 0 ? AppColors.primaryYellow : AppColors.lightGray)
                                    .frame(width: geometry.size.width * data.completionRate, height: 8)
                                    .cornerRadius(4)
                                    .animation(.easeInOut(duration: 0.3), value: data.completionRate)
                            }
                        }
                        .frame(height: 8)
                        
                        Text("\(Int(data.completionRate * 100))%")
                            .font(.bellGothic(size: 12, weight: .bold))
                            .foregroundColor(AppColors.darkGray)
                            .frame(width: 40, alignment: .trailing)
                    }
                }
            }
            .padding(16)
            .background(AppColors.cardGradient)
            .cornerRadius(16)
            .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

struct TopProceduresView: View {
    @ObservedObject var viewModel: ProcedureViewModel
    let period: ProgressView.ProgressPeriod
    
    private var topProcedures: [ProcedureProgress] {
        viewModel.getTopProcedures(for: period)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Top Procedures")
                .font(.bellGothic(size: 20, weight: .bold))
                .foregroundColor(AppColors.primaryBlue)
            
            if topProcedures.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "chart.bar")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.primaryBlue.opacity(0.3))
                    
                    Text("No progress data yet")
                        .font(.bellGothic(size: 16))
                        .foregroundColor(AppColors.darkGray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(AppColors.lightGray.opacity(0.3))
                .cornerRadius(12)
            } else {
                VStack(spacing: 12) {
                    ForEach(Array(topProcedures.enumerated()), id: \.element.procedureId) { index, item in
                        HStack(spacing: 12) {
                            Text("#\(index + 1)")
                                .font(.bellGothic(size: 16, weight: .bold))
                                .foregroundColor(AppColors.primaryYellow)
                                .frame(width: 30)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                if let procedure = viewModel.procedures.first(where: { $0.id == item.procedureId }) {
                                    Text(procedure.name)
                                        .font(.bellGothic(size: 16, weight: .bold))
                                        .foregroundColor(AppColors.primaryBlue)
                                        .lineLimit(1)
                                }
                                
                                Text("\(item.completedCount) completions")
                                    .font(.bellGothic(size: 12))
                                    .foregroundColor(AppColors.darkGray.opacity(0.7))
                            }
                            
                            Spacer()
                            
                            Image(systemName: "star.fill")
                                .font(.system(size: 16))
                                .foregroundColor(AppColors.primaryYellow)
                        }
                        .padding(12)
                        .background(AppColors.cardGradient)
                        .cornerRadius(10)
                    }
                }
            }
        }
    }
}

struct ProgressStatistics {
    let completedProcedures: Int
    let totalSteps: Int
    let completionRate: Double
    let currentStreak: Int
}

struct WeekDayProgress {
    let day: WeekDay
    let completionRate: Double
}

struct ProcedureProgress {
    let procedureId: UUID
    let completedCount: Int
}

extension ProcedureViewModel {
    func getStatistics(for period: ProgressView.ProgressPeriod) -> ProgressStatistics {
        let calendar = Calendar.current
        let now = Date()
        let startDate: Date
        
        switch period {
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: now) ?? now
        case .all:
            startDate = Date.distantPast
        }
        
        let filteredProgress = dailyProgress.filter { $0.date >= startDate }
        let completedProcedures = Set(filteredProgress.map { $0.procedureId }).count
        
        var totalSteps = 0
        var completedSteps = 0
        
        for progress in filteredProgress {
            if let procedure = procedures.first(where: { $0.id == progress.procedureId }) {
                totalSteps += procedure.steps.count
                completedSteps += progress.completedSteps.count
            }
        }
        
        let completionRate = totalSteps > 0 ? Double(completedSteps) / Double(totalSteps) * 100 : 0
        
        let streak = calculateStreak()
        
        return ProgressStatistics(
            completedProcedures: completedProcedures,
            totalSteps: totalSteps,
            completionRate: completionRate,
            currentStreak: streak
        )
    }
    
    func getWeeklyProgress() -> [WeekDayProgress] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return WeekDay.allCases.map { day in
            let dayDate = getDateForWeekDay(day, from: today)
            let dayStart = calendar.startOfDay(for: dayDate)
            let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart) ?? dayStart
            
            let dayProgress = dailyProgress.filter { progress in
                progress.date >= dayStart && progress.date < dayEnd
            }
            
            var totalSteps = 0
            var completedSteps = 0
            
            for progress in dayProgress {
                if let procedure = procedures.first(where: { $0.id == progress.procedureId }) {
                    totalSteps += procedure.steps.count
                    completedSteps += progress.completedSteps.count
                }
            }
            
            let completionRate = totalSteps > 0 ? Double(completedSteps) / Double(totalSteps) : 0
            
            return WeekDayProgress(day: day, completionRate: completionRate)
        }
    }
    
    func getTopProcedures(for period: ProgressView.ProgressPeriod, limit: Int = 5) -> [ProcedureProgress] {
        let calendar = Calendar.current
        let now = Date()
        let startDate: Date
        
        switch period {
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: now) ?? now
        case .all:
            startDate = Date.distantPast
        }
        
        let filteredProgress = dailyProgress.filter { $0.date >= startDate }
        
        var procedureCounts: [UUID: Int] = [:]
        
        for progress in filteredProgress {
            let allStepsCompleted = procedures.first(where: { $0.id == progress.procedureId })
                .map { $0.steps.count > 0 && progress.completedSteps.count == $0.steps.count } ?? false
            
            if allStepsCompleted {
                procedureCounts[progress.procedureId, default: 0] += 1
            }
        }
        
        return procedureCounts
            .map { ProcedureProgress(procedureId: $0.key, completedCount: $0.value) }
            .sorted { $0.completedCount > $1.completedCount }
            .prefix(limit)
            .map { $0 }
    }
    
    private func calculateStreak() -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var streak = 0
        var currentDate = today
        
        while true {
            let dayProgress = dailyProgress.filter { progress in
                calendar.isDate(progress.date, inSameDayAs: currentDate)
            }
            
            if dayProgress.isEmpty {
                break
            }
            
            let hasCompleted = dayProgress.contains { progress in
                if let procedure = procedures.first(where: { $0.id == progress.procedureId }) {
                    return !procedure.steps.isEmpty && progress.completedSteps.count == procedure.steps.count
                }
                return false
            }
            
            if hasCompleted {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }
        
        return streak
    }
    
    private func getDateForWeekDay(_ weekDay: WeekDay, from date: Date) -> Date {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let adjustedWeekday = weekday == 1 ? 7 : weekday - 1
        let targetWeekday = weekDay.rawValue
        
        let daysDifference = targetWeekday - adjustedWeekday
        return calendar.date(byAdding: .day, value: daysDifference, to: date) ?? date
    }
}

#Preview {
    ProgressView(viewModel: ProcedureViewModel())
}
