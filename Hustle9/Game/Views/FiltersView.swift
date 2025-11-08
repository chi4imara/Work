import SwiftUI

struct FiltersView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: GamesViewModel
    
    @State private var selectedCategories: Set<GameCategory>
    
    init(viewModel: GamesViewModel) {
        self.viewModel = viewModel
        _selectedCategories = State(initialValue: viewModel.selectedCategories)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(GameCategory.allCases) { category in
                                CategoryFilterRow(
                                    category: category,
                                    isSelected: selectedCategories.contains(category)
                                ) {
                                    if selectedCategories.contains(category) {
                                        selectedCategories.remove(category)
                                    } else {
                                        selectedCategories.insert(category)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                    
                    VStack(spacing: 12) {
                        Button("Reset All") {
                            selectedCategories.removeAll()
                        }
                        .font(AppFonts.buttonMedium)
                        .foregroundColor(AppColors.primaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(AppColors.buttonBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(AppColors.buttonBorder, lineWidth: 1)
                                )
                        )
                        
                        Button("Apply Filters") {
                            viewModel.updateCategoryFilter(selectedCategories)
                            dismiss()
                        }
                        .font(AppFonts.buttonMedium)
                        .foregroundColor(AppColors.primaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(AppColors.accent)
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Filter by Categories")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
            }
        }
    }
}

struct CategoryFilterRow: View {
    let category: GameCategory
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Image(systemName: category.iconName)
                    .font(.title2)
                    .foregroundColor(AppColors.accent)
                    .frame(width: 30)
                
                Text(category.displayName)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isSelected ? AppColors.accent : AppColors.secondaryText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? AppColors.accent : AppColors.cardBorder, lineWidth: 1)
                    )
            )
        }
    }
}

#Preview {
    FiltersView(viewModel: GamesViewModel())
}
