import SwiftUI

struct ShoppingListView: View {
    @EnvironmentObject var productStore: ProductStore
    @State private var showingClearAlert = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                HStack {
                    Text("Shopping List")
                        .font(FontManager.bold(size: 28))
                        .foregroundColor(ColorManager.primaryBlue)
                    
                    Spacer()
                    
                    if !productStore.shoppingListProducts.isEmpty {
                        Button(action: {
                            showingClearAlert = true
                        }) {
                            Text("Clear List")
                                .font(FontManager.medium(size: 16))
                                .foregroundColor(ColorManager.statusNeedToBuy)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if productStore.shoppingListProducts.isEmpty {
                    EmptyShoppingListView()
                    
                    Spacer()
                } else {
                    VStack(spacing: 0) {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(productStore.shoppingListProducts) { product in
                                    ShoppingListCard(product: product)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                            .padding(.bottom, 10)
                        }
                    }
                }
            }
        }
        .alert("Clear Shopping List", isPresented: $showingClearAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                clearShoppingList()
            }
        } message: {
            Text("This will mark all items as purchased and move them to stock. Are you sure?")
        }
    }
    
    private func clearShoppingList() {
        for product in productStore.shoppingListProducts {
            productStore.markAsPurchased(product)
        }
    }
}

struct EmptyShoppingListView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "cart")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorManager.primaryBlue.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("Your shopping list is empty")
                    .font(FontManager.bold(size: 24))
                    .foregroundColor(ColorManager.primaryBlue)
                    .multilineTextAlignment(.center)
                
                Text("All your products are in order!")
                    .font(FontManager.regular(size: 16))
                    .foregroundColor(ColorManager.darkGray)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct ShoppingListCard: View {
    let product: Product
    @EnvironmentObject var productStore: ProductStore
    @State private var showingPurchaseAnimation = false
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(product.name)
                    .font(FontManager.medium(size: 18))
                    .foregroundColor(ColorManager.primaryBlue)
                    .lineLimit(2)
                
                Text("\(product.brand) • \(product.category.displayName)")
                    .font(FontManager.regular(size: 14))
                    .foregroundColor(ColorManager.darkGray)
                
                if !product.comment.isEmpty {
                    Text(product.comment)
                        .font(FontManager.regular(size: 12))
                        .foregroundColor(ColorManager.darkGray.opacity(0.8))
                        .italic()
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            VStack(spacing: 8) {
                Text("\(product.quantity) pcs")
                    .font(FontManager.medium(size: 14))
                    .foregroundColor(ColorManager.darkGray)
                
                Button(action: {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        showingPurchaseAnimation = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        productStore.markAsPurchased(product)
                    }
                }) {
                    Text("Purchased")
                        .font(FontManager.medium(size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            LinearGradient(
                                colors: [ColorManager.statusInUse, ColorManager.primaryYellow],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .scaleEffect(showingPurchaseAnimation ? 1.1 : 1.0)
                }
                .disabled(showingPurchaseAnimation)
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .opacity(showingPurchaseAnimation ? 0.6 : 1.0)
    }
}

#Preview {
    ShoppingListView()
        .environmentObject(ProductStore())
}
