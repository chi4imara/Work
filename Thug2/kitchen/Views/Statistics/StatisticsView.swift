import SwiftUI
import Charts

struct StatisticsView: View {
    @ObservedObject var viewModel: InteriorIdeasViewModel
    
    var body: some View {
        ZStack {
            BackgroundView()
                
                if viewModel.totalIdeasCount == 0 {
                    EmptyStatisticsView()
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            HStack {
                                Text("Statistics")
                                    .font(AppFonts.title1())
                                    .foregroundColor(AppColors.primaryText)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                            
                            OverviewCardsView(viewModel: viewModel)
                            
                            CategoryChartView(viewModel: viewModel)
                            
                            AchievementsView(viewModel: viewModel)
                            
                            InsightsView(viewModel: viewModel)
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.bottom, 20)
                    }
                }
        }
    }
}

struct OverviewCardsView: View {
    @ObservedObject var viewModel: InteriorIdeasViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                StatCard(
                    title: "Total Ideas",
                    value: "\(viewModel.totalIdeasCount)",
                    icon: "lightbulb.fill",
                    color: AppColors.primaryOrange
                )
                
                StatCard(
                    title: "Favorites",
                    value: "\(viewModel.favoriteIdeasCount)",
                    icon: "star.fill",
                    color: AppColors.accentPurple
                )
            }
            
            HStack(spacing: 16) {
                StatCard(
                    title: "Categories",
                    value: "\(viewModel.ideasByCategory.filter { $0.value > 0 }.count)",
                    icon: "folder.fill",
                    color: AppColors.accentGreen
                )
                
                StatCard(
                    title: "This Week",
                    value: "\(ideasThisWeek)",
                    icon: "calendar",
                    color: AppColors.accentPink
                )
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var ideasThisWeek: Int {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return viewModel.ideas.filter { $0.dateAdded >= weekAgo }.count
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
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(AppFonts.title1())
                    .foregroundColor(AppColors.primaryText)
                
                Text(title)
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.secondaryText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}

struct CategoryChartView: View {
    @ObservedObject var viewModel: InteriorIdeasViewModel
    
    private var chartData: [CategoryData] {
        viewModel.ideasByCategory.compactMap { category, count in
            guard count > 0 else { return nil }
            return CategoryData(category: category.rawValue, count: count)
        }.sorted { $0.count > $1.count }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Ideas by Category")
                .font(AppFonts.title3())
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 20)
            
            VStack(spacing: 16) {
                ForEach(chartData, id: \.category) { data in
                    CategoryBarView(
                        data: data,
                        total: viewModel.totalIdeasCount,
                        color: colorForCategory(data.category)
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
            .padding(.horizontal, 20)
        }
    }
    
    private func colorForCategory(_ category: String) -> Color {
        switch category {
        case "Living Room": return AppColors.primaryOrange
        case "Kitchen": return AppColors.accentPurple
        case "Bedroom": return AppColors.accentGreen
        case "Bathroom": return AppColors.accentPink
        case "Hallway": return AppColors.primaryBlue
        default: return AppColors.secondaryText
        }
    }
}

struct CategoryBarView: View {
    let data: CategoryData
    let total: Int
    let color: Color
    
    private var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(data.count) / Double(total)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(data.category)
                    .font(AppFonts.callout())
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Text("\(data.count)")
                    .font(AppFonts.callout())
                    .foregroundColor(AppColors.secondaryText)
                
                Text("(\(Int(percentage * 100))%)")
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.tertiaryText)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(AppColors.cardBorder)
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * percentage, height: 8)
                        .cornerRadius(4)
                        .animation(.easeInOut(duration: 1.0), value: percentage)
                }
            }
            .frame(height: 8)
        }
    }
}

struct TimelineChartView: View {
    @ObservedObject var viewModel: InteriorIdeasViewModel
    
