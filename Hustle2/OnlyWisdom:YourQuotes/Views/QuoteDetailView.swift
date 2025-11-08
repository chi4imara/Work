import SwiftUI

struct QuoteDetailView: View {
    @ObservedObject var quoteStore: QuoteStore
    @Environment(\.presentationMode) var presentationMode
    
    let quote: Quote
    
    private var currentQuote: Quote {
        quoteStore.quotes.first { $0.id == quote.id } ?? quote
    }
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @State private var showingArchiveAlert = false
    
    var body: some View {
        ZStack {
            DesignSystem.Gradients.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xl) {
                    headerSection
                        .transition(.opacity.combined(with: .scale))
                    
                    contentSection
                        .transition(.opacity.combined(with: .scale))
                    
                    metadataSection
                        .transition(.opacity.combined(with: .scale))
                    
                    actionsSection
                        .transition(.opacity.combined(with: .scale))
                }
                .padding(.horizontal, DesignSystem.Spacing.lg)
                .padding(.bottom, DesignSystem.Spacing.xxl)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: currentQuote.title)
        .animation(.easeInOut(duration: 0.3), value: currentQuote.content)
        .animation(.easeInOut(duration: 0.3), value: currentQuote.isArchived)
        .navigationTitle("Quote Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing: Menu {
                Button("Edit") {
                    showingEditView = true
                }
                
                if currentQuote.isArchived {
                    Button("Unarchive") {
                        unarchiveQuote()
                    }
                } else {
                    Button("Archive") {
                        showingArchiveAlert = true
                    }
                }
                
                Button("Delete", role: .destructive) {
                    showingDeleteAlert = true
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(DesignSystem.Colors.textPrimary)
            }
        )
        .sheet(isPresented: $showingEditView) {
            AddEditQuoteView(quoteStore: quoteStore, editingQuote: currentQuote)
        }
        .alert("Delete Quote", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                deleteQuote()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this quote? This action cannot be undone.")
        }
        .alert("Archive Quote", isPresented: $showingArchiveAlert) {
            Button("Archive") {
                archiveQuote()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This quote will be moved to your archive.")
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text(currentQuote.title)
                .font(FontManager.poppinsBold(size: 28))
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .lineLimit(nil)
            
            HStack(spacing: DesignSystem.Spacing.sm) {
                HStack(spacing: DesignSystem.Spacing.xs) {
                    Image(systemName: currentQuote.type.icon)
                        .font(.system(size: 10, weight: .medium))
                    Text(currentQuote.type.displayName)
                        .font(FontManager.poppinsMedium(size: 9))
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(DesignSystem.Colors.primaryBlue)
                .padding(.horizontal, DesignSystem.Spacing.md)
                .padding(.vertical, DesignSystem.Spacing.sm)
                .background(DesignSystem.Colors.lightBlue.opacity(0.2))
                .cornerRadius(DesignSystem.CornerRadius.md)
                
                if let category = currentQuote.category {
                    HStack(spacing: DesignSystem.Spacing.xs) {
                        Image(systemName: "folder")
                            .font(.system(size: 10, weight: .medium))
                        Text(category)
                            .font(FontManager.poppinsMedium(size: 9))
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .padding(.horizontal, DesignSystem.Spacing.md)
                    .padding(.vertical, DesignSystem.Spacing.sm)
                    .background(DesignSystem.Colors.backgroundSecondary)
                    .cornerRadius(DesignSystem.CornerRadius.md)
                }
                
                if currentQuote.isArchived {
                    HStack(spacing: DesignSystem.Spacing.xs) {
                        Image(systemName: "archivebox")
                            .font(.system(size: 10, weight: .medium))
                        Text("Archived")
                            .font(FontManager.poppinsMedium(size: 8))
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(DesignSystem.Colors.warning)
                    .padding(.horizontal, DesignSystem.Spacing.md)
                    .padding(.vertical, DesignSystem.Spacing.sm)
                    .background(DesignSystem.Colors.warning.opacity(0.1))
                    .cornerRadius(DesignSystem.CornerRadius.md)
                }
            }
        }
        .padding(DesignSystem.Spacing.lg)
        .cardStyle()
    }
    
    private var contentSection: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
                Text("Content")
                    .font(FontManager.poppinsSemiBold(size: 18))
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Text(currentQuote.content)
                    .font(FontManager.poppinsRegular(size: 16))
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .lineSpacing(6)
                    .lineLimit(nil)
            
            if currentQuote.type == .quote, let source = currentQuote.source, !source.isEmpty {
                HStack {
                    Spacer()
                    Text("— \(source)")
                        .font(FontManager.poppinsLight(size: 14))
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                        .italic()
                }
                .padding(.top, DesignSystem.Spacing.sm)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(DesignSystem.Spacing.lg)
        .cardStyle()
    }
    
    private var metadataSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
            Text("Details")
                .font(FontManager.poppinsSemiBold(size: 18))
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            VStack(spacing: DesignSystem.Spacing.sm) {
                metadataRow(icon: "calendar", title: "Created", value: formatDate(currentQuote.dateCreated))
                
                if let archivedDate = currentQuote.dateArchived {
                    metadataRow(icon: "archivebox", title: "Archived", value: formatDate(archivedDate))
                }
                
                if let category = currentQuote.category {
                    metadataRow(icon: "folder", title: "Category", value: category)
                }
                
                if currentQuote.type == .quote, let source = currentQuote.source, !source.isEmpty {
                    metadataRow(icon: "person", title: "Source", value: source)
                }
            }
        }
        .padding(DesignSystem.Spacing.lg)
        .cardStyle()
    }
    
    private var actionsSection: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            HStack(spacing: DesignSystem.Spacing.md) {
                Button {
                    showingEditView = true
                } label: {
                    Text("Edit")
                        .font(FontManager.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 8)
                }
                .primaryButtonStyle()
                
                if currentQuote.isArchived {
                    Button {
                        unarchiveQuote()
                    } label: {
                        Text("Unarchive")
                            .font(FontManager.subheadline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 8)
                    }
                    .secondaryButtonStyle()
                } else {
                    Button {
                        showingArchiveAlert = true
                    } label: {
                        Text("Archive")
                            .font(FontManager.subheadline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 8)
                    }
                    .secondaryButtonStyle()
                }
            }
            
            Button("Delete Quote") {
                showingDeleteAlert = true
            }
            .foregroundColor(DesignSystem.Colors.error)
            .font(FontManager.poppinsRegular(size: 16))
            .padding(.vertical, DesignSystem.Spacing.sm)
        }
    }
    
    private func metadataRow(icon: String, title: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(DesignSystem.Colors.primaryBlue)
                .frame(width: 20)
            
            Text(title)
                .font(FontManager.poppinsMedium(size: 14))
                .foregroundColor(DesignSystem.Colors.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(FontManager.poppinsRegular(size: 14))
                .foregroundColor(DesignSystem.Colors.textPrimary)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func archiveQuote() {
        quoteStore.archiveQuote(currentQuote)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func unarchiveQuote() {
        quoteStore.unarchiveQuote(currentQuote)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func deleteQuote() {
        quoteStore.deleteQuote(currentQuote)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    NavigationView {
        QuoteDetailView(
            quoteStore: QuoteStore(),
            quote: Quote(
                title: "Sample Quote",
                content: "This is a sample quote content that demonstrates how the detail view looks with longer text that spans multiple lines and shows the full formatting.",
                type: .quote,
                source: "Sample Author",
                category: "Inspiration"
            )
        )
    }
}
