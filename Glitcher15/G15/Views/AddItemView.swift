import SwiftUI

struct AddItemView: View {
    @ObservedObject var viewModel: ItemsViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedTab: TabItem
    
    @State private var itemName = ""
    @State private var selectedCategory: ItemCategory = .other
    @State private var itemNote = ""
    
    private var isFormValid: Bool {
        !itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("New Item")
                        .font(FontManager.playfairBold(size: 28))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
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
                        
                        Button(action: addItem) {
                            Text("Add Item")
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
            }
        }
    }
    
    private func addItem() {
        let newItem = Item(
            name: itemName.trimmingCharacters(in: .whitespacesAndNewlines),
            category: selectedCategory,
            note: itemNote.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        viewModel.addItem(newItem)
        presentationMode.wrappedValue.dismiss()
        
        withAnimation {
            selectedTab = .items
            itemName = ""
            selectedCategory = .other
            itemNote = ""
        }
    }
}
