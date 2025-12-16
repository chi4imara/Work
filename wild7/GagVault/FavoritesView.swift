import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                HStack {
                    Text("Favorites")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                if dataManager.favoriteChallenges.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    favoritesList
                }
            }
        }
    }
    
    private var favoritesList: some View {
        List {
            ForEach(dataManager.favoriteChallenges) { challenge in
                FavoriteChallengeCard(challenge: challenge)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                    }
            }
            .onDelete(perform: removeFavorites)
        }
        .listStyle(PlainListStyle())
        .background(Color.clear)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "star")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.textSecondary)
            
            Text("No favorite challenges yet")
                .font(.ubuntu(20, weight: .medium))
                .foregroundColor(AppColors.textPrimary)
            
            Text("Add challenges to favorites from the main screen")
                .font(.ubuntu(16))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(40)
    }
    
    private func removeFavorites(offsets: IndexSet) {
        for index in offsets {
            let challenge = dataManager.favoriteChallenges[index]
            dataManager.toggleFavorite(challenge)
        }
    }
}

struct FavoriteChallengeCard: View {
    @EnvironmentObject var dataManager: DataManager
    let challenge: Challenge
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(challenge.text)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.textPrimary)
                .lineSpacing(4)
            
            HStack {
                Text("Category: \(dataManager.getCategoryName(for: challenge.categoryId))")
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.textSecondary)
                
                Spacer()
                
                Image(systemName: "star.fill")
                    .foregroundColor(AppColors.secondary)
                    .font(.system(size: 14))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.primary.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal, 4)
        .padding(.vertical, 2)
    }
}

#Preview {
    FavoritesView()
        .environmentObject(DataManager.shared)
}
