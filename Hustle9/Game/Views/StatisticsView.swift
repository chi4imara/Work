import SwiftUI

struct StatisticsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: GamesViewModel
    @State private var selectedPeriod: TimePeriod = .all
    
    enum TimePeriod: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
        case all = "All Time"
        
        var displayName: String { rawValue }
    }
    
    private var statistics: GameStatistics {
        GameStatistics(games: viewModel.games, period: selectedPeriod)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            periodSelector
                            
                            mainStatsGrid
                            
                            categoryBreakdown
                            
                            recentActivity
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Statistics")
                        .font(AppFonts.title1)
                        .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.accent)
                    }
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Statistics")
                .font(AppFonts.largeTitle)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
    
    private var periodSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(TimePeriod.allCases, id: \.self) { period in
                    Button(action: {
                        selectedPeriod = period
                    }) {
                        Text(period.displayName)
                            .font(AppFonts.buttonSmall)
                            .foregroundColor(selectedPeriod == period ? AppColors.primaryText : AppColors.secondaryText)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(selectedPeriod == period ? AppColors.accent : AppColors.buttonBackground)
                            )
                    }
                }
            }
            .padding(.horizontal, 40)
        }
        .padding(.horizontal, -40)
    }
    
    private var mainStatsGrid: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                StatCard(
                    title: "Total Games",
                    value: "\(statistics.totalGames)",
                    icon: "gamecontroller.fill",
                    color: AppColors.primaryBlue
                )
                
                StatCard(
                    title: "Favorites",
                    value: "\(statistics.favoriteGames)",
                    icon: "star.fill",
                    color: AppColors.accent
                )
            }
            
            HStack(spacing: 16) {
                StatCard(
                    title: "Sections",
                    value: "\(statistics.totalSections)",
                    icon: "doc.text.fill",
                    color: AppColors.success
                )
                
                StatCard(
                    title: "Categories",
                    value: "\(statistics.uniqueCategories)",
                    icon: "folder.fill",
                    color: AppColors.warning
                )
            }
        }
    }
    
    private var categoryBreakdown: some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Games by Category")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.primaryText)
                
                VStack(spacing: 12) {
                    ForEach(statistics.categoryStats, id: \.category) { stat in
                        CategoryStatRow(
                            category: stat.category,
                            count: stat.count,
                            percentage: stat.percentage,
                            total: statistics.totalGames
                        )
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.cardBorder, lineWidth: 1)
                        )
                )
            }
            Spacer()
        }
    }
    
    private var recentActivity: some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Recent Activity")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.primaryText)
                
                VStack(spacing: 12) {
                    ForEach(statistics.recentGames.prefix(5), id: \.id) { game in
                        RecentActivityRow(game: game)
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.cardBorder, lineWidth: 1)
                        )
                )
            }
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
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(AppFonts.title1)
                .foregroundColor(AppColors.primaryText)
            
            Text(title)
                .font(AppFonts.caption1)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
}

struct CategoryStatRow: View {
    let category: GameCategory
    let count: Int
    let percentage: Double
    let total: Int
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: category.iconName)
                .font(.system(size: 16))
                .foregroundColor(AppColors.accent)
                .frame(width: 20)
            
            Text(category.displayName)
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(count)")
                    .font(AppFonts.bodyMedium)
                    .foregroundColor(AppColors.primaryText)
                
                Text("\(Int(percentage))%")
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            GeometryReader { geometry in
                RoundedRectangle(cornerRadius: 4)
                    .fill(AppColors.cardBorder)
                    .frame(height: 6)
                    .overlay(
                        HStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(AppColors.accent)
                                .frame(width: geometry.size.width * (percentage / 100))
                            Spacer(minLength: 0)
                        }
                    )
            }
            .frame(width: 60, height: 6)
        }
    }
}

struct RecentActivityRow: View {
    let game: Game
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: game.category.iconName)
                .font(.system(size: 16))
                .foregroundColor(AppColors.accent)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(game.name)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(1)
                
                Text(game.dateModified.formatted(date: .abbreviated, time: .omitted))
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            if game.isFavorite {
                Image(systemName: "star.fill")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.accent)
            }
        }
    }
}

struct GameStatistics {
    let games: [Game]
    let period: StatisticsView.TimePeriod
    
    var totalGames: Int {
        games.count
    }
    
    var favoriteGames: Int {
        games.filter { $0.isFavorite }.count
    }
    
    var totalSections: Int {
        games.reduce(0) { $0 + $1.sections.count }
    }
    
    var uniqueCategories: Int {
        Set(games.map { $0.category }).count
    }
    
    var categoryStats: [CategoryStat] {
        let categoryCounts = Dictionary(grouping: games, by: { $0.category })
            .mapValues { $0.count }
        
        return GameCategory.allCases.compactMap { category in
            let count = categoryCounts[category] ?? 0
            guard count > 0 else { return nil }
            
            return CategoryStat(
                category: category,
                count: count,
                percentage: totalGames > 0 ? Double(count) / Double(totalGames) * 100 : 0
            )
        }.sorted { $0.count > $1.count }
    }
    
    var recentGames: [Game] {
        games.sorted { $0.dateModified > $1.dateModified }
    }
}

struct CategoryStat {
    let category: GameCategory
    let count: Int
    let percentage: Double
}

#Preview {
    ZStack {
        BackgroundView()
        StatisticsView()
            .environmentObject(GamesViewModel())
    }
}
