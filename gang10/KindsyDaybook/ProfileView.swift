import SwiftUI

struct StatisticsView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var bubbles: [MovingBubble] = []
    @State private var selectedPeriod: StatisticsPeriod = .week
    
    enum StatisticsPeriod: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
        case all = "All Time"
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(bubbles, id: \.id) { bubble in
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: bubble.size, height: bubble.size)
                    .position(bubble.position)
                    .animation(.linear(duration: bubble.duration).repeatForever(autoreverses: false), value: bubble.position)
            }
            
            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        Text("Statistics")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                    }
                    .padding(.vertical)

                    headerSection
                    
                    if viewModel.hasSmiles {
                        periodSelector
                        
                        mainStatisticsSection
                        
                        analyticsSection
                        
                        quoteSection
                        
                        actionButton
                    } else {
                        emptyStateView
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .onAppear {
            generateBubbles()
        }
        .sheet(isPresented: $viewModel.showingAddSmile) {
            AddEditSmileView()
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("Your Happiness Journey")
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.center)
            
            Text("Track your positive moments and see how joy grows over time")
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
    }
    
    private var periodSelector: some View {
        HStack(spacing: 12) {
            ForEach(StatisticsPeriod.allCases, id: \.self) { period in
                Button(action: {
                    selectedPeriod = period
                }) {
                    Text(period.rawValue)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(selectedPeriod == period ? AppColors.skyBlue : AppColors.secondaryText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(selectedPeriod == period ? AppColors.white : AppColors.white.opacity(0.2))
                        )
                }
            }
        }
        .padding(.horizontal, 4)
    }
    
    private var mainStatisticsSection: some View {
        VStack(spacing: 16) {
            Text("Overview")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                StatisticCardView(
                    icon: "face.smiling",
                    title: "Total Smiles",
                    value: "\(getFilteredStatistics().totalSmiles)",
                    color: AppColors.yellow
                )
                
                StatisticCardView(
                    icon: "calendar",
                    title: "Active Days",
                    value: "\(getFilteredStatistics().daysWithSmiles)",
                    color: AppColors.softPink
                )
                
                StatisticCardView(
                    icon: "star.fill",
                    title: "Best Day",
                    value: "\(getFilteredStatistics().maxSmilesInDay)",
                    color: AppColors.lightGreen
                )
                
                StatisticCardView(
                    icon: "clock",
                    title: "Last Smile",
                    value: formatLastSmileDate(),
                    color: AppColors.lavender
                )
            }
        }
    }
    
    private var analyticsSection: some View {
        VStack(spacing: 16) {
            Text("Analytics")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                AnalyticsCardView(
                    title: "Average per Day",
                    value: String(format: "%.1f", Double(getFilteredStatistics().totalSmiles) / max(1, Double(getFilteredStatistics().daysWithSmiles))),
                    icon: "chart.bar.fill",
                    color: AppColors.coral
                )
                
                AnalyticsCardView(
                    title: "Streak",
                    value: "\(calculateStreak()) days",
                    icon: "flame.fill",
                    color: AppColors.yellow
                )
                
                AnalyticsCardView(
                    title: getPeriodTitle(),
                    value: "\(getFilteredStatistics().totalSmiles) smiles",
                    icon: "calendar.badge.clock",
                    color: AppColors.skyBlue
                )
            }
        }
    }
    
    private var quoteSection: some View {
        VStack(spacing: 16) {
            Text("Daily Inspiration")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                Text("\"\(viewModel.dailyQuote.text)\"")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                
                Text("Quote updates every morning")
                    .font(.ubuntu(12, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(AppColors.cardGradient)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.white.opacity(0.3), lineWidth: 1)
            )
        }
    }
    
    private var actionButton: some View {
        Button(action: {
            viewModel.showingAddSmile = true
        }) {
            Text("Add Smile Now")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.skyBlue)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(AppColors.white)
                .cornerRadius(25)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "heart")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.yellow)
            
            VStack(spacing: 12) {
                Text("You haven't recorded any smiles yet.")
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Start today.")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Button(action: {
                viewModel.showingAddSmile = true
            }) {
                Text("Add First Smile")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.skyBlue)
                    .frame(width: 200, height: 50)
                    .background(AppColors.white)
                    .cornerRadius(25)
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            }
        }
        .padding(.horizontal, 40)
    }
    
    private func generateBubbles() {
        bubbles = (0..<8).map { _ in
            MovingBubble(
                id: UUID(),
                size: CGFloat.random(in: 20...45),
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: UIScreen.main.bounds.height + 100
                ),
                duration: Double.random(in: 15...30)
            )
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            for i in bubbles.indices {
                bubbles[i].position = CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: -100
                )
            }
        }
    }
    
    
    private func formatLastSmileDate() -> String {
        guard let date = getFilteredStatistics().lastSmileDate else { return "Never" }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    private func calculateStreak() -> Int {
        return min(getFilteredStatistics().daysWithSmiles, 7)
    }
    
    private func getWeeklySmiles() -> Int {
        return viewModel.statistics.totalSmiles / 4
    }
    
    private func getFilteredSmiles() -> [Smile] {
        let allSmiles = DataService.shared.smiles
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedPeriod {
        case .week:
            let weekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now
            return allSmiles.filter { $0.createdAt >= weekAgo }
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            return allSmiles.filter { $0.createdAt >= monthAgo }
        case .year:
            let yearAgo = calendar.date(byAdding: .year, value: -1, to: now) ?? now
            return allSmiles.filter { $0.createdAt >= yearAgo }
        case .all:
            return allSmiles
        }
    }
    
    private func getFilteredStatistics() -> SmileStatistics {
        let filteredSmiles = getFilteredSmiles()
        let totalSmiles = filteredSmiles.count
        let lastSmileDate = filteredSmiles.first?.createdAt
        
        let calendar = Calendar.current
        let groupedByDay = Dictionary(grouping: filteredSmiles) { smile in
            calendar.startOfDay(for: smile.createdAt)
        }
        let maxSmilesInDay = groupedByDay.values.map { $0.count }.max() ?? 0
        
        let daysWithSmiles = Set(filteredSmiles.map { calendar.startOfDay(for: $0.createdAt) }).count
        
        return SmileStatistics(
            totalSmiles: totalSmiles,
            lastSmileDate: lastSmileDate,
            maxSmilesInDay: maxSmilesInDay,
            daysWithSmiles: daysWithSmiles
        )
    }
    
    private func getPeriodTitle() -> String {
        switch selectedPeriod {
        case .week:
            return "This Week"
        case .month:
            return "This Month"
        case .year:
            return "This Year"
        case .all:
            return "All Time"
        }
    }
}

struct StatisticCardView: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text(title)
                    .font(.ubuntu(12, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.white.opacity(0.3), lineWidth: 1)
        )
    }
}

struct AnalyticsCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                
                Text(value)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
            }
            
            Spacer()
        }
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.white.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    StatisticsView()
}

