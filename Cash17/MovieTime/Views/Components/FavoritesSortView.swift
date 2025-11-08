import SwiftUI

struct FavoritesSortView: View {
    @Binding var sortOption: FavoritesSortOption
    @Binding var favoriteMovies: [Movie]
    @Environment(\.presentationMode) var presentationMode
    
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
                        
                        Text("Sort Favorites")
                            .foregroundColor(Color(red: 0.988, green: 0.8, blue: 0.008))
                        
                        Spacer()
                        
                        Button("Done") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 16)
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(FavoritesSortOption.allCases, id: \.self) { option in
                                FavoritesSortOptionRow(
                                    option: option,
                                    isSelected: sortOption == option
                                ) {
                                    sortOption = option
                                    favoriteMovies = applySorting(to: favoriteMovies, option: option)
                                }
                                
                                if option != FavoritesSortOption.allCases.last {
                                    Rectangle()
                                        .fill(AppColors.lightGray.opacity(0.3))
                                        .frame(height: 0.5)
                                        .padding(.leading, 60)
                                }
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(AppColors.cardGradient)
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func applySorting(to movies: [Movie], option: FavoritesSortOption) -> [Movie] {
        switch option {
        case .dateAdded:
            return movies.sorted { $0.updatedAt > $1.updatedAt }
        case .watchDate:
            return movies.sorted { $0.watchDate > $1.watchDate }
        case .title:
            return movies.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        case .rating:
            return movies.sorted { $0.rating > $1.rating }
        }
    }
}

struct FavoritesSortOptionRow: View {
    let option: FavoritesSortOption
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(option.rawValue)
                        .font(FontManager.body)
                        .foregroundColor(isSelected ? AppColors.primaryText : AppColors.secondaryText)
                        .fontWeight(isSelected ? .semibold : .regular)
                    
                    Text(sortDescription(for: option))
                        .font(FontManager.caption)
                        .foregroundColor(AppColors.lightGray)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func sortDescription(for option: FavoritesSortOption) -> String {
        switch option {
        case .dateAdded:
            return "Recently added to favorites first"
        case .watchDate:
            return "Most recently watched first"
        case .title:
            return "Alphabetical order A-Z"
        case .rating:
            return "Highest rated first"
        }
    }
}

#Preview {
    FavoritesSortView(sortOption: .constant(.dateAdded), favoriteMovies: .constant([]))
}
