import SwiftUI

struct FiltersView: View {
    @EnvironmentObject var viewModel: MakeupLookViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedTab: Int
    
    
    @State private var tempFilterOptions = FilterOptions()
    
    init(selectedTab: Binding<Int>) {
        self._selectedTab = selectedTab
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                HStack {
                    Text("Filters")
                        .font(.playfairDisplay(28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Categories")
                                .font(.playfairDisplay(20, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            VStack(spacing: 12) {
                                ForEach(MakeupCategory.allCases, id: \.self) { category in
                                    CategoryFilterRow(
                                        category: category,
                                        isSelected: tempFilterOptions.selectedCategories.contains(category),
                                        count: viewModel.getLooksCount(for: category)
                                    ) {
                                        if tempFilterOptions.selectedCategories.contains(category) {
                                            tempFilterOptions.selectedCategories.remove(category)
                                        } else {
                                            tempFilterOptions.selectedCategories.insert(category)
                                        }
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Colors")
                                .font(.playfairDisplay(20, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 12) {
                                ForEach(ColorPalette.availableColors.prefix(15), id: \.self) { colorHex in
                                    ColorFilterButton(
                                        colorHex: colorHex,
                                        isSelected: tempFilterOptions.selectedColors.contains(colorHex)
                                    ) {
                                        if tempFilterOptions.selectedColors.contains(colorHex) {
                                            tempFilterOptions.selectedColors.remove(colorHex)
                                        } else {
                                            tempFilterOptions.selectedColors.insert(colorHex)
                                        }
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Favorites")
                                .font(.playfairDisplay(20, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                            
                            Button(action: {
                                tempFilterOptions.showOnlyFavorites.toggle()
                            }) {
                                HStack {
                                    Image(systemName: tempFilterOptions.showOnlyFavorites ? "checkmark.square.fill" : "square")
                                        .foregroundColor(tempFilterOptions.showOnlyFavorites ? AppColors.primaryYellow : AppColors.secondaryText)
                                        .font(.title2)
                                    
                                    Text("Show only favorite looks")
                                        .font(.playfairDisplay(16))
                                        .foregroundColor(AppColors.contrastText)
                                    
                                    Spacer()
                                }
                                .padding(16)
                                .background(AppColors.backgroundWhite.opacity(0.9))
                                .cornerRadius(12)
                            }
                        }
                        
                        VStack(spacing: 12) {
                            Button(action: applyFilters) {
                                Text("Apply Filters")
                                    .font(.playfairDisplay(16, weight: .semibold))
                                    .foregroundColor(AppColors.contrastText)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(AppColors.primaryBlue)
                                    .cornerRadius(25)
                            }
                            
                            Button(action: resetFilters) {
                                Text("Reset All")
                                    .font(.playfairDisplay(16, weight: .semibold))
                                    .foregroundColor(AppColors.primaryBlue)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(AppColors.backgroundWhite.opacity(0.9))
                                    .cornerRadius(25)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(AppColors.primaryBlue.opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.top, 16)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            tempFilterOptions = viewModel.filterOptions
        }
    }
    
    private func applyFilters() {
        viewModel.filterOptions = tempFilterOptions
        viewModel.applyFilters()
        presentationMode.wrappedValue.dismiss()
        
        withAnimation {
            selectedTab = 0
        }
    }
    
    private func resetFilters() {
        tempFilterOptions.reset()
        viewModel.resetFilters()
        presentationMode.wrappedValue.dismiss()
        
        withAnimation {
            selectedTab = 0
        }
    }
}

struct CategoryFilterRow: View {
    let category: MakeupCategory
    let isSelected: Bool
    let count: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? AppColors.primaryYellow : AppColors.secondaryText)
                    .font(.title2)
                
                Image(systemName: category.icon)
                    .foregroundColor(AppColors.primaryBlue)
                    .font(.title3)
                    .frame(width: 24)
                
                Text(category.displayName)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(AppColors.contrastText)
                
                Spacer()
                
                Text("\(count)")
                    .font(.playfairDisplay(14, weight: .semibold))
                    .foregroundColor(AppColors.secondaryText)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(AppColors.lightGray)
                    .cornerRadius(8)
            }
            .padding(16)
            .background(AppColors.backgroundWhite.opacity(0.9))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? AppColors.primaryYellow : AppColors.primaryBlue.opacity(0.1), lineWidth: isSelected ? 2 : 1)
            )
        }
    }
}

struct ColorFilterButton: View {
    let colorHex: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Circle()
                .fill(ColorPalette.colorFromHex(colorHex))
                .frame(width: 44, height: 44)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
                .overlay(
                    isSelected ?
                    Circle()
                        .stroke(AppColors.primaryYellow, lineWidth: 3)
                    : nil
                )
                .overlay(
                    isSelected ?
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.caption)
                        .background(Circle().fill(Color.black.opacity(0.6)).frame(width: 20, height: 20))
                    : nil
                )
                .scaleEffect(isSelected ? 0.9 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
    }
}
