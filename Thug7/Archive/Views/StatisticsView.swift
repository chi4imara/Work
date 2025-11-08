import SwiftUI

struct StatisticsView: View {
    @ObservedObject private var placeStore = PlaceStore.shared
    @State private var selectedPeriod: PlaceStore.FilterPeriod = .month
    @State private var circleOffset: CGFloat = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if placeStore.totalPlacesCount() == 0 {
                        emptyStateView
                    } else {
                        statisticsContent
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Statistics")
                .font(AppTheme.titleFont)
                .foregroundColor(AppTheme.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 15)
    }
    
    private var statisticsContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                generalInfoSection
                
                categoryDistributionSection
                
                timelineSection
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var generalInfoSection: some View {
        VStack(spacing: 16) {
            Text("Overview")
                .font(AppTheme.headlineFont)
                .foregroundColor(AppTheme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 16) {
                StatCard(
                    title: "Total Places",
                    value: "\(placeStore.totalPlacesCount())",
                    icon: "location.fill",
                    color: AppTheme.primaryBlue
                )
                
                StatCard(
                    title: "Last Added",
                    value: lastAddedText,
                    icon: "calendar",
                    color: AppTheme.accentGreen
                )
            }
        }
    }
    
    private var lastAddedText: String {
        guard let lastDate = placeStore.lastAddedDate() else {
            return "None"
        }
        
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: lastDate, relativeTo: Date())
    }
    
    private var categoryDistributionSection: some View {
        VStack(spacing: 16) {
            Text("Category Distribution")
                .font(AppTheme.headlineFont)
                .foregroundColor(AppTheme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 0) {
                pieChartView
                
                VStack(spacing: 12) {
                    ForEach(placeStore.categoryDistribution(), id: \.category) { item in
                        CategoryStatRow(
                            category: item.category,
                            count: item.count,
                            percentage: item.percentage
                        )
                    }
                }
                .padding(.top, 20)
            }
            .padding(20)
            .cardStyle()
        }
    }
    
    private var pieChartView: some View {
        ZStack {
            Circle()
                .stroke(AppTheme.textSecondary.opacity(0.2), lineWidth: 8)
                .frame(width: 120, height: 120)
            
            ForEach(Array(placeStore.categoryDistribution().enumerated()), id: \.offset) { index, item in
                let startAngle = calculateStartAngle(for: index)
                let endAngle = startAngle + (item.percentage / 100.0 * 360.0)
                
                Circle()
                    .trim(from: startAngle / 360.0, to: endAngle / 360.0)
                    .stroke(categoryColor(for: item.category), lineWidth: 8)
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
            }
            
            VStack {
                Text("\(placeStore.totalPlacesCount())")
                    .font(AppTheme.headlineFont)
                    .foregroundColor(AppTheme.textPrimary)
                
                Text("Places")
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.textSecondary)
            }
        }
    }
    
    private func calculateStartAngle(for index: Int) -> Double {
        let distribution = placeStore.categoryDistribution()
        var angle: Double = 0
        
        for i in 0..<index {
            angle += distribution[i].percentage / 100.0 * 360.0
        }
        
        return angle
    }
    
    private func categoryColor(for category: PlaceCategory) -> Color {
        switch category {
        case .school:
            return AppTheme.primaryBlue
        case .yard:
            return AppTheme.accentGreen
        case .trip:
            return AppTheme.accentOrange
        case .other:
            return AppTheme.accentPurple
        }
    }
    
    private var timelineSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Memory Timeline")
                    .font(AppTheme.headlineFont)
                    .foregroundColor(AppTheme.textPrimary)
                
                Spacer()
                
                Picker("Period", selection: $selectedPeriod) {
                    Text("Week").tag(PlaceStore.FilterPeriod.week)
                    Text("Month").tag(PlaceStore.FilterPeriod.month)
                    Text("Year").tag(PlaceStore.FilterPeriod.year)
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 200)
            }
            
            timelineChartView
                .padding(20)
                .cardStyle()
        }
    }
    
    private var timelineChartView: some View {
        let data = placeStore.dailyAdditions(for: selectedPeriod)
        let maxCount = data.map { $0.count }.max() ?? 1
        
        return VStack(spacing: 12) {
            if data.isEmpty {
                Text("No data for selected period")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.textSecondary)
                    .frame(height: 100)
            } else {
                HStack(alignment: .bottom, spacing: 4) {
                    ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                        VStack(spacing: 4) {
                            Rectangle()
                                .fill(AppTheme.primaryBlue)
                                .frame(
                                    width: min(30, (UIScreen.main.bounds.width - 80) / CGFloat(data.count) - 4),
                                    height: CGFloat(item.count) / CGFloat(maxCount) * 80
                                )
                                .cornerRadius(2)
                            
                            if data.count <= 7 || index % max(1, data.count / 7) == 0 {
                                Text(DateFormatter.shortDate.string(from: item.date))
                                    .font(.system(size: 10))
                                    .foregroundColor(AppTheme.textSecondary)
                                    .rotationEffect(.degrees(-45))
                            }
                        }
                    }
                }
                .frame(height: 120)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "chart.bar")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppTheme.textSecondary.opacity(0.5))
            
            VStack(spacing: 12) {
                Text("No Statistics Yet")
                    .font(AppTheme.headlineFont)
                    .foregroundColor(AppTheme.textPrimary)
                
                Text("Statistics will appear here once you add places")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
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
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(AppTheme.headlineFont)
                    .foregroundColor(AppTheme.textPrimary)
                
                Text(title)
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .cardStyle()
    }
}

struct CategoryStatRow: View {
    let category: PlaceCategory
    let count: Int
    let percentage: Double
    
    private var categoryColor: Color {
        switch category {
        case .school:
            return AppTheme.primaryBlue
        case .yard:
            return AppTheme.accentGreen
        case .trip:
            return AppTheme.accentOrange
        case .other:
            return AppTheme.accentPurple
        }
    }
    
    var body: some View {
        HStack {
            Circle()
                .fill(categoryColor)
                .frame(width: 12, height: 12)
            
            Text(category.displayName)
                .font(AppTheme.bodyFont)
                .foregroundColor(AppTheme.textPrimary)
            
            Spacer()
            
            HStack(spacing: 8) {
                Text("\(count)")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.textPrimary)
                
                Text("(\(String(format: "%.1f", percentage))%)")
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.textSecondary)
            }
        }
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        return formatter
    }()
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
