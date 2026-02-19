import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("History")
                        .font(.ubuntu(.bold, size: AppConstants.headerFontSize))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, AppConstants.mediumSpacing)
                .padding(.vertical, AppConstants.mediumSpacing)
                
                ScrollView {
                    VStack(spacing: AppConstants.largeSpacing) {
                        StatsSection(viewModel: viewModel)
                        
                        CalendarSection(viewModel: viewModel)
                        
                        if let selectedProgress = viewModel.selectedDayProgress {
                            DayDetailsSection(
                                progress: selectedProgress,
                                selectedDate: viewModel.selectedDate
                            )
                        }
                    }
                    .padding(.horizontal, AppConstants.mediumSpacing)
                    .padding(.top, AppConstants.mediumSpacing)
                    .padding(.bottom, 120)
                }
            }
        }
        .onAppear {
            viewModel.loadHistoryData()
        }
    }
}

struct StatsSection: View {
    @ObservedObject var viewModel: HistoryViewModel
    
    var body: some View {
        CardView {
            VStack(spacing: AppConstants.mediumSpacing) {
                Text("Your Progress")
                    .font(.ubuntu(.semiBold, size: AppConstants.largeFontSize))
                    .foregroundColor(AppColors.primaryText)
                
                HStack(spacing: 20) {
                    StatCard(
                        title: "Current Streak",
                        value: "\(viewModel.getCurrentStreak())",
                        subtitle: "days",
                        iconName: "flame.fill",
                        color: AppColors.primaryOrange
                    )
                    
                    StatCard(
                        title: "Total Tasks",
                        value: "\(viewModel.getTotalCompletedTasks())",
                        subtitle: "completed",
                        iconName: "checkmark.circle.fill",
                        color: AppColors.success
                    )
                    
                    StatCard(
                        title: "Challenges",
                        value: "\(viewModel.getTotalCompletedChallenges())",
                        subtitle: "completed",
                        iconName: "star.fill",
                        color: AppColors.primaryOrange
                    )
                }
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let iconName: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: iconName)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(.ubuntu(.bold, size: 20))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.ubuntu(.medium, size: 10))
                    .foregroundColor(AppColors.secondaryText)
                
                Text(subtitle)
                    .font(.ubuntu(.regular, size: 9))
                    .foregroundColor(AppColors.tertiaryText)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct CalendarSection: View {
    @ObservedObject var viewModel: HistoryViewModel
    
    var body: some View {
        CardView {
            VStack(spacing: AppConstants.mediumSpacing) {
                HStack {
                    Button(action: viewModel.goToPreviousMonth) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(AppColors.primaryOrange)
                    }
                    
                    Spacer()
                    
                    Text(viewModel.monthYearString)
                        .font(.ubuntu(.semiBold, size: AppConstants.largeFontSize))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button(action: viewModel.goToNextMonth) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(AppColors.primaryOrange)
                    }
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                    ForEach(Array(["S", "M", "T", "W", "T", "F", "S"].enumerated()), id: \.offset) { _, day in
                        Text(day)
                            .font(.ubuntu(.medium, size: AppConstants.smallFontSize))
                            .foregroundColor(AppColors.tertiaryText)
                            .frame(height: 30)
                    }
                    
                    ForEach(viewModel.monthDates, id: \.self) { date in
                        CalendarDayView(
                            date: date,
                            isSelected: Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate),
                            hasProgress: viewModel.hasProgressForDate(date),
                            progressPercentage: viewModel.getProgressPercentage(for: date)
                        ) {
                            viewModel.selectDate(date)
                        }
                    }
                }
            }
        }
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let hasProgress: Bool
    let progressPercentage: Double
    let onTap: () -> Void
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                Circle()
                    .fill(
                        isSelected ? AppColors.primaryOrange :
                        isToday ? AppColors.primaryOrange.opacity(0.3) :
                        Color.clear
                    )
                    .frame(width: 36, height: 36)
                
                if hasProgress {
                    Circle()
                        .trim(from: 0, to: progressPercentage)
                        .stroke(
                            isSelected ? AppColors.primaryText : AppColors.primaryOrange,
                            style: StrokeStyle(lineWidth: 2, lineCap: .round)
                        )
                        .frame(width: 32, height: 32)
                        .rotationEffect(.degrees(-90))
                }
                
