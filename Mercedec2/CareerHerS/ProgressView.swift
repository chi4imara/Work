import SwiftUI
import Charts

struct ProgressScreen: View {
    @ObservedObject private var viewModel = ProgressViewModel.shared
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                HStack {
                    Text("Progress")
                        .font(.custom("PlayfairDisplay-Bold", size: 28))
                        .foregroundColor(Color.theme.primaryBlue)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if let progressData = viewModel.progressData {
                    ScrollView(showsIndicators: false) {
                        VStack {
                            HStack(spacing: 16) {
                                StatCard(
                                    title: "Courses\nCompleted",
                                    value: "\(progressData.totalCoursesCompleted)",
                                    icon: "book.circle.fill",
                                    color: Color.theme.primaryBlue
                                )
                                
                                StatCard(
                                    title: "Hours\nSpent",
                                    value: "\(Int(progressData.totalTimeSpent / 3600))",
                                    icon: "clock.circle.fill",
                                    color: Color.theme.accentOrange
                                )
                            }
                            .padding(.horizontal, 20)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Daily Activity")
                                    .font(.custom("PlayfairDisplay-SemiBold", size: 20))
                                    .foregroundColor(Color.theme.primaryBlue)
                                    .padding(.horizontal, 20)
                                
                                ActivityChart(data: progressData.dailyActivity)
                                    .frame(height: 200)
                                    .padding(.horizontal, 20)
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Time by Skills")
                                    .font(.custom("PlayfairDisplay-SemiBold", size: 20))
                                    .foregroundColor(Color.theme.primaryBlue)
                                    .padding(.horizontal, 20)
                                
                                SkillDistributionChart(data: progressData.skillDistribution)
                                    .padding(.horizontal, 20)
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Recent Achievements")
                                    .font(.custom("PlayfairDisplay-SemiBold", size: 20))
                                    .foregroundColor(Color.theme.primaryBlue)
                                    .padding(.horizontal, 20)
                                
                                LazyVStack(spacing: 12) {
                                    ForEach(viewModel.achievements) { achievement in
                                        AchievementRow(achievement: achievement)
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.bottom, 120)
                    }
                } else {
                    EmptyProgressView()
                }
            }
        }
    }
}


struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)
            
            Text(value)
                .font(.custom("PlayfairDisplay-Bold", size: 24))
                .foregroundColor(Color.theme.primaryBlue)
            
            Text(title)
                .font(.custom("PlayfairDisplay-Medium", size: 12))
                .foregroundColor(Color.theme.darkGray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color.theme.cardGradient)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct ActivityChart: View {
    let data: [ActivityPoint]
    
    var body: some View {
        VStack {
            if #available(iOS 16.0, *) {
                Chart(data) { point in
                    LineMark(
                        x: .value("Date", point.date),
                        y: .value("Activity", point.value)
                    )
                    .foregroundStyle(Color.theme.primaryBlue)
                    .lineStyle(StrokeStyle(lineWidth: 3))
                    
                    AreaMark(
                        x: .value("Date", point.date),
                        y: .value("Activity", point.value)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.theme.primaryBlue.opacity(0.3), Color.clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day, count: 7)) { _ in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.month().day())
                    }
                }
                .chartYAxis {
                    AxisMarks { _ in
                        AxisGridLine()
                        AxisValueLabel()
                    }
                }
            } else {
                SimpleLineChart(data: data)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct SimpleLineChart: View {
    let data: [ActivityPoint]
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                guard !data.isEmpty else { return }
                
                let maxValue = data.map(\.value).max() ?? 1
                let stepX = geometry.size.width / CGFloat(data.count - 1)
                let stepY = geometry.size.height / CGFloat(maxValue)
                
                path.move(to: CGPoint(x: 0, y: geometry.size.height - CGFloat(data[0].value) * stepY))
                
                for i in 1..<data.count {
                    let point = CGPoint(
                        x: CGFloat(i) * stepX,
                        y: geometry.size.height - CGFloat(data[i].value) * stepY
                    )
                    path.addLine(to: point)
                }
            }
            .stroke(Color.theme.primaryBlue, lineWidth: 3)
        }
    }
}

struct SkillDistributionChart: View {
    let data: [SkillProgress]
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(data) { skillProgress in
                HStack {
                    Text(skillProgress.skill)
                        .font(.custom("PlayfairDisplay-Medium", size: 14))
                        .foregroundColor(Color.theme.primaryBlue)
                        .frame(width: 120, alignment: .leading)
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.theme.lightGray)
                                .frame(height: 8)
                                .cornerRadius(4)
                            
                            Rectangle()
                                .fill(Color.theme.primaryYellow)
                                .frame(width: geometry.size.width * skillProgress.percentage / 100, height: 8)
                                .cornerRadius(4)
                        }
                    }
                    .frame(height: 8)
                    
                    Text("\(Int(skillProgress.percentage))%")
                        .font(.custom("PlayfairDisplay-SemiBold", size: 12))
                        .foregroundColor(Color.theme.primaryBlue)
                        .frame(width: 40, alignment: .trailing)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct AchievementRow: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: achievementIcon)
                .font(.system(size: 24))
                .foregroundColor(achievementColor)
                .frame(width: 40, height: 40)
                .background(achievementColor.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                    .foregroundColor(Color.theme.primaryBlue)
                
                HStack {
                    Text(achievement.skill)
                        .font(.custom("PlayfairDisplay-Medium", size: 12))
                        .foregroundColor(Color.theme.accentOrange)
                    
                    Spacer()
                    
                    Text(achievement.completedDate, style: .date)
                        .font(.custom("PlayfairDisplay-Regular", size: 12))
                        .foregroundColor(Color.theme.darkGray)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private var achievementIcon: String {
        switch achievement.type {
        case .courseCompleted:
            return "book.circle.fill"
        case .skillMastered:
            return "star.circle.fill"
        case .goalAchieved:
            return "target"
        }
    }
    
    private var achievementColor: Color {
        switch achievement.type {
        case .courseCompleted:
            return Color.theme.primaryBlue
        case .skillMastered:
            return Color.theme.primaryYellow
        case .goalAchieved:
            return Color.theme.softGreen
        }
    }
}

struct EmptyProgressView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 60))
                .foregroundColor(Color.theme.primaryBlue.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No data for analysis")
                    .font(.custom("PlayfairDisplay-SemiBold", size: 20))
                    .foregroundColor(Color.theme.primaryBlue)
                
                Text("Start your first course to see progress")
                    .font(.custom("PlayfairDisplay-Regular", size: 16))
                    .foregroundColor(Color.theme.darkGray)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(40)
    }
}

#Preview {
    ProgressScreen()
}
