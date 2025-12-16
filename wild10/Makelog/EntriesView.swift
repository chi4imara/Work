import SwiftUI

struct EntriesView: View {
    @ObservedObject var viewModel: WeatherEntriesViewModel
    @State private var showingDeleteAlert = false
    @State private var entryToDelete: WeatherEntry?
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.hasEntries {
                    if viewModel.hasFilteredResults {
                        entriesListView
                    } else {
                        noFilterResultsView
                    }
                } else {
                    emptyStateView
                }
            }
        }
        .sheet(isPresented: $viewModel.isShowingCreateEntry) {
            CreateEntryView(
                viewModel: CreateEntryViewModel(
                    weatherEntriesViewModel: viewModel,
                    editingEntry: viewModel.editingEntry
                )
            )
        }
        .actionSheet(isPresented: $viewModel.isShowingCategoryFilter) {
            categoryFilterActionSheet
        }
        .actionSheet(isPresented: $viewModel.isShowingSortOptions) {
            sortOptionsActionSheet
        }
        .alert("Delete Entry", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let entry = entryToDelete {
                    viewModel.deleteEntry(entry)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this entry? This action cannot be undone.")
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("My Weather Diary")
                    .font(AppFonts.title1)
                    .foregroundColor(AppColors.textPrimary)
                
                if viewModel.filterState.isActive {
                    Text("Filtered by \(viewModel.filterState.selectedCategory?.name ?? "")")
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            
            Spacer()
            
            HStack(spacing: AppSpacing.sm) {
                Button(action: { viewModel.isShowingSortOptions = true }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.textPrimary)
                        .frame(width: 40, height: 40)
                        .background(
                            Circle()
                                .fill(AppColors.cardBackground)
                                .overlay(
                                    Circle()
                                        .stroke(AppColors.cardBorder, lineWidth: 1)
                                )
                        )
                }
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.top, AppSpacing.sm)
        .padding(.bottom, AppSpacing.md)
    }
    
    private var entriesListView: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: AppSpacing.md) {
                    ForEach(viewModel.filteredAndSortedEntries) { entry in
                        NavigationLink(destination: EntryDetailView(entry: entry, viewModel: viewModel)) {
                            EntryCardView(entry: entry)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .contextMenu {
                            Button(action: { viewModel.startEditingEntry(entry) }) {
                                Label("Edit", systemImage: "pencil")
                            }
                            
                            Button(role: .destructive, action: {
                                entryToDelete = entry
                                showingDeleteAlert = true
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive, action: {
                                entryToDelete = entry
                                showingDeleteAlert = true
                            }) {
                                Image(systemName: "trash")
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button(action: { viewModel.startEditingEntry(entry) }) {
                                Image(systemName: "pencil")
                            }
                            .tint(AppColors.accentGreen)
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.bottom, 100)
            }
            
            HStack {
                Spacer()
                Text("Total entries: \(viewModel.filteredEntriesCount)")
                    .font(AppFonts.footnote)
                    .foregroundColor(AppColors.textSecondary)
                Spacer()
            }
            .padding(.vertical, AppSpacing.sm)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
            )
            .padding(.horizontal, AppSpacing.md)
            .padding(.bottom, AppSpacing.sm)
        }
        .padding(.bottom, 100)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()
            
            Image(systemName: "cloud")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.textSecondary)
            
            VStack(spacing: AppSpacing.sm) {
                Text("You haven't added any entries yet")
                    .font(AppFonts.title3)
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text("Start documenting your weather experiences")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { viewModel.isShowingCreateEntry = true }) {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Add First Entry")
                        .font(AppFonts.headline)
                }
                .foregroundColor(AppColors.buttonText)
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.md)
                .background(
                    RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                        .fill(AppColors.buttonBackground)
                )
            }
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.xl)
    }
    
    private var noFilterResultsView: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.textSecondary)
            
            VStack(spacing: AppSpacing.sm) {
                Text("No matches found")
                    .font(AppFonts.title3)
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Try adjusting your filter settings")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Button(action: { viewModel.clearFilter() }) {
                Text("Clear Filter")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.buttonText)
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.vertical, AppSpacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                            .fill(AppColors.buttonBackground)
                    )
            }
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.xl)
    }
    
    private var categoryFilterActionSheet: ActionSheet {
        var buttons: [ActionSheet.Button] = []
        
        buttons.append(.default(Text("All Categories")) {
            viewModel.clearFilter()
        })
        
        for category in viewModel.categories {
            buttons.append(.default(Text(category.name)) {
                viewModel.applyFilter(category: category)
            })
        }
        
        buttons.append(.cancel())
        
        return ActionSheet(
            title: Text("Filter by Category"),
            buttons: buttons
        )
    }
    
    private var sortOptionsActionSheet: ActionSheet {
        ActionSheet(
            title: Text("Options"),
            buttons: [
                .default(Text("Filter by Category")) {
                    viewModel.isShowingCategoryFilter = true
                },
                .default(Text("Sort by Date (Newest First)")) {
                    viewModel.applySorting(.dateDescending)
                },
                .default(Text("Sort by Date (Oldest First)")) {
                    viewModel.applySorting(.dateAscending)
                },
                .default(Text("Sort Alphabetically")) {
                    viewModel.applySorting(.alphabetical)
                },
                .cancel()
            ]
        )
    }
}

struct EntryCardView: View {
    let entry: WeatherEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(entry.truncatedDescription)
                .font(AppFonts.body)
                .foregroundColor(AppColors.textPrimary)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
            
            HStack {
                Text("Category: \(entry.category.name)")
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.textSecondary)
                
                Spacer()
                
                Text(entry.shortFormattedDate)
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .padding(AppSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
}

#Preview {
    EntriesView(viewModel: WeatherEntriesViewModel())
}
