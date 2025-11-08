import SwiftUI

struct BookCardView: View {
    let book: Book
    let isSelected: Bool
    let isSelectionMode: Bool
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onLongPress: () -> Void
    
    @State private var dragOffset: CGSize = .zero
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .overlay(
                       RoundedRectangle(cornerRadius: 16)
                           .stroke(
                               LinearGradient(
                                colors: [.blue.opacity(0.5), .purple.opacity(0.5)],
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing
                               ),
                               lineWidth: 2
                           )
                   )
                .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
            
            if isSelectionMode {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? AppColors.primaryBlue : AppColors.lightBlue, lineWidth: 2)
            }
            
            HStack(spacing: 16) {
                if isSelectionMode {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 24))
                        .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.secondaryText)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(book.title)
                            .font(FontManager.cardTitle)
                            .foregroundColor(AppColors.primaryText)
                            .lineLimit(2)
                        
                        if let author = book.author, !author.isEmpty {
                            Text(author)
                                .font(FontManager.cardSubtitle)
                                .foregroundColor(AppColors.secondaryText)
                                .lineLimit(1)
                        }
                    }
                    
                    HStack {
                        statusBadge
                        
                        Spacer()
                        
                        if book.status == .completed, let rating = book.ratingText {
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(AppColors.warningColor)
                                Text(rating)
                                    .font(FontManager.caption)
                                    .foregroundColor(AppColors.secondaryText)
                            }
                        }
                    }
                    
                    if book.status == .reading, let progress = book.progressText {
                        Text(progress)
                            .font(FontManager.caption)
                            .foregroundColor(AppColors.lightText)
                            .padding(.top, 4)
                    }
                }
                
                Spacer()
                
                if !isSelectionMode {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            .padding(16)
        }
        .scaleEffect(isSelected ? 0.98 : 1.0)
        .onTapGesture {
            onTap()
        }
        .onLongPressGesture {
            onLongPress()
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .alert("Delete Book", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete '\(book.title)'? This action cannot be undone.")
        }
    }
    
    private var statusBadge: some View {
        Text(book.status.displayName)
            .font(FontManager.caption)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(statusColor)
            )
    }
    
    private var statusColor: Color {
        switch book.status {
        case .reading:
            return AppColors.readingColor
        case .completed:
            return AppColors.completedColor
        case .wantToRead:
            return AppColors.wantToReadColor
        }
    }
}
