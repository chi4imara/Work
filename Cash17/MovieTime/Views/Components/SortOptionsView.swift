import SwiftUI

struct SortOptionsView: View {
    @ObservedObject var viewModel: MoviesViewModel
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
                        
                        Text("Sort Movies")
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
                            ForEach(MoviesViewModel.SortOption.allCases, id: \.self) { option in
                                SortOptionRow(
                                    option: option,
                                    isSelected: viewModel.sortOption == option
                                ) {
                                    viewModel.sortOption = option
                                    viewModel.applyFilters()
                                }
                                
                                if option != MoviesViewModel.SortOption.allCases.last {
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
}

struct SortOptionRow: View {
    let option: MoviesViewModel.SortOption
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
    
    private func sortDescription(for option: MoviesViewModel.SortOption) -> String {
        switch option {
        case .dateDescending:
            return "Most recently watched first"
        case .dateAscending:
            return "Oldest movies first"
        case .titleAscending:
            return "Alphabetical order A-Z"
        case .titleDescending:
            return "Alphabetical order Z-A"
        case .ratingDescending:
            return "Highest rated first"
        case .ratingAscending:
            return "Lowest rated first"
        }
    }
}

#Preview {
    SortOptionsView(viewModel: MoviesViewModel())
}
