import SwiftUI

struct StatisticsView: View {
    @StateObject private var viewModel = HistoryViewModel()
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Statistics")
                        .font(.ubuntu(.bold, size: AppConstants.headerFontSize))
                        .foregroundColor(AppColors.primaryText)
                    Spacer()
                }
                .padding(.horizontal, AppConstants.mediumSpacing)
                .padding(.vertical, AppConstants.mediumSpacing)
                
                ScrollView {
                    VStack(spacing: AppConstants.largeSpacing) {
                        CardView {
                            VStack(spacing: AppConstants.mediumSpacing) {
                                Text("Your Progress")
                                    .font(.ubuntu(.semiBold, size: AppConstants.largeFontSize))
                                    .foregroundColor(AppColors.primaryText)
                                HStack(spacing: 20) {
                                    StatCard(title: "Current Streak", value: "\(viewModel.getCurrentStreak())", subtitle: "days", iconName: "flame.fill", color: AppColors.primaryOrange)
                                    StatCard(title: "Total Tasks", value: "\(viewModel.getTotalCompletedTasks())", subtitle: "completed", iconName: "checkmark.circle.fill", color: AppColors.success)
                                    StatCard(title: "Challenges", value: "\(viewModel.getTotalCompletedChallenges())", subtitle: "completed", iconName: "star.fill", color: AppColors.primaryOrange)
                                }
                            }
                        }
                        
                        CardView {
                            VStack(alignment: .leading, spacing: AppConstants.mediumSpacing) {
                                Text("Last 7 Days")
                                    .font(.ubuntu(.semiBold, size: AppConstants.largeFontSize))
                                    .foregroundColor(AppColors.primaryText)
                                StatisticsChartView(viewModel: viewModel)
                            }
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

struct StatisticsChartView: View {
    @ObservedObject var viewModel: HistoryViewModel
    
    private let chartHeight: CGFloat = 140
    private let barSpacing: CGFloat = 6
    
    private var last7DaysData: [(date: Date, tasks: Int, challenges: Int)] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (0..<7).reversed().compactMap { offset -> (Date, Int, Int)? in
            guard let date = calendar.date(byAdding: .day, value: -offset, to: today) else { return nil }
            let progress = viewModel.getProgressForDate(date)
            let tasks = progress?.completedTasks.count ?? 0
            let challenges = progress?.completedChallenges.count ?? 0
            return (date, tasks, challenges)
        }
    }
    
    private var maxValue: Int {
        max(1, last7DaysData.flatMap { [$0.tasks, $0.challenges] }.max() ?? 1)
    }
    
    private var dayLabels: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return last7DaysData.map { formatter.string(from: $0.date) }
    }
    
    var body: some View {
        GeometryReader { geo in
            let barWidth = max(8, (geo.size.width - barSpacing * CGFloat(last7DaysData.count - 1)) / CGFloat(last7DaysData.count * 2) - 4)
            VStack(spacing: 12) {
                HStack(alignment: .bottom, spacing: barSpacing) {
                    ForEach(Array(last7DaysData.enumerated()), id: \.offset) { index, day in
                        VStack(spacing: 6) {
                            HStack(alignment: .bottom, spacing: 2) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(AppColors.success.opacity(0.9))
                                    .frame(width: barWidth, height: barHeight(for: day.tasks))
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(AppColors.primaryOrange.opacity(0.9))
                                    .frame(width: barWidth, height: barHeight(for: day.challenges))
                            }
                            .frame(height: chartHeight, alignment: .bottom)
                            Text(dayLabels[index])
                                .font(.ubuntu(.medium, size: 9))
                                .foregroundColor(AppColors.tertiaryText)
                                .lineLimit(1)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .frame(height: chartHeight + 24)
                HStack(spacing: 16) {
                    HStack(spacing: 6) {
                        RoundedRectangle(cornerRadius: 2).fill(AppColors.success).frame(width: 10, height: 10)
                        Text("Tasks").font(.ubuntu(.regular, size: 10)).foregroundColor(AppColors.secondaryText)
                    }
                    HStack(spacing: 6) {
                        RoundedRectangle(cornerRadius: 2).fill(AppColors.primaryOrange).frame(width: 10, height: 10)
                        Text("Challenges").font(.ubuntu(.regular, size: 10)).foregroundColor(AppColors.secondaryText)
                    }
                }
            }
        }
        .frame(height: chartHeight + 60)
    }
    
    private func barHeight(for value: Int) -> CGFloat {
        guard maxValue > 0 else { return 0 }
        return max(4, chartHeight * CGFloat(value) / CGFloat(maxValue))
    }
}

#Preview {
    StatisticsView()
}
