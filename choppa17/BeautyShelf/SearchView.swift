import SwiftUI

struct SearchView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject private var searchViewModel = ProductsListViewModel()
    @State private var showingFilters = false
    
    var searchResults: [Product] {
        searchViewModel.filteredProducts(from: appViewModel.allProducts)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        Text("Search")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            HStack {
                                SearchBarView(
                                    searchText: $searchViewModel.searchText,
                                    placeholder: "Search products, brands, categories..."
                                )
                                
                                Button(action: {
                                    showingFilters = true
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(AppColors.secondaryButtonBackground)
                                            .frame(width: 44, height: 44)
                                        
                                        Image(systemName: "slider.horizontal.3")
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundColor(AppColors.primaryText)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 8)
                            
                            if !searchViewModel.searchText.isEmpty {
                                QuickFiltersView(searchViewModel: searchViewModel)
                            }
                        }
                    }
                    .padding(.top, 10)
                    
                    if searchViewModel.searchText.isEmpty {
                        SearchEmptyState()
                    } else if searchResults.isEmpty {
                        SearchNoResults(searchText: searchViewModel.searchText)
                    } else {
                        SearchResultsList(
                            products: searchResults,
                            searchText: searchViewModel.searchText
                        )
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingFilters) {
            SearchFiltersSheet(searchViewModel: searchViewModel)
        }
    }
}

struct SearchEmptyState: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "magnifyingglass.circle")
                    .font(.system(size: 60))
                    .foregroundColor(AppColors.primaryYellow)
                
                VStack(spacing: 12) {
                    Text("Start Searching")
                        .font(.ubuntu(22, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Search for products by name, brand, category, or even notes to quickly find what you're looking for.")
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Try searching for:")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                VStack(alignment: .leading, spacing: 8) {
                    SearchSuggestion(text: "Lipstick")
                    SearchSuggestion(text: "Dior")
                    SearchSuggestion(text: "Foundation")
                    SearchSuggestion(text: "Expired products")
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding(.bottom, 70)
    }
}

struct SearchSuggestion: View {
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 12))
                .foregroundColor(AppColors.secondaryText)
            
            Text(text)
                .font(.ubuntu(14, weight: .regular))
                .foregroundColor(AppColors.secondaryText)
            
            Spacer()
        }
    }
}

struct SearchNoResults: View {
    let searchText: String
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "questionmark.circle")
                .font(.system(size: 50))
                .foregroundColor(AppColors.primaryYellow)
            
            VStack(spacing: 8) {
                Text("No results for \"\(searchText)\"")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Try different keywords or check your spelling")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct QuickFiltersView: View {
    @ObservedObject var searchViewModel: ProductsListViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                QuickFilterChip(
                    title: "All",
                    isSelected: searchViewModel.selectedFilter == .all,
                    action: { searchViewModel.selectedFilter = .all }
                )
                
                QuickFilterChip(
                    title: "By Category",
                    isSelected: searchViewModel.selectedFilter == .category,
                    action: { searchViewModel.selectedFilter = .category }
                )
                
                QuickFilterChip(
                    title: "Expiring Soon",
                    isSelected: searchViewModel.selectedFilter == .expiration,
                    action: { searchViewModel.selectedFilter = .expiration }
                )
                
                QuickFilterChip(
                    title: "By Brand",
                    isSelected: searchViewModel.selectedFilter == .brand,
                    action: { searchViewModel.selectedFilter = .brand }
                )
            }
            .padding(.horizontal, 20)
        }
    }
}

struct QuickFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.ubuntu(12, weight: .medium))
                .foregroundColor(isSelected ? AppColors.darkText : AppColors.primaryText)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? AppColors.primaryYellow : AppColors.secondaryButtonBackground)
                .cornerRadius(16)
        }
    }
}

