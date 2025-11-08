import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject private var meetingStore: MeetingStore
    @State private var selectedPeriod: StatisticsPeriod = .month
    @State private var selectedMeeting: Meeting?
    
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("Statistics")
                            .font(.theme.title1)
                            .foregroundColor(Color.theme.primaryText)
                        
                        Spacer()
                    }
                    .padding()
                    
                    if meetingStore.meetings.isEmpty {
                        emptyStateView
                    } else {
                        statisticsContent
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(item: $selectedMeeting) { meeting in
                MeetingDetailView(meeting: meeting, meetingStore: meetingStore)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "chart.bar")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(Color.theme.lightText)
            
            VStack(spacing: 12) {
                Text("Not enough data for statistics")
                    .font(.theme.title3)
                    .foregroundColor(Color.theme.primaryText)
                
                Text("Add some meetings to see your patterns")
                    .font(.theme.body)
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button("Add Meeting") {
                selectedTab = 0
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var statisticsContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                periodSelector
                
                statisticsCards
                
                chartsSection
                
                Spacer(minLength: 100) 
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Statistics")
                .font(.theme.title1)
                .foregroundColor(Color.theme.primaryText)
            
            Spacer()
        }
        .padding(.top, 10)
    }
    
    private var periodSelector: some View {
        HStack(spacing: 0) {
            ForEach(StatisticsPeriod.allCases, id: \.self) { period in
                Button(action: {
                    selectedPeriod = period
                }) {
                    Text(period.localizedString)
                        .font(.theme.subheadline)
                        .foregroundColor(selectedPeriod == period ? Color.white : Color.theme.primaryText)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(selectedPeriod == period ? Color.theme.primaryBlue : Color.clear)
                        )
                }
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.8))
                .shadow(color: Color.theme.shadowColor, radius: 2, x: 0, y: 1)
        )
    }
    
    private var statisticsCards: some View {
        let stats = meetingStore.statisticsForPeriod(selectedPeriod)
        
        return LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 12) {
            StatCard(
                title: "Total Meetings",
                value: "\(stats.totalMeetings)",
                icon: "person.2.fill",
                color: Color.theme.primaryBlue
            )
            
            StatCard(
                title: "Active Days",
                value: "\(stats.uniqueDays)",
                icon: "calendar",
                color: Color.theme.accentTeal
            )
            
            StatCard(
                title: "Avg per Week",
                value: String(format: "%.1f", stats.averagePerWeek),
                icon: "chart.line.uptrend.xyaxis",
                color: Color.theme.primaryPurple
            )
            
            if let mostActive = stats.mostActiveDay {
                StatCard(
                    title: "Most Active",
                    value: "\(mostActive.count)",
                    subtitle: formatDate(mostActive.date),
                    icon: "star.fill",
                    color: Color.theme.softPink
                )
            } else {
                StatCard(
                    title: "Most Active",
                    value: "0",
                    icon: "star.fill",
                    color: Color.theme.softPink
                )
            }
        }
    }
    
    private var chartsSection: some View {
        VStack(spacing: 24) {
            weekdayChart
            
            if !meetingStore.statisticsForPeriod(selectedPeriod).topLocations.isEmpty {
                topLocationsChart
            }
        }
    }
    
    private var weekdayChart: some View {
        let stats = meetingStore.statisticsForPeriod(selectedPeriod)
        let weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        let chartData = weekdays.enumerated().map { index, day in
            WeekdayData(day: day, count: stats.weekdayDistribution[index])
        }
        
        return VStack(alignment: .leading, spacing: 16) {
            Text("Meetings by Weekday")
                .font(.theme.headline)
                .foregroundColor(Color.theme.primaryText)
            
            SimpleBarChart(data: chartData)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.theme.cardGradient)
                .shadow(color: Color.theme.cardShadow, radius: 4, x: 0, y: 2)
        )
    }
    
    private var topLocationsChart: some View {
        let stats = meetingStore.statisticsForPeriod(selectedPeriod)
        
        return VStack(alignment: .leading, spacing: 16) {
            Text("Top Locations")
                .font(.theme.headline)
                .foregroundColor(Color.theme.primaryText)
            
            VStack(spacing: 8) {
                ForEach(Array(stats.topLocations.prefix(5).enumerated()), id: \.offset) { index, location in
                    LocationRow(
                        location: location.location,
                        count: location.count,
                        color: locationColors[index % locationColors.count]
                    )
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.theme.cardGradient)
                .shadow(color: Color.theme.cardShadow, radius: 4, x: 0, y: 2)
        )
    }
    
    private let locationColors = [
        Color.theme.primaryBlue,
        Color.theme.primaryPurple,
        Color.theme.accentTeal,
        Color.theme.softPink,
        Color.theme.successGreen
    ]
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        return formatter.string(from: date)
    }
}

struct WeekdayData: Identifiable {
    let id = UUID()
    let day: String
    let count: Int
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String?
    let icon: String
    let color: Color
    
    init(title: String, value: String, subtitle: String? = nil, icon: String, color: Color) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.icon = icon
        self.color = color
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.theme.title2)
                    .foregroundColor(Color.theme.primaryText)
                
                Text(title)
                    .font(.theme.caption)
                    .foregroundColor(Color.theme.secondaryText)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.theme.caption2)
                        .foregroundColor(Color.theme.lightText)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.theme.cardGradient)
                .shadow(color: Color.theme.cardShadow, radius: 2, x: 0, y: 1)
        )
    }
}

struct LocationRow: View {
    let location: String
    let count: Int
    let color: Color
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(location)
                .font(.theme.body)
                .foregroundColor(Color.theme.primaryText)
            
            Spacer()
            
            Text("\(count)")
                .font(.theme.subheadline)
                .foregroundColor(Color.theme.secondaryText)
        }
    }
}

struct SimpleBarChart: View {
    let data: [WeekdayData]
    
    private var maxCount: Int {
        data.map(\.count).max() ?? 1
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(data) { item in
                VStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.theme.primaryBlue.gradient)
                        .frame(width: 30, height: CGFloat(item.count) / CGFloat(maxCount) * 150)
                    
                    Text(item.day)
                        .font(.theme.caption2)
                        .foregroundColor(Color.theme.secondaryText)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 200)
    }
}


