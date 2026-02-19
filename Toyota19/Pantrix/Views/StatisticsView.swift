import SwiftUI

struct StatisticsView: View {
    @ObservedObject var appState: AppState
    
    private var totalCookedCount: Int {
        appState.cookedRecipes.count
    }
    
    private var favoriteCount: Int {
        appState.favoriteRecipes.count
    }
    
    private var totalRecipesCount: Int {
        appState.recipes.count
    }
    
    private var cookedThisWeek: Int {
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
        return appState.cookedRecipes.filter { $0.dateCook >= startOfWeek }.count
    }
    
    private var mostCookedRecipes: [(name: String, count: Int)] {
        let grouped = Dictionary(grouping: appState.cookedRecipes, by: { $0.recipeName })
        return grouped
            .map { ($0.key, $0.value.count) }
            .sorted { $0.1 > $1.1 }
            .prefix(5)
            .map { ($0.0, $0.1) }
    }
    
    private var categoryBreakdown: [(Recipe.RecipeCategory, Int)] {
        Recipe.RecipeCategory.allCases.map { category in
            let count = appState.recipes.filter { $0.category == category }.count
            return (category, count)
        }
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        Text("Statistics")
                            .font(.appTitle)
                            .foregroundColor(.appWhite)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            StatCard(
                                title: "Total Cooked",
                                value: "\(totalCookedCount)",
                                icon: "checkmark.circle.fill"
                            )
                            
                            StatCard(
                                title: "This Week",
                                value: "\(cookedThisWeek)",
                                icon: "calendar"
                            )
                        }
                        
                        HStack(spacing: 16) {
                            StatCard(
                                title: "Favorites",
                                value: "\(favoriteCount)",
                                icon: "heart.fill"
                            )
                            
                            StatCard(
                                title: "Recipes",
                                value: "\(totalRecipesCount)",
                                icon: "book.fill"
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    if !mostCookedRecipes.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Most Cooked")
                                .font(.appTitle3)
                                .foregroundColor(.appWhite)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 8) {
                                ForEach(Array(mostCookedRecipes.enumerated()), id: \.offset) { index, item in
                                    HStack {
                                        Text("\(index + 1).")
                                            .font(.appCallout)
                                            .foregroundColor(.appOrange)
                                            .frame(width: 24, alignment: .leading)
                                        
                                        Text(item.name)
                                            .font(.appBody)
                                            .foregroundColor(.appWhite)
                                        
                                        Spacer()
                                        
                                        Text("\(item.count)x")
                                            .font(.appCallout)
                                            .foregroundColor(.appOrange)
                                    }
                                    .padding(16)
                                    .background(AppColors.cardGradient)
                                    .cornerRadius(12)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recipes by Category")
                            .font(.appTitle3)
                            .foregroundColor(.appWhite)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 8) {
                            ForEach(categoryBreakdown, id: \.0) { category, count in
                                HStack {
                                    Text(category.displayName)
                                        .font(.appBody)
                                        .foregroundColor(.appWhite)
                                    
                                    Spacer()
                                    
                                    Text("\(count)")
                                        .font(.appCallout)
                                        .foregroundColor(.appOrange)
                                }
                                .padding(16)
                                .background(AppColors.cardGradient)
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.bottom, 120)
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.appCallout)
                    .foregroundColor(.appOrange)
                Spacer()
            }
            
            Text(value)
                .font(.appTitle2)
                .foregroundColor(.appWhite)
            
            Text(title)
                .font(.appCaption)
                .foregroundColor(.appWhite.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.appWhite.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    StatisticsView(appState: AppState())
}
