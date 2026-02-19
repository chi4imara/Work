import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: NotesViewModel
    
    var body: some View {
        ZStack {
            Color.theme.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                favoritesListView
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Favorites")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var favoritesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if viewModel.favoriteNotes.isEmpty {
                    emptyStateView
                } else {
                    ForEach(viewModel.favoriteNotes) { note in
                        NavigationLink(destination: NoteDetailView(noteId: note.id, viewModel: viewModel)) {
                            FavoriteNoteCardView(note: note)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart")
                .font(.system(size: 60))
                .foregroundColor(Color.theme.secondaryText)
            
            Text("Nothing in favorites yet.")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(Color.theme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 60)
    }
}

struct FavoriteNoteCardView: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(note.firstLine)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                    .lineLimit(2)
                
                Spacer()
                
                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Color.theme.accentYellow)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(Color.theme.secondaryText)
                }
            }
            
            HStack {
                Text(note.category)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(Color.theme.accentYellow)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.theme.accentYellow.opacity(0.2))
                    .cornerRadius(8)
                
                Spacer()
                
                Text(note.formattedDate)
                    .font(.ubuntu(12))
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
        .padding(16)
        .background(Color.theme.cardGradient)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.theme.accentYellow.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    FavoritesView(viewModel: NotesViewModel())
}
