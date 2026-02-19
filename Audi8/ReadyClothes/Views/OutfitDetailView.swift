import SwiftUI

struct OutfitDetailView: View {
    @EnvironmentObject var outfitViewModel: OutfitViewModel
    @Environment(\.dismiss) private var dismiss
    
    let outfitId: UUID
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var outfit: Outfit? {
        outfitViewModel.getOutfit(by: outfitId)
    }
    
    var body: some View {
        Group {
            if let currentOutfit = outfit {
                OutfitDetailContentView(
                    outfit: currentOutfit,
                    showingEditView: $showingEditView,
                    showingDeleteAlert: $showingDeleteAlert,
                    dismiss: dismiss
                )
                .environmentObject(outfitViewModel)
            } else {
                ZStack {
                    AppColors.backgroundGradient
                        .ignoresSafeArea()
                    
                    VStack {
                        Text("Outfit not found")
                            .font(.lumierepolis(20, weight: .bold))
                            .foregroundColor(.textPrimary)
                    }
                }
            }
        }
    }
}

struct OutfitDetailContentView: View {
    let outfit: Outfit
    @Binding var showingEditView: Bool
    @Binding var showingDeleteAlert: Bool
    @EnvironmentObject var outfitViewModel: OutfitViewModel
    let dismiss: DismissAction
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.cardBackground.opacity(0.3))
                            .frame(height: 300)
                        
                        if let image = outfit.image {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 300)
                                .clipped()
                                .cornerRadius(25)
                        } else {
                            Image(systemName: "tshirt.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.textSecondary.opacity(0.3))
                        }
                        
                        if outfit.isFavorite {
                            VStack {
                                HStack {
                                    Spacer()
                                    Image(systemName: "heart.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.accentPink)
                                        .padding(12)
                                        .background(
                                            Circle()
                                                .fill(Color.white.opacity(0.9))
                                        )
                                }
                                Spacer()
                            }
                            .padding(20)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 20) {
                        VStack(spacing: 12) {
                            Text(outfit.name)
                                .font(.lumierepolis(28, weight: .bold))
                                .foregroundColor(.textPrimary)
                                .multilineTextAlignment(.center)
                            
                            Text(outfit.category.displayName)
                                .font(.lumierepolis(16, weight: .bold))
                                .foregroundColor(.textDark)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.primaryYellow)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.lumierepolis(18, weight: .bold))
                                .foregroundColor(.textPrimary)
                            
                            if outfit.description.isEmpty {
                                Text("No description added")
                                    .font(.lumierepolis(16, weight: .light))
                                    .foregroundColor(.textSecondary.opacity(0.7))
                                    .italic()
                            } else {
                                Text(outfit.description)
                                    .font(.lumierepolis(16, weight: .light))
                                    .foregroundColor(.textSecondary)
                                    .lineSpacing(4)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.cardBackground.opacity(0.3))
                        )
                        
                        VStack(spacing: 16) {
                            Button(action: {
                                showingEditView = true
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 18, weight: .bold))
                                    Text("Edit")
                                        .font(.lumierepolis(18, weight: .bold))
                                }
                                .foregroundColor(.textDark)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(Color.primaryYellow)
                                )
                            }
                            
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "trash")
                                        .font(.system(size: 18, weight: .bold))
                                    Text("Delete Outfit")
                                        .font(.lumierepolis(18, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(Color.red.opacity(0.8))
                                )
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, 20)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                        Text("Back")
                            .font(.lumierepolis(16))
                    }
                    .foregroundColor(.textPrimary)
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            EditOutfitView(outfit: outfit)
                .environmentObject(outfitViewModel)
        }
        .alert("Delete Outfit", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                outfitViewModel.deleteOutfit(outfit)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this outfit? This action cannot be undone.")
        }
    }
}

#Preview {
    NavigationView {
        OutfitDetailView(outfitId: UUID())
            .environmentObject(OutfitViewModel())
    }
}
