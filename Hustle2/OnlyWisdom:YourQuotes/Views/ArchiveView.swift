import SwiftUI

struct ArchiveView: View {
    @ObservedObject var quoteStore: QuoteStore
    @State private var showingFilters = false
    @State private var showingSortOptions = false
    @State private var selectedQuotes: Set<Quote> = []
    @State private var isSelectionMode = false
    @State private var showingDeleteAlert = false
    @State private var quoteToDelete: Quote?
    @State private var selectedQuoteForDetail: Quote?
    
    var body: some View {
            ZStack {
                Color.clear
                    .backgroundGradient()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if quoteStore.archivedQuotes.isEmpty {
                        emptyStateView
                    } else {
                        archiveListView
                    }
                    
                    if isSelectionMode {
                        selectionToolbar
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingFilters) {
                ArchiveFiltersView(quoteStore: quoteStore)
            }
            .actionSheet(isPresented: $showingSortOptions) {
                sortActionSheet
            }
            .sheet(item: $selectedQuoteForDetail) { quote in
                NavigationView {
                    QuoteDetailView(quoteStore: quoteStore, quote: quote)
                }
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
                Text("Are you sure you want to permanently delete this quote? This action cannot be undone.")
            }
    }
    
    private var headerView: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            HStack {
                Text("Archive")
                    .font(FontManager.poppinsBold(size: 28))
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Spacer()
                
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
            
            SearchBar(text: $quoteStore.searchText)
        }
        .padding(.horizontal, DesignSystem.Spacing.lg)
        .padding(.vertical, DesignSystem.Spacing.md)
    }
    
    private var archiveListView: some View {
        ScrollView {
            LazyVStack(spacing: DesignSystem.Spacing.md) {
                ForEach(quoteStore.archivedQuotes) { quote in
                    ArchiveQuoteCard(
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
                        onUnarchive: {
                            quoteStore.unarchiveQuote(quote)
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
            
            Image(systemName: "archivebox")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(DesignSystem.Colors.lightBlue)
            
            VStack(spacing: DesignSystem.Spacing.md) {
                Text("Archive is empty")
                    .font(FontManager.poppinsSemiBold(size: 20))
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Text("Archived quotes will appear here. You can archive quotes from the main feed to keep them safe but out of your active collection.")
                    .font(FontManager.poppinsRegular(size: 16))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
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
                Button("Unarchive") {
                    quoteStore.unarchiveQuotes(Array(selectedQuotes))
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
            buttons: [
                .default(Text("Date Created")) {
                    quoteStore.sortOption = .dateCreated
                },
                .default(Text("Date Archived")) {
                    quoteStore.sortOption = .dateArchived
                },
                .default(Text("Alphabetical")) {
                    quoteStore.sortOption = .alphabetical
                },
                .default(Text("Category")) {
                    quoteStore.sortOption = .category
                },
                .cancel()
            ]
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

struct ArchiveQuoteCard: View {
    let quote: Quote
    let isSelected: Bool
    let isSelectionMode: Bool
    let onTap: () -> Void
    let onUnarchive: () -> Void
    let onDelete: () -> Void
    let onLongPress: () -> Void
    
    @State private var dragOffset: CGSize = .zero
    @State private var showingUnarchiveButton = false
    @State private var showingDeleteButton = false
    
    var body: some View {
        ZStack {
            HStack {
                if showingUnarchiveButton {
                    Button(action: onUnarchive) {
                        VStack(spacing: DesignSystem.Spacing.xs) {
                            Image(systemName: "tray.and.arrow.up")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Unarchive")
                                .font(FontManager.poppinsRegular(size: 10))
                        }
                        .foregroundColor(.white)
                        .frame(width: 70, height: 60)
                        .background(DesignSystem.Colors.success)
                        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md))
                    }
                    .transition(.scale.combined(with: .opacity))
                }
                
                Spacer()
                
                if showingDeleteButton {
                    Button(action: onDelete) {
                        VStack(spacing: DesignSystem.Spacing.xs) {
                            Image(systemName: "trash")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Delete")
                                .font(FontManager.poppinsRegular(size: 10))
                        }
                        .foregroundColor(.white)
                        .frame(width: 70, height: 60)
                        .background(DesignSystem.Colors.error)
                        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md))
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            
            cardContent
                .onTapGesture {
                    onTap()
                }
        }
    }
    
    private var cardContent: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text(quote.title)
                        .font(FontManager.poppinsSemiBold(size: 18))
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                        .lineLimit(2)
                    
                    HStack(spacing: DesignSystem.Spacing.sm) {
                        HStack(spacing: DesignSystem.Spacing.xs) {
                            Image(systemName: quote.type.icon)
                                .font(.system(size: 12, weight: .medium))
                            Text(quote.type.displayName)
                                .font(FontManager.poppinsRegular(size: 12))
                        }
                        .foregroundColor(DesignSystem.Colors.primaryBlue)
                        .padding(.horizontal, DesignSystem.Spacing.sm)
                        .padding(.vertical, DesignSystem.Spacing.xs)
                        .background(DesignSystem.Colors.lightBlue.opacity(0.2))
                        .cornerRadius(DesignSystem.CornerRadius.sm)
                        
                        if let category = quote.category {
                            Text(category)
                                .font(FontManager.poppinsRegular(size: 12))
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                                .padding(.horizontal, DesignSystem.Spacing.sm)
                                .padding(.vertical, DesignSystem.Spacing.xs)
                                .background(DesignSystem.Colors.backgroundSecondary)
                                .cornerRadius(DesignSystem.CornerRadius.sm)
                        }
                        
                        HStack(spacing: DesignSystem.Spacing.xs) {
                            Image(systemName: "archivebox")
                                .font(.system(size: 12, weight: .medium))
                            Text("Archived")
                                .font(FontManager.poppinsRegular(size: 12))
                        }
                        .foregroundColor(DesignSystem.Colors.warning)
                        .padding(.horizontal, DesignSystem.Spacing.sm)
                        .padding(.vertical, DesignSystem.Spacing.xs)
                        .background(DesignSystem.Colors.warning.opacity(0.1))
                        .cornerRadius(DesignSystem.CornerRadius.sm)
                        
                        Spacer()
                    }
                }
                
                Spacer()
                
                if isSelectionMode {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(isSelected ? DesignSystem.Colors.primaryBlue : DesignSystem.Colors.textSecondary)
                }
            }
            
            Text(quote.preview)
                .font(FontManager.poppinsRegular(size: 14))
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
            
            HStack {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text("Created: \(formatDate(quote.dateCreated))")
                        .font(FontManager.poppinsLight(size: 12))
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                    
                    if let archivedDate = quote.dateArchived {
                        Text("Archived: \(formatDate(archivedDate))")
                            .font(FontManager.poppinsLight(size: 12))
                            .foregroundColor(DesignSystem.Colors.warning)
                    }
                }
                
                Spacer()
                
                if quote.type == .quote && quote.source != nil {
                    Text("• \(quote.source!)")
                        .font(FontManager.poppinsLight(size: 12))
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                        .lineLimit(1)
                }
            }
        }
        .padding(DesignSystem.Spacing.lg)
        .cardStyle()
        .scaleEffect(isSelected ? 0.98 : 1.0)
        .animation(DesignSystem.Animation.quick, value: isSelected)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct ArchiveFiltersView: View {
    @ObservedObject var quoteStore: QuoteStore
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            FiltersView(quoteStore: quoteStore)
                .navigationBarItems(
                    leading: Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    },
                    trailing: Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
        }
    }
}

#Preview {
    ArchiveView(quoteStore: QuoteStore())
}
