import SwiftUI

struct OutfitDetailView: View {
    @State var outfit: Outfit
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 20) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(outfit.name)
                                .font(.ubuntu(28, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                                .lineLimit(nil)
                            
                            HStack(spacing: 12) {
                                TagView(text: outfit.season.displayName, color: AppColors.primaryBlue)
                                TagView(text: outfit.mood.displayName, color: AppColors.primaryPurple)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: toggleFavorite) {
                            Image(systemName: outfit.isFavorite ? "heart.fill" : "heart")
                                .font(.system(size: 28))
                                .foregroundColor(outfit.isFavorite ? AppColors.favoriteHeart : AppColors.secondaryText)
                        }
                    }
                    
                    Divider()
                        .background(Color.white.opacity(0.2))
                    
                    VStack(spacing: 16) {
                        DetailRow(title: "Season", value: outfit.season.displayName)
                        DetailRow(title: "Mood", value: outfit.mood.displayName)
                        DetailRow(title: "Situation", value: outfit.situation.displayName)
                        
                        if !outfit.comment.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Comment")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Text(outfit.comment)
                                    .font(.ubuntu(16))
                                    .foregroundColor(AppColors.secondaryText)
                                    .lineLimit(nil)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Comment")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Text("Description not added. Can be added later.")
                                    .font(.ubuntu(16))
                                    .foregroundColor(AppColors.secondaryText.opacity(0.7))
                                    .italic()
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppColors.cardBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                
                VStack(spacing: 16) {
                    Button(action: { showingEditSheet = true }) {
                        HStack {
                            Image(systemName: "pencil")
                                .font(.system(size: 16, weight: .medium))
                            Text("Edit Outfit")
                                .font(.ubuntu(16, weight: .medium))
                        }
                        .foregroundColor(AppColors.buttonText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.buttonBackground)
                        )
                    }
                    
                    Button(action: { showingDeleteAlert = true }) {
                        HStack {
                            Image(systemName: "trash")
                                .font(.system(size: 16, weight: .medium))
                            Text("Delete Outfit")
                                .font(.ubuntu(16, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.errorRed)
                        )
                    }
                }
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .background(AppColors.mainBackgroundGradient.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditSheet) {
            AddEditOutfitView(editingOutfit: outfit)
        }
        .alert("Delete Outfit", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                dataManager.deleteOutfit(outfit)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this outfit? This action cannot be undone.")
        }
        .onReceive(dataManager.$outfits) { outfits in
            if let updatedOutfit = outfits.first(where: { $0.id == outfit.id }) {
                self.outfit = updatedOutfit
            }
        }
    }
    
    private func toggleFavorite() {
        var updatedOutfit = outfit
        updatedOutfit.isFavorite.toggle()
        dataManager.updateOutfit(updatedOutfit)
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Text(value)
                .font(.ubuntu(16))
                .foregroundColor(AppColors.secondaryText)
        }
    }
}

struct TagView: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.ubuntu(12, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(color)
            )
    }
}

#Preview {
    NavigationView {
        OutfitDetailView(outfit: Outfit(
            name: "Casual Jeans & White Shirt",
            season: .spring,
            mood: .casual,
            situation: .work,
            comment: "Perfect for everyday wear. Add a nice watch.",
            isFavorite: true
        ))
    }
    .environmentObject(DataManager.shared)
}
