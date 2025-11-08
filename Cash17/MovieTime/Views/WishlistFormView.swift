import SwiftUI

struct WishlistFormView: View {
    @ObservedObject var viewModel: WishlistViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let movie: WishlistMovie?
    
    @State private var title = ""
    @State private var genre = ""
    @State private var note = ""
    @State private var isPriority = false
    @State private var showingGenrePicker = false
    @State private var showingDeleteConfirmation = false
    
    private var isEditing: Bool {
        movie != nil
    }
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    init(viewModel: WishlistViewModel, movie: WishlistMovie? = nil) {
        self.viewModel = viewModel
        self.movie = movie
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                        Spacer()
                        
                        Text(isEditing ? "Edit Wishlist Movie" : "Add to Wishlist")
                            .font(FontManager.headline)
                            .foregroundColor(Color(red: 0.988, green: 0.8, blue: 0.008))
                        
                        Spacer()
                        
                        HStack {
                            if isEditing {
                                Button("Delete") {
                                    showingDeleteConfirmation = true
                                }
                                .foregroundColor(AppColors.error)
                            }
                            
                            Button("Save") {
                                saveMovie()
                            }
                            .disabled(!isFormValid)
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 16)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            titleSection
                            
                            genreSection
                            
                            noteSection
                            
                            prioritySection
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            loadMovieData()
        }
        .sheet(isPresented: $showingGenrePicker) {
            WishlistGenrePickerView(selectedGenre: $genre)
        }
        .alert("Delete Movie", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let movie = movie {
                    viewModel.deleteWishlistMovie(movie)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        } message: {
            Text("This movie will be permanently deleted from your wishlist.")
        }
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Title *")
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            TextField("Enter movie title", text: $title)
                .font(FontManager.body)
                .foregroundColor(AppColors.secondaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                )
        }
    }
    
    private var genreSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Genre")
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            Button(action: { showingGenrePicker = true }) {
                HStack {
                    Text(genre.isEmpty ? "Select genre (optional)" : genre)
                        .font(FontManager.body)
                        .foregroundColor(genre.isEmpty ? AppColors.lightGray : AppColors.secondaryText)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.lightGray)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private var noteSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Why do you want to watch this?")
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            TextEditor(text: $note)
                .font(FontManager.body)
                .foregroundColor(AppColors.secondaryText)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(minHeight: 100)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.lightGray.opacity(0.3), lineWidth: 1)
                )
                .scrollContentBackground(.hidden)
        }
    }
    
    private var prioritySection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Priority")
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Mark as high priority to watch")
                    .font(FontManager.caption)
                    .foregroundColor(AppColors.lightGray)
            }
            
            Spacer()
            
            Toggle("", isOn: $isPriority)
                .toggleStyle(SwitchToggleStyle(tint: AppColors.primaryText))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
        )
    }
    
    private func loadMovieData() {
        if let movie = movie {
            title = movie.title
            genre = movie.genre ?? ""
            note = movie.note ?? ""
            isPriority = movie.isPriority
        }
    }
    
    private func saveMovie() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedGenre = genre.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let movie = movie {
            viewModel.updateWishlistMovie(
                movie,
                title: trimmedTitle,
                genre: trimmedGenre.isEmpty ? nil : trimmedGenre,
                note: trimmedNote.isEmpty ? nil : trimmedNote,
                isPriority: isPriority
            )
        } else {
            viewModel.addWishlistMovie(
                title: trimmedTitle,
                genre: trimmedGenre.isEmpty ? nil : trimmedGenre,
                note: trimmedNote.isEmpty ? nil : trimmedNote,
                isPriority: isPriority
            )
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct WishlistGenrePickerView: View {
    @Binding var selectedGenre: String
    @Environment(\.presentationMode) var presentationMode
    
    private let genres = [
        "Action", "Adventure", "Animation", "Biography", "Comedy", "Crime",
        "Documentary", "Drama", "Family", "Fantasy", "History", "Horror",
        "Music", "Mystery", "Romance", "Sci-Fi", "Sport", "Thriller", "War", "Western"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Spacer()
                        Spacer()
                        
                        Text("Select Genre")
                            .font(FontManager.headline)
                            .foregroundColor(Color(red: 0.988, green: 0.8, blue: 0.008))
                        
                        Spacer()
                        
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .padding(.trailing, 16)
                        .padding(.vertical, 16)
                    }
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            Button(action: {
                                selectedGenre = ""
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                HStack {
                                    Text("No Genre")
                                        .font(FontManager.body)
                                        .foregroundColor(AppColors.lightGray)
                                    
                                    Spacer()
                                    
                                    if selectedGenre.isEmpty {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(AppColors.primaryText)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(selectedGenre.isEmpty ? AppColors.primaryText.opacity(0.1) : Color.clear)
                                )
                                .contentShape(Rectangle())
                            }
                            .frame(maxWidth: .infinity)
                            .buttonStyle(PlainButtonStyle())
                            
                            ForEach(genres, id: \.self) { genre in
                                Button(action: {
                                    selectedGenre = genre
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    HStack {
                                        Text(genre)
                                            .font(FontManager.body)
                                            .foregroundColor(AppColors.secondaryText)
                                        
                                        Spacer()
                                        
                                        if selectedGenre == genre {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(AppColors.primaryText)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedGenre == genre ? AppColors.primaryText.opacity(0.1) : Color.clear)
                                    )
                                    .contentShape(Rectangle())
                                }
                                .frame(maxWidth: .infinity)
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    WishlistFormView(viewModel: WishlistViewModel())
}
