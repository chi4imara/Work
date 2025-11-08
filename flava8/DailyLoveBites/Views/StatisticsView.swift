import SwiftUI

struct StatisticsView: View {
    @ObservedObject private var viewModel = RecipeViewModel.shared
    @ObservedObject private var tagViewModel = TagViewModel.shared
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerSection
                        
                        VStack(spacing: 16) {
                            overviewStatsSection
                            
                            difficultyStatsSection
                            
                            cookingTimeStatsSection
                            
                            tagsStatsSection
                            
                            recentActivitySection
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(20)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Statistics")
                        .font(AppFonts.titleLarge)
                        .foregroundColor(.white)
                    
                    Text("Your cooking journey")
                        .font(AppFonts.bodyMedium)
                        .foregroundColor(.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.accentOrange)
                    .frame(width: 44, height: 44)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }
        }
    }
    
    private var overviewStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(AppFonts.titleSmall)
                .foregroundColor(.white)
            
            HStack(spacing: 12) {
                StatCard(
                    title: "Total Recipes",
                    value: "\(viewModel.recipes.count)",
                    icon: "book.fill",
                    color: .primaryPurple
                )
                
                StatCard(
                    title: "Favorites",
                    value: "\(viewModel.recipes.filter { $0.isFavorite }.count)",
                    icon: "heart.fill",
                    color: .errorRed
                )
            }
            
            HStack(spacing: 12) {
                StatCard(
                    title: "Tags",
                    value: "\(tagViewModel.tags.count)",
                    icon: "tag.fill",
                    color: .accentOrange
                )
                
                StatCard(
                    title: "Avg. Time",
                    value: averageCookingTime,
                    icon: "clock.fill",
                    color: .accentPink
                )
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
    }
    
    private var difficultyStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Difficulty Distribution")
                .font(AppFonts.titleSmall)
                .foregroundColor(.white)
            
            VStack(spacing: 8) {
                ForEach(Recipe.Difficulty.allCases, id: \.self) { difficulty in
                    DifficultyBar(
                        difficulty: difficulty,
                        count: viewModel.recipes.filter { $0.difficulty == difficulty }.count,
                        total: viewModel.recipes.count
                    )
                }
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
    }
    
    private var cookingTimeStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Cooking Time")
                .font(AppFonts.titleSmall)
                .foregroundColor(.white)
            
            VStack(spacing: 8) {
                TimeStatRow(
                    title: "Quick (≤15 min)",
                    count: viewModel.recipes.filter { ($0.cookingTime ?? 0) <= 15 }.count,
                    color: .successGreen
                )
                
                TimeStatRow(
                    title: "Medium (16-30 min)",
                    count: viewModel.recipes.filter { let time = $0.cookingTime ?? 0; return time > 15 && time <= 30 }.count,
                    color: .warningYellow
                )
                
                TimeStatRow(
                    title: "Long (>30 min)",
                    count: viewModel.recipes.filter { ($0.cookingTime ?? 0) > 30 }.count,
                    color: .errorRed
                )
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
    }
    
    private var tagsStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Popular Tags")
                .font(AppFonts.titleSmall)
                .foregroundColor(.white)
            
            if tagViewModel.tags.isEmpty {
                Text("No tags yet")
                    .font(AppFonts.bodyMedium)
                    .foregroundColor(.secondaryText)
            } else {
                VStack(spacing: 8) {
                    ForEach(Array(tagViewModel.tags.prefix(5)), id: \.id) { tag in
                        TagStatRow(
                            tag: tag,
                            count: tagViewModel.getTagUsageCount(tag)
                        )
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
    }
    
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(AppFonts.titleSmall)
                .foregroundColor(.white)
            
            VStack(spacing: 8) {
                ForEach(Array(viewModel.recipes.sorted { $0.updatedAt > $1.updatedAt }.prefix(3)), id: \.id) { recipe in
                    RecentActivityRow(recipe: recipe)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
    }
    
    private var averageCookingTime: String {
        let recipesWithTime = viewModel.recipes.compactMap { $0.cookingTime }
        guard !recipesWithTime.isEmpty else { return "N/A" }
        
        let average = recipesWithTime.reduce(0, +) / recipesWithTime.count
        return "\(average) min"
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
                .font(.system(size: 20))
                .foregroundColor(color)
            
            Text(value)
                .font(AppFonts.titleMedium)
                .foregroundColor(.white)
            
            Text(title)
                .font(AppFonts.bodySmall)
                .foregroundColor(.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

struct DifficultyBar: View {
    let difficulty: Recipe.Difficulty
    let count: Int
    let total: Int
    
    private var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(count) / Double(total)
    }
    
    private var color: Color {
        switch difficulty {
        case .easy: return .successGreen
        case .medium: return .warningYellow
        case .hard: return .errorRed
        }
    }
    
    var body: some View {
        HStack {
            Text(difficulty.localizedString)
                .font(AppFonts.bodyMedium)
                .foregroundColor(.white)
                .frame(width: 60, alignment: .leading)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * percentage, height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
            
            Text("\(count)")
                .font(AppFonts.bodySmall)
                .foregroundColor(.secondaryText)
                .frame(width: 30, alignment: .trailing)
        }
    }
}

struct TimeStatRow: View {
    let title: String
    let count: Int
    let color: Color
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            
            Text(title)
                .font(AppFonts.bodyMedium)
                .foregroundColor(.white)
            
            Spacer()
            
            Text("\(count)")
                .font(AppFonts.bodyMedium)
                .foregroundColor(.secondaryText)
        }
    }
}

struct TagStatRow: View {
    let tag: Tag
    let count: Int
    
    var body: some View {
        HStack {
            Text("#\(tag.name)")
                .font(AppFonts.bodyMedium)
                .foregroundColor(.primaryPurple)
            
            Spacer()
            
            Text("\(count) recipe\(count == 1 ? "" : "s")")
                .font(AppFonts.bodySmall)
                .foregroundColor(.secondaryText)
        }
    }
}

struct RecentActivityRow: View {
    let recipe: Recipe
    
    var body: some View {
        HStack {
            Image(systemName: "clock")
                .font(.system(size: 14))
                .foregroundColor(.accentOrange)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(recipe.name)
                    .font(AppFonts.bodyMedium)
                    .foregroundColor(.white)
                
                Text("Updated \(formatDate(recipe.updatedAt))")
                    .font(AppFonts.bodySmall)
                    .foregroundColor(.secondaryText)
            }
            
            Spacer()
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

#Preview {
    StatisticsView()
}