    private var chartData: [TimelineData] {
        let calendar = Calendar.current
        let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        
        var dailyCounts: [String: Int] = [:]
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        
        for i in 0..<30 {
            if let date = calendar.date(byAdding: .day, value: -i, to: Date()) {
                let dateString = formatter.string(from: date)
                dailyCounts[dateString] = 0
            }
        }
        
        for idea in viewModel.ideas {
            if idea.dateAdded >= thirtyDaysAgo {
                let dateString = formatter.string(from: idea.dateAdded)
                dailyCounts[dateString, default: 0] += 1
            }
        }
        
        return dailyCounts.map { date, count in
            TimelineData(date: date, count: count)
        }.sorted { $0.date < $1.date }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Ideas Added (Last 30 Days)")
                .font(AppFonts.title3())
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 20)
            
            VStack(spacing: 16) {
                if chartData.isEmpty {
                    Text("No data available")
                        .font(AppFonts.body())
                        .foregroundColor(AppColors.secondaryText)
                        .frame(height: 100)
                } else {
                    SimpleBarChartView(data: chartData)
                        .frame(height: 150)
                }
            }
            .padding(20)
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
            .padding(.horizontal, 20)
        }
    }
}

struct SimpleBarChartView: View {
    let data: [TimelineData]
    @State private var animateBars = false
    @State private var selectedBar: Int? = nil
    
    init(data: [TimelineData]) {
        self.data = data
    }
    
    private var maxValue: Int {
        data.map(\.count).max() ?? 1
    }
    
    private var chartHeight: CGFloat = 120
    private var barSpacing: CGFloat = 8
    
    var body: some View {
        VStack(spacing: 16) {
            GeometryReader { geometry in
                HStack(alignment: .bottom, spacing: barSpacing) {
                    ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                        VStack(spacing: 4) {
                            if animateBars {
                                Text("\(item.count)")
                                    .font(AppFonts.caption2())
                                    .foregroundColor(AppColors.primaryText)
                                    .opacity(selectedBar == index ? 1.0 : 0.7)
                                    .scaleEffect(selectedBar == index ? 1.1 : 1.0)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedBar)
                            }
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(
                                    LinearGradient(
                                        colors: selectedBar == index ? 
                                            [AppColors.primaryOrange, AppColors.primaryOrange.opacity(0.8)] :
                                            [AppColors.primaryOrange.opacity(0.8), AppColors.primaryOrange.opacity(0.6)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(
                                    width: max(8, (geometry.size.width - CGFloat(data.count - 1) * barSpacing) / CGFloat(data.count)),
                                    height: animateBars ? 
                                        (CGFloat(item.count) / CGFloat(maxValue)) * chartHeight : 0
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(
                                            selectedBar == index ? 
                                                AppColors.primaryOrange : 
                                                Color.clear,
                                            lineWidth: selectedBar == index ? 2 : 0
                                        )
                                )
                                .shadow(
                                    color: selectedBar == index ? 
                                        AppColors.primaryOrange.opacity(0.4) : 
                                        Color.black.opacity(0.2),
                                    radius: selectedBar == index ? 8 : 4,
                                    x: 0,
                                    y: selectedBar == index ? 4 : 2
                                )
                                .scaleEffect(selectedBar == index ? 1.05 : 1.0)
                                .animation(
                                    .spring(response: 0.6, dampingFraction: 0.8)
                                    .delay(Double(index) * 0.1),
                                    value: animateBars
                                )
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedBar)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        selectedBar = selectedBar == index ? nil : index
                                    }
                                }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
            .frame(height: chartHeight + 20)
            
            HStack(spacing: barSpacing) {
                ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                    Text(item.date)
                        .font(AppFonts.caption2())
                        .foregroundColor(AppColors.secondaryText)
                        .frame(maxWidth: .infinity)
                        .opacity(animateBars ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.5).delay(Double(index) * 0.1 + 0.3), value: animateBars)
                }
            }
            .padding(.horizontal, 4)
        }
        .onAppear {
            withAnimation {
                animateBars = true
            }
        }
    }
}

