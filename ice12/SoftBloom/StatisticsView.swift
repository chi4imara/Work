import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: GratitudeViewModel
    
    private var statistics: GratitudeStatistics {
        viewModel.calculateStatistics()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                GradientBackground()
                
                if viewModel.entries.isEmpty {
                    VStack(spacing: 24) {
                        Spacer()
                        
                        Image(systemName: "chart.bar")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(.accentBlue.opacity(0.6))
                        
                        VStack(spacing: 12) {
                            Text("Statistics will appear after your first gratitude")
                                .font(.playfairDisplay(size: 20, weight: .bold))
                                .foregroundColor(.primaryPurple)
                                .multilineTextAlignment(.center)
                            
                            Text("Start your gratitude journey to see your progress and streaks here.")
                                .font(.playfairDisplay(size: 16))
                                .foregroundColor(.darkGray)
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                                .padding(.horizontal, 20)
                        }
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(spacing: 8) {
                                Text("Statistics & Streaks")
                                    .font(.playfairDisplay(size: 28, weight: .bold))
                                    .foregroundColor(.primaryPurple)
                                
                                Text("Your gratitude journey overview")
                                    .font(.playfairDisplay(size: 16))
                                    .foregroundColor(.accentBlue)
                            }
                            .padding(.top, 20)
                            
                            VStack(spacing: 16) {
                                StatCard(
                                    title: "Total Days with Gratitude",
                                    value: "\(statistics.totalDays)",
                                    icon: "heart.fill",
                                    color: .accentYellow
                                )
                                
                                StatCard(
                                    title: "Current Streak",
                                    value: "\(statistics.currentStreak) days in a row",
                                    icon: "flame.fill",
                                    color: .primaryPurple
                                )
                                
                                StatCard(
                                    title: "Best Streak",
                                    value: "\(statistics.bestStreak) days in a row",
                                    icon: "star.fill",
                                    color: .accentBlue
                                )
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Image(systemName: "calendar.badge.clock")
                                        .font(.system(size: 20))
                                        .foregroundColor(.softGreen)
                                    
                                    Text("Days of Week")
                                        .font(.playfairDisplay(size: 20, weight: .bold))
                                        .foregroundColor(.primaryPurple)
                                    
                                    Spacer()
                                }
                                
                                Text("Entries in the last 8 weeks")
                                    .font(.playfairDisplay(size: 14))
                                    .foregroundColor(.accentBlue)
                                
                                VStack(spacing: 8) {
                                    ForEach(["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"], id: \.self) { day in
                                        WeekdayRow(
                                            day: day,
                                            count: statistics.weekdayStats[day] ?? 0
                                        )
                                    }
                                }
                            }
                            .padding(20)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .font(.system(size: 20))
                                        .foregroundColor(.accentYellow)
                                    
                                    Text("Monthly Progress")
                                        .font(.playfairDisplay(size: 20, weight: .bold))
                                        .foregroundColor(.primaryPurple)
                                    
                                    Spacer()
                                }
                                
                                VStack(spacing: 12) {
                                    ProgressRow(
                                        title: "Entries this month",
                                        value: "\(statistics.monthlyProgress.entriesThisMonth)"
                                    )
                                    
                                    ProgressRow(
                                        title: "Missed days",
                                        value: "\(statistics.monthlyProgress.missedDays)"
                                    )
                                    
                                    ProgressRow(
                                        title: "Month completion",
                                        value: "\(statistics.monthlyProgress.completionPercentage)%"
                                    )
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("Completion")
                                            .font(.playfairDisplay(size: 14, weight: .medium))
                                            .foregroundColor(.darkGray)
                                        
                                        Spacer()
                                        
                                        Text("\(statistics.monthlyProgress.completionPercentage)%")
                                            .font(.playfairDisplay(size: 14, weight: .bold))
                                            .foregroundColor(.accentBlue)
                                    }
                                    
                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            Rectangle()
                                                .fill(Color.lightGray.opacity(0.3))
                                                .frame(height: 8)
                                                .cornerRadius(4)
                                            
                                            Rectangle()
                                                .fill(Color.accentGradient)
                                                .frame(
                                                    width: geometry.size.width * CGFloat(statistics.monthlyProgress.completionPercentage) / 100,
                                                    height: 8
                                                )
                                                .cornerRadius(4)
                                        }
                                    }
                                    .frame(height: 8)
                                }
                            }
                            .padding(20)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                            
                            Spacer(minLength: 20)
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.playfairDisplay(size: 14, weight: .medium))
                    .foregroundColor(.darkGray)
                
                Text(value)
                    .font(.playfairDisplay(size: 18, weight: .bold))
                    .foregroundColor(.primaryPurple)
            }
            
            Spacer()
        }
        .padding(20)
        .background(Color.white.opacity(0.9))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct WeekdayRow: View {
    let day: String
    let count: Int
    
    var body: some View {
        HStack {
            Text(day.prefix(3).uppercased())
                .font(.playfairDisplay(size: 14, weight: .medium))
                .foregroundColor(.darkGray)
                .frame(width: 40, alignment: .leading)
            
            Spacer()
            
            Text("\(count)")
                .font(.playfairDisplay(size: 16, weight: .bold))
                .foregroundColor(.accentBlue)
        }
        .padding(.vertical, 4)
    }
}

struct ProgressRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.playfairDisplay(size: 16))
                .foregroundColor(.darkGray)
            
            Spacer()
            
            Text(value)
                .font(.playfairDisplay(size: 16, weight: .bold))
                .foregroundColor(.primaryPurple)
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = GratitudeViewModel()
        viewModel.addEntry(text: "Grateful for the beautiful sunrise", for: Date())
        viewModel.addEntry(text: "Thankful for my family", for: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date())
        
        return StatisticsView(viewModel: viewModel)
    }
}
