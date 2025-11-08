import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @ObservedObject var viewModel: MoviesViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEditForm = false
    @State private var showingArchiveConfirmation = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    
                    if let review = movie.review, !review.isEmpty {
                        reviewSection(review: review)
                    }
                    
                    if let location = movie.watchLocation, !location.isEmpty {
                        watchLocationSection(location: location)
                    }
                    
                    if !movie.notes.isEmpty {
                        notesSection
                    }
                    
                    actionButtonsSection
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingEditForm) {
            MovieFormView(viewModel: viewModel, movie: movie)
        }
        .alert("Delete Movie", isPresented: $showingArchiveConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.archiveMovie(movie)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("This movie will be permanently deleted.")
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.toggleFavorite(movie)
                }) {
                    Image(systemName: movie.isFavorite ? "star.fill" : "star")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(movie.isFavorite ? AppColors.warning : AppColors.secondaryText)
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text(movie.title)
                    .font(FontManager.largeTitle)
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(nil)
                
                HStack {
                    Text(movie.genre)
                        .font(FontManager.title3)
                        .foregroundColor(AppColors.secondaryText)
                    
                    Spacer()
                    
                    if movie.isFavorite {
                        Image(systemName: "star.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppColors.warning)
                    }
                }
                
                HStack {
                    Text("Watched on \(movie.formattedWatchDate)")
                        .font(FontManager.body)
                        .foregroundColor(AppColors.lightGray)
                    
                    Spacer()
                    
                    Text(movie.ratingText)
                        .font(FontManager.headline)
                        .foregroundColor(AppColors.primaryText)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.primaryText.opacity(0.2))
                        )
                }
            }
        }
    }
    
    private func reviewSection(review: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Review")
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            Text(review)
                .font(FontManager.body)
                .foregroundColor(AppColors.secondaryText)
                .lineSpacing(4)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.cardGradient)
                )
        }
    }
    
    private func watchLocationSection(location: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Watch Location")
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            HStack {
                Image(systemName: "location")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                Text(location)
                    .font(FontManager.body)
                    .foregroundColor(AppColors.secondaryText)
                
                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
            )
        }
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Notes")
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(movie.notes, id: \.self) { note in
                    HStack(alignment: .top, spacing: 12) {
                        Circle()
                            .fill(AppColors.primaryText)
                            .frame(width: 6, height: 6)
                            .padding(.top, 6)
                        
                        Text(note)
                            .font(FontManager.body)
                            .foregroundColor(AppColors.secondaryText)
                            .lineLimit(nil)
                        
                        Spacer()
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
            )
        }
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: 12) {
            Button(action: {
                showingEditForm = true
            }) {
                HStack {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("Edit Movie")
                        .font(FontManager.headline)
                }
                .foregroundColor(AppColors.background)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.primaryText)
                )
            }
            
            Button(action: {
                showingArchiveConfirmation = true
            }) {
                HStack {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("Delete Movie")
                        .font(FontManager.headline)
                }
                .foregroundColor(AppColors.error)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.error, lineWidth: 2)
                )
            }
        }
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
    sampleMovie.review = "Amazing movie with groundbreaking visual effects and philosophical themes. The story explores deep questions about reality and consciousness while delivering incredible action sequences."
    sampleMovie.watchLocation = "IMAX Theater"
    sampleMovie.notes = ["Watched with friends", "Great soundtrack", "Mind-bending plot"]
    sampleMovie.isFavorite = true
    sampleMovie.isArchived = false
    sampleMovie.createdAt = Date()
    sampleMovie.updatedAt = Date()
    
    return NavigationView {
        MovieDetailView(movie: sampleMovie, viewModel: MoviesViewModel())
    }
}
