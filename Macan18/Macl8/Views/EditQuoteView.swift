import SwiftUI

struct EditQuoteView: View {
    let quote: Quote
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var quoteManager = QuoteManager.shared
    
    @State private var quoteText: String
    @State private var author: String
    @State private var source: String
    @State private var selectedTheme: QuoteTheme
    @State private var comment: String
    
    init(quote: Quote) {
        self.quote = quote
        self._quoteText = State(initialValue: quote.text)
        self._author = State(initialValue: quote.author)
        self._source = State(initialValue: quote.source)
        self._selectedTheme = State(initialValue: quote.theme)
        self._comment = State(initialValue: quote.comment)
    }
    
    private var isFormValid: Bool {
        !quoteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var hasChanges: Bool {
        quoteText != quote.text ||
        author != quote.author ||
        source != quote.source ||
        selectedTheme != quote.theme ||
        comment != quote.comment
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.Gradients.primaryBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppTheme.Spacing.lg) {
                        headerView
                        
                        formView
                        
                        buttonsView
                    }
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    .padding(.bottom, AppTheme.Spacing.xl)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        HStack {
            Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(AppTheme.Colors.secondaryText)
            .font(.playfairDisplay(AppTheme.Typography.body, weight: .medium))
            
            Spacer()
            
            Text("Edit Quote")
                .font(.playfairDisplay(AppTheme.Typography.title2, weight: .bold))
                .foregroundColor(AppTheme.Colors.primaryText)
            
            Spacer()
            
            Button("Save") {
                saveChanges()
            }
            .foregroundColor((isFormValid && hasChanges) ? AppTheme.Colors.accent : AppTheme.Colors.buttonDisabled)
            .font(.playfairDisplay(AppTheme.Typography.body, weight: .semiBold))
            .disabled(!isFormValid || !hasChanges)
        }
        .padding(.top, AppTheme.Spacing.md)
    }
    
    private var formView: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Text("Quote Text *")
                    .font(.playfairDisplay(AppTheme.Typography.headline, weight: .semiBold))
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                TextEditor(text: $quoteText)
                    .font(.playfairDisplay(AppTheme.Typography.body))
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 100)
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
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Text("Author")
                    .font(.playfairDisplay(AppTheme.Typography.headline, weight: .semiBold))
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                TextField("e.g., Audrey Hepburn", text: $author)
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
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Text("Source")
                    .font(.playfairDisplay(AppTheme.Typography.headline, weight: .semiBold))
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                TextField("e.g., Interview, 1963", text: $source)
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
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Text("Theme")
                    .font(.playfairDisplay(AppTheme.Typography.headline, weight: .semiBold))
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Menu {
                    ForEach(QuoteTheme.allCases, id: \.self) { theme in
                        Button(action: { selectedTheme = theme }) {
                            HStack {
                                Image(systemName: theme.icon)
                                Text(theme.displayName)
                                if selectedTheme == theme {
                                    Spacer()
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: selectedTheme.icon)
                            .foregroundColor(AppTheme.Colors.accent)
                        
                        Text(selectedTheme.displayName)
                            .font(.playfairDisplay(AppTheme.Typography.body))
                            .foregroundColor(AppTheme.Colors.primaryText)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .foregroundColor(AppTheme.Colors.secondaryText)
                    }
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
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Text("Comment (Optional)")
                    .font(.playfairDisplay(AppTheme.Typography.headline, weight: .semiBold))
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                TextField("e.g., Perfect for morning motivation", text: $comment)
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
    }
    
    private var buttonsView: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Button {
                saveChanges()
            } label: {
                Text("Save Changes")
                    .primaryButton()
            }
            .disabled(!isFormValid || !hasChanges)
            .opacity((isFormValid && hasChanges) ? 1.0 : 0.6)
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Cancel")
                    .secondaryButton()
            }
        }
        .padding(.top, AppTheme.Spacing.lg)
    }
    
    private func saveChanges() {
        var updatedQuote = quote
        updatedQuote.text = quoteText.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedQuote.author = author.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedQuote.source = source.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedQuote.theme = selectedTheme
        updatedQuote.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
        
        quoteManager.updateQuote(updatedQuote)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    EditQuoteView(quote: Quote(
        text: "Fashion fades, style is eternal.",
        author: "Yves Saint Laurent",
        source: "Interview, 1978",
        theme: .style,
        comment: "Perfect for self-expression section"
    ))
}
