import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: GiftManagerViewModel
    @State private var selectedPersonId: UUID?
    
    @Binding var selectedTab: TabItem
    
    private var selectedPersonName: String {
        if let personId = selectedPersonId,
           let person = viewModel.getPerson(by: personId) {
            return person.name
        }
        return "All"
    }
    
    private var statusStats: (ideas: Int, purchased: Int, gifted: Int) {
        viewModel.getTotalStats(for: selectedPersonId)
    }
    
    private var budgetStats: (total: Double, average: Double, max: Double, min: Double, count: Int) {
        viewModel.getBudgetStats(for: selectedPersonId)
    }
    
    private var eventStats: [EventType: Int] {
        viewModel.getEventStats(for: selectedPersonId)
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                if hasData {
                    ScrollView {
                        LazyVStack(spacing: 24) {
                            statusChartView
                            
                            eventTypesChartView
                            
                            budgetSummaryView
                            
                            timelineChartView
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                } else {
                    emptyStateView
                }
            }
        }
    }
    
    private var hasData: Bool {
        let stats = statusStats
        return stats.ideas > 0 || stats.purchased > 0 || stats.gifted > 0
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Statistics")
                    .font(AppFonts.largeTitle)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            
            Menu {
                Button("All") {
                    selectedPersonId = nil
                }
                
                ForEach(viewModel.people) { person in
                    Button(person.name) {
                        selectedPersonId = person.id
                    }
                }
            } label: {
                HStack {
                    Text("Person: \(selectedPersonName)")
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(AppColors.textSecondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var statusChartView: some View {
        StatisticsCardView(title: "Ideas Status", icon: "chart.pie") {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .stroke(AppColors.cardBorder, lineWidth: 2)
                        .frame(width: 160, height: 160)
                    
                    PieChartView(
                        data: [
                            PieSlice(value: Double(statusStats.ideas), color: AppColors.statusIdea, label: "Ideas"),
                            PieSlice(value: Double(statusStats.purchased), color: AppColors.statusPurchased, label: "Purchased"),
                            PieSlice(value: Double(statusStats.gifted), color: AppColors.statusGifted, label: "Gifted")
                        ]
                    )
                    .frame(width: 160, height: 160)
                    
                    VStack(spacing: 2) {
                        Text("Total Ideas")
                            .font(AppFonts.caption1)
                            .foregroundColor(AppColors.textSecondary)
                        
                        Text("\(statusStats.ideas + statusStats.purchased + statusStats.gifted)")
                            .font(AppFonts.title2)
                            .foregroundColor(AppColors.textPrimary)
                            .fontWeight(.bold)
                    }
                }
                
                HStack(spacing: 20) {
                    LegendItem(color: AppColors.statusIdea, label: "Ideas", value: statusStats.ideas)
                    LegendItem(color: AppColors.statusPurchased, label: "Purchased", value: statusStats.purchased)
                    LegendItem(color: AppColors.statusGifted, label: "Gifted", value: statusStats.gifted)
                }
                
            }
        }
    }
    
    private var eventTypesChartView: some View {
        StatisticsCardView(title: "Ideas by Event Type", icon: "calendar") {
            VStack(spacing: 12) {
                ForEach(EventType.allCases, id: \.self) { eventType in
                    let count = eventStats[eventType] ?? 0
                    let maxCount = eventStats.values.max() ?? 1
                    let percentage = maxCount > 0 ? Double(count) / Double(maxCount) : 0
                    
                    HStack {
                        Text(eventType.displayName)
                            .font(AppFonts.callout)
                            .foregroundColor(AppColors.textPrimary)
                            .frame(width: 100, alignment: .leading)
                        
                        GeometryReader { geometry in
                            HStack(spacing: 0) {
                                Rectangle()
                                    .fill(AppColors.primaryYellow)
                                    .frame(width: geometry.size.width * percentage)
                                    .cornerRadius(4)
                                
                                Spacer(minLength: 0)
                            }
                        }
                        .frame(height: 8)
                        
                        Text("\(count)")
                            .font(AppFonts.callout)
                            .foregroundColor(AppColors.textSecondary)
                            .frame(width: 30, alignment: .trailing)
                    }
                }
            }
        }
    }
    
    private var budgetSummaryView: some View {
        StatisticsCardView(title: "Budget Summary", icon: "dollarsign.circle") {
            if budgetStats.count > 0 {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    BudgetStatItem(title: "Total Budget", value: String(format: "$%.2f", budgetStats.total))
                    BudgetStatItem(title: "Average", value: String(format: "$%.2f", budgetStats.average))
                    BudgetStatItem(title: "Maximum", value: String(format: "$%.2f", budgetStats.max))
                    BudgetStatItem(title: "Minimum", value: String(format: "$%.2f", budgetStats.min))
                }
            } else {
                VStack(spacing: 8) {
                    Text("No Budget Data")
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text("Budget information not specified for any ideas")
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.textTertiary)
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    private var timelineChartView: some View {
        StatisticsCardView(title: "Events Timeline", icon: "chart.bar") {
            VStack(spacing: 16) {
                let months = getNext6Months()
                let monthlyData = getMonthlyEventData(months: months)
                
                if monthlyData.contains(where: { $0.count > 0 }) {
                    HStack(alignment: .bottom, spacing: 8) {
                        ForEach(monthlyData, id: \.month) { data in
                            VStack(spacing: 4) {
                                let maxCount = monthlyData.map { $0.count }.max() ?? 1
                                let height = maxCount > 0 ? CGFloat(data.count) / CGFloat(maxCount) * 80 : 0
                                
                                Rectangle()
                                    .fill(AppColors.primaryYellow)
                                    .frame(width: 30, height: max(height, 2))
                                    .cornerRadius(4)
                                
                                Text(data.month)
                                    .font(AppFonts.caption2)
                                    .foregroundColor(AppColors.textSecondary)
                                    .rotationEffect(.degrees(-45))
                                
                                Text("\(data.count)")
                                    .font(AppFonts.caption2)
                                    .foregroundColor(AppColors.textPrimary)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(height: 120)
                } else {
                    VStack(spacing: 8) {
                        Text("No Upcoming Events")
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.textSecondary)
                        
                        Text("No events scheduled for the next 6 months")
                            .font(AppFonts.callout)
                            .foregroundColor(AppColors.textTertiary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "chart.bar")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.textSecondary)
            
            VStack(spacing: 12) {
                Text("No Data for Statistics")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Add some gift ideas to see statistics")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedTab = .ideas
                }
            } label: {
                Text("Go to Ideas")
                    .font(AppFonts.buttonMedium)
                    .foregroundColor(AppColors.primaryBlue)
                    .frame(width: 160, height: 48)
                    .background(AppColors.primaryYellow)
                    .cornerRadius(24)
            }
        }
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func getNext6Months() -> [Date] {
        let calendar = Calendar.current
        let now = Date()
        var months: [Date] = []
        
        for i in 0..<6 {
            if let month = calendar.date(byAdding: .month, value: i, to: now) {
                months.append(month)
            }
        }
        
        return months
    }
    
    private func getMonthlyEventData(months: [Date]) -> [MonthlyEventData] {
        let calendar = Calendar.current
        let ideas = selectedPersonId != nil ? viewModel.getGiftIdeas(for: selectedPersonId!) : viewModel.giftIdeas
        
        return months.map { month in
            let monthName = DateFormatter().monthSymbols[calendar.component(.month, from: month) - 1]
            let shortMonthName = String(monthName.prefix(3))
            
            let count = ideas.filter { idea in
                guard let eventDate = idea.eventDate else { return false }
                return calendar.isDate(eventDate, equalTo: month, toGranularity: .month)
            }.count
            
            return MonthlyEventData(month: shortMonthName, count: count)
        }
    }
}

struct MonthlyEventData {
    let month: String
    let count: Int
}

struct StatisticsCardView<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.primaryYellow)
                
                Text(title)
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            
            content
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}

struct LegendItem: View {
    let color: Color
    let label: String
    let value: Int
    
    var body: some View {
        VStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(label)
                .font(AppFonts.caption1)
                .foregroundColor(AppColors.textSecondary)
            
            Text("\(value)")
                .font(AppFonts.callout)
                .foregroundColor(AppColors.textPrimary)
                .fontWeight(.semibold)
        }
    }
}

struct BudgetStatItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(AppFonts.callout)
                .foregroundColor(AppColors.textSecondary)
            
            Text(value)
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryYellow)
                .fontWeight(.semibold)
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.cardBackground.opacity(0.5))
        .cornerRadius(8)
    }
}

struct PieChartView: View {
    let data: [PieSlice]
    
    var body: some View {
        GeometryReader { geometry in
            let total = data.reduce(0) { $0 + $1.value }
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let radius = min(geometry.size.width, geometry.size.height) / 2
            
            ZStack {
                ForEach(0..<data.count, id: \.self) { index in
                    let slice = data[index]
                    let startAngle = getStartAngle(for: index, data: data, total: total)
                    let endAngle = startAngle + Angle(degrees: (slice.value / total) * 360)
                    
                    Path { path in
                        path.move(to: center)
                        path.addArc(
                            center: center,
                            radius: radius - 10,
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: false
                        )
                        path.closeSubpath()
                    }
                    .fill(slice.color)
                }
            }
        }
    }
    
    private func getStartAngle(for index: Int, data: [PieSlice], total: Double) -> Angle {
        let previousValues = data.prefix(index).reduce(0) { $0 + $1.value }
        return Angle(degrees: (previousValues / total) * 360 - 90)
    }
}

struct PieSlice {
    let value: Double
    let color: Color
    let label: String
}