struct SearchResultsList: View {
    let products: [Product]
    let searchText: String
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("\(products.count) result\(products.count == 1 ? "" : "s")")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(products) { product in
                        NavigationLink(destination: ProductDetailView(product: product)) {
                            SearchResultCard(
                                product: product,
                                storageLocation: appViewModel.getStorageLocation(for: product.id),
                                searchText: searchText
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 120)
            }
        }
    }
}

struct SearchResultCard: View {
    let product: Product
    let storageLocation: StorageLocation?
    let searchText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(highlightedText(product.name, searchText: searchText))
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(AppColors.darkText)
                        .lineLimit(2)
                    
                    HStack {
                        Text(product.category.displayName)
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(AppColors.accentPurple)
                        
                        Text("•")
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(AppColors.darkText.opacity(0.5))
                        
                        Text(highlightedText(product.brand, searchText: searchText))
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(AppColors.darkText.opacity(0.7))
                    }
                }
                
                Spacer()
                
                VStack {
                    if product.isExpiringSoon {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(AppColors.warningRed)
                            .font(.system(size: 16))
                    }
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.darkText.opacity(0.5))
                }
            }
            
            if let location = storageLocation {
                HStack {
                    Image(systemName: location.icon)
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.accentPurple.opacity(0.7))
                    
                    Text("In: \(location.name)")
                        .font(.ubuntu(12, weight: .regular))
                        .foregroundColor(AppColors.darkText.opacity(0.6))
                    
                    Spacer()
                }
            }
            
            if !product.notes.isEmpty && product.notes.localizedCaseInsensitiveContains(searchText) {
                Text("Notes: \(product.notes)")
                    .font(.ubuntu(12, weight: .regular))
                    .foregroundColor(AppColors.darkText.opacity(0.6))
                    .lineLimit(2)
                    .padding(.top, 4)
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private func highlightedText(_ text: String, searchText: String) -> AttributedString {
        var attributedString = AttributedString(text)
        
        if !searchText.isEmpty {
            let range = text.range(of: searchText, options: .caseInsensitive)
            if let range = range {
                let nsRange = NSRange(range, in: text)
                if let attributedRange = Range(nsRange, in: attributedString) {
                    attributedString[attributedRange].backgroundColor = AppColors.primaryYellow.opacity(0.3)
                }
            }
        }
        
        return attributedString
    }
}

struct SearchFiltersSheet: View {
    @ObservedObject var searchViewModel: ProductsListViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 24) {
                    Text("Search Filters")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                        .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Sort by")
                                .font(.ubuntu(18, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            VStack(spacing: 8) {
                                ForEach(ProductFilter.allCases, id: \.self) { filter in
                                    FilterOptionRow(
                                        title: filter.rawValue,
                                        isSelected: searchViewModel.selectedFilter == filter,
                                        action: {
                                            searchViewModel.selectedFilter = filter
                                        }
                                    )
                                }
                            }
                        }
                        
                        if searchViewModel.selectedFilter == .category {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Category")
                                    .font(.ubuntu(18, weight: .bold))
                                    .foregroundColor(AppColors.primaryText)
                                
                                ScrollView {
                                    VStack(spacing: 8) {
                                        FilterOptionRow(
                                            title: "All Categories",
                                            isSelected: searchViewModel.selectedCategory == nil,
                                            action: {
                                                searchViewModel.selectedCategory = nil
                                            }
                                        )
                                        
                                        ForEach(ProductCategory.allCases, id: \.self) { category in
                                            FilterOptionRow(
                                                title: category.displayName,
                                                isSelected: searchViewModel.selectedCategory == category,
                                                action: {
                                                    searchViewModel.selectedCategory = category
                                                }
                                            )
                                        }
                                    }
                                }
                                .frame(maxHeight: 200)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Apply Filters")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(AppColors.buttonText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(AppColors.buttonBackground)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                }
            }
        }
    }
}

struct FilterOptionRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.darkText)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(AppColors.primaryYellow)
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(AppColors.darkText.opacity(0.3))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SearchView()
        .environmentObject(AppViewModel())
}
