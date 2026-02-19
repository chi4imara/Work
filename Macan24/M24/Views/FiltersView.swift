import SwiftUI

struct FiltersView: View {
    @EnvironmentObject var viewModel: BreakfastViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedTab: Int
    
    @State private var selectedCategories: Set<BreakfastCategory> = []
    @State private var drinkFilter: String = ""
    
    var hasActiveFilters: Bool {
        !selectedCategories.isEmpty || !drinkFilter.isEmpty
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 32) {
                        categoryFiltersSection
                        
                        drinkFilterSection
                        
                        actionButtons
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            loadCurrentFilters()
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Filters")
                .font(.playfairDisplay(size: 32, weight: .bold))
                .foregroundColor(AppColors.primaryBlue)
            
            Spacer()
            
            if viewModel.isFiltering {
                ZStack {
                    Circle()
                        .fill(AppColors.primaryYellow)
                        .frame(width: 42, height: 42)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(AppColors.backgroundWhite)
                }
                .shadow(color: AppColors.primaryYellow.opacity(0.3), radius: 5, x: 0, y: 2)
            } else {
                Color.clear
                    .frame(width: 42, height: 42)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var categoryFiltersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "square.grid.2x2.fill")
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.primaryBlue)
                
                Text("Categories")
                    .font(.playfairDisplay(size: 24, weight: .bold))
                    .foregroundColor(AppColors.primaryBlue)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                ForEach(BreakfastCategory.allCases, id: \.self) { category in
                    CategoryFilterRow(
                        category: category,
                        isSelected: selectedCategories.contains(category),
                        count: viewModel.getBreakfastCount(for: category)
                    ) {
                        toggleCategory(category)
                    }
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.backgroundWhite.opacity(0.95))
                .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 4)
        )
    }
    
    private var drinkFilterSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "cup.and.saucer.fill")
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.accentOrange)
                
                Text("Drink")
                    .font(.playfairDisplay(size: 24, weight: .bold))
                    .foregroundColor(AppColors.primaryBlue)
                
                Spacer()
            }
            
            TextField("Search by drink (e.g., Coffee, Juice, Tea)", text: $drinkFilter)
                .font(.playfairDisplay(size: 16))
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(AppColors.softGray.opacity(0.8))
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(
                            drinkFilter.isEmpty ? Color.clear : AppColors.accentOrange.opacity(0.5),
                            lineWidth: 2
                        )
                )
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.backgroundWhite.opacity(0.95))
                .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 4)
        )
    }
    
    private var actionButtons: some View {
        VStack(spacing: 16) {
            Button(action: applyFilters) {
                HStack(spacing: 12) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold))
                    
                    Text("Apply Filters")
                        .font(.playfairDisplay(size: 18, weight: .semibold))
                }
                .foregroundColor(AppColors.backgroundWhite)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    hasActiveFilters ?
                    LinearGradient(
                        colors: [AppColors.primaryYellow, AppColors.accentOrange],
                        startPoint: .leading,
                        endPoint: .trailing
                    ) :
                        LinearGradient(
                            colors: [AppColors.textGray.opacity(0.3), AppColors.textGray.opacity(0.3)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                )
                .cornerRadius(25)
                .shadow(
                    color: hasActiveFilters ? AppColors.primaryYellow.opacity(0.4) : Color.clear,
                    radius: hasActiveFilters ? 10 : 0,
                    x: 0,
                    y: hasActiveFilters ? 5 : 0
                )
            }
            .disabled(!hasActiveFilters)
            
            Button(action: resetFilters) {
                HStack(spacing: 12) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("Reset")
                        .font(.playfairDisplay(size: 16, weight: .medium))
                }
                .foregroundColor(AppColors.textGray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(AppColors.backgroundWhite.opacity(0.9))
                .cornerRadius(20)
                .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
            }
        }
    }
    
    private func loadCurrentFilters() {
        selectedCategories = viewModel.selectedCategories
        drinkFilter = viewModel.drinkFilter
    }
    
    private func toggleCategory(_ category: BreakfastCategory) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }
    
    private func applyFilters() {
        viewModel.selectedCategories = selectedCategories
        viewModel.drinkFilter = drinkFilter
        viewModel.updateFilteredBreakfasts()
        presentationMode.wrappedValue.dismiss()
        
        withAnimation {
            selectedTab = 0
        }
    }
    
    private func resetFilters() {
        selectedCategories.removeAll()
        drinkFilter = ""
        viewModel.clearFilters()
        presentationMode.wrappedValue.dismiss()
        
        withAnimation {
            selectedTab = 0
        }
    }
}

struct CategoryFilterRow: View {
    let category: BreakfastCategory
    let isSelected: Bool
    let count: Int
    let action: () -> Void
    
    private var categoryIcon: String {
        switch category {
        case .weekday:
            return "briefcase.fill"
        case .weekend:
            return "house.fill"
        case .holiday:
            return "star.fill"
        case .outdoor:
            return "leaf.fill"
        }
    }
    
    private var categoryColor: Color {
        switch category {
        case .weekday:
            return AppColors.primaryBlue
        case .weekend:
            return AppColors.accentGreen
        case .holiday:
            return AppColors.primaryYellow
        case .outdoor:
            return AppColors.accentOrange
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? categoryColor : AppColors.softGray)
                        .frame(width: 24, height: 24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(categoryColor, lineWidth: 2)
                        )
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(AppColors.backgroundWhite)
                    }
                }
                
                Image(systemName: categoryIcon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(categoryColor)
                    .frame(width: 24)
                
                Text(category.displayName)
                    .font(.playfairDisplay(size: 18, weight: .medium))
                    .foregroundColor(AppColors.primaryBlue)
                
                Spacer()
                
                Text("(\(count))")
                    .font(.playfairDisplay(size: 16))
                    .foregroundColor(AppColors.textGray.opacity(0.7))
            }
            .padding(.vertical, 8)
        }
    }
}

