import SwiftUI

struct GameCard: View {
    let game: Game
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onToggleFavorite: () -> Void
    
    @State private var offset: CGSize = .zero
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(game.name)
                .font(AppFonts.subheadline)
                .foregroundColor(AppColors.primaryText)
                .lineLimit(1)
            
            Image(systemName: game.category.iconName)
                .font(.title2)
                .foregroundColor(AppColors.accent)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(AppColors.buttonBackground)
                        .overlay(
                            Circle()
                                .stroke(AppColors.buttonBorder, lineWidth: 1)
                        )
                )
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(game.category.displayName)
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text("Sections: \(game.sectionCount)")
                        .font(AppFonts.caption2)
                        .foregroundColor(AppColors.placeholderText)
                }
                Spacer()
                
                Button(action: onToggleFavorite) {
                    Image(systemName: game.isFavorite ? "star.fill" : "star")
                        .foregroundColor(game.isFavorite ? AppColors.accent : AppColors.secondaryText)
                        .font(.system(size: 16))
                }
            }
            
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
        
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
        .alert("Delete Game", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete \"\(game.name)\"? This action cannot be undone.")
        }
    }
}

#Preview {
    ZStack {
        BackgroundView()
        
        VStack {
            GameCard(
                game: Game(name: "Monopoly", category: .family, description: "Classic property trading game"),
                onTap: { },
                onEdit: { },
                onDelete: { },
                onToggleFavorite: { }
            )
            .padding()
        }
    }
}
