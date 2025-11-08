import SwiftUI

struct AddEditMovieView: View {
    @ObservedObject var viewModel: MovieListViewModel
    @Environment(\.dismiss) private var dismiss
    
    let movieToEdit: Movie?
    
    @State private var title: String = ""
    @State private var year: String = ""
    @State private var selectedType: Movie.MovieType = .movie
    @State private var selectedGenre: String = ""
    @State private var notes: String = ""
    @State private var isWatched: Bool = false
    
    @State private var showingDuplicateAlert = false
    @State private var titleError: String = ""
    @State private var yearError: String = ""
    
    private var isEditing: Bool {
        movieToEdit != nil
    }
    
    private var navigationTitle: String {
        isEditing ? "Edit Movie" : "Add Movie"
    }
    
    init(viewModel: MovieListViewModel, movieToEdit: Movie? = nil) {
        self.viewModel = viewModel
        self.movieToEdit = movieToEdit
        
        if let movie = movieToEdit {
            _title = State(initialValue: movie.title)
            _year = State(initialValue: movie.year?.description ?? "")
            _selectedType = State(initialValue: movie.type)
            _selectedGenre = State(initialValue: movie.genre ?? "")
            _notes = State(initialValue: movie.notes ?? "")
            _isWatched = State(initialValue: movie.isWatched)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        FormField(
                            title: "Title",
                            text: $title,
                            placeholder: "Enter movie or series title",
                            errorMessage: titleError,
                            isRequired: true
                        )
                        
                        FormField(
                            title: "Release Year",
                            text: $year,
                            placeholder: "e.g. 2023",
                            errorMessage: yearError,
                            keyboardType: .numberPad
                        )
                        
                        FormSection(title: "Type") {
                            Picker("Type", selection: $selectedType) {
                                ForEach(Movie.MovieType.allCases, id: \.self) { type in
                                    Text(type.displayName).tag(type)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        if !viewModel.genres.isEmpty {
                            FormSection(title: "Genre") {
                                Picker("Genre", selection: $selectedGenre) {
                                    Text("No Genre").tag("")
                                    ForEach(viewModel.genres) { genre in
                                        Text(genre.name).tag(genre.name)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        
                        FormSection(title: "Notes") {
                            TextEditor(text: $notes)
                                .font(AppFonts.body)
                                .frame(minHeight: 100)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(AppColors.secondaryText.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        FormSection(title: "Status") {
                            Toggle("Watched", isOn: $isWatched)
                                .font(AppFonts.body)
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveMovie()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                    .fontWeight(.semibold)
                    .disabled(!isFormValid)
                }
            }
        }
        .alert("Duplicate Movie", isPresented: $showingDuplicateAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Save Anyway") {
                saveMovieForced()
            }
        } message: {
            Text("A movie with the same title, year, and type already exists. Save anyway?")
        }
    }
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        title.count <= 200 &&
        (year.isEmpty || isValidYear) &&
        notes.count <= 2000
    }
    
    private var isValidYear: Bool {
        guard let yearInt = Int(year) else { return false }
        let currentYear = Calendar.current.component(.year, from: Date())
        return yearInt >= 1888 && yearInt <= currentYear
    }
    
    private func validateForm() -> Bool {
        titleError = ""
        yearError = ""
        
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedTitle.isEmpty {
            titleError = "Title is required"
            return false
        }
        
        if trimmedTitle.count > 200 {
            titleError = "Title must be 200 characters or less"
            return false
        }
        
        if !year.isEmpty {
            if let yearInt = Int(year) {
                let currentYear = Calendar.current.component(.year, from: Date())
                if yearInt < 1888 || yearInt > currentYear {
                    yearError = "Year must be between 1888 and \(currentYear)"
                    return false
                }
            } else {
                yearError = "Invalid year format"
                return false
            }
        }
        
        if notes.count > 2000 {
            return false
        }
        
        return true
    }
    
    private func saveMovie() {
        guard validateForm() else { return }
        
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let movieYear = year.isEmpty ? nil : Int(year)
        let movieGenre = selectedGenre.isEmpty ? nil : selectedGenre
        let movieNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : notes
        
        if !isEditing {
            let duplicate = viewModel.movies.first { existing in
                existing.title.lowercased() == trimmedTitle.lowercased() &&
                existing.year == movieYear &&
                existing.type == selectedType
            }
            
            if duplicate != nil {
                showingDuplicateAlert = true
                return
            }
        }
        
        if let movieToEdit = movieToEdit {
            var updatedMovie = movieToEdit
            updatedMovie.title = trimmedTitle
            updatedMovie.year = movieYear
            updatedMovie.type = selectedType
            updatedMovie.genre = movieGenre
            updatedMovie.notes = movieNotes
            updatedMovie.isWatched = isWatched
            
            viewModel.updateMovie(updatedMovie)
        } else {
            let newMovie = Movie(
                title: trimmedTitle,
                year: movieYear,
                type: selectedType,
                genre: movieGenre,
                notes: movieNotes,
                isWatched: isWatched
            )
            
            viewModel.addMovie(newMovie)
        }
        
        dismiss()
    }
    
    private func saveMovieForced() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let movieYear = year.isEmpty ? nil : Int(year)
        let movieGenre = selectedGenre.isEmpty ? nil : selectedGenre
        let movieNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : notes
        
        let newMovie = Movie(
            title: trimmedTitle,
            year: movieYear,
            type: selectedType,
            genre: movieGenre,
            notes: movieNotes,
            isWatched: isWatched
        )
        
        viewModel.addMovie(newMovie)
        dismiss()
    }
}

struct FormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    let errorMessage: String
    var isRequired: Bool = false
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        FormSection(title: title, isRequired: isRequired) {
            VStack(alignment: .leading, spacing: 8) {
                TextField(placeholder, text: $text)
                    .font(AppFonts.body)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(keyboardType)
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.error)
                }
            }
        }
    }
}

struct FormSection<Content: View>: View {
    let title: String
    var isRequired: Bool = false
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(AppFonts.bodyMedium)
                    .foregroundColor(AppColors.primaryText)
                
                if isRequired {
                    Text("*")
                        .font(AppFonts.bodyMedium)
                        .foregroundColor(AppColors.error)
                }
            }
            
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: AppColors.cardShadow, radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    AddEditMovieView(viewModel: MovieListViewModel())
}
