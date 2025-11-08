import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel: MovieListViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var tempFilterOptions: FilterOptions
    
    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        self._tempFilterOptions = State(initialValue: viewModel.filterOptions)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        filterSection(title: "Status") {
                            VStack(spacing: 12) {
                                FilterCheckbox(
                                    title: "Not Watched",
                                    isSelected: tempFilterOptions.showUnwatched
                                ) {
                                    tempFilterOptions.showUnwatched.toggle()
                                }
                                
                                FilterCheckbox(
                                    title: "Watched",
                                    isSelected: tempFilterOptions.showWatched
                                ) {
                                    tempFilterOptions.showWatched.toggle()
                                }
                            }
                        }
                        
                        filterSection(title: "Type") {
                            VStack(spacing: 12) {
                                FilterCheckbox(
                                    title: "Movie",
                                    isSelected: tempFilterOptions.showMovies
                                ) {
                                    tempFilterOptions.showMovies.toggle()
                                }
                                
                                FilterCheckbox(
                                    title: "Series",
                                    isSelected: tempFilterOptions.showSeries
                                ) {
                                    tempFilterOptions.showSeries.toggle()
                                }
                            }
                        }
                        
                        if !viewModel.genres.isEmpty {
                            filterSection(title: "Genres") {
                                LazyVGrid(columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ], spacing: 12) {
                                    ForEach(viewModel.genres) { genre in
                                        FilterCheckbox(
                                            title: genre.name,
                                            isSelected: tempFilterOptions.selectedGenres.contains(genre.name)
                                        ) {
                                            if tempFilterOptions.selectedGenres.contains(genre.name) {
                                                tempFilterOptions.selectedGenres.remove(genre.name)
                                            } else {
                                                tempFilterOptions.selectedGenres.insert(genre.name)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Filter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        tempFilterOptions.reset()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        viewModel.filterOptions = tempFilterOptions
                        viewModel.saveData()
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func filterSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(AppFonts.title3)
                .foregroundColor(AppColors.primaryText)
            
            content()
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

struct FilterCheckbox: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.secondaryText)
                
                Text(title)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FilterView(viewModel: MovieListViewModel())
}
