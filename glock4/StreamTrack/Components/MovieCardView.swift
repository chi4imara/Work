import SwiftUI

struct MovieCardView: View {
    let movie: Movie
    let onToggleWatched: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGSize = .zero
    @State private var showingDetails: Movie? = nil
    
    var body: some View {
        ZStack {
            HStack {
                if offset.width > 0 {
                    Button(action: onEdit) {
                        VStack {
                            Image(systemName: "pencil")
                                .font(.system(size: 20, weight: .semibold))
                            Text("Edit")
                                .font(AppFonts.caption)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(AppColors.primaryBlue)
                    }
                    .frame(width: abs(offset.width))
                }
                
                Spacer()
                
                if offset.width < 0 {
                    Button(action: onDelete) {
                        VStack {
                            Image(systemName: "trash")
                                .font(.system(size: 20, weight: .semibold))
                            Text("Delete")
                                .font(AppFonts.caption)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(AppColors.error)
                    }
                    .frame(width: abs(offset.width))
                }
            }
            
            cardContent
                .offset(x: offset.width, y: 0)
                .highPriorityGesture(
                    DragGesture(minimumDistance: 20)
                        .onChanged { value in
                            offset = value.translation
                        }
                        .onEnded { value in
                            withAnimation(.spring()) {
                                if abs(value.translation.width) > 100 {
                                    if value.translation.width > 0 {
                                        onEdit()
                                    } else {
                                        onDelete()
                                    }
                                }
                                offset = .zero
                            }
                        }
                )
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .sheet(item: $showingDetails) { movie in
            MovieDetailView(
                movie: movie, 
                onToggleWatched: onToggleWatched, 
                onEdit: {
                    showingDetails = nil
                    onEdit()
                }, 
                onDelete: onDelete
            )
        }
    }
    
    private var cardContent: some View {
        Button(action: { showingDetails = movie }) {
            HStack(spacing: 16) {
                Button(action: onToggleWatched) {
                    Image(systemName: movie.isWatched ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(movie.isWatched ? AppColors.accent : AppColors.secondaryText)
                        .animation(.easeInOut(duration: 0.2), value: movie.isWatched)
                }
                .buttonStyle(PlainButtonStyle())
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(movie.title)
                        .font(AppFonts.title3)
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text(movie.displaySubtitle)
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(1)
                    
                    Text(movie.formattedCreatedAt)
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.secondaryText.opacity(0.8))
                }
                
                Spacer()
                
                VStack {
                    Image(systemName: movie.type == .movie ? "film" : "tv")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.primaryBlue)
                    
                    if movie.isWatched {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.accent)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: AppColors.cardShadow, radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 16) {
        MovieCardView(
            movie: Movie(
                title: "Inception",
                year: 2010,
                type: .movie,
                genre: "Sci-Fi",
                notes: "Great movie about dreams",
                isWatched: false
            ),
            onToggleWatched: {},
            onEdit: {},
            onDelete: {}
        )
        
        MovieCardView(
            movie: Movie(
                title: "Breaking Bad",
                year: 2008,
                type: .series,
                genre: "Drama",
                notes: "Amazing series",
                isWatched: true
            ),
            onToggleWatched: {},
            onEdit: {},
            onDelete: {}
        )
    }
    .padding()
    .background(AppColors.backgroundGradient)
}
