import SwiftUI

struct FiltersView: View {
    @ObservedObject var viewModel: InteriorIdeasViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var tempFilterSettings: FilterSettings
    
    init(viewModel: InteriorIdeasViewModel) {
        self.viewModel = viewModel
        self._tempFilterSettings = State(initialValue: viewModel.filterSettings)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack {
                    HStack {
                        Button("Done") {
                            dismiss()
                        }
                        .foregroundColor(AppColors.primaryOrange)
                        .disabled(true)
                        .opacity(0)
                        
                        Spacer()
                        
                        Text("Filters & Sort")
                            .font(AppFonts.title2())
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Button("Done") {
                            dismiss()
                        }
                        .foregroundColor(AppColors.primaryOrange)
                    }
                    .padding()
                    
                    ScrollView {
                        VStack(spacing: 30) {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Categories")
                                    .font(AppFonts.title3())
                                    .foregroundColor(AppColors.primaryText)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                    ForEach(InteriorIdea.Category.allCases, id: \.self) { category in
                                        CategoryFilterButton(
                                            category: category,
                                            isSelected: tempFilterSettings.selectedCategories.contains(category)
                                        ) {
                                            if tempFilterSettings.selectedCategories.contains(category) {
                                                tempFilterSettings.selectedCategories.remove(category)
                                            } else {
                                                tempFilterSettings.selectedCategories.insert(category)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Search")
                                    .font(AppFonts.title3())
                                    .foregroundColor(AppColors.primaryText)
                                
                                TextField("Search ideas...", text: $tempFilterSettings.searchText)
                                    .font(AppFonts.body())
                                    .foregroundColor(AppColors.primaryText)
                                    .padding(16)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.cardBorder, lineWidth: 1)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Sort By")
                                    .font(AppFonts.title3())
                                    .foregroundColor(AppColors.primaryText)
                                
                                VStack(spacing: 12) {
                                    ForEach(FilterSettings.SortOption.allCases, id: \.self) { option in
                                        SortOptionButton(
                                            option: option,
                                            isSelected: tempFilterSettings.sortOption == option
                                        ) {
                                            tempFilterSettings.sortOption = option
                                        }
                                    }
                                }
                            }
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
                
                VStack {
                    Spacer()
                    
                    HStack(spacing: 16) {
                        Button(action: {
                            tempFilterSettings = FilterSettings()
                        }) {
                            Text("Reset")
                                .font(AppFonts.button())
                                .foregroundColor(AppColors.secondaryText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(AppColors.cardBackground)
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(AppColors.cardBorder, lineWidth: 1)
                                )
                        }
                        
                        Button(action: {
                            viewModel.updateFilterSettings(tempFilterSettings)
                            dismiss()
                        }) {
                            Text("Apply")
                                .font(AppFonts.button())
                                .foregroundColor(AppColors.primaryWhite)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(AppGradients.buttonGradient)
                                .cornerRadius(25)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

struct CategoryFilterButton: View {
    let category: InteriorIdea.Category
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 16))
                    .foregroundColor(isSelected ? AppColors.primaryOrange : AppColors.secondaryText)
                
                Text(category.rawValue)
                    .font(AppFonts.callout())
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            .padding(12)
            .background(isSelected ? AppColors.primaryOrange.opacity(0.1) : AppColors.cardBackground)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? AppColors.primaryOrange : AppColors.cardBorder, lineWidth: 1)
            )
        }
    }
}

struct SortOptionButton: View {
    let option: FilterSettings.SortOption
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .font(.system(size: 16))
                    .foregroundColor(isSelected ? AppColors.primaryOrange : AppColors.secondaryText)
                
                Text(option.rawValue)
                    .font(AppFonts.callout())
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            .padding(12)
            .background(isSelected ? AppColors.primaryOrange.opacity(0.1) : AppColors.cardBackground)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? AppColors.primaryOrange : AppColors.cardBorder, lineWidth: 1)
            )
        }
    }
}

#Preview {
    FiltersView(viewModel: InteriorIdeasViewModel())
}
