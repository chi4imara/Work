import SwiftUI

struct InsightsView: View {
    @ObservedObject var store: FirstExperienceStore
    @State private var selectedInsight: InsightType = .recommendations
    @State private var showingGoalSheet = false
    @State private var newGoalTitle = ""
    @State private var newGoalDescription = ""
    @State private var showingAddExperience = false
    @State private var showingCategorySuggestions = false
    @State private var showingLocationSuggestions = false
    
    enum InsightType: String, CaseIterable {
        case recommendations = "Recommendations"
        case achievements = "Achievements"
        case goals = "Goals"
        case motivation = "Motivation"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackgroundView()
                
                VStack(spacing: 0) {
                    headerView
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            quickStatsSection
                            
                            insightTypeSelector
                            
                            insightContent
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingGoalSheet) {
            addGoalSheet
        }
        .sheet(isPresented: $showingAddExperience) {
            AddEditExperienceView(store: store)
        }
        .sheet(isPresented: $showingCategorySuggestions) {
            categorySuggestionsSheet
        }
        .sheet(isPresented: $showingLocationSuggestions) {
            locationSuggestionsSheet
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Insights")
                    .font(FontManager.largeTitle)
                    .foregroundColor(AppColors.pureWhite)
                
                Spacer()
                
                Button(action: {
                    showingGoalSheet = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.accentYellow)
                }
            }
            
            HStack {
                Text("Discover your growth patterns")
                    .font(FontManager.caption1)
                    .foregroundColor(AppColors.pureWhite.opacity(0.8))
                
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var quickStatsSection: some View {
        HStack(spacing: 16) {
            QuickStatCard(
                title: "Total",
                value: "\(store.experiences.count)",
                icon: "star.fill",
                color: AppColors.accentYellow
            )
            
            QuickStatCard(
                title: "This Month",
                value: "\(getThisMonthCount())",
                icon: "calendar",
                color: AppColors.lightPurple
            )
            
            QuickStatCard(
                title: "Categories",
                value: "\(getUniqueCategoriesCount())",
                icon: "tag.fill",
                color: AppColors.mintGreen
            )
        }
    }
    
    private var insightTypeSelector: some View {
        Picker("Insight Type", selection: $selectedInsight) {
            ForEach(InsightType.allCases, id: \.self) { type in
                Text(type.rawValue).tag(type)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .colorScheme(.dark)
    }
    
    @ViewBuilder
    private var insightContent: some View {
        switch selectedInsight {
        case .recommendations:
            recommendationsContent
        case .achievements:
            achievementsContent
        case .goals:
            goalsContent
        case .motivation:
            motivationContent
        }
    }
    
    private var recommendationsContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Smart Recommendations")
                .font(FontManager.title2)
                .foregroundColor(AppColors.pureWhite)
            
            VStack(spacing: 12) {
                RecommendationCard(
                    icon: "lightbulb.fill",
                    title: "Try New Categories",
                    description: getCategoryRecommendation(),
                    color: AppColors.accentYellow,
                    action: "Explore",
                    onTap: {
                        showingCategorySuggestions = true
                    }
                )
                
                RecommendationCard(
                    icon: "location.fill",
                    title: "Location-Based Ideas",
                    description: getLocationRecommendation(),
                    color: Color.blue,
                    action: "Discover",
                    onTap: {
                        showingLocationSuggestions = true
                    }
                )
                
                RecommendationCard(
                    icon: "calendar.badge.plus",
                    title: "Timing Suggestions",
                    description: getTimingRecommendation(),
                    color: AppColors.softPink,
                    action: "Plan",
                    onTap: {
                        showingAddExperience = true
                    }
                )
            }
        }
    }
    
    private var achievementsContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Achievements")
                .font(FontManager.title2)
                .foregroundColor(AppColors.pureWhite)
            
            VStack(spacing: 12) {
                ForEach(getAchievements(), id: \.title) { achievement in
                    AchievementCard(achievement: achievement)
                }
            }
        }
    }
    
