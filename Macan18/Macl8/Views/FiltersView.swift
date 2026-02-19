import SwiftUI

struct FiltersView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var quoteManager: QuoteManager
    @Binding var selectedTab: TabItem
    
    @State private var selectedThemes: Set<QuoteTheme> = []
    @State private var authorFilter = ""
    @State private var keywordsFilter = ""
    
    init(quoteManager: QuoteManager, selectedTab: Binding<TabItem>) {
        self.quoteManager = quoteManager
        self._selectedTab = selectedTab
    }
    
    init(quoteManager: QuoteManager) {
        self.quoteManager = quoteManager
        self._selectedTab = .constant(.filters)
    }
    
    var body: some View {
        ZStack {
            AppTheme.Gradients.primaryBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: AppTheme.Spacing.lg) {
                        themeFiltersView
                        
                        authorFilterView
                        
                        keywordsFilterView
                        
                        actionButtonsView
                    }
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    .padding(.bottom, 120)
                }
            }
        }
        .onAppear {
            loadCurrentFilters()
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Filters")
                .font(.playfairDisplay(AppTheme.Typography.largeTitle, weight: .bold))
                .foregroundColor(AppTheme.Colors.primaryText)
            
            Spacer()
            
            if !quoteManager.currentFilter.isEmpty {
                Button("Clear All") {
                    clearAllFilters()
                }
                .foregroundColor(AppTheme.Colors.accent)
                .font(.playfairDisplay(AppTheme.Typography.body, weight: .medium))
            }
        }
        .padding(.horizontal, AppTheme.Spacing.lg)
        .padding(.top, AppTheme.Spacing.md)
        .padding(.bottom, AppTheme.Spacing.sm)
    }
    
    private var themeFiltersView: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Themes")
                .font(.playfairDisplay(AppTheme.Typography.title3, weight: .semiBold))
                .foregroundColor(AppTheme.Colors.primaryText)
            
            VStack(spacing: AppTheme.Spacing.sm) {
                ForEach(QuoteTheme.allCases, id: \.self) { theme in
                    ThemeCheckboxView(
                        theme: theme,
                        isSelected: selectedThemes.contains(theme)
                    ) { isSelected in
                        if isSelected {
                            selectedThemes.insert(theme)
                        } else {
                            selectedThemes.remove(theme)
                        }
                    }
                }
            }
            .padding(AppTheme.Spacing.md)
            .cardBackground()
        }
    }
    
    private var authorFilterView: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Author")
                .font(.playfairDisplay(AppTheme.Typography.title3, weight: .semiBold))
                .foregroundColor(AppTheme.Colors.primaryText)
            
            TextField("e.g., Audrey Hepburn", text: $authorFilter)
                .font(.playfairDisplay(AppTheme.Typography.body))
                .foregroundColor(AppTheme.Colors.primaryText)
                .padding(AppTheme.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .fill(AppTheme.Colors.cardBackground.opacity(0.6))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .stroke(AppTheme.Colors.border, lineWidth: 1)
                )
        }
    }
    
    private var keywordsFilterView: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Keywords")
                .font(.playfairDisplay(AppTheme.Typography.title3, weight: .semiBold))
                .foregroundColor(AppTheme.Colors.primaryText)
            
            TextField("e.g., fashion, inspire", text: $keywordsFilter)
                .font(.playfairDisplay(AppTheme.Typography.body))
                .foregroundColor(AppTheme.Colors.primaryText)
                .padding(AppTheme.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .fill(AppTheme.Colors.cardBackground.opacity(0.6))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .stroke(AppTheme.Colors.border, lineWidth: 1)
                )
        }
    }
    
    private var actionButtonsView: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Button {
                applyFilters()
            } label: {
                Text("Apply Filters")
                    .primaryButton()
            }
            
            Button {
                resetFilters()
            } label: {
                Text("Reset Filters")
                    .secondaryButton()
            }
        }
        .padding(.top, AppTheme.Spacing.lg)
    }
    
    private func loadCurrentFilters() {
        selectedThemes = quoteManager.currentFilter.themes
        authorFilter = quoteManager.currentFilter.author
        keywordsFilter = quoteManager.currentFilter.keywords
    }
    
    private func applyFilters() {
        var filter = QuoteFilter()
        filter.themes = selectedThemes
        filter.author = authorFilter.trimmingCharacters(in: .whitespacesAndNewlines)
        filter.keywords = keywordsFilter.trimmingCharacters(in: .whitespacesAndNewlines)
        
        quoteManager.applyFilter(filter)
        selectedTab = .quotes
        
        withAnimation {
            selectedTab = .quotes
        }
        
    }
    
    private func resetFilters() {
        selectedThemes.removeAll()
        authorFilter = ""
        keywordsFilter = ""
        quoteManager.clearFilter()
        
        withAnimation {
            selectedTab = .quotes
        }
    }
    
    private func clearAllFilters() {
        resetFilters()
    }
}

struct ThemeCheckboxView: View {
    let theme: QuoteTheme
    let isSelected: Bool
    let onToggle: (Bool) -> Void
    
    var body: some View {
        Button(action: { onToggle(!isSelected) }) {
            HStack(spacing: AppTheme.Spacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small)
                        .fill(isSelected ? AppTheme.Colors.accent : Color.clear)
                        .frame(width: 20, height: 20)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small)
                                .stroke(AppTheme.Colors.accent, lineWidth: 2)
                        )
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(AppTheme.Colors.primaryText)
                    }
                }
                
                HStack(spacing: AppTheme.Spacing.sm) {
                    Image(systemName: theme.icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppTheme.Colors.accent)
                    
                    Text(theme.displayName)
                        .font(.playfairDisplay(AppTheme.Typography.body, weight: .medium))
                        .foregroundColor(AppTheme.Colors.primaryText)
                }
                
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

