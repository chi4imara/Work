import SwiftUI

struct SearchView: View {
    @EnvironmentObject var viewModel: ItemsViewModel
    @State private var isSearching = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                searchBarView
                
                contentView
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Search")
                .font(.playfairDisplay(32, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchBarView: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(ColorTheme.textSecondary)
                
                TextField("Search items...", text: $viewModel.searchText)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(ColorTheme.textPrimary)
                    .onTapGesture {
                        isSearching = true
                    }
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                        isSearching = false
                        hideKeyboard()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(ColorTheme.textSecondary)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorTheme.backgroundWhite)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(ColorTheme.lightBlue, lineWidth: 1)
                    }
            )
            
            if isSearching {
                Button("Cancel") {
                    viewModel.searchText = ""
                    isSearching = false
                    hideKeyboard()
                }
                .font(.playfairDisplay(16, weight: .medium))
                .foregroundColor(ColorTheme.primaryBlue)
                .transition(.move(edge: .trailing))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .animation(.easeInOut(duration: 0.3), value: isSearching)
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.searchText.isEmpty {
            emptySearchView
        } else if viewModel.filteredItems.isEmpty {
            noResultsView
        } else {
            searchResultsView
        }
    }
    
    private var emptySearchView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "magnifyingglass.circle")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorTheme.primaryBlue.opacity(0.6))
            
            Text("Enter a word or phrase to search")
                .font(.playfairDisplay(18, weight: .medium))
                .foregroundColor(ColorTheme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var noResultsView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "exclamationmark.magnifyingglass")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorTheme.primaryBlue.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No matches found")
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(ColorTheme.textPrimary)
                
                Text("Try searching with different keywords")
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(ColorTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var searchResultsView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredItems) { item in
                    NavigationLink(destination: ItemDetailView(itemId: item.id)) {
                        SearchResultRowView(item: item, searchText: viewModel.searchText)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
}

struct SearchResultRowView: View {
    let item: Item
    let searchText: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(ColorTheme.lightBlue)
                    .frame(width: 50, height: 50)
                
                Image(systemName: item.category.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(ColorTheme.primaryBlue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(highlightedText(item.name, searchText: searchText))
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(ColorTheme.textPrimary)
                    .lineLimit(1)
                
                Text(item.category.displayName)
                    .font(.playfairDisplay(14, weight: .medium))
                    .foregroundColor(ColorTheme.textSecondary)
                
                if let matchingContent = getMatchingContent() {
                    Text(matchingContent)
                        .font(.playfairDisplay(12, weight: .regular))
                        .foregroundColor(ColorTheme.textSecondary.opacity(0.8))
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(ColorTheme.textSecondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
    
    private func highlightedText(_ text: String, searchText: String) -> AttributedString {
        var attributedString = AttributedString(text)
        
        if let range = text.range(of: searchText, options: .caseInsensitive) {
            let nsRange = NSRange(range, in: text)
            if let attributedRange = Range(nsRange, in: attributedString) {
                attributedString[attributedRange].backgroundColor = ColorTheme.primaryYellow.opacity(0.3)
            }
        }
        
        return attributedString
    }
    
    private func getMatchingContent() -> String? {
        let searchLower = searchText.lowercased()
        
        if item.characteristics.lowercased().contains(searchLower) && !item.characteristics.isEmpty {
            return "Characteristics: \(item.characteristics)"
        } else if item.notes.lowercased().contains(searchLower) && !item.notes.isEmpty {
            return "Notes: \(item.notes)"
        }
        
        return nil
    }
}

#Preview {
    SearchView()
}
