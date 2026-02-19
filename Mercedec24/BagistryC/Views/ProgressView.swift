import SwiftUI

struct UserProgressView: View {
    @EnvironmentObject private var userViewModel: UserViewModel
    @EnvironmentObject private var bagViewModel: BagViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            backgroundView
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerSection
                
                tabSelectorSection
                
                TabView(selection: $selectedTab) {
                    tryOnsTabContent
                        .tag(0)
                    
                    achievementsTabContent
                        .tag(1)
                    
                    statisticsTabContent
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }
        .onAppear {
            userViewModel.refreshProgressData()
            userViewModel.setCollectionCount(bagViewModel.favoriteBags.count)
        }
    }
    
    private var backgroundView: some View {
        ZStack {
            LinearGradient(
                colors: [Color.theme.gradientStart, Color.theme.gradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            GridPattern()
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Your Progress")
                .font(.ubuntu(32, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            Text("Track your style journey")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(Color.theme.secondaryText)
        }
        .padding(.top, 20)
        .padding(.horizontal, 16)
    }
    
    private var tabSelectorSection: some View {
        HStack(spacing: 0) {
            ForEach(0..<3) { index in
                Button(action: { selectedTab = index }) {
                    VStack(spacing: 4) {
                        Text(tabTitle(for: index))
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(selectedTab == index ? Color.theme.accentYellow : Color.theme.secondaryText)
                        
                        Rectangle()
                            .fill(selectedTab == index ? Color.theme.accentYellow : Color.clear)
                            .frame(height: 2)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.top, 16)
    }
    
    private func tabTitle(for index: Int) -> String {
        switch index {
        case 0: return "Try-Ons"
        case 1: return "Achievements"
        case 2: return "Statistics"
        default: return ""
        }
    }
    
    private var tryOnsTabContent: some View {
        ScrollView {
            VStack(spacing: 16) {
                if userViewModel.tryOnSessions.isEmpty {
                    emptyTryOnsView
                } else {
                    tryOnsList
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyTryOnsView: some View {
        VStack(spacing: 16) {
            Image(systemName: "camera.viewfinder")
                .font(.system(size: 60))
                .foregroundColor(Color.theme.secondaryText)
            
            Text("No try-ons yet")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            Text("Start trying on bags to see your history here")
                .font(.ubuntu(14))
                .foregroundColor(Color.theme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(height: 300)
    }
    
    private var tryOnsList: some View {
        LazyVStack(spacing: 12) {
            ForEach(userViewModel.tryOnSessions.sorted { $0.date > $1.date }) { session in
                TryOnSessionCard(session: session)
            }
        }
    }
    
    private var achievementsTabContent: some View {
        ScrollView {
            VStack(spacing: 16) {
                achievementsList
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var achievementsList: some View {
        LazyVStack(spacing: 12) {
            ForEach(userViewModel.achievements) { achievement in
                AchievementCard(achievement: achievement)
            }
        }
    }
    
    private var statisticsTabContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                if userViewModel.tryOnSessions.isEmpty {
                    emptyStatisticsView
                } else {
                    statisticsContent
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStatisticsView: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.bar")
                .font(.system(size: 60))
                .foregroundColor(Color.theme.secondaryText)
            
            Text("No data to analyze")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            Text("Try on some bags to see your style preferences")
                .font(.ubuntu(14))
                .foregroundColor(Color.theme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(height: 300)
    }
    
    private var statisticsContent: some View {
        VStack(spacing: 20) {
            overviewStatsSection
            
            stylePreferencesSection
            
            brandPreferencesSection
            
            categoryBreakdownSection
        }
    }
    
    private var overviewStatsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Overview")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                StatCard(
                    title: "Total Try-Ons",
                    value: "\(userViewModel.statistics.totalTryOns)",
                    icon: "camera.viewfinder"
                )
                
                StatCard(
                    title: "Collection Size",
                    value: "\(bagViewModel.favoriteBags.count)",
                    icon: "heart.fill"
                )
                
                StatCard(
                    title: "Average Rating",
                    value: String(format: "%.1f", userViewModel.statistics.averageRating),
                    icon: "star.fill"
                )
                
                StatCard(
                    title: "Favorite Style",
                    value: userViewModel.statistics.favoriteStyle?.rawValue ?? "None",
                    icon: "sparkles"
                )
            }
        }
    }
    
    private var stylePreferencesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Style Preferences")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            VStack(spacing: 8) {
                ForEach(userViewModel.getProgressData(), id: \.0) { style, progress in
                    HStack {
                        Text(style)
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                            .frame(width: 80, alignment: .leading)
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.theme.cardBackground)
                                    .frame(height: 8)
                                    .cornerRadius(4)
                                
                                Rectangle()
                                    .fill(Color.theme.accentYellow)
                                    .frame(width: geometry.size.width * progress, height: 8)
                                    .cornerRadius(4)
                            }
                        }
                        .frame(height: 8)
                        
                        Text("\(Int(progress * 100))%")
                            .font(.ubuntu(12))
                            .foregroundColor(Color.theme.secondaryText)
                            .frame(width: 40, alignment: .trailing)
                    }
                }
            }
            .padding(16)
            .background(Color.theme.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.theme.cardBorder, lineWidth: 1)
            )
        }
    }
    
    private var brandPreferencesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Top Brands")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            VStack(spacing: 8) {
                ForEach(Array(userViewModel.getBrandData().enumerated()), id: \.offset) { index, brandData in
                    HStack {
                        Text("\(index + 1).")
                            .font(.ubuntu(14, weight: .bold))
                            .foregroundColor(Color.theme.accentYellow)
                            .frame(width: 20)
                        
                        Text(brandData.0)
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                        
                        Spacer()
                        
                        Text("\(brandData.1) tries")
                            .font(.ubuntu(12))
                            .foregroundColor(Color.theme.secondaryText)
                    }
                }
            }
            .padding(16)
            .background(Color.theme.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.theme.cardBorder, lineWidth: 1)
            )
        }
    }
    
    private var categoryBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Category Breakdown")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(userViewModel.getCategoryData(), id: \.0) { category, count in
                    VStack(spacing: 8) {
                        Text("\(count)")
                            .font(.ubuntu(20, weight: .bold))
                            .foregroundColor(Color.theme.accentYellow)
                        
                        Text(category)
                            .font(.ubuntu(12, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                            .multilineTextAlignment(.center)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(Color.theme.cardBackground)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.theme.cardBorder, lineWidth: 1)
                    )
                }
            }
        }
    }
}

