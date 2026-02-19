import SwiftUI

struct EditItemView: View {
    let item: Item
    @ObservedObject var viewModel: ItemsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var itemName: String
    @State private var selectedCategory: ItemCategory
    @State private var itemNote: String
    
    init(item: Item, viewModel: ItemsViewModel) {
        self.item = item
        self.viewModel = viewModel
        self._itemName = State(initialValue: item.name)
        self._selectedCategory = State(initialValue: item.category)
        self._itemNote = State(initialValue: item.note)
    }
    
    private var isFormValid: Bool {
        !itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.primaryGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Item Name")
                                .font(FontManager.playfairMedium(size: 16))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter item name", text: $itemName)
                                .font(FontManager.playfairRegular(size: 16))
                                .foregroundColor(AppColors.primaryText)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(AppColors.yellow.opacity(0.3), lineWidth: 1)
                                        )
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(FontManager.playfairMedium(size: 16))
                                .foregroundColor(AppColors.primaryText)
                            
                            Menu {
                                ForEach(ItemCategory.allCases) { category in
                                    Button(action: {
                                        selectedCategory = category
                                    }) {
                                        HStack {
                                            Text(category.displayName)
                                            if selectedCategory == category {
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedCategory.displayName)
                                        .font(FontManager.playfairRegular(size: 16))
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 12))
                                        .foregroundColor(AppColors.secondaryText)
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(AppColors.yellow.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Note (Optional)")
                                .font(FontManager.playfairMedium(size: 16))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Add a note", text: $itemNote, axis: .vertical)
                                .font(FontManager.playfairRegular(size: 16))
                                .foregroundColor(AppColors.primaryText)
                                .lineLimit(3...6)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(AppColors.yellow.opacity(0.3), lineWidth: 1)
                                        )
                                )
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: saveChanges) {
                        Text("Save Changes")
                            .font(FontManager.playfairSemiBold(size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(isFormValid ? AnyShapeStyle(AppColors.accentGradient) : AnyShapeStyle(AppColors.cardBackground))
                            )
                    }
                    .disabled(!isFormValid)
                    .opacity(isFormValid ? 1.0 : 0.6)
                }
                .padding(20)
            }
            .navigationTitle("Edit Item")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(FontManager.playfairMedium(size: 16))
                    .foregroundColor(AppColors.yellow)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    private func saveChanges() {
        let updatedItem = Item(
            name: itemName.trimmingCharacters(in: .whitespacesAndNewlines),
            category: selectedCategory,
            note: itemNote.trimmingCharacters(in: .whitespacesAndNewlines),
            isInBag: item.isInBag
        )
        
        var finalItem = updatedItem
        finalItem = Item(name: updatedItem.name, category: updatedItem.category, note: updatedItem.note, isInBag: updatedItem.isInBag)
        
        viewModel.updateItem(item, with: finalItem)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    EditItemView(
        item: Item(name: "Sample Item", category: .gadgets, note: "This is a sample note"),
        viewModel: ItemsViewModel()
    )
}
