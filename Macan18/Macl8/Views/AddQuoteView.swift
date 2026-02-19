import SwiftUI

struct AddQuoteView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var quoteManager = QuoteManager.shared
    
    @State private var quoteText = ""
    @State private var author = ""
    @State private var source = ""
    @State private var selectedTheme: QuoteTheme = .style
    @State private var comment = ""
    
    private var isFormValid: Bool {
        !quoteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
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
            
            Text("New Quote")
                .font(.playfairDisplay(AppTheme.Typography.title2, weight: .bold))
                .foregroundColor(AppTheme.Colors.primaryText)
            
            Spacer()
            
            Button("Save") {
                saveQuote()
            }
            .foregroundColor(isFormValid ? AppTheme.Colors.accent : AppTheme.Colors.buttonDisabled)
            .font(.playfairDisplay(AppTheme.Typography.body, weight: .semiBold))
            .disabled(!isFormValid)
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
                saveQuote()
            } label: {
                Text("Save Quote")
                    .primaryButton()
            }
            .disabled(!isFormValid)
            .opacity(isFormValid ? 1.0 : 0.6)
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Cancel")
                    .secondaryButton()
            }
        }
        .padding(.top, AppTheme.Spacing.lg)
    }
    
    private func saveQuote() {
        let newQuote = Quote(
            text: quoteText.trimmingCharacters(in: .whitespacesAndNewlines),
            author: author.trimmingCharacters(in: .whitespacesAndNewlines),
            source: source.trimmingCharacters(in: .whitespacesAndNewlines),
            theme: selectedTheme,
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        quoteManager.addQuote(newQuote)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddQuoteView()
}
