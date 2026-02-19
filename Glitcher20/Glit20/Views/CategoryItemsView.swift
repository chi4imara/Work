import SwiftUI

struct CategoryItemsView: View {
    let category: Category
    let viewModel: WardrobeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    private var categoryItems: [WardrobeItem] {
        viewModel.itemsInCategory(category.name)
    }
    
    var body: some View {
        ZStack {
            AppColorScheme.backgroundGradient
                .ignoresSafeArea()
            
            if categoryItems.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "tshirt")
                        .font(.system(size: 60))
                        .foregroundColor(Color.textSecondary)
                    
                    Text("No items in this category yet.")
                        .font(FontManager.playfairDisplay(size: 18))
                        .foregroundColor(Color.textSecondary)
                        .multilineTextAlignment(.center)
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(categoryItems) { item in
                            NavigationLink(destination: ItemDetailView(itemId: item.id, viewModel: viewModel)) {
                                CategoryItemCardView(item: item, viewModel: viewModel)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }
}

struct CategoryItemCardView: View {
    let item: WardrobeItem
    let viewModel: WardrobeViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(item.name)
                    .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(Color.textPrimary)
                    .lineLimit(2)
                
                if !item.description.isEmpty {
                    Text(item.description)
                        .font(FontManager.playfairDisplay(size: 14))
                        .foregroundColor(Color.textSecondary)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            Button(action: {
                viewModel.togglePurchased(item)
            }) {
                Image(systemName: item.isPurchased ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(item.isPurchased ? Color.secondaryGreen : Color.textSecondary)
            }
        }
        .padding()
        .background(AppColorScheme.cardGradient)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
}

#Preview {
    NavigationView {
        CategoryItemsView(
            category: Category(name: "Tops", itemCount: 3),
            viewModel: WardrobeViewModel()
        )
    }
}
