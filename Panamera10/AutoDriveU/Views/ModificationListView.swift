import SwiftUI

struct ModificationListView: View {
    @EnvironmentObject var viewModel: ModificationViewModel
    @State private var showingAddModification = false
    @State private var showingSortOptions = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                searchAndFilterView
                
                if viewModel.filteredModifications.isEmpty {
                    emptyStateView
                        .padding(.bottom, 40)
                    
                    Spacer()
                } else {
                    modificationsList
                }
            }
        }
        .sheet(isPresented: $showingAddModification) {
            AddModificationView()
                .environmentObject(viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Modification List")
                    .font(FontManager.largeTitle)
                    .foregroundColor(AppColors.primaryWhite)
                
                Text("\(viewModel.modifications.count) modifications")
                    .font(FontManager.subheadline)
                    .foregroundColor(AppColors.primaryWhite.opacity(0.8))
            }
            
            Spacer()
            
            Button(action: {
                showingAddModification = true
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.primaryWhite)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppColors.primaryDarkBlue)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchAndFilterView: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.primaryDarkBlue.opacity(0.6))
                
                TextField("Search modifications...", text: $viewModel.searchText)
                    .font(FontManager.body)
                    .foregroundColor(AppColors.primaryDarkBlue)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.primaryDarkBlue.opacity(0.6))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(AppColors.cardBackground)
            )
            
            HStack {
                if let selectedCategory = viewModel.selectedCategory {
                    HStack(spacing: 8) {
                        Text(selectedCategory.displayName)
                            .font(FontManager.caption1)
                            .foregroundColor(AppColors.primaryWhite)
                        
                        Button(action: {
                            viewModel.clearCategoryFilter()
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(AppColors.primaryWhite)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.categoryColor(for: selectedCategory))
                    )
                }
                
                Spacer()
                
                Button(action: {
                    showingSortOptions = true
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.up.arrow.down")
                            .font(.system(size: 14, weight: .medium))
                        Text(viewModel.selectedSortOption.displayName)
                            .font(FontManager.caption1)
                    }
                    .foregroundColor(AppColors.primaryWhite)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.primaryDarkBlue.opacity(0.8))
                    )
                }
                .confirmationDialog("Sort Modifications", isPresented: $showingSortOptions, titleVisibility: .visible) {
                    ForEach(SortOption.allCases) { option in
                        Button(option.displayName) {
                            viewModel.selectedSortOption = option
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "wrench.and.screwdriver")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryWhite.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No Modifications")
                    .font(FontManager.title2)
                    .foregroundColor(AppColors.primaryWhite)
                
                Text("Add your first modification idea.")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                showingAddModification = true
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 20, weight: .medium))
                    Text("Add Mod")
                        .font(FontManager.headline)
                }
                .foregroundColor(AppColors.primaryWhite)
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(AppColors.primaryDarkBlue)
                )
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    private var modificationsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredModifications) { modification in
                    NavigationLink(destination: ModificationDetailView(modificationId: modification.id)
                        .environmentObject(viewModel)) {
                        ModificationCard(modification: modification)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
}

struct ModificationCard: View {
    let modification: Modification
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(modification.name)
                        .font(FontManager.headline)
                        .foregroundColor(AppColors.cardText)
                        .lineLimit(2)
                    
                    Text(modification.category.displayName)
                        .font(FontManager.caption1)
                        .foregroundColor(AppColors.categoryColor(for: modification.category))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(AppColors.categoryColor(for: modification.category).opacity(0.2))
                        )
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("$\(Int(modification.budget))")
                        .font(FontManager.headline)
                        .foregroundColor(AppColors.cardText)
                    
                    Text(modification.status.displayName)
                        .font(FontManager.caption2)
                        .foregroundColor(AppColors.statusColor(for: modification.status))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(AppColors.statusColor(for: modification.status).opacity(0.2))
                        )
                }
            }
            
            if !modification.description.isEmpty {
                Text(modification.description)
                    .font(FontManager.subheadline)
                    .foregroundColor(AppColors.cardText.opacity(0.8))
                    .lineLimit(2)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.primaryDarkBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    ModificationListView()
        .environmentObject(ModificationViewModel())
}
