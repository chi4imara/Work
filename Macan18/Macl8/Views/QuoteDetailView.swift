import SwiftUI

struct QuoteDetailView: View {
    let quoteId: UUID
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var quoteManager = QuoteManager.shared
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var quote: Quote? {
        quoteManager.quotes.first { $0.id == quoteId }
    }
    
    var body: some View {
        ZStack {
            AppTheme.Gradients.primaryBackground
                .ignoresSafeArea()
            
            if let quote = quote {
                ScrollView {
                    VStack(spacing: AppTheme.Spacing.xl) {
                        headerView
                        
                        quoteContentView(quote: quote)
                        
                        actionsView(quote: quote)
                    }
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    .padding(.bottom, 120)
                }
            } else {
                VStack(spacing: AppTheme.Spacing.lg) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(AppTheme.Colors.accent.opacity(0.6))
                    
                    Text("Quote not found")
                        .font(.playfairDisplay(AppTheme.Typography.title2, weight: .bold))
                        .foregroundColor(AppTheme.Colors.primaryText)
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Go Back")
                            .primaryButton()
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingEditView) {
            if let quote = quote {
                EditQuoteView(quote: quote)
            }
        }
        .alert("Delete Quote", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                deleteQuote()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this quote? This action cannot be undone.")
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppTheme.Colors.accent)
            }
            
            Spacer()
            
            Text("Quote Details")
                .font(.playfairDisplay(AppTheme.Typography.title2, weight: .bold))
                .foregroundColor(AppTheme.Colors.primaryText)
            
            Spacer()
            
            Button(action: { showingEditView = true }) {
                Image(systemName: "pencil")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppTheme.Colors.accent)
            }
        }
        .padding(.top, AppTheme.Spacing.md)
    }
    
    private func quoteContentView(quote: Quote) -> some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            VStack(spacing: AppTheme.Spacing.md) {
                Image(systemName: "quote.opening")
                    .font(.system(size: 24, weight: .light))
                    .foregroundColor(AppTheme.Colors.accent.opacity(0.6))
                
                Text(quote.text)
                    .font(.playfairDisplay(AppTheme.Typography.title3, weight: .regular))
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .padding(.horizontal, AppTheme.Spacing.md)
                
                Image(systemName: "quote.closing")
                    .font(.system(size: 24, weight: .light))
                    .foregroundColor(AppTheme.Colors.accent.opacity(0.6))
            }
            .padding(AppTheme.Spacing.lg)
            .cardBackground()
            
            VStack(spacing: AppTheme.Spacing.md) {
                if !quote.author.isEmpty {
                    detailRow(title: "Author", value: quote.author, icon: "person")
                }
                
                if !quote.source.isEmpty {
                    detailRow(title: "Source", value: quote.source, icon: "book")
                }
                
                detailRow(title: "Theme", value: quote.theme.displayName, icon: quote.theme.icon)
                
                if !quote.comment.isEmpty {
                    detailRow(title: "Comment", value: quote.comment, icon: "text.bubble")
                }
                
                detailRow(title: "Created", value: formatDate(quote.dateCreated), icon: "calendar")
                
                if quote.dateModified != quote.dateCreated {
                    detailRow(title: "Modified", value: formatDate(quote.dateModified), icon: "clock")
                }
            }
            .padding(AppTheme.Spacing.lg)
            .cardBackground()
        }
    }
    
    private func detailRow(title: String, value: String, icon: String) -> some View {
        HStack(alignment: .top, spacing: AppTheme.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppTheme.Colors.accent)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(title)
                    .font(.playfairDisplay(AppTheme.Typography.subheadline, weight: .semiBold))
                    .foregroundColor(AppTheme.Colors.secondaryText)
                
                Text(value)
                    .font(.playfairDisplay(AppTheme.Typography.body, weight: .regular))
                    .foregroundColor(AppTheme.Colors.primaryText)
            }
            
            Spacer()
        }
    }
    
    private func actionsView(quote: Quote) -> some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Button {
                showingEditView = true
            } label: {
                Text("Edit Quote")
                    .primaryButton()
            }
            
            Button {
                showingDeleteAlert = true
            } label: {
                Text("Delete Quote")
                    .font(.playfairDisplay(AppTheme.Typography.body, weight: .semiBold))
                    .foregroundColor(AppTheme.Colors.error)
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    .padding(.vertical, AppTheme.Spacing.md)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                            .fill(AppTheme.Colors.error.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                    .stroke(AppTheme.Colors.error.opacity(0.3), lineWidth: 1)
                            )
                    )
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func deleteQuote() {
        if let quote = quote {
            quoteManager.deleteQuote(quote)
            presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    let sampleQuote = Quote(
        text: "Fashion fades, style is eternal.",
        author: "Yves Saint Laurent",
        source: "Interview, 1978",
        theme: .style,
        comment: "Perfect for self-expression section"
    )
    return QuoteDetailView(quoteId: sampleQuote.id)
}
