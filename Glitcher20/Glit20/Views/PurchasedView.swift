import SwiftUI

struct PurchasedView: View {
    @EnvironmentObject var viewModel: WardrobeViewModel

    var body: some View {
        ZStack {
            AppColorScheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Purchased")
                        .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                        .foregroundColor(Color.textPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.purchasedItems.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 60))
                            .foregroundColor(Color.textSecondary)
                        
                        Text("You haven't bought anything yet.")
                            .font(FontManager.playfairDisplay(size: 18))
                            .foregroundColor(Color.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.purchasedItems) { item in
                                NavigationLink(destination: ItemDetailView(itemId: item.id, viewModel: viewModel)) {
                                    PurchasedItemCardView(item: item, viewModel: viewModel)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
        }
    }
}

struct PurchasedItemCardView: View {
    let item: WardrobeItem
    let viewModel: WardrobeViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(item.name)
                    .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(Color.textPrimary)
                    .lineLimit(2)
                
                Text(item.category)
                    .font(FontManager.playfairDisplay(size: 14))
                    .foregroundColor(Color.primaryYellow)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.primaryYellow.opacity(0.2))
                    .cornerRadius(8)
                
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
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(Color.secondaryGreen)
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
    PurchasedView()
}
