import SwiftUI

struct SearchView: View {
    @ObservedObject var quoteManager: QuoteManager
    @State private var searchText = ""
    
    private var searchResults: [Quote] {
        if searchText.isEmpty {
            return []
        }
        
        let lowercaseQuery = searchText.lowercased()
        return quoteManager.quotes.filter { quote in
            quote.text.lowercased().contains(lowercaseQuery) ||
            quote.author.lowercased().contains(lowercaseQuery) ||
            quote.source.lowercased().contains(lowercaseQuery) ||
            quote.comment.lowercased().contains(lowercaseQuery) ||
            quote.theme.displayName.lowercased().contains(lowercaseQuery)
        }
        .sorted { $0.dateModified > $1.dateModified }
    }
    
    var body: some View {
        ZStack {
            AppTheme.Gradients.primaryBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                searchBarView
                
                if searchText.isEmpty {
                    emptySearchView
                } else if searchResults.isEmpty {
                    noResultsView
                } else {
                    searchResultsView
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Search Quotes")
                .font(.playfairDisplay(AppTheme.Typography.largeTitle, weight: .bold))
                .foregroundColor(AppTheme.Colors.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, AppTheme.Spacing.lg)
        .padding(.top, AppTheme.Spacing.md)
        .padding(.bottom, AppTheme.Spacing.sm)
    }
    
    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppTheme.Colors.placeholderText)
            
            TextField("Search by words, author, or source", text: $searchText)
                .font(.playfairDisplay(AppTheme.Typography.body))
                .foregroundColor(AppTheme.Colors.primaryText)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !searchText.isEmpty {
                Button(action: { 
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppTheme.Colors.placeholderText)
                }
            }
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.vertical, AppTheme.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(AppTheme.Colors.cardBackground.opacity(0.6))
        )
        .padding(.horizontal, AppTheme.Spacing.lg)
        .padding(.vertical, AppTheme.Spacing.md)
    }
    
    private var emptySearchView: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppTheme.Colors.accent.opacity(0.6))
            
            VStack(spacing: AppTheme.Spacing.sm) {
                Text("Search Your Quotes")
                    .font(.playfairDisplay(AppTheme.Typography.title2, weight: .semiBold))
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Text("Find quotes by text, author, source, or theme")
                    .font(.playfairDisplay(AppTheme.Typography.body, weight: .regular))
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            if !quoteManager.quotes.isEmpty {
                VStack(spacing: AppTheme.Spacing.sm) {
                    Text("Popular Authors")
                        .font(.playfairDisplay(AppTheme.Typography.subheadline, weight: .semiBold))
                        .foregroundColor(AppTheme.Colors.secondaryText)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: AppTheme.Spacing.sm) {
                        ForEach(popularAuthors, id: \.self) { author in
                            Button {
                                searchText = author
                            } label: {
                                Text(author)
                                    .font(.playfairDisplay(AppTheme.Typography.caption1, weight: .medium))
                                    .foregroundColor(AppTheme.Colors.accent)
                                    .padding(.horizontal, AppTheme.Spacing.sm)
                                    .padding(.vertical, AppTheme.Spacing.xs)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small)
                                            .fill(AppTheme.Colors.accent.opacity(0.1))
                                    )
                            }
                        }
                    }
                }
                .padding(.top, AppTheme.Spacing.lg)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, AppTheme.Spacing.xl)
    }
    
    private var noResultsView: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Image(systemName: "exclamationmark.magnifyingglass")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppTheme.Colors.accent.opacity(0.6))
            
            Text("No quotes found for \"\(searchText)\"")
                .font(.playfairDisplay(AppTheme.Typography.title3, weight: .medium))
                .foregroundColor(AppTheme.Colors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppTheme.Spacing.xl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var searchResultsView: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("\(searchResults.count) \(searchResults.count == 1 ? "result" : "results") found")
                .font(.playfairDisplay(AppTheme.Typography.subheadline, weight: .medium))
                .foregroundColor(AppTheme.Colors.secondaryText)
                .padding(.horizontal, AppTheme.Spacing.lg)
            
            ScrollView {
                LazyVStack(spacing: AppTheme.Spacing.md) {
                    ForEach(searchResults) { quote in
                        NavigationLink(destination: QuoteDetailView(quoteId: quote.id)) {
                            SearchResultCardView(quote: quote, searchText: searchText)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.lg)
                .padding(.bottom, 120)
            }
        }
    }
    
    private var popularAuthors: [String] {
        let authors = quoteManager.quotes
            .compactMap { $0.author.isEmpty ? nil : $0.author }
            .reduce(into: [String: Int]()) { counts, author in
                counts[author, default: 0] += 1
            }
        
        return Array(authors.keys)
            .sorted { authors[$0]! > authors[$1]! }
            .prefix(6)
            .map { $0 }
    }
}

struct SearchResultCardView: View {
    let quote: Quote
    let searchText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text(highlightedText(quote.text, searchText: searchText))
                .font(.playfairDisplay(AppTheme.Typography.body, weight: .regular))
                .foregroundColor(AppTheme.Colors.primaryText)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
            
            HStack {
                if !quote.author.isEmpty {
                    Text("— \(quote.author)")
                        .font(.playfairDisplay(AppTheme.Typography.subheadline, weight: .medium))
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .italic()
                }
                
                Spacer()
                
                HStack(spacing: AppTheme.Spacing.xs) {
                    Image(systemName: quote.theme.icon)
                        .font(.system(size: 12))
                    Text(quote.theme.displayName)
                        .font(.playfairDisplay(AppTheme.Typography.caption1, weight: .medium))
                }
                .foregroundColor(AppTheme.Colors.accent)
                .padding(.horizontal, AppTheme.Spacing.sm)
                .padding(.vertical, AppTheme.Spacing.xs)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small)
                        .fill(AppTheme.Colors.accent.opacity(0.1))
                )
            }
        }
        .padding(AppTheme.Spacing.md)
        .cardBackground()
    }
    
    private func highlightedText(_ text: String, searchText: String) -> AttributedString {
        var attributedString = AttributedString(text)
        
        if !searchText.isEmpty {
            let range = text.lowercased().range(of: searchText.lowercased())
            if let range = range {
                let nsRange = NSRange(range, in: text)
                if let attributedRange = Range(nsRange, in: attributedString) {
                    attributedString[attributedRange].backgroundColor = AppTheme.Colors.accent.opacity(0.3)
                }
            }
        }
        
        return attributedString
    }
}

