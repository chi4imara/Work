import SwiftUI

struct ThemesView: View {
    @ObservedObject var quoteManager: QuoteManager
    @Binding var selectedTab: TabItem
    
    var body: some View {
        ZStack {
            AppTheme.Gradients.primaryBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if quoteManager.quotes.isEmpty {
                    emptyStateView
                } else {
                    themesListView
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Quote Themes")
                .font(.playfairDisplay(AppTheme.Typography.largeTitle, weight: .bold))
                .foregroundColor(AppTheme.Colors.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, AppTheme.Spacing.lg)
        .padding(.top, AppTheme.Spacing.md)
        .padding(.bottom, AppTheme.Spacing.sm)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Image(systemName: "folder")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppTheme.Colors.accent.opacity(0.6))
            
            Text("Themes will appear when you add at least one quote.")
                .font(.playfairDisplay(AppTheme.Typography.title3, weight: .medium))
                .foregroundColor(AppTheme.Colors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppTheme.Spacing.xl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var themesListView: some View {
        ScrollView {
            LazyVStack(spacing: AppTheme.Spacing.md) {
                ForEach(quoteManager.themeStats, id: \.theme) { themeStat in
                    ThemeCardView(
                        theme: themeStat.theme,
                        count: themeStat.count
                    ) {
                        quoteManager.applyThemeFilter(themeStat.theme)
                        selectedTab = .quotes
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.bottom, 120)
        }
    }
}

struct ThemeCardView: View {
    let theme: QuoteTheme
    let count: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.md) {
                ZStack {
                    Circle()
                        .fill(AppTheme.Gradients.accentGradient)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: theme.icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(AppTheme.Colors.primaryText)
                }
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text(theme.displayName)
                        .font(.playfairDisplay(AppTheme.Typography.headline, weight: .semiBold))
                        .foregroundColor(AppTheme.Colors.primaryText)
                    
                    Text("\(count) \(count == 1 ? "quote" : "quotes")")
                        .font(.playfairDisplay(AppTheme.Typography.subheadline, weight: .regular))
                        .foregroundColor(AppTheme.Colors.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppTheme.Colors.accent)
            }
            .padding(AppTheme.Spacing.lg)
            .cardBackground()
        }
        .buttonStyle(PlainButtonStyle())
    }
}
