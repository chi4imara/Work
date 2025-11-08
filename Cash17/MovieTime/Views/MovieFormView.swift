import SwiftUI

struct MovieFormView: View {
    @ObservedObject var viewModel: MoviesViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let movie: Movie?
    
    @State private var title = ""
    @State private var genre = ""
    @State private var watchDate = Date()
    @State private var rating: Double = 7.0
    @State private var review = ""
    @State private var watchLocation = ""
    @State private var notes: [String] = []
    @State private var isFavorite = false
    @State private var newNote = ""
    @State private var showingGenrePicker = false
    @State private var showingArchiveConfirmation = false
    
    private var isEditing: Bool {
        movie != nil
    }
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !genre.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        watchDate <= Date()
    }
    
    init(viewModel: MoviesViewModel, movie: Movie? = nil) {
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
                        
                        Text(isEditing ? "Edit Movie" : "Add Movie")
                            .font(FontManager.headline)
                            .foregroundColor(Color(red: 0.988, green: 0.8, blue: 0.008))
                        
                        Spacer()
                        
                        HStack {
                            if isEditing {
                                Button("Delete") {
                                    showingArchiveConfirmation = true
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
                            
                            watchDateSection
                            
                            ratingSection
                            
                            reviewSection
                            
                            watchLocationSection
                            

                            notesSection
                            
                            favoriteSection
                            
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
            GenrePickerView(selectedGenre: $genre)
        }
        .alert("Delete Movie", isPresented: $showingArchiveConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let movie = movie {
                    viewModel.archiveMovie(movie)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        } message: {
            Text("This movie will be permanently deleted.")
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
            Text("Genre *")
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            Button(action: { showingGenrePicker = true }) {
                HStack {
                    Text(genre.isEmpty ? "Select genre" : genre)
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
    
    private var watchDateSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Watch Date *")
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            DatePicker("", selection: $watchDate, in: ...Date(), displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .accentColor(AppColors.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                )
        }
    }
    
    private var ratingSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Rating")
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Text("\(Int(rating))/10")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Slider(value: $rating, in: 1...10, step: 1)
                .accentColor(AppColors.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                )
        }
    }
    
    private var reviewSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Review")
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            TextEditor(text: $review)
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
    
    private var watchLocationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Watch Location")
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            TextField("e.g., Cinema, Home, Netflix", text: $watchLocation)
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
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Notes")
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            ForEach(Array(notes.enumerated()), id: \.offset) { index, note in
                HStack {
                    Text("• \(note)")
                        .font(FontManager.body)
                        .foregroundColor(AppColors.secondaryText)
                    
                    Spacer()
                    
                    Button(action: {
                        notes.remove(at: index)
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppColors.error)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.cardBackground)
                )
            }
            
            HStack {
                TextField("Add a note", text: $newNote)
                    .font(FontManager.body)
                    .foregroundColor(AppColors.secondaryText)
                
                Button("Add") {
                    if !newNote.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        notes.append(newNote.trimmingCharacters(in: .whitespacesAndNewlines))
                        newNote = ""
                    }
                }
                .font(FontManager.body)
                .foregroundColor(AppColors.primaryText)
                .disabled(newNote.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
            )
        }
    }
    
    private var favoriteSection: some View {
        HStack {
            Text("Add to Favorites")
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Toggle("", isOn: $isFavorite)
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
            genre = movie.genre
            watchDate = movie.watchDate
            rating = Double(movie.rating)
            review = movie.review ?? ""
            watchLocation = movie.watchLocation ?? ""
            notes = movie.notes
            isFavorite = movie.isFavorite
        }
    }
    
    private func saveMovie() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedGenre = genre.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedReview = review.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedLocation = watchLocation.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let movie = movie {
            viewModel.updateMovie(
                movie,
                title: trimmedTitle,
                genre: trimmedGenre,
                watchDate: watchDate,
                rating: Int16(rating),
                review: trimmedReview.isEmpty ? nil : trimmedReview,
                watchLocation: trimmedLocation.isEmpty ? nil : trimmedLocation,
                notes: notes,
                isFavorite: isFavorite
            )
        } else {
            viewModel.addMovie(
                title: trimmedTitle,
                genre: trimmedGenre,
                watchDate: watchDate,
                rating: Int16(rating),
                review: trimmedReview.isEmpty ? nil : trimmedReview,
                watchLocation: trimmedLocation.isEmpty ? nil : trimmedLocation,
                notes: notes,
                isFavorite: isFavorite
            )
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct GenrePickerView: View {
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
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 16)
                    
                    ScrollView {
                        LazyVStack(spacing: 8) {
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
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedGenre == genre ? AppColors.primaryText.opacity(0.1) : Color.clear)
                                    )
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
            }
        }
    }
}

#Preview {
    MovieFormView(viewModel: MoviesViewModel())
}
