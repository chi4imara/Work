import SwiftUI

struct CategoriesView: View {
    @ObservedObject var quoteStore: QuoteStore
    @State private var showingNewCategoryAlert = false
    @State private var showingRenameCategoryAlert = false
    @State private var showingDeleteCategoryAlert = false
    @State private var newCategoryName = ""
    @State private var categoryToRename: Category?
    @State private var categoryToDelete: Category?
    @State private var showingMoveQuotesSheet = false
    @State private var selectedMoveToCategory: String = ""
    @State private var selectedCategoryForQuotes: String?
    
    var body: some View {
            ZStack {
                Color.clear
                    .backgroundGradient()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if quoteStore.categories.isEmpty {
                        emptyStateView
                    } else {
                        categoriesListView
                    }
                }
            }
            .navigationBarHidden(true)
            .alert("New Category", isPresented: $showingNewCategoryAlert) {
                TextField("Category name", text: $newCategoryName)
                Button("Create") {
                    createNewCategory()
                }
                Button("Cancel", role: .cancel) {
                    newCategoryName = ""
                }
            } message: {
                Text("Enter a name for the new category")
            }
            .alert("Rename Category", isPresented: $showingRenameCategoryAlert) {
                TextField("Category name", text: $newCategoryName)
                Button("Rename") {
                    renameCategory()
                }
                Button("Cancel", role: .cancel) {
                    newCategoryName = ""
                    categoryToRename = nil
                }
            } message: {
                Text("Enter a new name for this category")
            }
            .alert("Delete Category", isPresented: $showingDeleteCategoryAlert) {
                Button("Delete", role: .destructive) {
                    if let category = categoryToDelete {
                        let quotesCount = quoteStore.quotesCount(for: category)
                        if quotesCount > 0 {
                            showingMoveQuotesSheet = true
                        } else {
                            quoteStore.deleteCategory(category)
                            categoryToDelete = nil
                        }
                    }
                }
                Button("Cancel", role: .cancel) {
                    categoryToDelete = nil
                }
            } message: {
                if let category = categoryToDelete {
                    let quotesCount = quoteStore.quotesCount(for: category)
                    if quotesCount > 0 {
                        Text("This category contains \(quotesCount) quote(s). You'll be able to move them to another category or leave them uncategorized.")
                    } else {
                        Text("Are you sure you want to delete this category?")
                    }
                }
            }
            .actionSheet(isPresented: $showingMoveQuotesSheet) {
                moveQuotesActionSheet
            }
            .sheet(item: Binding<CategoryWrapper?>(
                get: { selectedCategoryForQuotes.map(CategoryWrapper.init) },
                set: { selectedCategoryForQuotes = $0?.name }
            )) { wrapper in
                NavigationView {
                    CategoryQuotesView(quoteStore: quoteStore, categoryName: wrapper.name)
                }
            }
    }
    
    private var headerView: some View {
        HStack {
            Text("Categories")
                .font(FontManager.poppinsBold(size: 28))
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            Spacer()
            
            Button(action: { showingNewCategoryAlert = true }) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(DesignSystem.Colors.primaryBlue)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.lg)
        .padding(.top, DesignSystem.Spacing.md)
        .padding(.bottom, 5)
    }
    
    private var categoriesListView: some View {
        ScrollView {
            LazyVStack(spacing: DesignSystem.Spacing.md) {
                ForEach(quoteStore.categories.sorted { $0.name < $1.name }) { category in
                    CategoryCard(
                        category: category,
                        quotesCount: quoteStore.quotesCount(for: category),
                        onTap: {
                            selectedCategoryForQuotes = category.name
                        },
                        onRename: {
                            categoryToRename = category
                            newCategoryName = category.name
                            showingRenameCategoryAlert = true
                        },
                        onDelete: {
                            categoryToDelete = category
                            showingDeleteCategoryAlert = true
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
            
            Image(systemName: "folder")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(DesignSystem.Colors.lightBlue)
            
            VStack(spacing: DesignSystem.Spacing.md) {
                Text("No categories yet")
                    .font(FontManager.poppinsSemiBold(size: 20))
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Text("Create categories to organize your quotes and thoughts by topic, theme, or any way that makes sense to you.")
                    .font(FontManager.poppinsRegular(size: 16))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button("Create Category") {
                showingNewCategoryAlert = true
            }
            .primaryButtonStyle()
            
            Spacer()
        }
        .padding(.horizontal, DesignSystem.Spacing.lg)
    }
    
    private var moveQuotesActionSheet: ActionSheet {
        var buttons: [ActionSheet.Button] = []
        
        buttons.append(.default(Text("Leave uncategorized")) {
            if let category = categoryToDelete {
                quoteStore.deleteCategory(category, moveToCategory: nil)
                categoryToDelete = nil
            }
        })
        
        let otherCategories = quoteStore.categories.filter { $0.id != categoryToDelete?.id }
        for category in otherCategories {
            buttons.append(.default(Text("Move to \(category.name)")) {
                if let categoryToDelete = categoryToDelete {
                    quoteStore.deleteCategory(categoryToDelete, moveToCategory: category.name)
                    self.categoryToDelete = nil
                }
            })
        }
        
        buttons.append(.cancel {
            categoryToDelete = nil
        })
        
        return ActionSheet(
            title: Text("Move quotes to:"),
            message: Text("Choose where to move the quotes from this category"),
            buttons: buttons
        )
    }
    
    private func createNewCategory() {
        let trimmedName = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            return
        }
        
        guard !quoteStore.categoryExists(trimmedName) else {
            return
        }
        
        let newCategory = Category(name: trimmedName)
        quoteStore.addCategory(newCategory)
        newCategoryName = ""
    }
    
    private func renameCategory() {
        guard let category = categoryToRename else { return }
        
        let trimmedName = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            return
        }
        
        guard !quoteStore.categoryExists(trimmedName) || trimmedName == category.name else {
            return
        }
        
        var updatedCategory = category
        updatedCategory.name = trimmedName
        quoteStore.updateCategory(updatedCategory)
        
        newCategoryName = ""
        categoryToRename = nil
    }
}

struct CategoryCard: View {
    let category: Category
    let quotesCount: Int
    let onTap: () -> Void
    let onRename: () -> Void
    let onDelete: () -> Void
    
    @State private var dragOffset: CGSize = .zero
    @State private var showingRenameButton = false
    @State private var showingDeleteButton = false
    
    var body: some View {
        ZStack {
            HStack {
                if showingRenameButton {
                    Button(action: onRename) {
                        VStack(spacing: DesignSystem.Spacing.xs) {
                            Image(systemName: "pencil")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Rename")
                                .font(FontManager.poppinsRegular(size: 10))
                        }
                        .foregroundColor(.white)
                        .frame(width: 70, height: 60)
                        .background(DesignSystem.Colors.primaryBlue)
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
        HStack(spacing: DesignSystem.Spacing.lg) {
            ZStack {
                Circle()
                    .fill(DesignSystem.Colors.lightBlue.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: "folder.fill")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(DesignSystem.Colors.primaryBlue)
            }
            
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                Text(category.name)
                    .font(FontManager.poppinsSemiBold(size: 18))
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .lineLimit(1)
                
                Text("\(quotesCount) quote\(quotesCount == 1 ? "" : "s")")
                    .font(FontManager.poppinsRegular(size: 14))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                
                Text("Created \(formatDate(category.dateCreated))")
                    .font(FontManager.poppinsLight(size: 12))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(DesignSystem.Colors.textSecondary)
        }
        .padding(DesignSystem.Spacing.lg)
        .cardStyle()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return "today"
        } else if calendar.isDateInYesterday(date) {
            return "yesterday"
        } else if calendar.dateInterval(of: .weekOfYear, for: Date())?.contains(date) == true {
            formatter.dateFormat = "EEEE"
            return formatter.string(from: date).lowercased()
        } else {
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
    }
}

struct CategoryQuotesView: View {
    @ObservedObject var quoteStore: QuoteStore
    let categoryName: String
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedQuoteForDetail: Quote?
    
    private var categoryQuotes: [Quote] {
        quoteStore.quotesForCategory(categoryName)
    }
    
    var body: some View {
        ZStack {
            Color.clear
                .backgroundGradient()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                    }
                    .padding(.trailing, 8)
                    
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                        Text(categoryName)
                            .font(FontManager.poppinsBold(size: 24))
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                        
                        Text("\(categoryQuotes.count) quote\(categoryQuotes.count == 1 ? "" : "s")")
                            .font(FontManager.poppinsRegular(size: 14))
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, DesignSystem.Spacing.lg)
                .padding(.top, DesignSystem.Spacing.md)
                
                if categoryQuotes.isEmpty {
                    VStack(spacing: DesignSystem.Spacing.xl) {
                        Spacer()
                        
                        Image(systemName: "folder")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(DesignSystem.Colors.lightBlue)
                        
                        Text("No quotes in this category yet")
                            .font(FontManager.poppinsSemiBold(size: 18))
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: DesignSystem.Spacing.md) {
                            ForEach(categoryQuotes) { quote in
                                QuoteCard(
                                    quote: quote,
                                    isSelected: false,
                                    isSelectionMode: false,
                                    onTap: {
                                        selectedQuoteForDetail = quote
                                    },
                                    onEdit: {
                                    },
                                    onDelete: {
                                        quoteStore.deleteQuote(quote)
                                    },
                                    onLongPress: {}
                                )
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.lg)
                        .padding(.bottom, DesignSystem.Spacing.xxl)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(item: $selectedQuoteForDetail) { quote in
            NavigationView {
                QuoteDetailView(quoteStore: quoteStore, quote: quote)
            }
        }
    }
}

struct CategoryWrapper: Identifiable {
    let id = UUID()
    let name: String
}

#Preview {
    CategoriesView(quoteStore: QuoteStore())
}
