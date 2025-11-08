import SwiftUI

struct FeedView: View {
    @ObservedObject var quoteStore: QuoteStore
    @State private var showingAddQuote = false
    @State private var showingFilters = false
    @State private var showingSortOptions = false
    @State private var selectedQuotes: Set<Quote> = []
    @State private var isSelectionMode = false
    @State private var showingDeleteAlert = false
    @State private var quoteToDelete: Quote?
    @State private var selectedQuoteForDetail: Quote?
    @State private var selectedQuoteForEdit: Quote?
    
    var body: some View {
            ZStack {
                Color.clear
                    .backgroundGradient()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if quoteStore.activeQuotes.isEmpty {
                        emptyStateView
                    } else {
                        quotesListView
                    }
                    
                    if isSelectionMode {
                        selectionToolbar
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddQuote) {
                AddEditQuoteView(quoteStore: quoteStore)
            }
            .sheet(isPresented: $showingFilters) {
                FiltersView(quoteStore: quoteStore)
            }
            .sheet(item: $selectedQuoteForEdit) { quote in
                AddEditQuoteView(quoteStore: quoteStore, editingQuote: quote)
            }
            .sheet(item: $selectedQuoteForDetail) { quote in
                NavigationView {
                    QuoteDetailView(quoteStore: quoteStore, quote: quote)
                }
            }
            .actionSheet(isPresented: $showingSortOptions) {
                sortActionSheet
            }
            .alert("Delete Quote", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    if let quote = quoteToDelete {
                        quoteStore.deleteQuote(quote)
                        quoteToDelete = nil
                    }
                }
                Button("Cancel", role: .cancel) {
                    quoteToDelete = nil
                }
            } message: {
                Text("Are you sure you want to delete this quote? This action cannot be undone.")
            }
    }
    
    private var headerView: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            HStack {
                Text("My Quotes")
                    .font(FontManager.poppinsBold(size: 28))
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Spacer()
                
                HStack(spacing: DesignSystem.Spacing.sm) {
                    Button(action: { showingAddQuote = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                            .background(DesignSystem.Colors.primaryBlue)
                            .clipShape(Circle())
                    }
                    
                    Menu {
                        Button("Filters") {
                            showingFilters = true
                        }
                        Button("Sort") {
                            showingSortOptions = true
                        }
                        if quoteStore.hasActiveFilters() {
                            Button("Clear Filters") {
                                quoteStore.clearFilters()
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                            .frame(width: 36, height: 36)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: DesignSystem.Shadow.light, radius: 4)
                    }
                }
            }
            
            SearchBar(text: $quoteStore.searchText)
        }
        .padding(.horizontal, DesignSystem.Spacing.lg)
        .padding(.vertical, DesignSystem.Spacing.md)
    }
    
    private var quotesListView: some View {
        ScrollView {
            LazyVStack(spacing: DesignSystem.Spacing.md) {
                ForEach(quoteStore.activeQuotes) { quote in
                    QuoteCard(
                        quote: quote,
                        isSelected: selectedQuotes.contains(quote),
                        isSelectionMode: isSelectionMode,
                        onTap: {
                            if isSelectionMode {
                                toggleSelection(quote)
                            } else {
                                selectedQuoteForDetail = quote
                            }
                        },
                        onEdit: {
                            selectedQuoteForEdit = quote
                        },
                        onDelete: {
                            quoteToDelete = quote
                            showingDeleteAlert = true
                        },
                        onLongPress: {
                            if !isSelectionMode {
                                isSelectionMode = true
                                selectedQuotes.insert(quote)
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.bottom, DesignSystem.Spacing.xxl)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: DesignSystem.Spacing.xl) {
            Spacer()
            
            Image(systemName: "lightbulb")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(DesignSystem.Colors.lightBlue)
            
            VStack(spacing: DesignSystem.Spacing.md) {
                Text("No saved quotes yet")
                    .font(FontManager.poppinsSemiBold(size: 20))
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Text("Start building your collection of inspiring quotes and thoughts")
                    .font(FontManager.poppinsRegular(size: 16))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button("Add First Quote") {
                showingAddQuote = true
            }
            .primaryButtonStyle()
            
            Spacer()
        }
        .padding(.horizontal, DesignSystem.Spacing.lg)
    }
    
    private var selectionToolbar: some View {
        HStack {
            Button("Cancel") {
                isSelectionMode = false
                selectedQuotes.removeAll()
            }
            .foregroundColor(DesignSystem.Colors.textSecondary)
            
            Spacer()
            
            Text("\(selectedQuotes.count) selected")
                .font(FontManager.poppinsRegular(size: 14))
                .foregroundColor(DesignSystem.Colors.textSecondary)
            
            Spacer()
            
            HStack(spacing: DesignSystem.Spacing.lg) {
                Button("Archive") {
                    quoteStore.archiveQuotes(Array(selectedQuotes))
                    isSelectionMode = false
                    selectedQuotes.removeAll()
                }
                .foregroundColor(DesignSystem.Colors.primaryBlue)
                
                Button("Delete") {
                    quoteStore.deleteQuotes(Array(selectedQuotes))
                    isSelectionMode = false
                    selectedQuotes.removeAll()
                }
                .foregroundColor(DesignSystem.Colors.error)
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.lg)
        .padding(.vertical, DesignSystem.Spacing.md)
        .background(Color.white)
        .shadow(color: DesignSystem.Shadow.light, radius: 8, y: -2)
    }
    
    private var sortActionSheet: ActionSheet {
        ActionSheet(
            title: Text("Sort by"),
            buttons: SortOption.allCases.map { option in
                .default(Text(option.rawValue)) {
                    quoteStore.sortOption = option
                }
            } + [.cancel()]
        )
    }
    
    private func toggleSelection(_ quote: Quote) {
        if selectedQuotes.contains(quote) {
            selectedQuotes.remove(quote)
        } else {
            selectedQuotes.insert(quote)
        }
        
        if selectedQuotes.isEmpty {
            isSelectionMode = false
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(DesignSystem.Colors.textSecondary)
            
            TextField("Search quotes and thoughts...", text: $text)
                .font(FontManager.poppinsRegular(size: 16))
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.md)
        .padding(.vertical, DesignSystem.Spacing.sm)
        .background(Color.white)
        .cornerRadius(DesignSystem.CornerRadius.md)
        .shadow(color: DesignSystem.Shadow.light, radius: 4)
    }
}

#Preview {
    FeedView(quoteStore: QuoteStore())
}