                Text(dayNumber)
                    .font(.ubuntu(.medium, size: AppConstants.smallFontSize))
                    .foregroundColor(
                        isSelected ? AppColors.primaryText :
                        isToday ? AppColors.primaryOrange :
                        AppColors.secondaryText
                    )
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(height: 40)
        .animation(.easeInOut(duration: AppConstants.shortAnimation), value: isSelected)
    }
}

struct DayDetailsSection: View {
    let progress: DailyProgress
    let selectedDate: Date
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter.string(from: selectedDate)
    }
    
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: AppConstants.mediumSpacing) {
                Text(dateString)
                    .font(.ubuntu(.semiBold, size: AppConstants.largeFontSize))
                    .foregroundColor(AppColors.primaryText)
                
                if let energyRecord = progress.energyRecord, !energyRecord.energyLevels.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Energy Assessment")
                            .font(.ubuntu(.medium, size: AppConstants.mediumFontSize))
                            .foregroundColor(AppColors.secondaryText)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                            ForEach(energyRecord.energyLevels, id: \.id) { energy in
                                HStack(spacing: 6) {
                                    Image(systemName: energy.type.iconName)
                                        .font(.system(size: 12))
                                        .foregroundColor(AppColors.primaryOrange)
                                    
                                    Text(energy.type.displayName)
                                        .font(.ubuntu(.regular, size: 10))
                                        .foregroundColor(AppColors.tertiaryText)
                                        .lineLimit(1)
                                }
                                .padding(.horizontal, 6)
                                .padding(.vertical, 4)
                                .background(AppColors.primaryOrange.opacity(0.1))
                                .cornerRadius(AppConstants.smallCornerRadius)
                            }
                        }
                    }
                }
                
                if !progress.completedTasks.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Completed Tasks (\(progress.completedTasks.count))")
                            .font(.ubuntu(.medium, size: AppConstants.mediumFontSize))
                            .foregroundColor(AppColors.secondaryText)
                        
                        ForEach(progress.completedTasks, id: \.id) { task in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppColors.success)
                                
                                Text(task.title)
                                    .font(.ubuntu(.regular, size: AppConstants.smallFontSize))
                                    .foregroundColor(AppColors.tertiaryText)
                                    .lineLimit(1)
                                
                                Spacer()
                            }
                        }
                    }
                }
                
                if !progress.completedChallenges.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Completed Challenges (\(progress.completedChallenges.count))")
                            .font(.ubuntu(.medium, size: AppConstants.mediumFontSize))
                            .foregroundColor(AppColors.secondaryText)
                        
                        ForEach(progress.completedChallenges, id: \.id) { challenge in
                            HStack {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppColors.primaryOrange)
                                
                                Text(challenge.title)
                                    .font(.ubuntu(.regular, size: AppConstants.smallFontSize))
                                    .foregroundColor(AppColors.tertiaryText)
                                    .lineLimit(1)
                                
                                Spacer()
                            }
                        }
                    }
                }
                
                if let diary = progress.diaryEntry, !diary.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Journal Entry")
                            .font(.ubuntu(.medium, size: AppConstants.mediumFontSize))
                            .foregroundColor(AppColors.secondaryText)
                        
                        if !diary.thoughts.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Thoughts:")
                                    .font(.ubuntu(.medium, size: AppConstants.smallFontSize))
                                    .foregroundColor(AppColors.tertiaryText)
                                
                                Text(diary.thoughts)
                                    .font(.ubuntu(.regular, size: AppConstants.smallFontSize))
                                    .foregroundColor(AppColors.tertiaryText)
                                    .lineLimit(3)
                            }
                        }
                        
                        if !diary.achievements.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Achievements:")
                                    .font(.ubuntu(.medium, size: AppConstants.smallFontSize))
                                    .foregroundColor(AppColors.tertiaryText)
                                
                                Text(diary.achievements)
                                    .font(.ubuntu(.regular, size: AppConstants.smallFontSize))
                                    .foregroundColor(AppColors.tertiaryText)
                                    .lineLimit(3)
                            }
                        }
                    }
                }
                
                HStack {
                    Text("Daily Progress:")
                        .font(.ubuntu(.medium, size: AppConstants.mediumFontSize))
                        .foregroundColor(AppColors.secondaryText)
                    
                    Spacer()
                    
                    Text("\(Int(progress.progressPercentage * 100))%")
                        .font(.ubuntu(.semiBold, size: AppConstants.mediumFontSize))
                        .foregroundColor(AppColors.primaryOrange)
                }
            }
        }
    }
}

#Preview {
    HistoryView()
}
