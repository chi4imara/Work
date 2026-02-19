import SwiftUI

struct PurchaseListView: View {
    @ObservedObject var viewModel: PurchaseViewModel
    @State private var showingAddPurchase = false
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(0..<8, id: \.self) { index in
                Circle()
                    .fill(ColorTheme.white.opacity(0.1))
                    .frame(width: CGFloat.random(in: 8...18))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .animation(
                        Animation.linear(duration: Double.random(in: 5...10))
                            .repeatForever(autoreverses: false),
                        value: UUID()
                    )
            }
            
            VStack(spacing: 0) {
                HStack {
                    Text("Purchases")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(ColorTheme.white)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddPurchase = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(ColorTheme.white)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.sortedPurchases.isEmpty {
                    VStack(spacing: 24) {
                        Spacer()
                        
                        Image(systemName: "bag.badge.plus")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(ColorTheme.white.opacity(0.7))
                        
                        VStack(spacing: 12) {
                            Text("Here will appear your purchases.")
                                .font(.ubuntu(20, weight: .medium))
                                .foregroundColor(ColorTheme.white)
                                .multilineTextAlignment(.center)
                            
                            Text("Add the first one to record the fact of purchase.")
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(ColorTheme.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 32)
                        
                        Button(action: {
                            showingAddPurchase = true
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Add Purchase")
                                    .font(.ubuntu(16, weight: .medium))
                            }
                            .foregroundColor(ColorTheme.primaryBlue)
                            .frame(height: 48)
                            .frame(maxWidth: .infinity)
                            .background(ColorTheme.white)
                            .cornerRadius(24)
                            .shadow(color: ColorTheme.cardShadow, radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal, 32)
                        .padding(.top, 16)
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.sortedPurchases) { purchase in
                                NavigationLink(destination: PurchaseDetailView(purchaseId: purchase.id, viewModel: viewModel)) {
                                    PurchaseRowView(purchase: purchase)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddPurchase) {
            AddEditPurchaseView(viewModel: viewModel)
        }
    }
}

struct PurchaseRowView: View {
    let purchase: Purchase
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(purchase.whatBought)
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(ColorTheme.darkGray)
                        .lineLimit(2)
                    
                    if !purchase.whereBought.isEmpty {
                        Text(purchase.whereBought)
                            .font(.ubuntu(14, weight: .regular))
                            .foregroundColor(ColorTheme.darkGray.opacity(0.7))
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(purchase.date, style: .date)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorTheme.primaryBlue)
                    
                    Text(purchase.date, style: .time)
                        .font(.ubuntu(12, weight: .regular))
                        .foregroundColor(ColorTheme.darkGray.opacity(0.6))
                }
            }
        }
        .padding(16)
        .background(ColorTheme.cardBackground)
        .cornerRadius(16)
        .shadow(color: ColorTheme.cardShadow, radius: 8, x: 0, y: 4)
    }
}
