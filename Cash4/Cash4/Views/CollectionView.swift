import SwiftUI

struct CollectionView: View {
    @ObservedObject var viewModel: CollectionViewModel
    @State private var showingItemDetail = false
    @State private var selectedItem: CollectionItem?
    @State private var showingFilters = false
    @State private var showingMenu = false
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                searchAndFiltersView
                
                if viewModel.filteredItems.isEmpty {
                    emptyStateView
                } else {
                    itemsList
                }
            }
        }
        .sheet(isPresented: $showingItemDetail) {
            if let item = selectedItem {
                ItemDetailView(viewModel: viewModel, item: item, isPresented: $showingItemDetail)
            } else {
                ItemDetailView(viewModel: viewModel, item: CollectionItem(), isPresented: $showingItemDetail)
            }
        }
        .sheet(isPresented: $showingFilters) {
            FiltersView(viewModel: viewModel, isPresented: $showingFilters)
        }
        .actionSheet(isPresented: $showingMenu) {
            ActionSheet(
                title: Text("Menu"),
                buttons: [
                    .default(Text("Filters & Sort")) {
                        showingFilters = true
                    },
                    .destructive(Text("Clear All Data")) {
                        viewModel.clearAllData()
                    },
                    .cancel()
                ]
            )
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("My Collection")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: { showingMenu = true }) {
                Image(systemName: "ellipsis")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Circle().fill(Color.white.opacity(0.2)))
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchAndFiltersView: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white.opacity(0.7))
                
                TextField("Search items...", text: $viewModel.searchText)
                    .foregroundColor(.white)
                    .foregroundStyle(.white, Color.gray)
                    .accentColor(.white)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: { viewModel.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.2))
            )
            .padding(.horizontal, 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FilterChip(title: "All", isSelected: !viewModel.showOnlyWithValue && !viewModel.showDuplicatesOnly && !viewModel.showForTradeOnly && !viewModel.showNeedsVerification) {
                        viewModel.showOnlyWithValue = false
                        viewModel.showDuplicatesOnly = false
                        viewModel.showForTradeOnly = false
                        viewModel.showNeedsVerification = false
                    }
                    
                    FilterChip(title: "With Value", isSelected: viewModel.showOnlyWithValue) {
                        viewModel.showOnlyWithValue.toggle()
                    }
                    
                    FilterChip(title: "Duplicates", isSelected: viewModel.showDuplicatesOnly) {
                        viewModel.showDuplicatesOnly.toggle()
                    }
                    
                    FilterChip(title: "For Trade", isSelected: viewModel.showForTradeOnly) {
                        viewModel.showForTradeOnly.toggle()
                    }
                    
                    FilterChip(title: "Needs Check", isSelected: viewModel.showNeedsVerification) {
                        viewModel.showNeedsVerification.toggle()
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.vertical, 16)
    }
    
    private var itemsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredItems) { item in
                    CollectionItemCard(item: item) {
                        selectedItem = item
                        showingItemDetail = true
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "books.vertical")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.6))
            
            Text(viewModel.items.isEmpty ? "Here will be your collection" : "Nothing found")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text(viewModel.items.isEmpty ? "Start by adding your first item" : "Try adjusting your search or filters")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Button(action: {
                if !viewModel.items.isEmpty {
                    viewModel.searchText = ""
                    viewModel.showOnlyWithValue = false
                    viewModel.showDuplicatesOnly = false
                    viewModel.showForTradeOnly = false
                    viewModel.showNeedsVerification = false
                } else {
                    selectedItem = nil
                    showingItemDetail = true
                }
            }) {
                Text(viewModel.items.isEmpty ? "Add Item" : "Reset Filters")
                    .font(.headline)
                    .foregroundColor(.primaryBlue)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                    )
            }
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.callout)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .primaryBlue : .white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isSelected ? Color.white : Color.white.opacity(0.2))
                )
        }
    }
}

struct CollectionItemCard: View {
    let item: CollectionItem
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.cardText)
                            .multilineTextAlignment(.leading)
                        
                        if !item.series.isEmpty || item.year != nil {
                            Text("\(item.series)\(item.series.isEmpty ? "" : " • ")\(item.year.map(String.init) ?? "")")
                                .font(.callout)
                                .foregroundColor(.cardSecondaryText)
                        }
                    }
                    
                    Spacer()
                    
                    if let value = item.currentValue {
                        VStack(alignment: .trailing) {
                            Text("$\(String(format: "%.0f", value))")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.accentGreen)
                        }
                    }
                }
                
                HStack {
                    PropertyTag(text: item.condition, color: .accentOrange)
                    
                    if !item.manufacturer.isEmpty {
                        PropertyTag(text: item.manufacturer, color: .accentPurple)
                    }
                    
                    if !item.storageLocation.isEmpty {
                        PropertyTag(text: item.storageLocation, color: .lightBlue)
                    }
                    
                    Spacer()
                }
                
                if item.isDuplicate || item.hasValue || item.isForTrade {
                    HStack(spacing: 8) {
                        if item.isDuplicate {
                            Badge(text: "Duplicate", color: .accentOrange)
                        }
                        if item.hasValue {
                            Badge(text: "Valued", color: .accentGreen)
                        }
                        if item.isForTrade {
                            Badge(text: "For Trade", color: .accentPurple)
                        }
                        
                        Spacer()
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.cardGradient)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PropertyTag: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(0.2))
            )
    }
}

struct Badge: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(color)
            )
    }
}

#Preview {
    CollectionView(viewModel: CollectionViewModel())
}
