import SwiftUI

struct StatisticsView: View {
    @ObservedObject var memoryStore: MemoryStore
    @State private var showingFilterMenu = false
    
    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if memoryStore.filteredMemories.isEmpty {
                    emptyStateView
                } else {
                    statisticsContent
                }
            }
        }
        .actionSheet(isPresented: $showingFilterMenu) {
            filterActionSheet
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Statistics")
                .font(AppFonts.largeTitle)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: { showingFilterMenu = true }) {
                HStack(spacing: 4) {
                    Text(memoryStore.currentFilter.localizedTitle)
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.primaryYellow)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.primaryYellow)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(AppColors.primaryYellow.opacity(0.3), lineWidth: 1)
                        )
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "chart.bar")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryYellow.opacity(0.6))
            
            Text("Not enough data for statistics")
                .font(AppFonts.title2)
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
    }
    
    private var statisticsContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    StatisticCard(
                        title: "Total Memories",
                        value: "\(memoryStore.totalMemories)",
                        icon: "book.fill",
                        color: AppColors.primaryYellow
                    )
                    
                    StatisticCard(
                        title: "Important",
                        value: "\(memoryStore.importantMemories)",
                        icon: "star.fill",
                        color: AppColors.importantStar
                    )
                    
                    StatisticCard(
                        title: "Average Length",
                        value: "\(memoryStore.averageTextLength)",
                        subtitle: "characters",
                        icon: "textformat",
                        color: AppColors.editGreen
                    )
                    
                    if let busiestDay = memoryStore.busiestDay {
                        StatisticCard(
                            title: "Busiest Day",
                            value: formatBusiestDay(busiestDay.date),
                            subtitle: "\(busiestDay.count) memories",
                            icon: "calendar.badge.plus",
                            color: AppColors.primaryBlue
                        )
                    } else {
                        StatisticCard(
                            title: "Busiest Day",
                            value: "N/A",
                            icon: "calendar.badge.plus",
                            color: AppColors.primaryBlue
                        )
                    }
                }
                
                chartSection
                
                insightsSection
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var chartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Memory Distribution")
                .font(AppFonts.title2)
                .foregroundColor(AppColors.primaryText)
            
            if memoryStore.totalMemories > 0 {
                PieChartView(
                    importantCount: memoryStore.importantMemories,
                    totalCount: memoryStore.totalMemories
                )
                .frame(height: 200)
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "chart.pie")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.primaryYellow.opacity(0.6))
                    
                    Text("No data for chart")
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.secondaryText)
                }
                .frame(height: 200)
            }
        }
    }
    
    private var insightsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Insights")
                .font(AppFonts.title2)
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                if memoryStore.totalMemories > 0 {
                    InsightCard(
                        text: "You saved \(Int(Double(memoryStore.importantMemories) / Double(memoryStore.totalMemories) * 100))% of memories as important"
                    )
                }
                
                if let longestMemory = memoryStore.filteredMemories.max(by: { $0.text.count < $1.text.count }) {
                    InsightCard(
                        text: "Your longest memory has \(longestMemory.text.count) characters"
                    )
                }
                
                if memoryStore.currentFilter == .month {
                    InsightCard(
                        text: "This month you recorded \(memoryStore.totalMemories) memories"
                    )
                } else if memoryStore.currentFilter == .week {
                    InsightCard(
                        text: "This week you recorded \(memoryStore.totalMemories) memories"
                    )
                }
                
                if memoryStore.totalMemories >= 10 {
                    InsightCard(
                        text: "Great job building your memory collection! Keep it up!"
                    )
                }
            }
        }
    }
    
    private var filterActionSheet: ActionSheet {
        ActionSheet(
            title: Text("Filter Period"),
            buttons: [
                .default(Text("This Week")) { memoryStore.setFilter(.week) },
                .default(Text("This Month")) { memoryStore.setFilter(.month) },
                .default(Text("All Time")) { memoryStore.setFilter(.all) },
                .cancel()
            ]
        )
    }
    
    private func formatBusiestDay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

struct StatisticCard: View {
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
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(AppFonts.title)
                    .foregroundColor(AppColors.primaryText)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            
            Text(title)
                .font(AppFonts.callout)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct InsightCard: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 16))
                .foregroundColor(AppColors.primaryYellow)
            
            Text(text)
                .font(AppFonts.callout)
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.primaryYellow.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#Preview {
    StatisticsView(memoryStore: MemoryStore())
}
