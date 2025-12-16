import SwiftUI

struct InspirationView: View {
    @State private var selectedTheme: String?
    @State private var expandedTheme: String?
    
    private let dailyIdeas = [
        "Try making an omelet with herbs and toast.",
        "Combine sweet and salty: cheese with honey.",
        "Add lemon to tea — feel the evening comfort.",
        "Roast vegetables with olive oil and garlic.",
        "Make a simple pasta with butter and parmesan."
    ]
    
    private let weeklyThemes = [
        "Breakfast": [
            "Overnight oats with berries",
            "Avocado toast with poached egg",
            "Smoothie bowl with granola"
        ],
        "Autumn Dishes": [
            "Pumpkin soup with cream",
            "Apple cinnamon oatmeal",
            "Roasted root vegetables"
        ],
        "5 Ingredients": [
            "Caprese salad",
            "Garlic butter shrimp",
            "Banana pancakes"
        ],
        "Sweet Without Sugar": [
            "Date energy balls",
            "Fruit salad with mint",
            "Baked apples with cinnamon"
        ]
    ]
    
    private let dailyTips = [
        "Home cooking is also creativity.",
        "The best recipes come from the heart.",
        "Simple ingredients make the most comfort.",
        "Every dish tells a story.",
        "Cooking is love made visible."
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        HStack {
                            Text("Inspiration")
                                .font(FontManager.title1)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(AppColors.primaryYellow)
                                
                                Text("Ideas of the Day")
                                    .font(FontManager.title2)
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(Array(dailyIdeas.enumerated()), id: \.offset) { index, idea in
                                        IdeaCard(idea: idea, index: index)
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "calendar")
                                    .font(.system(size: 20))
                                    .foregroundColor(AppColors.primaryBlue)
                                
                                Text("Weekly Themes")
                                    .font(FontManager.title2)
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                ForEach(Array(weeklyThemes.keys.sorted()), id: \.self) { theme in
                                    ThemeCard(
                                        theme: theme,
                                        recipes: weeklyThemes[theme] ?? [],
                                        isExpanded: expandedTheme == theme,
                                        onTap: {
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                if expandedTheme == theme {
                                                    expandedTheme = nil
                                                } else {
                                                    expandedTheme = theme
                                                }
                                            }
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "quote.bubble.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(AppColors.accent)
                                
                                Text("Tip of the Day")
                                    .font(FontManager.title2)
                                    .foregroundColor(AppColors.textPrimary)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            
                            DailyTipCard(tip: dailyTips.randomElement() ?? dailyTips[0])
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct IdeaCard: View {
    let idea: String
    let index: Int
    
    private let colors = [
        AppColors.primaryBlue,
        AppColors.primaryYellow,
        AppColors.accent,
        AppColors.success,
        AppColors.primaryBlue.opacity(0.8)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "fork.knife")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(index + 1)")
                    .font(FontManager.caption1)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Text(idea)
                .font(FontManager.body)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
        }
        .padding(16)
        .frame(width: 200, alignment: .leading)
        .frame(maxHeight: .infinity)
        .background(colors[index % colors.count])
        .cornerRadius(16)
    }
}

struct ThemeCard: View {
    let theme: String
    let recipes: [String]
    let isExpanded: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: onTap) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(theme)
                            .font(FontManager.headline)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("\(recipes.count) ideas")
                            .font(FontManager.caption1)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                        .rotationEffect(.degrees(isExpanded ? 0 : 0))
                        .animation(.easeInOut(duration: 0.2), value: isExpanded)
                }
                .padding(16)
                .background(AppColors.cardGradient)
                .cornerRadius(isExpanded ? 16 : 16)
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack(spacing: 8) {
                    ForEach(recipes, id: \.self) { recipe in
                        HStack {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 6))
                                .foregroundColor(AppColors.primaryBlue)
                            
                            Text(recipe)
                                .font(FontManager.callout)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    }
                }
                .background(AppColors.cardGradient.opacity(0.5))
                .cornerRadius(16)
                .padding(.top, -16)
                .padding(.top, 20)
            }
        }
    }
}

struct DailyTipCard: View {
    let tip: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "heart.fill")
                .font(.system(size: 24))
                .foregroundColor(AppColors.accent)
            
            Text(tip)
                .font(FontManager.body)
                .foregroundColor(AppColors.textPrimary)
                .multilineTextAlignment(.leading)
                .italic()
            
            Spacer()
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [AppColors.accent.opacity(0.1), AppColors.primaryYellow.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.accent.opacity(0.3), lineWidth: 1)
        )
    }
}