    private var goalsContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Your Goals")
                    .font(FontManager.title2)
                    .foregroundColor(AppColors.pureWhite)
                
                Spacer()
                
                Button("Add Goal") {
                    showingGoalSheet = true
                }
                .font(FontManager.callout)
                .foregroundColor(AppColors.accentYellow)
            }
            
            VStack(spacing: 12) {
                GoalCard(
                    title: "Complete 10 Experiences",
                    description: "You're \(max(0, 10 - store.experiences.count)) experiences away!",
                    progress: min(1.0, Double(store.experiences.count) / 10.0),
                    color: AppColors.accentYellow
                )
                
                GoalCard(
                    title: "Try 5 Different Categories",
                    description: "Explore diverse experiences",
                    progress: min(1.0, Double(getUniqueCategoriesCount()) / 5.0),
                    color: AppColors.lightPurple
                )
                
                ForEach(store.goals.filter { !$0.isCompleted }, id: \.id) { goal in
                    GoalCard(
                        title: goal.title,
                        description: goal.description,
                        progress: 0.0,
                        color: AppColors.softPink
                    )
                }
            }
        }
    }
    
    private var motivationContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Daily Motivation")
                .font(FontManager.title2)
                .foregroundColor(AppColors.pureWhite)
            
            VStack(spacing: 12) {
                MotivationCard(
                    quote: getMotivationalQuote(),
                    author: "FirstGlow",
                    color: AppColors.peachOrange
                )
                
                MotivationCard(
                    quote: "Every first time is a step towards becoming who you want to be.",
                    author: "Your Journey",
                    color: AppColors.softPink
                )
            }
        }
    }
    
    private var addGoalSheet: some View {
            ZStack {
                AnimatedBackgroundView()
                
                VStack(spacing: 24) {
                    HStack {
                        Button("Cancel") {
                            showingGoalSheet = false
                            newGoalTitle = ""
                            newGoalDescription = ""
                        }
                        .font(FontManager.callout)
                        .foregroundColor(AppColors.pureWhite)
                        
                        Spacer()
                        
                        Text("Add Goal")
                            .font(FontManager.title2)
                            .foregroundColor(AppColors.pureWhite)
                        
                        Spacer()
                        
                        Button("Save") {
                            let newGoal = Goal(title: newGoalTitle, description: newGoalDescription)
                            store.addGoal(newGoal)
                            showingGoalSheet = false
                            newGoalTitle = ""
                            newGoalDescription = ""
                        }
                        .font(FontManager.callout)
                        .foregroundColor(!newGoalTitle.isEmpty ? AppColors.accentYellow : AppColors.pureWhite.opacity(0.5))
                        .disabled(newGoalTitle.isEmpty)
                    }
                    .padding()
                    
                    TextField("Goal Title", text: $newGoalTitle)
                        .foregroundColor(AppColors.pureWhite)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.pureWhite.opacity(0.1))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.pureWhite.opacity(0.3), lineWidth: 1)
                                }
                        )
                    
                    TextField("Description", text: $newGoalDescription, axis: .vertical)
                        .foregroundColor(AppColors.pureWhite)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.pureWhite.opacity(0.1))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.pureWhite.opacity(0.3), lineWidth: 1)
                                }
                        )
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
        }
    
    private var categorySuggestionsSheet: some View {
        NavigationView {
            ZStack {
                AnimatedBackgroundView()
                
                VStack(spacing: 20) {
                    Text("Category Suggestions")
                        .font(FontManager.title2)
                        .foregroundColor(AppColors.pureWhite)
                        .padding(.top)
                    
                    Text("Based on your current experiences, here are some categories you might want to explore:")
                        .font(FontManager.body)
                        .foregroundColor(AppColors.pureWhite.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        ForEach(getSuggestedCategories(), id: \.self) { category in
                            HStack {
                                Image(systemName: "tag.fill")
                                    .foregroundColor(AppColors.accentYellow)
                                
                                Text(category)
                                    .font(FontManager.body)
                                    .foregroundColor(AppColors.darkGray)
                                
                                Spacer()
                                
                                Button("Add") {
                                    let newCategory = Category(name: category)
                                    store.addCategory(newCategory)
                                    showingCategorySuggestions = false
                                }
                                .font(FontManager.caption1)
                                .foregroundColor(AppColors.accentYellow)
                            }
                            .padding()
                            .cardBackground()
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .overlay(
                VStack {
                    HStack {
                        Spacer()
                        Button("Close") {
                            showingCategorySuggestions = false
                        }
                        .font(FontManager.callout)
                        .foregroundColor(AppColors.accentYellow)
                        .padding()
                    }
                    .padding(.trailing, 8)
                    Spacer()
                }
            )
        }
    }
    
    private var locationSuggestionsSheet: some View {
        NavigationView {
            ZStack {
                AnimatedBackgroundView()
                
                VStack(spacing: 20) {
                    Text("Location Ideas")
                        .font(FontManager.title2)
                        .foregroundColor(AppColors.pureWhite)
                        .padding(.top)
                    
                    Text("Discover new places to have your first experiences:")
                        .font(FontManager.body)
                        .foregroundColor(AppColors.pureWhite.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        ForEach(getSuggestedLocations(), id: \.self) { location in
                            HStack {
                                Image(systemName: "location.fill")
                                    .foregroundColor(Color.blue)
                                
                                Text(location)
                                    .font(FontManager.body)
                                    .foregroundColor(AppColors.darkGray)
                                
                                Spacer()
                                
                                Button("Use") {
                                    UIPasteboard.general.string = location
                                    showingLocationSuggestions = false
                                    showingAddExperience = true
                                }
                                .font(FontManager.caption1)
                                .foregroundColor(Color.blue)
                            }
                            .padding()
                            .cardBackground()
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .overlay(
                VStack {
                    HStack {
                        Spacer()
                        
                        Button("Close") {
                            showingLocationSuggestions = false
                        }
                        .font(FontManager.callout)
                        .foregroundColor(Color.blue)
                        .padding()
                    }
                    .padding(.trailing, 8)
                    Spacer()
                }
            )
        }
    }
    
    private func getThisMonthCount() -> Int {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.dateInterval(of: .month, for: now)?.start ?? now
        
        return store.experiences.filter { $0.date >= startOfMonth }.count
    }
    
    private func getUniqueCategoriesCount() -> Int {
        let categories = Set(store.experiences.compactMap { $0.category })
        return categories.count
    }
    
    private func getCategoryRecommendation() -> String {
        let categories = Set(store.experiences.compactMap { $0.category })
        if categories.count < 3 {
            return "Try exploring different categories to diversify your experiences!"
        } else {
            return "Great job exploring! Consider trying a completely new category."
        }
    }
    
    private func getLocationRecommendation() -> String {
        let places = Set(store.experiences.compactMap { $0.place })
        if places.count < 2 {
            return "Try adding experiences from different locations to expand your horizons."
        } else {
            return "You're exploring diverse places! Keep discovering new locations."
        }
    }
    
    private func getTimingRecommendation() -> String {
        let recentCount = getThisMonthCount()
        if recentCount == 0 {
            return "It's been a while since your last experience. Time for something new!"
        } else if recentCount >= 3 {
            return "You're on fire! Keep up this amazing momentum."
        } else {
            return "Great pace! Consider planning your next experience soon."
        }
    }
    
    private func getAchievements() -> [Achievement] {
        var achievements: [Achievement] = []
        
        if store.experiences.count >= 1 {
            achievements.append(Achievement(
                title: "First Step",
                description: "Added your first experience",
                icon: "star.fill",
                color: AppColors.accentYellow,
                isUnlocked: true
            ))
        }
        
        if store.experiences.count >= 5 {
            achievements.append(Achievement(
                title: "Explorer",
                description: "Completed 5 experiences",
                icon: "map.fill",
                color: AppColors.lightPurple,
                isUnlocked: true
            ))
        }
        
        if getUniqueCategoriesCount() >= 3 {
            achievements.append(Achievement(
                title: "Diverse",
                description: "Tried 3 different categories",
                icon: "tag.fill",
                color: AppColors.mintGreen,
                isUnlocked: true
            ))
        }
        
        return achievements
    }
    
    private func getMotivationalQuote() -> String {
        let quotes = [
            "Every expert was once a beginner.",
            "The only impossible journey is the one you never begin.",
            "Life begins at the end of your comfort zone.",
            "You miss 100% of the shots you don't take.",
            "The future belongs to those who believe in the beauty of their dreams."
        ]
        
        let index = abs(store.experiences.count) % quotes.count
        return quotes[index]
    }
    
    private func getSuggestedCategories() -> [String] {
        let existingCategories = Set(store.experiences.compactMap { $0.category })
        let allCategories = [
            "Travel", "Food", "Sports", "Music", "Art", "Technology",
            "Nature", "Culture", "Adventure", "Learning", "Social", "Health"
        ]
        
        return allCategories.filter { !existingCategories.contains($0) }.prefix(5).map { $0 }
    }
    
    private func getSuggestedLocations() -> [String] {
        let existingPlaces = Set(store.experiences.compactMap { $0.place })
        let suggestions = [
            "Local Museum", "New Restaurant", "Park", "Library", "Gym",
            "Art Gallery", "Concert Hall", "Beach", "Mountain", "City Center"
        ]
        
        return suggestions.filter { !existingPlaces.contains($0) }.prefix(5).map { $0 }
    }
}

struct QuickStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(FontManager.title2)
                .foregroundColor(AppColors.darkGray)
            
            Text(title)
                .font(FontManager.caption1)
                .foregroundColor(AppColors.mediumGray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(16)
        .cardBackground()
    }
}

struct RecommendationCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    let action: String
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(FontManager.builderSans(.semiBold, size: 15))
                        .foregroundColor(AppColors.darkGray)
                    
                    Text(description)
                        .font(FontManager.callout)
                        .foregroundColor(AppColors.mediumGray)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Button(action: onTap) {
                    Text(action)
                        .font(FontManager.callout)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(color.opacity(0.1))
                        )
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardBackground()
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: achievement.icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(achievement.color)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.darkGray)
                
                Text(achievement.description)
                    .font(FontManager.callout)
                    .foregroundColor(AppColors.mediumGray)
            }
            
            Spacer()
            
            if achievement.isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.accentYellow)
            }
        }
        .padding(16)
        .cardBackground()
        .opacity(achievement.isUnlocked ? 1.0 : 0.6)
    }
}

struct GoalCard: View {
    let title: String
    let description: String
    let progress: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.darkGray)
                
                Spacer()
                
                if title == "Complete 10 Experiences"  || title == "Try 5 Different Categories" {
                    Text("\(Int(progress * 100))%")
                        .font(FontManager.caption1)
                        .foregroundColor(color)
                }
            }
            
            Text(description)
                .font(FontManager.callout)
                .foregroundColor(AppColors.mediumGray)
            
            if title == "Complete 10 Experiences"  || title == "Try 5 Different Categories" {
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: color))
            }
        }
        .padding(16)
        .cardBackground()
    }
}

struct MotivationCard: View {
    let quote: String
    let author: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\(quote)")
                .font(FontManager.body)
                .foregroundColor(AppColors.darkGray)
                .italic()
                .multilineTextAlignment(.leading)
            
            HStack {
                Spacer()
                Text("— \(author)")
                    .font(FontManager.caption1.bold())
                    .foregroundColor(color)
            }
        }
        .padding(16)
        .cardBackground()
    }
}

struct Achievement {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let isUnlocked: Bool
}

#Preview {
    InsightsView(store: FirstExperienceStore())
}
