import SwiftUI

struct ProgressView: View {
    @EnvironmentObject var bookingsVM: BookingsViewModel
    @EnvironmentObject var viewModel: ProgressViewModel
    @EnvironmentObject var profileVM: ProfileViewModel
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            if bookingsVM.bookings.isEmpty {
                emptyStateView
            } else {
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(alignment: .leading, spacing: 24) {
                        headerView
                        statisticsView
                        goalProgressView
                        achievementsView
                        visitChartView
                    }
                    .frame(maxWidth: .infinity)
                    .padding(20)
                    .padding(.bottom, 24)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            viewModel.recalculate(bookings: bookingsVM.bookings, visitGoal: profileVM.profile.visitGoal)
        }
        .onChange(of: bookingsVM.bookings.count) { _ in
            viewModel.recalculate(bookings: bookingsVM.bookings, visitGoal: profileVM.profile.visitGoal)
        }
        .refreshable {
            viewModel.refreshStatistics(bookings: bookingsVM.bookings, visitGoal: profileVM.profile.visitGoal)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "chart.bar.doc.horizontal")
                .font(.system(size: 60))
                .foregroundColor(ColorTheme.secondaryText)
            Text("No data for analysis")
                .font(.playfairBold(size: 22))
                .foregroundColor(ColorTheme.primaryText)
            Text("Add bookings and mark them as completed to see your progress and achievements here.")
                .font(.playfairRegular(size: 16))
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.vertical, 48)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Your Progress")
                    .font(.playfairBold(size: 28))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Track your wellness journey")
                    .font(.playfairRegular(size: 16))
                    .foregroundColor(ColorTheme.secondaryText)
            }
            
            Spacer()
            
            Button(action: { viewModel.recalculate(bookings: bookingsVM.bookings, visitGoal: profileVM.profile.visitGoal) }) {
                Image(systemName: "arrow.clockwise")
                    .font(.title2)
                    .foregroundColor(ColorTheme.primaryText)
                    .padding(12)
                    .background(ColorTheme.cardBackground)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(ColorTheme.cardBorder, lineWidth: 1)
                    )
            }
        }
    }
    
    private var statisticsView: some View {
        LazyVGrid(columns: [GridItem(.flexible(), alignment: .top), GridItem(.flexible(), alignment: .top)], spacing: 16) {
            StatCard(
                title: "Total Visits",
                value: "\(viewModel.statistics.totalVisits)",
                icon: "calendar.badge.checkmark",
                color: ColorTheme.primaryPurple
            )
            
            StatCard(
                title: "This Month",
                value: "\(viewModel.statistics.currentMonthVisits)",
                icon: "calendar",
                color: ColorTheme.primaryBlue
            )
            
            StatCard(
                title: "Average Spent",
                value: viewModel.statistics.formattedAverageSpending,
                icon: "dollarsign.circle",
                color: ColorTheme.accentGreen
            )
            
            StatCard(
                title: "Favorite Service",
                value: viewModel.statistics.favoriteService?.rawValue ?? "None",
                icon: "heart.fill",
                color: ColorTheme.accentPink
            )
        }
    }
    
    private var goalProgressView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Monthly Goal")
                .font(.playfairBold(size: 20))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 12) {
                HStack {
                    Text("4 visits per month")
                        .font(.playfairRegular(size: 16))
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    Spacer()
                    
                    Text("\(viewModel.statistics.visitGoalPercentage)%")
                        .font(.playfairBold(size: 18))
                        .foregroundColor(ColorTheme.primaryText)
                }
                
                ProgressBar(progress: viewModel.statistics.visitGoalProgress)
                
                HStack {
                    Text("\(viewModel.statistics.currentMonthVisits) completed")
                        .font(.playfairRegular(size: 14))
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    Spacer()
                    
                    Text("\(4 - viewModel.statistics.currentMonthVisits) remaining")
                        .font(.playfairRegular(size: 14))
                        .foregroundColor(ColorTheme.secondaryText)
                }
            }
            .padding(16)
            .background(ColorTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var achievementsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Achievements")
                .font(.playfairBold(size: 20))
                .foregroundColor(ColorTheme.primaryText)
            
            LazyVGrid(columns: [GridItem(.flexible(), alignment: .top), GridItem(.flexible(), alignment: .top)], spacing: 12) {
                ForEach(viewModel.statistics.achievements) { achievement in
                    AchievementCard(achievement: achievement)
                }
            }
        }
    }
    
    private var visitChartView: some View {
        let monthlyCounts = monthlyVisitCounts(from: bookingsVM.bookings)
        return VStack(alignment: .leading, spacing: 16) {
            Text("Visit History")
                .font(.playfairBold(size: 20))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 16) {
                GeometryReader { geometry in
                    let maxCount = monthlyCounts.max() ?? 1
                    let spacing: CGFloat = 4
                    let barWidth = max(6, min(20, (geometry.size.width - 11 * spacing) / 12))
                    let barMaxHeight: CGFloat = min(80, geometry.size.width * 0.25)
                    
                    HStack(alignment: .bottom, spacing: spacing) {
                        ForEach(0..<12, id: \.self) { month in
                            VStack(spacing: 2) {
                                let height = maxCount > 0 ? CGFloat(monthlyCounts[month]) / CGFloat(maxCount) * barMaxHeight : 0
                                Rectangle()
                                    .fill(ColorTheme.primaryPurple)
                                    .frame(width: barWidth, height: max(4, height))
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                                
                                Text(monthLabel(month))
                                    .font(.system(size: 9, weight: .medium))
                                    .foregroundColor(ColorTheme.secondaryText)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                .frame(height: 100)
                
                Text("Completed visits by month (last 12 months)")
                    .font(.playfairRegular(size: 14))
                    .foregroundColor(ColorTheme.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(16)
            .background(ColorTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private func monthlyVisitCounts(from bookings: [Booking]) -> [Int] {
        let calendar = Calendar.current
        let now = Date()
        var counts = Array(repeating: 0, count: 12)
        let completed = bookings.filter { $0.status == .completed }
        for booking in completed {
            guard let monthsAgo = calendar.dateComponents([.month], from: booking.date, to: now).month,
                  monthsAgo >= 0, monthsAgo < 12 else { continue }
            counts[11 - monthsAgo] += 1
        }
        return counts
    }
    
    private func monthLabel(_ index: Int) -> String {
        let calendar = Calendar.current
        let now = Date()
        guard let date = calendar.date(byAdding: .month, value: -(11 - index), to: now) else { return "—" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: date)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.playfairBold(size: 24))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text(title)
                    .font(.playfairRegular(size: 14))
                    .foregroundColor(ColorTheme.secondaryText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(ColorTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(ColorTheme.cardBorder, lineWidth: 1)
        )
    }
}

struct ProgressBar: View {
    let progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(ColorTheme.cardBorder)
                    .frame(height: 8)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                
                Rectangle()
                    .fill(ColorTheme.primaryPurple)
                    .frame(width: geometry.size.width * CGFloat(progress), height: 8)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .animation(.easeInOut(duration: 1.0), value: progress)
            }
        }
        .frame(height: 8)
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: achievement.icon)
                    .font(.title2)
                    .foregroundColor(achievement.isUnlocked ? ColorTheme.accentOrange : ColorTheme.secondaryText)
                
                Spacer()
                
                if achievement.isUnlocked {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(ColorTheme.statusSuccess)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.playfairSemiBold(size: 16))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text(achievement.description)
                    .font(.playfairRegular(size: 12))
                    .foregroundColor(ColorTheme.secondaryText)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if !achievement.isUnlocked {
                VStack(spacing: 4) {
                    ProgressBar(progress: achievement.progress)
                    
                    Text("\(achievement.progressPercentage)% complete")
                        .font(.playfairRegular(size: 10))
                        .foregroundColor(ColorTheme.secondaryText)
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(
            achievement.isUnlocked ? 
            ColorTheme.statusSuccess.opacity(0.1) : ColorTheme.cardBackground
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    achievement.isUnlocked ? 
                    ColorTheme.statusSuccess.opacity(0.3) : ColorTheme.cardBorder,
                    lineWidth: 1
                )
        )
    }
}

#Preview {
    ProgressView()
        .environmentObject(BookingsViewModel())
        .environmentObject(ProgressViewModel())
        .environmentObject(ProfileViewModel())
}