struct EmptyStatisticsView: View {
    var body: some View {
        VStack(spacing: 30) {
            HStack {
                Text("Statistics")
                    .font(AppFonts.title1())
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            .padding(.top, 10)
            
            Spacer()
            
            Image(systemName: "chart.bar")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: 12) {
                Text("No Statistics Available")
                    .font(AppFonts.title2())
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add some ideas to see your statistics and charts here.")
                    .font(AppFonts.body())
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct CategoryData {
    let category: String
    let count: Int
}

struct TimelineData {
    let date: String
    let count: Int
}

struct AchievementsView: View {
    @ObservedObject var viewModel: InteriorIdeasViewModel
    @State private var animateAchievements = false
    
    private var achievements: [Achievement] {
        var achievements: [Achievement] = []
        
        if viewModel.totalIdeasCount >= 1 {
            achievements.append(Achievement(
                title: "First Steps",
                description: "Created your first idea",
                icon: "star.fill",
                color: AppColors.primaryOrange,
                isUnlocked: true
            ))
        }
        
        if viewModel.totalIdeasCount >= 10 {
            achievements.append(Achievement(
                title: "Idea Collector",
                description: "Created 10 ideas",
                icon: "lightbulb.fill",
                color: AppColors.accentPurple,
                isUnlocked: true
            ))
        }
        
        if viewModel.totalIdeasCount >= 50 {
            achievements.append(Achievement(
                title: "Design Master",
                description: "Created 50 ideas",
                icon: "crown.fill",
                color: AppColors.accentGreen,
                isUnlocked: true
            ))
        }
        
        if viewModel.favoriteIdeasCount >= 5 {
            achievements.append(Achievement(
                title: "Curator",
                description: "Favorited 5 ideas",
                icon: "heart.fill",
                color: AppColors.accentPink,
                isUnlocked: true
            ))
        }
        
        let usedCategories = viewModel.ideasByCategory.filter { $0.value > 0 }.count
        if usedCategories >= 4 {
            achievements.append(Achievement(
                title: "Versatile Designer",
                description: "Used 4+ categories",
                icon: "square.grid.3x3.fill",
                color: AppColors.primaryBlue,
                isUnlocked: true
            ))
        }
        
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let recentIdeas = viewModel.ideas.filter { $0.dateAdded >= weekAgo }.count
        if recentIdeas >= 3 {
            achievements.append(Achievement(
                title: "Active Creator",
                description: "Created 3 ideas this week",
                icon: "flame.fill",
                color: AppColors.primaryOrange,
                isUnlocked: true
            ))
        }
        
        return achievements
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Achievements")
                .font(AppFonts.title3())
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 20)
            
            if achievements.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "trophy")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text("No achievements yet")
                        .font(AppFonts.body())
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text("Keep creating ideas to unlock achievements!")
                        .font(AppFonts.caption())
                        .foregroundColor(AppColors.tertiaryText)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(AppColors.cardBackground)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
                .padding(.horizontal, 20)
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ], spacing: 12) {
                    ForEach(Array(achievements.enumerated()), id: \.offset) { index, achievement in
                        AchievementCard(achievement: achievement)
                            .scaleEffect(animateAchievements ? 1.0 : 0.8)
                            .opacity(animateAchievements ? 1.0 : 0.0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: animateAchievements)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .onAppear {
            withAnimation {
                animateAchievements = true
            }
        }
    }
}

struct Achievement {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let isUnlocked: Bool
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(achievement.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(achievement.color)
            }
            
            VStack(spacing: 4) {
                Text(achievement.title)
                    .font(AppFonts.callout())
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                Text(achievement.description)
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .padding(16)
        .frame(width: 160, height: 160)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(achievement.color.opacity(0.3), lineWidth: 1)
        )
    }
}

struct InsightsView: View {
    @ObservedObject var viewModel: InteriorIdeasViewModel
    @State private var animateInsights = false
    