struct TryOnSessionCard: View {
    let session: TryOnSession
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(session.date, style: .date)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(Color.theme.accentYellow)
                
                Text(session.date, style: .time)
                    .font(.ubuntu(10))
                    .foregroundColor(Color.theme.secondaryText)
            }
            .frame(width: 60, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(session.brand)
                    .font(.ubuntu(14, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
                
                HStack(spacing: 8) {
                    Text(session.style.rawValue)
                        .font(.ubuntu(12))
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Text("•")
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Text(session.category.rawValue)
                        .font(.ubuntu(12))
                        .foregroundColor(Color.theme.secondaryText)
                }
                
                if let notes = session.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.ubuntu(11))
                        .foregroundColor(Color.theme.secondaryText)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            if let rating = session.rating {
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= rating ? "star.fill" : "star")
                            .font(.system(size: 12))
                            .foregroundColor(star <= rating ? Color.theme.accentYellow : Color.theme.secondaryText)
                    }
                }
            }
        }
        .padding(12)
        .background(Color.theme.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.theme.cardBorder, lineWidth: 1)
        )
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: achievement.icon)
                .font(.system(size: 24))
                .foregroundColor(achievement.isUnlocked ? Color.theme.accentYellow : Color.theme.secondaryText)
                .frame(width: 40, height: 40)
                .background(achievement.isUnlocked ? Color.theme.accentYellow.opacity(0.2) : Color.theme.cardBackground)
                .cornerRadius(20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(achievement.isUnlocked ? Color.theme.primaryText : Color.theme.secondaryText)
                
                Text(achievement.description)
                    .font(.ubuntu(14))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.leading)
                
                if let unlockedDate = achievement.unlockedDate {
                    Text("Unlocked \(unlockedDate, style: .date)")
                        .font(.ubuntu(12))
                        .foregroundColor(Color.theme.accentYellow)
                }
            }
            
            Spacer()
            
            if achievement.isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color.theme.accentYellow)
            }
        }
        .padding(16)
        .background(Color.theme.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(achievement.isUnlocked ? Color.theme.accentYellow : Color.theme.cardBorder, lineWidth: 1)
        )
        .opacity(achievement.isUnlocked ? 1.0 : 0.7)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(Color.theme.accentYellow)
            
            Text(value)
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            Text(title)
                .font(.ubuntu(12, weight: .medium))
                .foregroundColor(Color.theme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color.theme.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.theme.cardBorder, lineWidth: 1)
        )
    }
}

#Preview {
    UserProgressView()
        .environmentObject(UserViewModel())
        .environmentObject(BagViewModel())
}
