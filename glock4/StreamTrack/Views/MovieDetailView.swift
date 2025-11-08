import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    let onToggleWatched: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerCard
                        
                        detailsCard
                        
                        if let notes = movie.notes, !notes.isEmpty {
                            notesCard(notes: notes)
                        } else {
                            emptyNotesCard
                        }
                        
                        actionButtons
                    }
                    .padding(20)
                    .padding(.bottom, 50)
                }
            }
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                }
            }
        }
        .alert("Delete Movie", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this movie? This action cannot be undone.")
        }
    }
    
    private var headerCard: some View {
        VStack(spacing: 16) {
            Image(systemName: movie.type == .movie ? "film.fill" : "tv.fill")
                .font(.system(size: 40, weight: .light))
                .foregroundColor(AppColors.primaryBlue)
                .frame(width: 80, height: 80)
                .background(
                    Circle()
                        .fill(AppColors.lightBlue.opacity(0.2))
                )
            
            Text(movie.title)
                .font(AppFonts.title1)
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.center)
                .lineLimit(3)
            
            Text(movie.displaySubtitle)
                .font(AppFonts.body)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
            
            Button(action: onToggleWatched) {
                HStack(spacing: 8) {
                    Image(systemName: movie.isWatched ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 20, weight: .medium))
                    
                    Text(movie.isWatched ? "Watched" : "Not Watched")
                        .font(AppFonts.bodyMedium)
                }
                .foregroundColor(movie.isWatched ? AppColors.accent : AppColors.secondaryText)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(movie.isWatched ? AppColors.accent : AppColors.secondaryText, lineWidth: 2)
                )
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: AppColors.cardShadow, radius: 10, x: 0, y: 5)
        )
    }
    
    private var detailsCard: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Details")
                    .font(AppFonts.title3)
                    .foregroundColor(AppColors.primaryText)
                Spacer()
            }
            
            VStack(spacing: 12) {
                DetailRow(title: "Type", value: movie.type.displayName)
                
                if let year = movie.year {
                    DetailRow(title: "Year", value: String(year))
                }
                
                if let genre = movie.genre, !genre.isEmpty {
                    DetailRow(title: "Genre", value: genre)
                } else {
                    DetailRow(title: "Genre", value: "No genre")
                }
                
                DetailRow(title: "Status", value: movie.isWatched ? "Watched" : "Not Watched")
                
                DetailRow(title: "Added", value: movie.formattedCreatedAt)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: AppColors.cardShadow, radius: 8, x: 0, y: 4)
        )
    }
    
    private func notesCard(notes: String) -> some View {
        VStack(spacing: 16) {
            HStack {
                Text("Notes")
                    .font(AppFonts.title3)
                    .foregroundColor(AppColors.primaryText)
                Spacer()
            }
            
            Text(notes)
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(nil)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: AppColors.cardShadow, radius: 8, x: 0, y: 4)
        )
    }
    
    private var emptyNotesCard: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Notes")
                    .font(AppFonts.title3)
                    .foregroundColor(AppColors.primaryText)
                Spacer()
            }
            
            Text("No notes available")
                .font(AppFonts.body)
                .foregroundColor(AppColors.secondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .italic()
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: AppColors.cardShadow, radius: 8, x: 0, y: 4)
        )
    }
    
    private var actionButtons: some View {
        VStack(spacing: 16) {
            Button(action: { onEdit() }) {
                HStack {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Edit")
                        .font(AppFonts.bodyMedium)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(AppColors.blueGradient)
                )
                .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            
            Button(action: { showingDeleteAlert = true }) {
                HStack {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Delete")
                        .font(AppFonts.bodyMedium)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [AppColors.error, AppColors.error.opacity(0.8)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .shadow(color: AppColors.error.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(AppFonts.body)
                .foregroundColor(AppColors.secondaryText)
                .frame(width: 80, alignment: .leading)
            
            Text(value)
                .font(AppFonts.bodyMedium)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
    }
}

#Preview {
    MovieDetailView(
        movie: Movie(
            title: "Inception",
            year: 2010,
            type: .movie,
            genre: "Sci-Fi",
            notes: "A mind-bending thriller about dreams within dreams. Excellent cinematography and complex plot.",
            isWatched: true
        ),
        onToggleWatched: {},
        onEdit: {},
        onDelete: {}
    )
}