    private var insights: [Insight] {
        var insights: [Insight] = []
        
        if let mostPopular = viewModel.ideasByCategory.max(by: { $0.value < $1.value }) {
            insights.append(Insight(
                title: "Favorite Category",
                description: "You love \(mostPopular.key.rawValue) designs",
                icon: "heart.fill",
                color: AppColors.accentPink,
                value: "\(mostPopular.value) ideas"
            ))
        }
        
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let recentIdeas = viewModel.ideas.filter { $0.dateAdded >= weekAgo }.count
        if recentIdeas > 0 {
            insights.append(Insight(
                title: "This Week",
                description: "You've been very creative",
                icon: "calendar.badge.plus",
                color: AppColors.accentGreen,
                value: "\(recentIdeas) new ideas"
            ))
        }
        
        let favoritesRatio = viewModel.totalIdeasCount > 0 ? Double(viewModel.favoriteIdeasCount) / Double(viewModel.totalIdeasCount) : 0
        if favoritesRatio > 0.3 {
            insights.append(Insight(
                title: "Quality Focus",
                description: "You're selective with favorites",
                icon: "star.fill",
                color: AppColors.primaryOrange,
                value: "\(Int(favoritesRatio * 100))% favorited"
            ))
        }
        
        return insights
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Insights")
                .font(AppFonts.title3())
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 20)
            
            if insights.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text("No insights yet")
                        .font(AppFonts.body())
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text("Add more ideas to get personalized insights")
                        .font(AppFonts.caption())
                        .foregroundColor(AppColors.tertiaryText)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(AppColors.cardBackground)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
                .padding(.horizontal, 20)
            } else {
                VStack(spacing: 12) {
                    ForEach(Array(insights.enumerated()), id: \.offset) { index, insight in
                        InsightCard(insight: insight)
                            .scaleEffect(animateInsights ? 1.0 : 0.9)
                            .opacity(animateInsights ? 1.0 : 0.0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.2), value: animateInsights)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .onAppear {
            withAnimation {
                animateInsights = true
            }
        }
    }
}

struct Insight {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let value: String
}

struct InsightCard: View {
    let insight: Insight
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(insight.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: insight.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(insight.color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(insight.title)
                    .font(AppFonts.callout())
                    .foregroundColor(AppColors.primaryText)
                
                Text(insight.description)
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            Text(insight.value)
                .font(AppFonts.caption())
                .foregroundColor(insight.color)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(insight.color.opacity(0.2))
                )
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(insight.color.opacity(0.3), lineWidth: 1)
        )
    }
}

struct QuickActionsView: View {
    @ObservedObject var viewModel: InteriorIdeasViewModel
    @State private var animateActions = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(AppFonts.title3())
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 20)
            
            HStack(spacing: 16) {
                QuickActionCard(
                    title: "Add Idea",
                    icon: "plus.circle.fill",
                    color: AppColors.primaryOrange,
                    action: { /* Add idea action */ }
                )
                .scaleEffect(animateActions ? 1.0 : 0.8)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateActions)
                
                QuickActionCard(
                    title: "View Favorites",
                    icon: "heart.fill",
                    color: AppColors.accentPink,
                    action: { /* View favorites action */ }
                )
                .scaleEffect(animateActions ? 1.0 : 0.8)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateActions)
                
                QuickActionCard(
                    title: "Export Data",
                    icon: "square.and.arrow.up.fill",
                    color: AppColors.accentGreen,
                    action: { /* Export action */ }
                )
                .scaleEffect(animateActions ? 1.0 : 0.8)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateActions)
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            withAnimation {
                animateActions = true
            }
        }
    }
}

struct QuickActionCard: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
                action()
            }
        }) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
    }
}

#Preview {
    StatisticsView(viewModel: InteriorIdeasViewModel())
}
