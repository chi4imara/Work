import SwiftUI

struct AddOutfitView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    @State private var outfitName = ""
    @State private var notes = ""
    @State private var selectedItems: [WardrobeItem] = []
    
    private var isFormValid: Bool {
        !outfitName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !selectedItems.isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text("New Outfit")
                                .font(.ubuntu(28, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            Text("Create a new style combination")
                                .font(.ubuntu(16))
                                .foregroundColor(AppColors.secondaryText)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 20) {
                            FormField(title: "Outfit Name", text: $outfitName, placeholder: "Enter outfit name")
                                .padding(.horizontal, 20)
                            
                            if !selectedItems.isEmpty {
                                SelectedItemsPreview(selectedItems: selectedItems) { item in
                                    selectedItems.removeAll { $0.id == item.id }
                                }
                            }
                            
                            ItemSelectionView(
                                availableItems: appState.wardrobeItems,
                                selectedItems: $selectedItems
                            )
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Notes")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(AppColors.primaryText)
                                
                                TextField("Optional notes about this outfit...", text: $notes, axis: .vertical)
                                    .font(.ubuntu(14))
                                    .foregroundColor(AppColors.primaryText)
                                    .padding(16)
                                    .background(AppColors.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.cardBorder, lineWidth: 1)
                                    )
                                    .cornerRadius(12)
                                    .lineLimit(3...6)
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        VStack(spacing: 16) {
                            Button {
                                saveOutfit()
                            } label: {
                                Text("Save Outfit")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(AppColors.accentText)
                                    .padding(.horizontal, 32)
                                    .padding(.vertical, 16)
                                    .frame(maxWidth: .infinity)
                                    .background(AppColors.yellow)
                                    .cornerRadius(25)
                            }
                            .disabled(!isFormValid)
                            .opacity(isFormValid ? 1.0 : 0.6)
                            
                            Button("Cancel") {
                                dismiss()
                            }
                            .font(.ubuntu(16))
                            .foregroundColor(AppColors.secondaryText)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func saveOutfit() {
        let newOutfit = Outfit(
            name: outfitName.trimmingCharacters(in: .whitespacesAndNewlines),
            items: selectedItems,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        appState.addOutfit(newOutfit)
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        dismiss()
    }
}

struct SelectedItemsPreview: View {
    let selectedItems: [WardrobeItem]
    let onRemove: (WardrobeItem) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Selected Items (\(selectedItems.count))")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(selectedItems) { item in
                        SelectedItemCard(item: item) {
                            onRemove(item)
                        }
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
            }
        }
    }
}

struct SelectedItemCard: View {
    let item: WardrobeItem
    let onRemove: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 6) {
                    Image(systemName: item.category.icon)
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.yellow)
                    
                    Text(item.name)
                        .font(.ubuntu(10, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }
                .padding(12)
                .frame(width: 80, height: 80)
                .cardStyle()
                
                Button(action: onRemove) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(AppColors.yellow)
                        .background(Circle().fill(AppColors.accentText))
                }
                .offset(x: 8, y: -8)
            }
        }
    }
}

struct ItemSelectionView: View {
    let availableItems: [WardrobeItem]
    @Binding var selectedItems: [WardrobeItem]
    
    private var itemsByCategory: [WardrobeItem.ClothingCategory: [WardrobeItem]] {
        Dictionary(grouping: availableItems, by: { $0.category })
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Choose Items")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 20)
            
            if availableItems.isEmpty {
                EmptyWardrobeView()
            } else {
                ForEach(WardrobeItem.ClothingCategory.allCases, id: \.self) { category in
                    if let items = itemsByCategory[category], !items.isEmpty {
                        CategorySection(
                            category: category,
                            items: items,
                            selectedItems: $selectedItems
                        )
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CategorySection: View {
    let category: WardrobeItem.ClothingCategory
    let items: [WardrobeItem]
    @Binding var selectedItems: [WardrobeItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: category.icon)
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.yellow)
                
                Text(category.rawValue)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Text("\(items.count)")
                    .font(.ubuntu(12))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(items) { item in
                        SelectableItemCard(
                            item: item,
                            isSelected: selectedItems.contains { $0.id == item.id }
                        ) {
                            toggleItemSelection(item)
                        }
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
            }
        }
    }
    
    private func toggleItemSelection(_ item: WardrobeItem) {
        if let index = selectedItems.firstIndex(where: { $0.id == item.id }) {
            selectedItems.remove(at: index)
        } else {
            selectedItems.append(item)
        }
    }
}

struct SelectableItemCard: View {
    let item: WardrobeItem
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: item.category.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? AppColors.accentText : AppColors.yellow)
                
                Text(item.name)
                    .font(.ubuntu(10, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.accentText : AppColors.primaryText)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .padding(12)
            .frame(width: 80, height: 80)
            .background(isSelected ? AppColors.yellow : AppColors.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? AppColors.yellow : AppColors.cardBorder, lineWidth: isSelected ? 2 : 1)
            )
            .cornerRadius(16)
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EmptyWardrobeView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "tshirt")
                .font(.system(size: 48))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: 8) {
                Text("No Items in Wardrobe")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add some items to your wardrobe first to create outfits")
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(32)
        .cardStyle()
        .padding(.horizontal, 20)
    }
}

#Preview {
    AddOutfitView()
        .environmentObject(AppState())
}
