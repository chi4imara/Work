import SwiftUI

struct StatisticsView: View {
    @ObservedObject var practiceViewModel: PracticeViewModel
    
    private var totalSessions: Int {
        practiceViewModel.history.count
    }
    
    private var totalMinutes: Int {
        practiceViewModel.history.reduce(0) { $0 + $1.duration }
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Statistics")
                        .font(.appTitle)
                        .foregroundColor(AppColors.primaryNavy)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 25) {
                        overviewSection
                        
                        streakSection
                        
                        activitySection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
            }
        }
    }
    
    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Overview")
                .font(.screenTitle)
                .foregroundColor(AppColors.primaryNavy)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                StatOverviewCard(
                    title: "Total Sessions",
                    value: "\(totalSessions)",
                    icon: "checkmark.circle.fill",
                    color: AppColors.softGreen
                )
                
                StatOverviewCard(
                    title: "Total Time",
                    value: "\(totalMinutes) min",
                    icon: "clock.fill",
                    color: AppColors.lightBlue
                )
                
                StatOverviewCard(
                    title: "Current Streak",
                    value: "\(practiceViewModel.streakData.currentStreak)",
                    subtitle: "days",
                    icon: "flame.fill",
                    color: AppColors.primaryOrange
                )
                
                StatOverviewCard(
                    title: "Longest Streak",
                    value: "\(practiceViewModel.streakData.longestStreak)",
                    subtitle: "days",
                    icon: "trophy.fill",
                    color: AppColors.primaryNavy
                )
            }
        }
    }
    
    private var streakSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Streak")
                .font(.screenTitle)
                .foregroundColor(AppColors.primaryNavy)
            
            HStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text("\(practiceViewModel.streakData.currentStreak)")
                        .font(.playfairBold(size: 36))
                        .foregroundColor(AppColors.primaryOrange)
                    Text("Days in a row")
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(AppColors.cardGradient)
                .cornerRadius(16)
                .shadow(color: AppColors.primaryNavy.opacity(0.1), radius: 8, x: 0, y: 4)
                
                VStack(spacing: 8) {
                    Text("\(practiceViewModel.streakData.totalDays)")
                        .font(.playfairBold(size: 36))
                        .foregroundColor(AppColors.lightBlue)
                    Text("Total days")
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(AppColors.cardGradient)
                .cornerRadius(16)
                .shadow(color: AppColors.primaryNavy.opacity(0.1), radius: 8, x: 0, y: 4)
            }
        }
    }
    
    private var activitySection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Recent Activity")
                .font(.screenTitle)
                .foregroundColor(AppColors.primaryNavy)
            
            let recentEntries = Array(practiceViewModel.history.sorted { $0.completedAt > $1.completedAt }.prefix(7))
            
            if recentEntries.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "chart.bar.doc.horizontal")
                        .font(.system(size: 44))
                        .foregroundColor(AppColors.mediumGray)
                    Text("No activity yet")
                        .font(.bodyText)
                        .foregroundColor(AppColors.secondaryText)
                    Text("Complete practices to see your statistics")
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(30)
                .background(AppColors.cardGradient)
                .cornerRadius(16)
            } else {
                VStack(spacing: 10) {
                    ForEach(recentEntries) { entry in
                        HStack(spacing: 12) {
                            Image(systemName: entry.practiceType.icon)
                                .font(.system(size: 18))
                                .foregroundColor(AppColors.primaryOrange)
                                .frame(width: 36, height: 36)
                                .background(AppColors.primaryOrange.opacity(0.1))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(entry.practiceName)
                                    .font(.cardTitle)
                                    .foregroundColor(AppColors.primaryNavy)
                                Text(entry.completedAt, style: .date)
                                    .font(.caption)
                                    .foregroundColor(AppColors.secondaryText)
                            }
                            
                            Spacer()
                            
                            Text("\(entry.duration) min")
                                .font(.caption)
                                .foregroundColor(AppColors.secondaryText)
                        }
                        .padding(12)
                        .background(AppColors.cardGradient)
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
}

struct StatOverviewCard: View {
    let title: String
    let value: String
    var subtitle: String = ""
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                Spacer()
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.playfairBold(size: 22))
                    .foregroundColor(AppColors.primaryNavy)
                Text(title)
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.smallCaption)
                        .foregroundColor(AppColors.mediumGray)
                }
            }
        }
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.primaryNavy.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView(practiceViewModel: PracticeViewModel())
    }
}
