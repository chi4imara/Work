import SwiftUI

struct CollectionView: View {
    @ObservedObject var viewModel: FragranceViewModel
    @State private var showingAddFragrance = false
    @State private var showingSortOptions = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    searchAndControlsView
                    
                    if viewModel.filteredFragrances.isEmpty {
                        emptyStateView
                    } else {
                        fragranceListView
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddFragrance) {
            AddFragranceView(viewModel: viewModel)
        }
        .actionSheet(isPresented: $showingSortOptions) {
            sortActionSheet
        }
        .onChange(of: viewModel.searchText) { _ in
            viewModel.updateFilteredFragrances()
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("My Collection")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: { showingAddFragrance = true }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(AppColors.accentYellow)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchAndControlsView: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.secondaryText)
                
                TextField("Search by name or brand", text: $viewModel.searchText)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.primaryText)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: { viewModel.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
            
            HStack {
                Button(action: { showingSortOptions = true }) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.up.arrow.down")
                        Text("Sort: \(viewModel.sortOption.displayName)")
                            .font(.ubuntu(14, weight: .medium))
                    }
                    .foregroundColor(AppColors.primaryText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(AppColors.cardBackground)
                    .cornerRadius(8)
                }
                
                Spacer()
                
                if viewModel.currentFilter.isActive {
                    Button(action: { viewModel.resetFilter() }) {
                        HStack(spacing: 6) {
                            Image(systemName: "xmark.circle")
                            Text("Clear Filters")
                                .font(.ubuntu(14, weight: .medium))
                        }
                        .foregroundColor(AppColors.accentYellow)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(AppColors.cardBackground)
                        .cornerRadius(8)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "waterbottle")
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText)
            
            Text("No fragrances yet")
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Text("You don't have any added fragrances yet. Tap ➕ to add your first one.")
                .font(.ubuntu(16))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: { showingAddFragrance = true }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Fragrance")
                        .font(.ubuntu(16, weight: .medium))
                }
                .foregroundColor(AppColors.buttonText)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(AppColors.buttonPrimary)
                .cornerRadius(12)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var fragranceListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredFragrances) { fragrance in
                    NavigationLink(destination: FragranceDetailView(fragrance: fragrance, viewModel: viewModel)) {
                        FragranceCard(fragrance: fragrance)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var sortActionSheet: ActionSheet {
        ActionSheet(
            title: Text("Sort by"),
            buttons: SortOption.allCases.map { option in
                .default(Text(option.displayName)) {
                    viewModel.sortOption = option
                    viewModel.updateFilteredFragrances()
                }
            } + [.cancel()]
        )
    }
}

struct FragranceCard: View {
    let fragrance: Fragrance
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(fragrance.name)
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(2)
                    
                    Text("\(fragrance.brand) — \(fragrance.season.displayName)")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text(fragrance.type.displayName)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(AppColors.buttonText)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(AppColors.accentYellow)
                        .cornerRadius(6)
                    
                    Image(systemName: fragrance.season.icon)
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.accentYellow)
                }
            }
            
            if !fragrance.atmosphere.isEmpty {
                Text(fragrance.atmosphere)
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.tertiaryText)
                    .italic()
            }
            
            if !fragrance.mainNotes.isEmpty {
                Text("Notes: \(fragrance.mainNotes)")
                    .font(.ubuntu(13))
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(2)
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.borderPrimary, lineWidth: 1)
        )
    }
}

#Preview {
    CollectionView(viewModel: FragranceViewModel())
}
