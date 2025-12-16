import SwiftUI

struct AddEditOutfitView: View {
    @StateObject private var viewModel = AddEditOutfitViewModel()
    @Environment(\.dismiss) private var dismiss
    
    let editingOutfit: Outfit?
    
    init(editingOutfit: Outfit? = nil) {
        self.editingOutfit = editingOutfit
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Outfit Name")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                        
                        TextField("e.g., Jeans and white shirt", text: $viewModel.name)
                            .font(.ubuntu(16))
                            .foregroundColor(AppColors.primaryText)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.cardBackground)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Season")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                            ForEach(Season.allCases, id: \.self) { season in
                                SelectionButton(
                                    title: season.displayName,
                                    isSelected: viewModel.selectedSeason == season
                                ) {
                                    viewModel.selectedSeason = season
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Mood")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                            ForEach(Mood.allCases, id: \.self) { mood in
                                SelectionButton(
                                    title: mood.displayName,
                                    isSelected: viewModel.selectedMood == mood
                                ) {
                                    viewModel.selectedMood = mood
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Situation")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                            ForEach(Situation.allCases, id: \.self) { situation in
                                SelectionButton(
                                    title: situation.displayName,
                                    isSelected: viewModel.selectedSituation == situation
                                ) {
                                    viewModel.selectedSituation = situation
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Comment (Optional)")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                        
                        TextField("Add necklace or khaki bag", text: $viewModel.comment, axis: .vertical)
                            .font(.ubuntu(16))
                            .foregroundColor(AppColors.primaryText)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .frame(minHeight: 80, alignment: .topLeading)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.cardBackground)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    }
                    
                    HStack {
                        Text("Favorite Outfit")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Button(action: { viewModel.isFavorite.toggle() }) {
                            Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                                .font(.system(size: 24))
                                .foregroundColor(viewModel.isFavorite ? AppColors.favoriteHeart : AppColors.secondaryText)
                        }
                    }
                    .padding(.vertical, 8)
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .background(AppColors.mainBackgroundGradient.ignoresSafeArea())
            .navigationTitle(viewModel.isEditing ? "Edit Outfit" : "New Outfit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.secondaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.save()
                        dismiss()
                    }
                    .foregroundColor(viewModel.canSave ? AppColors.primaryYellow : AppColors.secondaryText)
                    .disabled(!viewModel.canSave)
                }
            }
        }
        .onAppear {
            if let outfit = editingOutfit {
                viewModel.setEditingOutfit(outfit)
            }
        }
    }
}

struct SelectionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.ubuntu(16, weight: isSelected ? .medium : .regular))
                .foregroundColor(isSelected ? AppColors.primaryPurple : AppColors.primaryText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? AppColors.primaryYellow : AppColors.cardBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

#Preview {
    AddEditOutfitView()
}
