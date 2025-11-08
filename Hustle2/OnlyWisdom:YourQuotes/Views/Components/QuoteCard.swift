import SwiftUI

struct QuoteCard: View {
    let quote: Quote
    let isSelected: Bool
    let isSelectionMode: Bool
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onLongPress: () -> Void
    
    @State private var dragOffset: CGSize = .zero
    @State private var showingDeleteButton = false
    @State private var showingEditButton = false
    
    var body: some View {
        ZStack {
            HStack {
                if showingEditButton {
                    Button(action: onEdit) {
                        Image(systemName: "pencil")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(DesignSystem.Colors.primaryBlue)
                            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md))
                    }
                    .transition(.scale.combined(with: .opacity))
                }
                
                Spacer()
                
                if showingDeleteButton {
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
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
                Text(formatDate(quote.dateCreated))
                    .font(FontManager.poppinsLight(size: 12))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                
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
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            formatter.timeStyle = .short
            return "Today, \(formatter.string(from: date))"
        } else if calendar.isDateInYesterday(date) {
            formatter.timeStyle = .short
            return "Yesterday, \(formatter.string(from: date))"
        } else if calendar.dateInterval(of: .weekOfYear, for: Date())?.contains(date) == true {
            formatter.dateFormat = "EEEE"
            return formatter.string(from: date)
        } else {
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
    }
}

#Preview {
    VStack(spacing: DesignSystem.Spacing.md) {
        QuoteCard(
            quote: Quote(
                title: "Sample Quote",
                content: "This is a sample quote content that demonstrates how the card looks with longer text that might wrap to multiple lines.",
                type: .quote,
                source: "Sample Author",
                category: "Inspiration"
            ),
            isSelected: false,
            isSelectionMode: false,
            onTap: {},
            onEdit: {},
            onDelete: {},
            onLongPress: {}
        )
        
        QuoteCard(
            quote: Quote(
                title: "Sample Thought",
                content: "This is a personal thought or idea.",
                type: .thought,
                category: "Personal"
            ),
            isSelected: true,
            isSelectionMode: true,
            onTap: {},
            onEdit: {},
            onDelete: {},
            onLongPress: {}
        )
    }
    .padding()
    .backgroundGradient()
}
