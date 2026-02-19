import SwiftUI

struct ItemDetailView: View {
    let itemId: UUID
    @ObservedObject var viewModel: ItemsViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var item: Item? {
        viewModel.getItemById(itemId)
    }
    
    var body: some View {
        Group {
            if let item = item {
                NavigationView {
                    ZStack {
                        AppColors.primaryGradient
                            .ignoresSafeArea()
                        
                        VStack(spacing: 24) {
                            VStack(spacing: 20) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Name")
                                        .font(FontManager.playfairMedium(size: 14))
                                        .foregroundColor(AppColors.secondaryText)
                                    
                                    Text(item.name)
                                        .font(FontManager.playfairSemiBold(size: 20))
                                        .foregroundColor(AppColors.primaryText)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Divider()
                                    .background(AppColors.secondaryText.opacity(0.3))
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Category")
                                        .font(FontManager.playfairMedium(size: 14))
                                        .foregroundColor(AppColors.secondaryText)
                                    
                                    Text(item.category.displayName)
                                        .font(FontManager.playfairMedium(size: 16))
                                        .foregroundColor(AppColors.yellow)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                if !item.note.isEmpty {
                                    Divider()
                                        .background(AppColors.secondaryText.opacity(0.3))
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Note")
                                            .font(FontManager.playfairMedium(size: 14))
                                            .foregroundColor(AppColors.secondaryText)
                                        
                                        Text(item.note)
                                            .font(FontManager.playfairRegular(size: 16))
                                            .foregroundColor(AppColors.primaryText)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                Divider()
                                    .background(AppColors.secondaryText.opacity(0.3))
                                
                                HStack {
                                    Text("In Bag")
                                        .font(FontManager.playfairMedium(size: 16))
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        viewModel.toggleItemInBag(item)
                                    }) {
                                        Image(systemName: item.isInBag ? "checkmark.circle.fill" : "circle")
                                            .font(.system(size: 28))
                                            .foregroundColor(item.isInBag ? AppColors.success : AppColors.secondaryText)
                                    }
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(AppColors.cardGradient)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(AppColors.yellow.opacity(0.2), lineWidth: 1)
                                    )
                            )
                            
                            Spacer()
                            
                            VStack(spacing: 16) {
                                Button(action: {
                                    showingEditView = true
                                }) {
                                    HStack {
                                        Image(systemName: "pencil")
                                            .font(.system(size: 16, weight: .medium))
                                        
                                        Text("Edit")
                                            .font(FontManager.playfairSemiBold(size: 18))
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(AppColors.accentGradient)
                                    )
                                }
                                
                                Button(action: {
                                    showingDeleteAlert = true
                                }) {
                                    HStack {
                                        Image(systemName: "trash")
                                            .font(.system(size: 16, weight: .medium))
                                        
                                        Text("Delete")
                                            .font(FontManager.playfairSemiBold(size: 18))
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(AppColors.error)
                                    )
                                }
                            }
                        }
                        .padding(20)
                    }
                    .navigationTitle(item.name)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Back") {
                                presentationMode.wrappedValue.dismiss()
                            }
                            .font(FontManager.playfairMedium(size: 16))
                            .foregroundColor(AppColors.yellow)
                        }
                    }
                    .preferredColorScheme(.dark)
                }
                .sheet(isPresented: $showingEditView) {
                    if let currentItem = viewModel.getItemById(itemId) {
                        EditItemView(item: currentItem, viewModel: viewModel)
                    }
                }
                .alert("Delete Item", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        if let itemToDelete = viewModel.getItemById(itemId) {
                            viewModel.deleteItem(itemToDelete)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                } message: {
                    Text("Are you sure you want to delete this item? This action cannot be undone.")
                }
            }
        }
    }
}

#Preview {
    let viewModel = ItemsViewModel()
    let sampleItem = Item(name: "Sample Item", category: .gadgets, note: "This is a sample note")
    if !viewModel.itemSets.isEmpty {
        viewModel.itemSets[0].items.append(sampleItem)
    }
    return ItemDetailView(
        itemId: sampleItem.id,
        viewModel: viewModel
    )
}
