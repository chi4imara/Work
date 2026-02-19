import SwiftUI

struct QuotesCollectionView: View {
    @ObservedObject var quoteManager: QuoteManager
    @Binding var selectedTab: TabItem
    @State private var showingAddQuote = false
    @State private var showingFilters = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Gradients.primaryBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    searchBarView
                    
                    if quoteManager.filteredQuotes.isEmpty {
                        emptyStateView
                    } else {
                        quotesListView
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddQuote) {
            AddQuoteView()
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("My Quotes")
                .font(.playfairDisplay(AppTheme.Typography.largeTitle, weight: .bold))
                .foregroundColor(AppTheme.Colors.primaryText)
            
            Spacer()
            
            HStack(spacing: AppTheme.Spacing.md) {
                Button(action: {
                    withAnimation {
                        selectedTab = .filters
                    }
                }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.system(size: 24))
                        .foregroundColor(AppTheme.Colors.accent)
                }
                
                Button(action: { showingAddQuote = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(AppTheme.Colors.accent)
                }
            }
        }
        .padding(.horizontal, AppTheme.Spacing.lg)
        .padding(.top, AppTheme.Spacing.md)
    }
    
    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppTheme.Colors.placeholderText)
            
            TextField("Search by words or author", text: $quoteManager.searchText)
                .font(.playfairDisplay(AppTheme.Typography.body))
                .foregroundColor(AppTheme.Colors.primaryText)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !quoteManager.searchText.isEmpty {
                Button(action: { quoteManager.searchText = "" }) {
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
    
    private var emptyStateView: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Image(systemName: "quote.bubble")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppTheme.Colors.accent.opacity(0.6))
            
            Text(quoteManager.quotes.isEmpty ? 
                 "Your collection is empty. Add your first inspiring quote." :
                 "No quotes match your search criteria.")
                .font(.playfairDisplay(AppTheme.Typography.title3, weight: .medium))
                .foregroundColor(AppTheme.Colors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppTheme.Spacing.xl)
            
            if quoteManager.quotes.isEmpty {
                Button {
                    showingAddQuote = true
                } label: {
                    Text("Add Your First Quote")
                        .primaryButton()
                }
                .padding(.top, AppTheme.Spacing.md)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 20)
    }
    
    private var quotesListView: some View {
        ScrollView {
            LazyVStack(spacing: AppTheme.Spacing.md) {
                ForEach(quoteManager.filteredQuotes) { quote in
                    NavigationLink(destination: QuoteDetailView(quoteId: quote.id)) {
                        QuoteCardView(quote: quote)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.bottom, 120)
        }
    }
}

struct QuoteCardView: View {
    let quote: Quote
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text(quote.text)
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
}

