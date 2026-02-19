import SwiftUI

struct CategoryItemsView: View {
    let category: ItemCategory
    @ObservedObject var viewModel: ItemsViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedItemId: UUID?
    
    private var categoryItems: [Item] {
        viewModel.getItemsForCategory(category)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.primaryGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    if categoryItems.isEmpty {
                        emptyStateView
                    } else {
                        itemsListView
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle(category.displayName)
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
        .sheet(item: Binding(
            get: { selectedItemId.map(IdentifiableUUID.init) },
            set: { selectedItemId = $0?.id }
        )) { wrapper in
            ItemDetailView(itemId: wrapper.id, viewModel: viewModel)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: categoryIcon)
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText)
            
            Text("No items in this category yet.")
                .font(FontManager.playfairMedium(size: 18))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var itemsListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(categoryItems) { item in
                    CategoryItemCardView(item: item, viewModel: viewModel) {
                        selectedItemId = item.id
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
    }
    
    private var categoryIcon: String {
        switch category {
        case .documents:
            return "doc.text"
        case .cosmetics:
            return "paintbrush"
        case .gadgets:
            return "iphone"
        case .accessories:
            return "bag"
        case .products:
            return "cart"
        case .other:
            return "questionmark.circle"
        }
    }
}

struct CategoryItemCardView: View {
    let item: Item
    let viewModel: ItemsViewModel
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Circle()
                    .fill(item.isInBag ? AppColors.success : AppColors.secondaryText.opacity(0.3))
                    .frame(width: 12, height: 12)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(FontManager.playfairSemiBold(size: 16))
                        .foregroundColor(AppColors.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if !item.note.isEmpty {
                        Text(item.note)
                            .font(FontManager.playfairRegular(size: 14))
                            .foregroundColor(AppColors.secondaryText)
                            .lineLimit(2)
                    }
                    
                    Text(item.isInBag ? "In Bag" : "Not in Bag")
                        .font(FontManager.playfairRegular(size: 12))
                        .foregroundColor(item.isInBag ? AppColors.success : AppColors.secondaryText)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(AppColors.yellow.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CategoryItemsView(category: .gadgets, viewModel: ItemsViewModel())
}
