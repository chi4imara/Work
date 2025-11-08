import SwiftUI

enum ChartType: String, CaseIterable {
    case bars = "bars"
    
    var displayName: String {
        switch self {
        case .bars: return "Bars"
        }
    }
}

struct StatisticsView: View {
    @ObservedObject var statisticsViewModel: StatisticsViewModel
    @ObservedObject var storiesViewModel: StoriesViewModel
    let sidebarToggleButton: AnyView
    @State private var showingAddStory = false
    @State private var chartType: ChartType = .bars
    
    init(statisticsViewModel: StatisticsViewModel, storiesViewModel: StoriesViewModel, sidebarToggleButton: some View) {
        self.statisticsViewModel = statisticsViewModel
        self.storiesViewModel = storiesViewModel
        self.sidebarToggleButton = AnyView(sidebarToggleButton)
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                if statisticsViewModel.totalStories == 0 {
                    emptyStateView
                } else {
                    statisticsContentView
                }
            }
        }
        .sheet(isPresented: $showingAddStory) {
            StoryEditView(viewModel: storiesViewModel, story: nil)
        }
    }
    
    private var headerView: some View {
        HStack {
            sidebarToggleButton
                .disabled(true)
                .opacity(0)
            
            Text("Statistics")
                .font(.screenTitle)
                .foregroundColor(.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
    }
    
    private var statisticsContentView: some View {
        ScrollView {
            VStack(spacing: 20) {
                generalInfoSection
                
                if !statisticsViewModel.tagStatistics.isEmpty {
                    tagsStatisticsSection
                }
                
                activityStatisticsSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 30)
        }
    }
    
    private var generalInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("General Information")
                .font(.cardTitle)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 8) {
                StatisticRowView(
                    title: "Total Stories",
                    value: "\(statisticsViewModel.totalStories)",
                    icon: "book.fill"
                )
                
                if let lastAdded = statisticsViewModel.lastAddedDate {
                    StatisticRowView(
                        title: "Last Added",
                        value: DateFormatter.shortDate.string(from: lastAdded),
                        icon: "calendar"
                    )
                }
            }
            .padding(16)
            .background(Color.cardBackground)
            .cornerRadius(12)
            .shadow(color: .shadowColor, radius: 4, x: 0, y: 2)
        }
    }
    
    private var tagsStatisticsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Tags Distribution")
                    .font(.cardTitle)
                    .foregroundColor(.textPrimary)
                
                Spacer()
            }
            
            VStack(spacing: 16) {
                if !statisticsViewModel.tagStatistics.isEmpty {
                            HorizontalBarChartView(tagStatistics: statisticsViewModel.tagStatistics)
                    .frame(height: 200)
                    .transition(.opacity.combined(with: .scale))
                    .animation(.easeInOut(duration: 0.3), value: chartType)
                }
                
                VStack(spacing: 8) {
                    ForEach(statisticsViewModel.tagStatistics.prefix(5), id: \.tag) { tagStat in
                        HStack {
                            Circle()
                                .fill(Color.tagColor(for: tagStat.tag))
                                .frame(width: 12, height: 12)
                            
                            Text(tagStat.tag)
                                .font(.bodyText)
                                .foregroundColor(.textPrimary)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Text("\(tagStat.count)")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                                .fontWeight(.medium)
                        }
                    }
                    
                    if statisticsViewModel.tagStatistics.count > 5 {
                        Text("... and \(statisticsViewModel.tagStatistics.count - 5) more")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 4)
                    }
                }
            }
            .padding(16)
            .background(Color.cardBackground)
            .cornerRadius(12)
            .shadow(color: .shadowColor, radius: 4, x: 0, y: 2)
        }
    }
    
    private var activityStatisticsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Activity")
                .font(.cardTitle)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 8) {
                StatisticRowView(
                    title: "Viewed Stories",
                    value: "\(statisticsViewModel.viewedStoriesCount)",
                    icon: "eye.fill"
                )
                
                if let lastViewed = statisticsViewModel.lastViewedDate {
                    StatisticRowView(
                        title: "Last Viewed",
                        value: relativeDateString(from: lastViewed),
                        icon: "clock.fill"
                    )
                }
                
                StatisticRowView(
                    title: "Max Day Streak",
                    value: "\(statisticsViewModel.maxDayStreak)",
                    icon: "flame.fill"
                )
                
                StatisticRowView(
                    title: "Current Streak",
                    value: "\(statisticsViewModel.currentDayStreak)",
                    icon: "calendar.badge.clock"
                )
            }
            .padding(16)
            .background(Color.cardBackground)
            .cornerRadius(12)
            .shadow(color: .shadowColor, radius: 4, x: 0, y: 2)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "chart.bar")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            
            Text("No data for statistics yet")
                .font(.cardTitle)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
            
            Button {
                showingAddStory = true
            } label: {
                Text("Add First Story")
                    .font(.buttonText)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(Color.primaryBlue)
                    .cornerRadius(20)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private func relativeDateString(from date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            return DateFormatter.shortDate.string(from: date)
        }
    }
}

struct StatisticRowView: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.primaryBlue)
                .frame(width: 24)
            
            Text(title)
                .font(.bodyText)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Text(value)
                .font(.bodyText)
                .foregroundColor(.textSecondary)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    let storiesVM = StoriesViewModel()
    let statisticsVM = StatisticsViewModel(storiesViewModel: storiesVM)
    
    StatisticsView(
        statisticsViewModel: statisticsVM,
        storiesViewModel: storiesVM,
        sidebarToggleButton: Button("Toggle") { }
    )
}
