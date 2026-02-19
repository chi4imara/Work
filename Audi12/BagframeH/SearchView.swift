import SwiftUI

struct SearchView: View {
    @EnvironmentObject var bagViewModel: BagViewModel
    @State private var searchText = ""
    @State private var selectedFilter: SearchFilter = .all
    
    var filteredBags: [Bag] {
        var bags = bagViewModel.bags
        
        if !searchText.isEmpty {
            bags = bags.filter { bag in
                bag.name.localizedCaseInsensitiveContains(searchText) ||
                bag.description.localizedCaseInsensitiveContains(searchText) ||
                bag.items.contains { $0.name.localizedCaseInsensitiveContains(searchText) }
            }
        }
        
        switch selectedFilter {
        case .all:
            return bags
        case .bags:
            return bags.filter { $0.type == .bag }
        case .backpacks:
            return bags.filter { $0.type == .backpack }
        case .withItems:
            return bags.filter { !$0.items.isEmpty }
        case .empty:
            return bags.filter { $0.items.isEmpty }
        }
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Search")
                        .font(.bellGothic(size: 28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                SearchBar(searchText: $searchText)
                    .padding()
                
                FilterBar(selectedFilter: $selectedFilter)
                    .padding(.horizontal)
                
                if filteredBags.isEmpty {
                    EmptySearchView(searchText: searchText)
                    
                    Spacer()
                } else {
                    SearchResultsView(bags: filteredBags)
                }
            }
        }
    }
}

struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.secondaryText)
            
            TextField("Search bags, items...", text: $searchText)
                .font(.bellGothic(size: 16))
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
        .padding()
        .background(AppColors.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
        .cornerRadius(12)
    }
}

struct FilterBar: View {
    @Binding var selectedFilter: SearchFilter
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(SearchFilter.allCases, id: \.self) { filter in
                    FilterChip(
                        title: filter.title,
                        isSelected: selectedFilter == filter,
                        action: { selectedFilter = filter }
                    )
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
        }
        .padding(.horizontal, -20)
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.bellGothic(size: 14, weight: isSelected ? .bold : .regular))
                .foregroundColor(isSelected ? AppColors.buttonText : AppColors.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? AppColors.buttonPrimary : AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? AppColors.yellow : AppColors.cardBorder, lineWidth: 1)
                )
                .cornerRadius(20)
        }
    }
}

struct SearchResultsView: View {
    @EnvironmentObject var bagViewModel: BagViewModel
    let bags: [Bag]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(bags) { bag in
                    NavigationLink(destination: BagDetailView(bagId: bag.id).environmentObject(bagViewModel)) {
                        SearchResultCard(bag: bag)
                            .environmentObject(bagViewModel)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
    }
}

struct SearchResultCard: View {
    @EnvironmentObject var bagViewModel: BagViewModel
    let bag: Bag
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: bag.type.icon)
                    .font(.title2)
                    .foregroundColor(AppColors.yellow)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(bag.name.isEmpty ? "Unnamed Bag" : bag.name)
                        .font(.bellGothic(size: 18, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(bag.type.displayName)
                        .font(.bellGothic(size: 14))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    Button(action: {
                        bagViewModel.toggleFavorite(bagId: bag.id)
                    }) {
                        Image(systemName: bagViewModel.isFavorite(bagId: bag.id) ? "heart.fill" : "heart")
                            .font(.system(size: 16))
                            .foregroundColor(bagViewModel.isFavorite(bagId: bag.id) ? AppColors.error : AppColors.secondaryText)
                    }
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("\(bag.items.count)")
                            .font(.bellGothic(size: 16, weight: .bold))
                            .foregroundColor(AppColors.yellow)
                        
                        Text("items")
                            .font(.bellGothic(size: 12))
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
            }
            
            if !bag.description.isEmpty {
                Text(bag.description)
                    .font(.bellGothic(size: 14))
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(2)
            }
        }
        .padding()
        .background(AppColors.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
        .cornerRadius(12)
    }
}

struct EmptySearchView: View {
    let searchText: String
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(AppColors.yellow.opacity(0.6))
            
            VStack(spacing: 12) {
                Text(searchText.isEmpty ? "Start searching" : "No results found")
                    .font(.bellGothic(size: 20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text(searchText.isEmpty ? "Search for bags, items, or descriptions" : "Try different keywords or filters")
                    .font(.bellGothic(size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding()
    }
}

enum SearchFilter: String, CaseIterable {
    case all = "All"
    case bags = "Bags"
    case backpacks = "Backpacks"
    case withItems = "With Items"
    case empty = "Empty"
    
    var title: String {
        return self.rawValue
    }
}

#Preview {
    SearchView()
        .environmentObject(BagViewModel())
}
