import SwiftUI

struct ProgressView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTimeframe: TimeFrame = .week
    
    private var filteredSessions: [TryOnSession] {
        let calendar = Calendar.current
        let now = Date()
        
        return appState.tryOnSessions.filter { session in
            switch selectedTimeframe {
            case .week:
                return calendar.isDate(session.date, equalTo: now, toGranularity: .weekOfYear)
            case .month:
                return calendar.isDate(session.date, equalTo: now, toGranularity: .month)
            case .year:
                return calendar.isDate(session.date, equalTo: now, toGranularity: .year)
            case .all:
                return true
            }
        }
    }
    
    private var styleStats: [JewelryStyle: Int] {
        Dictionary(grouping: filteredSessions, by: \.style)
            .mapValues { $0.count }
    }
    
    private var categoryStats: [JewelryCategory: Int] {
        Dictionary(grouping: filteredSessions, by: \.category)
            .mapValues { $0.count }
    }
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            GridPatternView()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    
                    timeFrameSelector
                    
                    if filteredSessions.isEmpty {
                        emptyStateView
                    } else {
                        statsCardsSection
                        
                        achievementsSection
                        
                        styleAnalysisSection
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 120)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Progress")
                        .font(.playfairDisplay(28, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text("Track your jewelry journey")
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(ColorTheme.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(ColorTheme.primaryBlue)
            }
        }
        .padding(.top, 20)
    }
    
    private var timeFrameSelector: some View {
        HStack(spacing: 0) {
            ForEach(TimeFrame.allCases, id: \.self) { timeframe in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTimeframe = timeframe
                    }
                }) {
                    Text(timeframe.rawValue)
                        .font(.playfairDisplay(14, weight: .medium))
                        .foregroundColor(selectedTimeframe == timeframe ? ColorTheme.whiteText : ColorTheme.primaryText)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedTimeframe == timeframe ? ColorTheme.primaryBlue : Color.clear)
                        )
                }
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.backgroundWhite)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 5)
        )
    }
    
    private var statsCardsSection: some View {
        HStack(spacing: 12) {
            StatCard(
                title: "Favorites",
                value: "\(appState.savedJewelry.count)",
                icon: "heart.fill",
                color: ColorTheme.softPink
            )
            
            StatCard(
                title: "Styles",
                value: "\(styleStats.keys.count)",
                icon: "sparkles",
                color: ColorTheme.primaryYellow
            )
        }
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Achievements")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(appState.achievements) { achievement in
                    AchievementCard(achievement: achievement)
                }
            }
        }
    }
    
    private var styleAnalysisSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Style Preferences")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 12) {
                ForEach(styleStats.sorted(by: { $0.value > $1.value }), id: \.key) { style, count in
                    StyleProgressBar(
                        style: style,
                        count: count,
                        total: filteredSessions.count
                    )
                }
            }
        }
    }
    
    private var recentSessionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Try-Ons")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 8) {
                ForEach(filteredSessions.prefix(5).sorted(by: { $0.date > $1.date })) { session in
                    SessionRow(session: session)
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(ColorTheme.secondaryText)
            
            VStack(spacing: 12) {
                Text("No data to analyze")
                    .font(.playfairDisplay(24, weight: .semibold))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Start trying on jewelry to see your progress and preferences")
                    .font(.playfairDisplay(16))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button {
                appState.selectedTab = 0
            } label: {
                Text("Start Exploring")
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(ColorTheme.whiteText)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(ColorTheme.primaryBlue)
                            .shadow(color: ColorTheme.primaryBlue.opacity(0.3), radius: 10)
                    )
            }
        }
        .padding(.vertical, 40)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(.playfairDisplay(24, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Text(title)
                .font(.playfairDisplay(12, weight: .medium))
                .foregroundColor(ColorTheme.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.backgroundWhite)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.08), radius: 6)
        )
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? ColorTheme.primaryYellow : ColorTheme.lightGray)
                    .frame(width: 40, height: 40)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(achievement.isUnlocked ? ColorTheme.whiteText : ColorTheme.secondaryText)
            }
            
            Text(achievement.title)
                .font(.playfairDisplay(12, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
                .multilineTextAlignment(.center)
            
            if !achievement.isUnlocked {
                SwiftUI.ProgressView(value: achievement.progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: ColorTheme.primaryBlue))
                    .scaleEffect(x: 1, y: 0.5)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorTheme.backgroundWhite)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.05), radius: 3)
        )
    }
}

struct StyleProgressBar: View {
    let style: JewelryStyle
    let count: Int
    let total: Int
    
    private var percentage: Double {
        total > 0 ? Double(count) / Double(total) : 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(style.rawValue)
                    .font(.playfairDisplay(14, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Text("\(count)")
                    .font(.playfairDisplay(12, weight: .semibold))
                    .foregroundColor(ColorTheme.secondaryText)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(ColorTheme.lightGray)
                        .frame(height: 6)
                        .cornerRadius(3)
                    
                    Rectangle()
                        .fill(ColorTheme.primaryBlue)
                        .frame(width: geometry.size.width * CGFloat(percentage), height: 6)
                        .cornerRadius(3)
                        .animation(.easeInOut(duration: 0.5), value: percentage)
                }
            }
            .frame(height: 6)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(ColorTheme.backgroundWhite)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.05), radius: 2)
        )
    }
}

struct SessionRow: View {
    let session: TryOnSession
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: session.category.icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(ColorTheme.primaryBlue)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(session.brand)
                    .font(.playfairDisplay(14, weight: .semibold))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("\(session.style.rawValue) • \(session.category.rawValue)")
                    .font(.playfairDisplay(12))
                    .foregroundColor(ColorTheme.secondaryText)
            }
            
            Spacer()
            
            Text(formatDate(session.date))
                .font(.playfairDisplay(10))
                .foregroundColor(ColorTheme.secondaryText)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(ColorTheme.backgroundWhite)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.05), radius: 2)
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

enum TimeFrame: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
    case all = "All"
}

#Preview {
    ProgressView()
        .environmentObject(AppState())
}
