import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        ZStack {
            ColorManager.mainGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("Statistics")
                            .font(FontManager.ubuntu(size: 28, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Text("Your game collection overview")
                            .font(FontManager.ubuntu(size: 14, weight: .regular))
                            .foregroundColor(ColorManager.secondaryText)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    
                    VStack(spacing: 16) {
                        StatCardView(
                            title: "Total Games",
                            value: "\(viewModel.games.count)",
                            icon: "gamecontroller.fill",
                            color: ColorManager.primaryBlue
                        )
                        
                        StatCardView(
                            title: "Favorite Games",
                            value: "\(viewModel.favoriteGames.count)",
                            icon: "star.fill",
                            color: ColorManager.primaryYellow
                        )
                        
                        StatCardView(
                            title: "Categories",
                            value: "\(viewModel.categories.count)",
                            icon: "tag.fill",
                            color: ColorManager.accentColor
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    if !viewModel.games.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Most Popular Games")
                                .font(FontManager.ubuntu(size: 20, weight: .bold))
                                .foregroundColor(ColorManager.primaryText)
                                .padding(.horizontal, 20)
                            
                            let topGames = viewModel.games
                                .sorted { $0.favoriteCount > $1.favoriteCount }
                                .prefix(5)
                            
                            VStack(spacing: 12) {
                                ForEach(Array(topGames.enumerated()), id: \.element.id) { index, game in
                                    TopGameRowView(
                                        rank: index + 1,
                                        game: game
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.top, 10)
                    }
                    
                    if !viewModel.categories.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Games by Category")
                                .font(FontManager.ubuntu(size: 20, weight: .bold))
                                .foregroundColor(ColorManager.primaryText)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                ForEach(viewModel.categories.sorted { $0.gameCount > $1.gameCount }) { category in
                                    CategoryStatRowView(category: category, totalGames: viewModel.games.count)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.top, 10)
                    }
                    
                    Spacer(minLength: 50)
                }
            }
        }
    }
}

struct StatCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.15))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(FontManager.ubuntu(size: 32, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text(title)
                    .font(FontManager.ubuntu(size: 14, weight: .medium))
                    .foregroundColor(ColorManager.secondaryText)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.cardBackground)
                .shadow(color: ColorManager.shadowColor, radius: 4, x: 0, y: 2)
        )
    }
}

struct TopGameRowView: View {
    let rank: Int
    let game: Game
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(ColorManager.primaryBlue.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Text("\(rank)")
                    .font(FontManager.ubuntu(size: 18, weight: .bold))
                    .foregroundColor(ColorManager.primaryBlue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(game.name)
                    .font(FontManager.ubuntu(size: 16, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text(game.category)
                    .font(FontManager.ubuntu(size: 12, weight: .medium))
                    .foregroundColor(ColorManager.secondaryText)
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .font(.system(size: 14))
                    .foregroundColor(ColorManager.primaryYellow)
                
                Text("\(game.favoriteCount)")
                    .font(FontManager.ubuntu(size: 14, weight: .medium))
                    .foregroundColor(ColorManager.secondaryText)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorManager.cardBackground)
                .shadow(color: ColorManager.shadowColor, radius: 2, x: 0, y: 1)
        )
    }
}

struct CategoryStatRowView: View {
    let category: Category
    let totalGames: Int
    
    private var percentage: Double {
        guard totalGames > 0 else { return 0 }
        return Double(category.gameCount) / Double(totalGames) * 100
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(category.name)
                    .font(FontManager.ubuntu(size: 16, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                
                Spacer()
                
                Text("\(category.gameCount) games")
                    .font(FontManager.ubuntu(size: 14, weight: .medium))
                    .foregroundColor(ColorManager.secondaryText)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(ColorManager.secondaryText.opacity(0.2))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(ColorManager.primaryBlue)
                        .frame(width: geometry.size.width * CGFloat(percentage / 100), height: 8)
                }
            }
            .frame(height: 8)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorManager.cardBackground)
                .shadow(color: ColorManager.shadowColor, radius: 2, x: 0, y: 1)
        )
    }
}

#Preview {
    StatisticsView(viewModel: GameViewModel())
}
