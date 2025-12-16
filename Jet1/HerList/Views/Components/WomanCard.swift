import SwiftUI

struct WomanCard: View {
    let woman: Woman
    let onTap: () -> Void
    let onFavoriteToggle: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGSize = .zero
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(woman.name)
                        .font(FontManager.ubuntu(18, weight: .bold))
                        .foregroundColor(Color.theme.darkText)
                    
                    Spacer()
                    
                    if woman.isFavorite {
                        Image(systemName: "heart.fill")
                            .foregroundColor(Color.theme.favoriteHeart)
                            .font(.system(size: 16))
                    }
                }
                
                Text(woman.profession)
                    .font(FontManager.ubuntu(14, weight: .medium))
                    .foregroundColor(Color.theme.grayText)
                
                if woman.hasQuote {
                    Text(woman.quotePreview)
                        .font(FontManager.ubuntu(14))
                        .foregroundColor(Color.theme.darkText.opacity(0.8))
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(Color.theme.grayText)
                .font(.system(size: 14, weight: .medium))
        }
        .padding(16)
        .background(Color.theme.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .offset(x: offset.width, y: 0)
        .highPriorityGesture(
            DragGesture(minimumDistance: 20)
                .onChanged { value in
                    if value.translation.width < 0 {
                        offset = value.translation
                    }
                }
                .onEnded { value in
                    if value.translation.width < -100 {
                        withAnimation(.spring()) {
                            offset = CGSize(width: -80, height: 0)
                        }
                    } else {
                        withAnimation(.spring()) {
                            offset = .zero
                        }
                    }
                }
        )
        .overlay(
            HStack {
                Spacer()
                
                if offset.width < -50 {
                    Button(action: {
                        showingDeleteConfirmation = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                            .frame(width: 60, height: 60)
                            .background(Color.theme.buttonDestructive)
                            .cornerRadius(12)
                    }
                    .transition(.move(edge: .trailing))
                }
            }
            .padding(.trailing, 16)
        )
        .onTapGesture {
            if offset == .zero {
                onTap()
            } else {
                withAnimation(.spring()) {
                    offset = .zero
                }
            }
        }
        .alert("Delete Woman", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) {
                withAnimation(.spring()) {
                    offset = .zero
                }
            }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete \(woman.name)? This action cannot be undone.")
        }
    }
}

#Preview {
    VStack {
        WomanCard(
            woman: Woman(
                name: "Coco Chanel",
                profession: "Designer",
                quote: "To be irreplaceable, one must always be different.",
                isFavorite: true
            ),
            onTap: {},
            onFavoriteToggle: {},
            onDelete: {}
        )
        
        WomanCard(
            woman: Woman(
                name: "Maya Angelou",
                profession: "Writer",
                quote: "Still I Rise - a powerful poem about resilience"
            ),
            onTap: {},
            onFavoriteToggle: {},
            onDelete: {}
        )
    }
    .padding()
    .background(Color.theme.backgroundGradient)
}
