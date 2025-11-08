import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: WonderViewModel
    @State private var searchText = ""
    @State private var selectedPeriod: TimePeriod = .all
    @State private var showingFilterMenu = false
    @State private var filteredEntries: [WonderEntry] = []
    
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    searchBarView
                    
                    if filteredEntries.isEmpty {
                        emptyStateView
                    } else {
                        entriesListView
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            updateFilteredEntries()
            viewModel.loadEntries()
        }
        .onChange(of: searchText) { _ in
            updateFilteredEntries()
        }
        .onChange(of: selectedPeriod) { _ in
            updateFilteredEntries()
        }
        .onChange(of: viewModel.entries) { _ in
            updateFilteredEntries()
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("History")
                .font(.appTitle)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: {
                showingFilterMenu = true
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                    Text(selectedPeriod.rawValue)
                }
                .font(.appCaption)
                .foregroundColor(AppColors.primaryBlue)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .actionSheet(isPresented: $showingFilterMenu) {
            ActionSheet(
                title: Text("Filter by Period"),
                buttons: [
                    .default(Text("Today")) {
                        selectedPeriod = .today
                    },
                    .default(Text("Week")) {
                        selectedPeriod = .week
                    },
                    .default(Text("Month")) {
                        selectedPeriod = .month
                    },
                    .default(Text("All Time")) {
                        selectedPeriod = .all
                    },
                    .cancel()
                ]
            )
        }
    }
    
    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.secondaryText)
            
            TextField("Search in title and description...", text: $searchText)
                .font(.appBody)
                .foregroundColor(AppColors.primaryText)
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColors.secondaryText)
                }
            }
        }
        .padding(12)
        .background(AppColors.cardBackground)
        .cornerRadius(8)
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: searchText.isEmpty ? "clock" : "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(AppColors.lightBlue)
            
            VStack(spacing: 12) {
                Text(searchText.isEmpty ? "History is empty" : "Nothing found")
                    .font(.appHeadline)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(searchText.isEmpty ? 
                     "Start adding entries to see them here" : 
                     "Try adjusting your search or filter")
                    .font(.appBody)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            if searchText.isEmpty {
                Button(action: {
                    selectedTab = 0
                }) {
                    Text("Add First Entry")
                        .font(.appSubheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(AppColors.primaryBlue)
                        .cornerRadius(8)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 32)
    }
    
    private var entriesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredEntries) { entry in
                    NavigationLink(destination: EntryDetailView(entry: entry, viewModel: viewModel)) {
                        HistoryEntryCardView(entry: entry)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .sheet(isPresented: $viewModel.showingAddEntry) {
            AddEditEntryView(viewModel: viewModel, entry: viewModel.selectedEntry)
        }
    }
    
    private func updateFilteredEntries() {
        if searchText.isEmpty {
            filteredEntries = viewModel.entries.filter { entry in
                let calendar = Calendar.current
                let now = Date()
                
                switch selectedPeriod {
                case .today:
                    return calendar.isDate(entry.date, inSameDayAs: now)
                case .week:
                    let weekAgo = calendar.date(byAdding: .day, value: -6, to: now) ?? now
                    return entry.date >= calendar.startOfDay(for: weekAgo)
                case .month:
                    let monthAgo = calendar.date(byAdding: .day, value: -30, to: now) ?? now
                    return entry.date >= calendar.startOfDay(for: monthAgo)
                case .all:
                    return true
                }
            }
        } else {
            filteredEntries = viewModel.entries.filter { entry in
                let matchesSearch = entry.title.localizedCaseInsensitiveContains(searchText) ||
                                   entry.description.localizedCaseInsensitiveContains(searchText)
                
                let matchesPeriod: Bool
                let calendar = Calendar.current
                let now = Date()
                
                switch selectedPeriod {
                case .today:
                    matchesPeriod = calendar.isDate(entry.date, inSameDayAs: now)
                case .week:
                    let weekAgo = calendar.date(byAdding: .day, value: -6, to: now) ?? now
                    matchesPeriod = entry.date >= calendar.startOfDay(for: weekAgo)
                case .month:
                    let monthAgo = calendar.date(byAdding: .day, value: -30, to: now) ?? now
                    matchesPeriod = entry.date >= calendar.startOfDay(for: monthAgo)
                case .all:
                    matchesPeriod = true
                }
                
                return matchesSearch && matchesPeriod
            }
        }
    }
}

struct HistoryEntryCardView: View {
    let entry: WonderEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(entry.title)
                    .font(.appSubheadline)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Text(entry.displayDate)
                    .font(.appSmall)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            if !entry.description.isEmpty {
                Text(entry.shortDescription)
                    .font(.appCaption)
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

