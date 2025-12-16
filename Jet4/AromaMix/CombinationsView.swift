import SwiftUI

struct CombinationsView: View {
    @ObservedObject var viewModel: ScentCombinationsViewModel
    @State private var showingAddCombination = false
    @State private var selectedCombinationId: UUID?
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                searchAndFiltersView
                
                if viewModel.filteredCombinations.isEmpty {
                    emptyStateView
                } else {
                    combinationsListView
                }
            }
        }
        .sheet(isPresented: $showingAddCombination) {
            AddCombinationView(viewModel: viewModel)
        }
        .sheet(isPresented: Binding(
            get: { selectedCombinationId != nil },
            set: { if !$0 { selectedCombinationId = nil } }
        )) {
            if let id = selectedCombinationId {
                CombinationDetailView(combinationId: id, viewModel: viewModel)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("My Combinations")
                .font(AppFonts.largeTitle)
                .foregroundColor(AppColors.darkGray)
            
            Spacer()
            
            Button(action: {
                showingAddCombination = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(AppColors.purpleGradientStart)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchAndFiltersView: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.darkGray.opacity(0.6))
                
                TextField("Search by name or aroma type...", text: $viewModel.searchText)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.darkGray)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.darkGray.opacity(0.6))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.8))
            .cornerRadius(12)
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    CategoryFilterButton(
                        title: "All",
                        isSelected: viewModel.selectedCategory == nil,
                        action: { viewModel.clearCategoryFilter() }
                    )
                    
                    ForEach(ScentCategory.allCases, id: \.self) { category in
                        CategoryFilterButton(
                            title: category.displayName,
                            isSelected: viewModel.selectedCategory == category,
                            action: { viewModel.setCategoryFilter(category) }
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.vertical, 15)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "heart.circle")
                .font(.system(size: 80))
                .foregroundColor(AppColors.purpleGradientStart.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No combinations yet")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.darkGray)
                
                Text("Start with your favorite perfumes and candles that sound perfect together.")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.darkGray.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: {
                showingAddCombination = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Combination")
                }
                .font(AppFonts.headline)
                .foregroundColor(.white)
                .frame(width: 200, height: 50)
                .background(AppColors.buttonGradient)
                .cornerRadius(25)
                .shadow(color: AppColors.purpleGradientStart.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            
            Spacer()
        }
    }
    
    private var combinationsListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredCombinations) { combination in
                    CombinationCardView(combination: combination) {
                        selectedCombinationId = combination.id
                    }
                    .contextMenu {
                        Button(action: {
                            selectedCombinationId = combination.id
                        }) {
                            Label("View Details", systemImage: "eye")
                        }
                        
                        Button(action: {
                            viewModel.deleteCombination(combination)
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
}

struct CategoryFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFonts.callout)
                .foregroundColor(isSelected ? .white : AppColors.darkGray)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected ? AppColors.purpleGradientStart : Color.white.opacity(0.8)
                )
                .cornerRadius(20)
        }
    }
}

struct CombinationCardView: View {
    let combination: ScentCombination
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(combination.name)
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.darkGray)
                            .multilineTextAlignment(.leading)
                        
                        Text("\(combination.category.displayName) combination")
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.blueText)
                    }
                    
                    Spacer()
                    
                    Image(systemName: combination.rating.icon)
                        .font(.system(size: 20))
                        .foregroundColor(ratingColor(for: combination.rating))
                }
                
                Text("\(combination.perfumeAroma) + \(combination.candleAroma)")
                    .font(AppFonts.subheadline)
                    .foregroundColor(AppColors.darkGray.opacity(0.8))
                    .multilineTextAlignment(.leading)
            }
            .padding(16)
            .background(AppColors.cardGradient)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func ratingColor(for rating: Rating) -> Color {
        switch rating {
        case .favorite: return AppColors.warningRed
        case .good: return AppColors.successGreen
        case .trial: return AppColors.yellowAccent
        }
    }
}

#Preview {
    CombinationsView(viewModel: ScentCombinationsViewModel())
}
