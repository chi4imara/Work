import SwiftUI

struct SectionCard: View {
    let section: GameSection
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGSize = .zero
    @State private var showingDeleteAlert = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(section.title)
                    .font(AppFonts.bodyMedium)
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(1)
                
                Text(section.preview)
                    .font(AppFonts.subheadline)
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .onTapGesture {
                onTap()
            }
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                Image(systemName: "trash")
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.error)
                    .padding(8)
                    .background(
                        Circle()
                            .fill(AppColors.error.opacity(0.1))
                    )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
        .alert("Delete Section", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete \"\(section.title)\"? This action cannot be undone.")
        }
    }
}

#Preview {
    ZStack {
        BackgroundView()
        
        VStack {
            SectionCard(
                section: GameSection(title: "Setup", content: "Place the board in the center of the table. Each player chooses a token and places it on the GO square."),
                onTap: { },
                onEdit: { },
                onDelete: { }
            )
            .padding()
        }
    }
}
