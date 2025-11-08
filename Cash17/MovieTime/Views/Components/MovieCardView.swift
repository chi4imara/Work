import SwiftUI

struct MovieCardView: View {
    let movie: Movie
    let isSelected: Bool
    let isSelectionMode: Bool
    let onTap: () -> Void
    let onLongPress: () -> Void
    let onSwipeLeft: () -> Void
    let onSwipeRight: () -> Void
    
    @StateObject private var viewModel = MoviesViewModel()
    
    @State private var dragOffset: CGSize = .zero
    @State private var isShowingLeftAction = false
    @State private var isShowingRightAction = false
    
    var body: some View {
        ZStack {
            HStack {
                if isShowingRightAction {
                    HStack {
                        Image(systemName: movie.isFavorite ? "star.slash" : "star")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(AppColors.warning)
                        
                        Text(movie.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                            .font(FontManager.caption)
                            .foregroundColor(AppColors.warning)
                        
                        Spacer()
                    }
                    .padding(.leading, 20)
                }
                
                Spacer()
                
                if isShowingLeftAction {
                    HStack {
                        Spacer()
                        
                        Text("Archive")
                            .font(FontManager.caption)
                            .foregroundColor(AppColors.error)
                        
                        Image(systemName: "archivebox")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(AppColors.error)
                    }
                    .padding(.trailing, 20)
                }
            }
            .frame(height: 120)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardBackground.opacity(0.5))
            )
            
            movieCard
        }
    }
    
    private var movieCard: some View {
        Group {
            if isSelectionMode {
                Button(action: onTap) {
                    cardContent
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                NavigationLink(destination: MovieDetailView(movie: movie, viewModel: viewModel)) {
                    cardContent
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .onLongPressGesture {
            onLongPress()
        }
    }
    
    private var cardContent: some View {
            HStack(spacing: 16) {
                if isSelectionMode {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSelected ? AppColors.success : AppColors.lightGray)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(movie.title)
                            .font(FontManager.headline)
                            .foregroundColor(AppColors.primaryText)
                            .lineLimit(2)
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.toggleFavorite(movie)
                        }) {
                            Image(systemName: movie.isFavorite ? "star.fill" : "star")
                                .foregroundColor(movie.isFavorite ? AppColors.warning : AppColors.lightGray)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Text(movie.genre)
                        .font(FontManager.subheadline)
                        .foregroundColor(AppColors.secondaryText)
                    
                    HStack {
                        Text(movie.formattedWatchDate)
                            .font(FontManager.caption)
                            .foregroundColor(AppColors.lightGray)
                        
                        Spacer()
                        
                        Text(movie.ratingText)
                            .font(FontManager.caption)
                            .foregroundColor(AppColors.primaryText)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppColors.primaryText.opacity(0.2))
                            )
                    }
                    
                    if !movie.shortReview.isEmpty && movie.shortReview != "No review" {
                        Text(movie.shortReview)
                            .font(FontManager.caption)
                            .foregroundColor(AppColors.lightGray)
                            .lineLimit(2)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? AppColors.success : Color.clear, lineWidth: 2)
            )
        }
    }


#Preview {
    let context = CoreDataManager.shared.context
    let sampleMovie = Movie(context: context)
    sampleMovie.id = UUID()
    sampleMovie.title = "The Matrix"
    sampleMovie.genre = "Sci-Fi"
    sampleMovie.watchDate = Date()
    sampleMovie.rating = 9
    sampleMovie.review = "Amazing movie with groundbreaking visual effects and philosophical themes."
    sampleMovie.isFavorite = true
    sampleMovie.isArchived = false
    sampleMovie.createdAt = Date()
    sampleMovie.updatedAt = Date()
    
    return VStack {
        MovieCardView(
            movie: sampleMovie,
            isSelected: false,
            isSelectionMode: false,
            onTap: { },
            onLongPress: { },
            onSwipeLeft: { },
            onSwipeRight: { }
        )
        .padding()
    }
    .background(AppColors.backgroundGradient)
}
