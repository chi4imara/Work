import SwiftUI

private struct OutfitDetailPresenter: Identifiable {
    let id: UUID
}

struct OutfitsView: View {
    @EnvironmentObject var viewModel: WardrobeViewModel
    @State private var showingAddOutfit = false
    @State private var selectedOutfitId: OutfitDetailPresenter?
    
    var body: some View {
        ZStack {
            AppColors.gradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Outfits")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Button(action: { showingAddOutfit = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(AppColors.primary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.outfits.isEmpty {
                    Spacer()
                    EmptyStateView(
                        title: "Create your first outfit and get inspired every day",
                        systemImage: "heart.fill"
                    ) {
                        showingAddOutfit = true
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach(viewModel.outfits) { outfit in
                                OutfitCard(outfit: outfit) {
                                    selectedOutfitId = OutfitDetailPresenter(id: outfit.id)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddOutfit) {
            AddOutfitView()
        }
        .sheet(item: $selectedOutfitId) { presenter in
            OutfitDetailView(outfitId: presenter.id)
        }
    }
}

struct OutfitCard: View {
    let outfit: Outfit
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.primary.opacity(0.1))
                    .frame(height: 120)
                    .overlay(
                        OutfitPhotoView(imageName: outfit.imageName, placeholderSize: 30, cornerRadius: 12)
                    )
                    .clipped()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(outfit.name)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(1)
                    
                    if let category = outfit.category {
                        Text(category)
                            .font(.ubuntu(12))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    Text(outfit.dateCreated, style: .date)
                        .font(.ubuntu(12))
                        .foregroundColor(AppColors.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(12)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardBackground)
                    .shadow(color: AppColors.shadow, radius: 8, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct OutfitDetailView: View {
    let outfitId: UUID
    @EnvironmentObject var viewModel: WardrobeViewModel
    @Environment(\.dismiss) private var dismiss
    
    private var outfit: Outfit? {
        viewModel.outfit(byId: outfitId)
    }
    
    var body: some View {
        Group {
            if let outfit = outfit {
                outfitContent(outfit: outfit)
            } else {
                Text("Outfit not found")
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.textSecondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    private func outfitContent(outfit: Outfit) -> some View {
        NavigationView {
            ZStack {
                AppColors.gradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppColors.primary.opacity(0.1))
                            .frame(height: 250)
                            .overlay(
                                OutfitPhotoView(imageName: outfit.imageName, placeholderSize: 60, cornerRadius: 20)
                            )
                            .clipped()
                            .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text(outfit.name)
                                .font(.ubuntu(24, weight: .bold))
                                .foregroundColor(AppColors.textPrimary)
                            
                            if let category = outfit.category {
                                Text("Category: \(category)")
                                    .font(.ubuntu(16))
                                    .foregroundColor(AppColors.textSecondary)
                            }
                            
                            Text("Created: \(outfit.dateCreated, style: .date)")
                                .font(.ubuntu(16))
                                .foregroundColor(AppColors.textSecondary)
                            
                            if !outfit.items.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Items in this outfit:")
                                        .font(.ubuntu(18, weight: .medium))
                                        .foregroundColor(AppColors.textPrimary)
                                    
                                    ForEach(outfit.items, id: \.id) { item in
                                        HStack {
                                            Circle()
                                                .fill(AppColors.accent)
                                                .frame(width: 6, height: 6)
                                            Text("\(item.name) (\(item.category))")
                                                .font(.ubuntu(14))
                                                .foregroundColor(AppColors.textSecondary)
                                        }
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationTitle("Outfit Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primary)
                }
            }
        }
    }
}

#Preview {
    OutfitsView()
        .environmentObject(WardrobeViewModel())
}
