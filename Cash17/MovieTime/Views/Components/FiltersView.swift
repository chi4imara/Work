import SwiftUI

struct FiltersView: View {
    @ObservedObject var viewModel: MoviesViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var tempSelectedGenres: Set<String> = []
    @State private var tempRatingRange: ClosedRange<Int> = 1...10
    @State private var tempDateFilter: MoviesViewModel.DateFilter = .all
    @State private var tempSearchText: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Button("Reset") {
                            resetFilters()
                        }
                        
                        Spacer()
                        
                        Text("Filters")
                            .font(FontManager.headline)
                            .foregroundColor(AppColors.accent)
                        
                        Spacer()
                        
                        Button("Apply") {
                            applyFilters()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 16)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            searchSection
                            
                            genresSection
                            
                            ratingSection
                            
                            dateFilterSection
                            
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
            loadCurrentFilters()
        }
    }
    
    private var searchSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Search by Title")
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            TextField("Enter movie title...", text: $tempSearchText)
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
    
    private var genresSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Genres")
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                ForEach(viewModel.availableGenres, id: \.self) { genre in
                    GenreFilterButton(
                        genre: genre,
                        isSelected: tempSelectedGenres.contains(genre)
                    ) {
                        if tempSelectedGenres.contains(genre) {
                            tempSelectedGenres.remove(genre)
                        } else {
                            tempSelectedGenres.insert(genre)
                        }
                    }
                }
            }
        }
    }
    
    private var ratingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Rating Range")
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Text("\(tempRatingRange.lowerBound) - \(tempRatingRange.upperBound)")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            VStack(spacing: 8) {
                HStack {
                    Text("Min: \(tempRatingRange.lowerBound)")
                        .font(FontManager.caption)
                        .foregroundColor(AppColors.lightGray)
                    
                    Spacer()
                    
                    Text("Max: \(tempRatingRange.upperBound)")
                        .font(FontManager.caption)
                        .foregroundColor(AppColors.lightGray)
                }
                
                HStack {
                    Button("1-5") {
                        tempRatingRange = 1...5
                    }
                    .foregroundColor(tempRatingRange == 1...5 ? AppColors.primaryText : AppColors.lightGray)
                    
                    Button("6-10") {
                        tempRatingRange = 6...10
                    }
                    .foregroundColor(tempRatingRange == 6...10 ? AppColors.primaryText : AppColors.lightGray)
                    
                    Button("All") {
                        tempRatingRange = 1...10
                    }
                    .foregroundColor(tempRatingRange == 1...10 ? AppColors.primaryText : AppColors.lightGray)
                    
                    Spacer()
                }
                .font(FontManager.caption)
            }
        }
    }
    
    private var dateFilterSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Time Period")
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 8) {
                ForEach(MoviesViewModel.DateFilter.allCases, id: \.self) { filter in
                    Button(action: {
                        tempDateFilter = filter
                    }) {
                        HStack {
                            Text(filter.rawValue)
                                .font(FontManager.body)
                                .foregroundColor(tempDateFilter == filter ? AppColors.primaryText : AppColors.secondaryText)
                            
                            Spacer()
                            
                            if tempDateFilter == filter {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(AppColors.primaryText)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(tempDateFilter == filter ? AppColors.primaryText.opacity(0.1) : AppColors.cardBackground)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    private func loadCurrentFilters() {
        tempSelectedGenres = viewModel.selectedGenres
        tempRatingRange = viewModel.ratingRange
        tempDateFilter = viewModel.dateFilter
        tempSearchText = viewModel.searchText
    }
    
    private func applyFilters() {
        viewModel.selectedGenres = tempSelectedGenres
        viewModel.ratingRange = tempRatingRange
        viewModel.dateFilter = tempDateFilter
        viewModel.searchText = tempSearchText
        viewModel.applyFilters()
    }
    
    private func resetFilters() {
        tempSelectedGenres.removeAll()
        tempRatingRange = 1...10
        tempDateFilter = .all
        tempSearchText = ""
    }
}

struct GenreFilterButton: View {
    let genre: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(genre)
                .font(FontManager.subheadline)
                .foregroundColor(isSelected ? AppColors.background : AppColors.secondaryText)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? AppColors.primaryText : AppColors.cardBackground)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FiltersView(viewModel: MoviesViewModel())
}
