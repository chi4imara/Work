import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var viewModel: MovieListViewModel
    @State private var showingClearListAlert = false
    @State private var showingGenreManager = false
    @State private var newGenreName = ""
    @State private var showingAddGenre = false
    @State private var genreError = ""
    @State private var editingGenre: Genre?
    @State private var editGenreName = ""
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 20) {
                    headerView
                    
                    clearListSection
                    
                    appInfoSection
                }
                .padding(20)
                .padding(.bottom, 100)
            }
        }
        .sheet(isPresented: $showingAddGenre) {
            AddGenreView(
                genreName: $newGenreName,
                genreError: $genreError,
                onSave: addGenre,
                onCancel: { showingAddGenre = false }
            )
        }
        .sheet(item: $editingGenre) { genre in
            EditGenreView(
                genre: genre,
                genreName: $editGenreName,
                genreError: $genreError,
                onSave: { updateGenre(genre) },
                onCancel: { editingGenre = nil }
            )
        }
        .alert("Clear List", isPresented: $showingClearListAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear All", role: .destructive) {
                viewModel.clearAllMovies()
            }
        } message: {
            Text("Delete all movies and series? This action cannot be undone.")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(AppFonts.title1)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
    }
    
    private var clearListSection: some View {
        SettingsSection(title: "Data Management") {
            SettingsRow(
                icon: "trash.circle",
                title: "Clear List",
                subtitle: "Delete all movies and series",
                iconColor: AppColors.error
            ) {
                showingClearListAlert = true
            }
        }
    }
    
    private var genresSection: some View {
        SettingsSection(title: "Genres") {
            VStack(spacing: 12) {
                SettingsRow(
                    icon: "plus.circle",
                    title: "Add Genre",
                    subtitle: "Create a new genre",
                    iconColor: AppColors.accent
                ) {
                    newGenreName = ""
                    genreError = ""
                    showingAddGenre = true
                }
                
                if viewModel.genres.isEmpty {
                    Text("No genres available")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.secondaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                } else {
                    ForEach(viewModel.genres) { genre in
                        GenreRow(
                            genre: genre,
                            onEdit: {
                                editingGenre = genre
                                editGenreName = genre.name
                                genreError = ""
                            },
                            onDelete: {
                                deleteGenre(genre)
                            }
                        )
                    }
                }
            }
        }
    }
    
    private var appInfoSection: some View {
        SettingsSection(title: "App") {
            VStack(spacing: 12) {
                SettingsRow(
                    icon: "doc.text",
                    title: "Terms of Use",
                    subtitle: "View terms and conditions",
                    iconColor: AppColors.primaryBlue
                ) {
                    openURL("https://docs.google.com/document/d/1C2jbLK2E8lwXE0HmPR4Z8cT5iFj0CvQQ_wlqmVuJjeM/edit?usp=sharing")
                }
                
                Divider()
                    .padding(.horizontal, -20)
                    .frame(maxWidth: .infinity)
                
                SettingsRow(
                    icon: "hand.raised",
                    title: "Privacy Policy",
                    subtitle: "View privacy policy",
                    iconColor: AppColors.primaryBlue
                ) {
                    openURL("https://docs.google.com/document/d/1cq_HoCHUm9cPv4wH5MTRKwkZ7oUnGaGyFODOXAlMYOc/edit?usp=sharing")
                }
                
                Divider()
                    .padding(.horizontal, -20)
                    .frame(maxWidth: .infinity)
                
                SettingsRow(
                    icon: "envelope",
                    title: "Contact Us",
                    subtitle: "Get in touch",
                    iconColor: AppColors.primaryBlue
                ) {
                    openURL("https://forms.gle/TtbdALz7B25RM79y8")
                }
                
                Divider()
                    .padding(.horizontal, -20)
                    .frame(maxWidth: .infinity)
                
                SettingsRow(
                    icon: "star",
                    title: "Rate App",
                    subtitle: "Rate us on the App Store",
                    iconColor: AppColors.warning
                ) {
                    requestReview()
                }
            }
        }
    }
    
    private func addGenre() {
        let trimmedName = newGenreName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedName.isEmpty {
            genreError = "Genre name cannot be empty"
            return
        }
        
        if trimmedName.count > 40 {
            genreError = "Genre name must be 40 characters or less"
            return
        }
        
        if viewModel.addGenre(trimmedName) {
            showingAddGenre = false
            newGenreName = ""
            genreError = ""
        } else {
            genreError = "Genre already exists"
        }
    }
    
    private func updateGenre(_ genre: Genre) {
        let trimmedName = editGenreName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedName.isEmpty {
            genreError = "Genre name cannot be empty"
            return
        }
        
        if trimmedName.count > 40 {
            genreError = "Genre name must be 40 characters or less"
            return
        }
        
        if viewModel.updateGenre(genre, newName: trimmedName) {
            editingGenre = nil
            editGenreName = ""
            genreError = ""
        } else {
            genreError = "Genre already exists"
        }
    }
    
    private func deleteGenre(_ genre: Genre) {
        viewModel.deleteGenre(genre)
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(AppFonts.title3)
                .foregroundColor(AppColors.primaryText)
            
            Divider()
                .padding(.horizontal, -20)
                .frame(maxWidth: .infinity)
            
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: AppColors.cardShadow, radius: 8, x: 0, y: 4)
        )
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(iconColor)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(AppFonts.bodyMedium)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(subtitle)
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(.vertical, 8)
        }
    }
}

struct GenreRow: View {
    let genre: Genre
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGSize = .zero
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                
                Button(action: onDelete) {
                    VStack {
                        Image(systemName: "trash")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Delete")
                            .font(AppFonts.caption)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(AppColors.error)
                }
                .frame(width: abs(offset.width))
            }
            
            Button(action: onEdit) {
                HStack {
                    Text(genre.name)
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Image(systemName: "pencil")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.backgroundGray)
                )
            }
            .buttonStyle(PlainButtonStyle())
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.width < 0 {
                            offset = value.translation
                        }
                    }
                    .onEnded { value in
                        withAnimation(.spring()) {
                            if value.translation.width < -100 {
                                onDelete()
                            }
                            offset = .zero
                        }
                    }
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct AddGenreView: View {
    @Binding var genreName: String
    @Binding var genreError: String
    let onSave: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    FormField(
                        title: "Genre Name",
                        text: $genreName,
                        placeholder: "Enter genre name",
                        errorMessage: genreError,
                        isRequired: true
                    )
                    
                    Spacer()
                }
                .padding(20)
            }
            .navigationTitle("Add Genre")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onCancel()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

struct EditGenreView: View {
    let genre: Genre
    @Binding var genreName: String
    @Binding var genreError: String
    let onSave: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    FormField(
                        title: "Genre Name",
                        text: $genreName,
                        placeholder: "Enter genre name",
                        errorMessage: genreError,
                        isRequired: true
                    )
                    
                    Spacer()
                }
                .padding(20)
            }
            .navigationTitle("Edit Genre")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onCancel()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    SettingsView(viewModel: MovieListViewModel())
}
