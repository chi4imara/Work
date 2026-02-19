import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: EventsViewModel
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Statistics")
                        .font(.custom("PlayfairDisplay-Bold", size: 32))
                        .foregroundColor(ColorTheme.textPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.events.isEmpty {
                    EmptyStatisticsView()
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            OverviewCards(viewModel: viewModel)
                            
                            ActivityChart(viewModel: viewModel)
                            
                            MonthlyBreakdown(viewModel: viewModel)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
    }
}

struct EmptyStatisticsView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(ColorTheme.primaryBlue.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No statistics yet")
                    .font(.custom("PlayfairDisplay-Medium", size: 18))
                    .foregroundColor(ColorTheme.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text("Start adding events to see your statistics")
                    .font(.custom("PlayfairDisplay-Regular", size: 16))
                    .foregroundColor(ColorTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct OverviewCards: View {
    @ObservedObject var viewModel: EventsViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                StatCard(
                    title: "Total Events",
                    value: "\(viewModel.totalEventsCount)",
                    icon: "list.bullet",
                    color: ColorTheme.primaryBlue
                )
                
                StatCard(
                    title: "This Week",
                    value: "\(viewModel.eventsThisWeek)",
                    icon: "calendar",
                    color: ColorTheme.accentYellow
                )
            }
            
            HStack(spacing: 16) {
                StatCard(
                    title: "This Month",
                    value: "\(viewModel.eventsThisMonth)",
                    icon: "chart.bar.fill",
                    color: ColorTheme.successGreen
                )
                
                if let mostActive = viewModel.mostActiveDay {
                    StatCard(
                        title: "Most Active",
                        value: "\(mostActive.count)",
                        icon: "star.fill",
                        color: ColorTheme.deleteRed
                    )
                } else {
                    StatCard(
                        title: "Most Active",
                        value: "0",
                        icon: "star.fill",
                        color: ColorTheme.deleteRed
                    )
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
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.custom("PlayfairDisplay-Bold", size: 32))
                    .foregroundColor(ColorTheme.textPrimary)
                
                Text(title)
                    .font(.custom("PlayfairDisplay-Regular", size: 14))
                    .foregroundColor(ColorTheme.textSecondary)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(ColorTheme.cardBackground)
        .cornerRadius(16)
        .shadow(color: ColorTheme.shadowColor, radius: 8, x: 0, y: 4)
    }
}

struct ActivityChart: View {
    @ObservedObject var viewModel: EventsViewModel
    
    var weeklyData: [(day: String, count: Int)] {
        let calendar = Calendar.current
        let today = Date()
        var data: [(day: String, count: Int)] = []
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: -6 + i, to: today) {
                let dayStart = calendar.startOfDay(for: date)
                let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)!
                
                let count = viewModel.events.filter { event in
                    event.timestamp >= dayStart && event.timestamp < dayEnd
                }.count
                
                data.append((day: formatter.string(from: date), count: count))
            }
        }
        
        return data
    }
    
    var maxCount: Int {
        weeklyData.map { $0.count }.max() ?? 1
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Activity")
                .font(.custom("PlayfairDisplay-SemiBold", size: 20))
                .foregroundColor(ColorTheme.textPrimary)
            
            VStack(spacing: 12) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .bottom, spacing: 8) {
                        ForEach(weeklyData, id: \.day) { data in
                            VStack(spacing: 8) {
                                ZStack(alignment: .bottom) {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(ColorTheme.primaryBlue.opacity(0.2))
                                        .frame(width: 40, height: 120)
                                    
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(
                                            LinearGradient(
                                                colors: [ColorTheme.primaryBlue, ColorTheme.accentYellow],
                                                startPoint: .bottom,
                                                endPoint: .top
                                            )
                                        )
                                        .frame(
                                            width: 40,
                                            height: maxCount > 0 ? CGFloat(data.count) / CGFloat(maxCount) * 120 : 0
                                        )
                                }
                                
                                Text(data.day)
                                    .font(.custom("PlayfairDisplay-Regular", size: 12))
                                    .foregroundColor(ColorTheme.textSecondary)
                                
                                Text("\(data.count)")
                                    .font(.custom("PlayfairDisplay-SemiBold", size: 14))
                                    .foregroundColor(ColorTheme.textPrimary)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.horizontal, -20)
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(ColorTheme.cardBackground)
            .cornerRadius(16)
            .shadow(color: ColorTheme.shadowColor, radius: 8, x: 0, y: 4)
        }
    }
}

struct MonthlyBreakdown: View {
    @ObservedObject var viewModel: EventsViewModel
    
    var monthlyData: [(month: String, count: Int)] {
        let grouped = viewModel.eventsByMonth
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        
        return grouped.map { (month: $0.key, count: $0.value.count) }
            .sorted { formatter.date(from: $0.month) ?? Date() > formatter.date(from: $1.month) ?? Date() }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Monthly Breakdown")
                .font(.custom("PlayfairDisplay-SemiBold", size: 20))
                .foregroundColor(ColorTheme.textPrimary)
            
            VStack(spacing: 12) {
                ForEach(monthlyData.prefix(6), id: \.month) { data in
                    HStack {
                        Text(data.month)
                            .font(.custom("PlayfairDisplay-Medium", size: 16))
                            .foregroundColor(ColorTheme.textPrimary)
                        
                        Spacer()
                        
                        HStack(spacing: 8) {
                            Text("\(data.count)")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                                .foregroundColor(ColorTheme.textPrimary)
                            
                            Image(systemName: "circle.fill")
                                .font(.system(size: 8))
                                .foregroundColor(ColorTheme.accentYellow)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(ColorTheme.cardBackground)
                    .cornerRadius(12)
                }
            }
        }
    }
}
