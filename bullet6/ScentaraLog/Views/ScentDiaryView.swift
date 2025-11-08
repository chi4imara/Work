import SwiftUI

struct ScentDiaryView: View {
    @ObservedObject var viewModel: ScentDiaryViewModel
    @State private var showingMenu = false
    @State private var showingSortOptions = false
    @State private var showingDeleteAllAlert = false
    
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        headerView
                        
                        searchBar
                        
                        if viewModel.filteredEntries.isEmpty {
                            emptyStateView
                        } else {
                            entriesListView
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
        }
        .sheet(isPresented: $viewModel.showingAddEntry) {
            AddEditEntryView(viewModel: viewModel)
        }
        .actionSheet(isPresented: $showingSortOptions) {
            sortActionSheet
        }
        .alert("Clear entire diary?", isPresented: $showingDeleteAllAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete All", role: .destructive) {
                viewModel.deleteAllEntries()
            }
        } message: {
            Text("This action cannot be undone.")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Scent Diary")
                .font(AppFonts.largeTitle)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: {
                    viewModel.showingAddEntry = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.primaryPurple)
                }
                
                Menu {
                    Button("Categories") {
                        withAnimation {
                            selectedTab = 2
                        }
                    }
                    
                    Button("Tips about sensations") {
                        withAnimation {
                            selectedTab = 3
                        }
                    }
                    
                    Button("Delete all entries", role: .destructive) {
                        showingDeleteAllAlert = true
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.primaryPurple)
                        .rotationEffect(.degrees(90))
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.lightText)
            
            TextField("Search by name or association...", text: $viewModel.searchText)
                .font(AppFonts.body)
                .foregroundColor(AppColors.primaryText)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.cardShadow, radius: 2, x: 0, y: 1)
        )
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "leaf.fill")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.primaryPurple.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No entries yet")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add a scent you noticed today")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                viewModel.showingAddEntry = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Entry")
                }
                .font(AppFonts.headline)
                .foregroundColor(AppColors.buttonText)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.buttonBackground)
                )
            }
        }
        .padding(.top, 40)
        .padding(.horizontal, 40)
    }
    
    private var entriesListView: some View {
        VStack(spacing: 0) {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.filteredEntries) { entry in
                        NavigationLink(destination: EntryDetailView(entryId: entry.id, viewModel: viewModel)) {
                            ScentEntryCard(entry: entry)
                        }
                        .contextMenu {
                            Button("Delete", role: .destructive) {
                                viewModel.deleteEntry(entry)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            
            Button(action: {
                showingSortOptions = true
            }) {
                HStack {
                    Image(systemName: "arrow.up.arrow.down")
                    Text("Sort")
                }
                .font(AppFonts.callout)
                .foregroundColor(AppColors.primaryPurple)
                .padding(.vertical, 12)
            }
            .padding(.bottom, 8)
        }
    }
    
    private var sortActionSheet: ActionSheet {
        ActionSheet(
            title: Text("Sort entries"),
            buttons: SortOption.allCases.map { option in
                    .default(Text(option.displayName)) {
                        viewModel.setSortOption(option)
                    }
            } + [.cancel()]
        )
    }
}

struct ScentEntryCard: View {
    let entry: ScentEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.name)
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(1)
                    
                    if !entry.category.isEmpty {
                        Text("Category: \(entry.category)")
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
                
                Spacer()
                
                Text(entry.dateAdded, style: .date)
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.lightText)
            }
            
            if !entry.associations.isEmpty {
                Text(entry.associations)
                    .font(AppFonts.subheadline)
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient.cardGradient)
                .shadow(color: AppColors.cardShadow, radius: 4, x: 0, y: 2)
        )
    }
}


