import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var outfitViewModel: OutfitViewModel
    
    private var favoriteOutfits: [Outfit] {
        outfitViewModel.getFavoriteOutfits()
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Favorites")
                            .font(.lumierepolis(28, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        Text("\(favoriteOutfits.count) favorite outfit\(favoriteOutfits.count == 1 ? "" : "s")")
                            .font(.lumierepolis(16, weight: .light))
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.accentPink)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if favoriteOutfits.isEmpty {
                    EmptyFavoritesView()
                    
                    Spacer()
                } else {
                    OutfitGridView(outfits: favoriteOutfits)
                        .environmentObject(outfitViewModel)
                }
            }
        }
    }
}

struct EmptyFavoritesView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "heart")
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(.textSecondary.opacity(0.5))
                
                VStack(spacing: 8) {
                    Text("You haven't added outfits to favorites yet")
                        .font(.lumierepolis(22, weight: .bold))
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("Mark your best outfits as favorites to find them quickly")
                        .font(.lumierepolis(16, weight: .light))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}
