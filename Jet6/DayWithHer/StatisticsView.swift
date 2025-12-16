import SwiftUI

struct StatisticsView: View {
    @StateObject private var viewModel = IdeaViewModel()
    
    var body: some View {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerView
                        
                        overviewStatsView
                        
                        categoryStatsView
                        
                        timelineStatsView
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                }
            }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Statistics")
                .font(.playfair(size: 28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Text("Track your activities and memories")
                .font(.playfair(size: 16, weight: .regular))
                .foregroundColor(AppColors.secondaryText)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var overviewStatsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(.playfair(size: 20, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                StatCardView(
                    icon: "lightbulb.fill",
                    title: "Total Ideas",
                    value: "\(viewModel.ideas.count)",
                    color: AppColors.yellowAccent
                )
                
                StatCardView(
                    icon: "checkmark.circle.fill",
                    title: "Completed",
                    value: "\(completedCount)",
                    color: AppColors.mintGreen
                )
                
                StatCardView(
                    icon: "clock.fill",
                    title: "Planned",
                    value: "\(plannedCount)",
                    color: AppColors.blueText
                )
                
                StatCardView(
                    icon: "star.fill",
                    title: "Memories",
                    value: "\(viewModel.completedIdeasWithMemories.count)",
                    color: AppColors.primaryPurple
                )
            }
        }
    }
    
    private var categoryStatsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("By Category")
                .font(.playfair(size: 20, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                ForEach(IdeaCategory.allCases, id: \.self) { category in
                    CategoryStatRowView(
                        category: category,
                        count: categoryCount(category),
                        total: viewModel.ideas.count
                    )
                }
            }
            .padding(16)
            .background(AppColors.cardGradient)
            .cornerRadius(16)
            .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 8, x: 0, y: 4)
        }
    }
    
    private var timelineStatsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Timeline")
                .font(.playfair(size: 20, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                TimelineStatRowView(
                    icon: "calendar",
                    title: "Ideas with Dates",
                    value: "\(viewModel.ideasWithDates.count)",
                    color: AppColors.blueText
                )
                
                TimelineStatRowView(
                    icon: "arrow.up.circle",
                    title: "Upcoming Events",
                    value: "\(viewModel.upcomingIdeas.count)",
                    color: AppColors.yellowAccent
                )
                
                TimelineStatRowView(
                    icon: "clock.arrow.circlepath",
                    title: "This Month",
                    value: "\(thisMonthCount)",
                    color: AppColors.mintGreen
                )
            }
            .padding(16)
            .background(AppColors.cardGradient)
            .cornerRadius(16)
            .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 8, x: 0, y: 4)
        }
    }
    
    private var completedCount: Int {
        viewModel.ideas.filter { $0.status == .completed }.count
    }
    
    private var plannedCount: Int {
        viewModel.ideas.filter { $0.status == .planned }.count
    }
    
    private func categoryCount(_ category: IdeaCategory) -> Int {
        viewModel.ideas.filter { $0.category == category }.count
    }
    
    private var thisMonthCount: Int {
        let calendar = Calendar.current
        let now = Date()
        return viewModel.ideas.filter { idea in
            guard let date = idea.date else { return false }
            return calendar.isDate(date, equalTo: now, toGranularity: .month)
        }.count
    }
}

struct StatCardView: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(color)
                .frame(width: 50, height: 50)
                .background(color.opacity(0.2))
                .clipShape(Circle())
            
            Text(value)
                .font(.playfair(size: 24, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Text(title)
                .font(.playfair(size: 14, weight: .medium))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct CategoryStatRowView: View {
    let category: IdeaCategory
    let count: Int
    let total: Int
    
    private var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(count) / Double(total) * 100
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: category.icon)
                .font(.system(size: 20))
                .foregroundColor(AppColors.blueText)
                .frame(width: 40, height: 40)
                .background(AppColors.blueText.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.rawValue)
                    .font(.playfair(size: 16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                if total > 0 {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(AppColors.lightPurple)
                                .frame(height: 6)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(AppColors.blueText)
                                .frame(width: geometry.size.width * CGFloat(percentage / 100), height: 6)
                        }
                    }
                    .frame(height: 6)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(count)")
                    .font(.playfair(size: 18, weight: .bold))
                    .foregroundColor(AppColors.blueText)
                
                if total > 0 {
                    Text("\(Int(percentage))%")
                        .font(.playfair(size: 12, weight: .medium))
                        .foregroundColor(AppColors.lightText)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct TimelineStatRowView: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.2))
                .clipShape(Circle())
            
            Text(title)
                .font(.playfair(size: 16, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Text(value)
                .font(.playfair(size: 18, weight: .bold))
                .foregroundColor(color)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    StatisticsView()
}
