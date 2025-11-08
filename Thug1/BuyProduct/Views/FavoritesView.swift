import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var purchaseStore: PurchaseStore
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("Favorite Purchases")
                            .font(.titleLarge)
                            .foregroundColor(.primaryWhite)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    if purchaseStore.favoritePurchases.isEmpty {
                        EmptyStateView(
                            icon: "star",
                            title: "No favorites yet",
                            description: "Mark purchases as favorites to see them here",
                            buttonTitle: "Go to Purchases",
                            buttonAction: {
                            }
                        )
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(purchaseStore.favoritePurchases) { purchase in
                                    NavigationLink(destination: PurchaseDetailView(purchase: purchase)) {
                                        FavoriteCardView(purchase: purchase)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .swipeActions(edge: .trailing) {
                                        Button("Remove") {
                                            purchaseStore.toggleFavorite(purchase)
                                        }
                                        .tint(.orange)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 100)
                        }
                    }
                }
            }
        }
    }
}

struct FavoriteCardView: View {
    let purchase: Purchase
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(purchase.name)
                        .font(.titleSmall)
                        .foregroundColor(.primary)
                    
                    Text("\(purchase.category.rawValue) • \(purchase.purchaseDate, formatter: DateFormatter.shortDate)")
                        .font(.bodySmall)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "star.fill")
                    .foregroundColor(.primaryYellow)
            }
            
            HStack {
                Text("Service: \(purchase.serviceLifeYears) years")
                    .font(.bodySmall)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                StatusBadge(status: purchase.status)
            }
            
            if !purchase.comment.isEmpty {
                Text(purchase.comment)
                    .font(.bodySmall)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .padding(.top, 4)
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    FavoritesView()
        .environmentObject(PurchaseStore())
}
