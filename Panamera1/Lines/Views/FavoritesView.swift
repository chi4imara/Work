import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var viewModel: FragranceViewModel
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Favorites")
                        .font(.bellGothicBold(size: 24))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.favoriteFragrances.isEmpty {
                    EmptyStateView(message: "No favorites yet.")
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.favoriteFragrances) { fragrance in
                                NavigationLink(destination: FragranceDetailView(fragranceId: fragrance.id)
                                    .environmentObject(viewModel)) {
                                    FavoriteFragranceCardView(fragrance: fragrance)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                    }
                }
            }
        }
    }
}

struct FavoriteFragranceCardView: View {
    let fragrance: Fragrance
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(fragrance.name)
                        .font(.bellGothicBold(size: 18))
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(1)
                    
                    Text(fragrance.brand)
                        .font(.bellGothicRegular(size: 14))
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Image(systemName: "heart.fill")
                    .foregroundColor(AppColors.primaryYellow)
                    .font(.title2)
            }
            
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: seasonIcon(for: fragrance.season))
                        .foregroundColor(AppColors.primaryYellow)
                        .font(.caption)
                    Text(fragrance.season.displayName)
                        .font(.bellGothicRegular(size: 12))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                Text(fragrance.style)
                    .font(.bellGothicRegular(size: 12))
                    .foregroundColor(AppColors.textAccent)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(AppColors.primaryYellow.opacity(0.2))
                    )
            }
            
            HStack {
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= fragrance.rating ? "star.fill" : "star")
                            .foregroundColor(AppColors.primaryYellow)
                            .font(.caption)
                    }
                }
                
                Spacer()
                
                Text(DateFormatter.shortDate.string(from: fragrance.dateAdded))
                    .font(.bellGothicRegular(size: 11))
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            AppColors.primaryYellow.opacity(0.1),
                            AppColors.primaryPink.opacity(0.3)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.primaryYellow.opacity(0.3), lineWidth: 1)
        )
    }
    
    private func seasonIcon(for season: Season) -> String {
        switch season {
        case .spring: return "leaf"
        case .summer: return "sun.max"
        case .autumn: return "leaf.fill"
        case .winter: return "snowflake"
        case .allSeasons: return "circle"
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(FragranceViewModel())
}
