import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: WonderViewModel
    @State private var showingMenu = false
    @State private var showingDeleteAlert = false
    @State private var entryToDelete: WonderEntry?
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if viewModel.entries.isEmpty {
                        emptyStateView
                    } else {
                        entriesListView
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $viewModel.showingAddEntry) {
                AddEditEntryView(viewModel: viewModel, entry: viewModel.selectedEntry)
            }
            .alert("Delete Entry", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    if let entry = entryToDelete {
                        viewModel.deleteEntry(entry)
                    }
                }
            } message: {
                Text("Are you sure you want to delete this entry?")
            }
        }
        .onAppear {
            viewModel.loadEntries()
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("What Surprised You")
                .font(.appTitle)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: {
                    viewModel.showAddEntry()
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(AppColors.primaryBlue)
                }
                
                Button(action: {
                    showingMenu = true
                }) {
                    Image(systemName: "ellipsis")
                        .font(.title2)
                        .foregroundColor(AppColors.primaryBlue)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .actionSheet(isPresented: $showingMenu) {
            ActionSheet(
                title: Text("Options"),
                buttons: [
                    .default(Text("Filter: \(viewModel.selectedPeriod.rawValue)")) {
                        let periods: [TimePeriod] = [.today, .week, .month, .all]
                        if let currentIndex = periods.firstIndex(of: viewModel.selectedPeriod) {
                            let nextIndex = (currentIndex + 1) % periods.count
                            viewModel.setPeriod(periods[nextIndex])
                        }
                    },
                    .default(Text("Sort: \(viewModel.sortOrder.rawValue)")) {
                        let newOrder: SortOrder = viewModel.sortOrder == .newest ? .oldest : .newest
                        viewModel.setSortOrder(newOrder)
                    },
                    .cancel()
                ]
            )
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "lightbulb")
                .font(.system(size: 60))
                .foregroundColor(AppColors.lightBlue)
            
            VStack(spacing: 12) {
                Text("No entries found")
                    .font(.appHeadline)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Tap the + button to add your first surprise")
                    .font(.appBody)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                viewModel.showAddEntry()
            }) {
                Text("Add First Entry")
                    .font(.appSubheadline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(AppColors.primaryBlue)
                    .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding(.horizontal, 32)
    }
    
    private var entriesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.entries) { entry in
                    NavigationLink(destination: EntryDetailView(entry: entry, viewModel: viewModel)) {
                        EntryCardView(entry: entry)
                    }
                    .contextMenu {
                    
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
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        Button(action: {
                            viewModel.showEditEntry(entry)
                        }) {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(AppColors.accent)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
    }
}

struct EntryCardView: View {
    let entry: WonderEntry
    
    var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(entry.title)
                        .font(.appSubheadline)
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Text(entry.displayDateTime)
                        .font(.appSmall)
                        .foregroundColor(AppColors.secondaryText)
                }
                
                if !entry.description.isEmpty {
                    Text(entry.shortDescription)
                        .font(.appBody)
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .concaveCard(cornerRadius: 8, depth: -5, color: AppColors.cardBackground)
    }
}
