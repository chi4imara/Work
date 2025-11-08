import SwiftUI

struct SortView: View {
    @ObservedObject var viewModel: MovieListViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var tempSortOption: SortOption
    
    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        self._tempSortOption = State(initialValue: viewModel.sortOption)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        SortOptionRow(
                            title: option.rawValue,
                            isSelected: tempSortOption == option
                        ) {
                            tempSortOption = option
                        }
                    }
                    
                    Spacer()
                }
                .padding(20)
            }
            .navigationTitle("Sort")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        tempSortOption = .dateNewest
                    }
                    .foregroundColor(AppColors.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        viewModel.sortOption = tempSortOption
                        viewModel.saveData()
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

struct SortOptionRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.primaryBlue)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: AppColors.cardShadow, radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SortView(viewModel: MovieListViewModel())
}
