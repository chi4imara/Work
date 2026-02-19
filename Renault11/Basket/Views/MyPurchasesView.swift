import SwiftUI

private struct PurchaseIdItem: Identifiable {
    let id: UUID
}

struct MyPurchasesView: View {
    @ObservedObject var viewModel: PurchaseViewModel
    @State private var showingNewPurchase = false
    @State private var selectedPurchaseId: PurchaseIdItem?
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    HStack {
                        Text("My Purchases")
                            .font(FontManager.playfairBold(size: 28))
                            .foregroundColor(Color.theme.primaryWhite)
                        
                        Spacer()
                        
                        Button(action: {
                            showingNewPurchase = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(Color.theme.primaryYellow)
                                .frame(width: 44, height: 44)
                                .background(Color.theme.cardGradient)
                                .cornerRadius(22)
                        }
                    }
                    
                    HStack {
                        Text("Track all your planned and completed purchases")
                            .font(FontManager.playfairRegular(size: 16))
                            .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
                        Spacer()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                if viewModel.purchases.isEmpty {
                    EmptyPurchasesView {
                        showingNewPurchase = true
                    }
                } else {
                    PurchasesListView(viewModel: viewModel) { purchase in
                        selectedPurchaseId = PurchaseIdItem(id: purchase.id)
                    }
                }
            }
        }
        .sheet(isPresented: $showingNewPurchase) {
            NewPurchaseView(viewModel: viewModel)
        }
        .sheet(item: $selectedPurchaseId) { item in
            PurchaseDetailView(purchaseId: item.id, viewModel: viewModel)
        }
    }
}

struct EmptyPurchasesView: View {
    let onAddPurchase: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: "bag")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(Color.theme.primaryYellow.opacity(0.6))
                
                VStack(spacing: 8) {
                    Text("No Purchases Yet")
                        .font(FontManager.playfairBold(size: 24))
                        .foregroundColor(Color.theme.primaryWhite)
                    
                    Text("Add your first purchase and start planning")
                        .font(FontManager.playfairRegular(size: 16))
                        .foregroundColor(Color.theme.primaryWhite.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
            }
            
            Button(action: onAddPurchase) {
                Text("Add First Purchase")
                    .font(FontManager.playfairSemiBold(size: 18))
                    .foregroundColor(Color.theme.darkBlue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.theme.primaryYellow)
                    .cornerRadius(28)
                    .shadow(color: Color.theme.primaryYellow.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct PurchasesListView: View {
    @ObservedObject var viewModel: PurchaseViewModel
    let onPurchaseSelected: (Purchase) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.purchases.sorted(by: { $0.date > $1.date })) { purchase in
                    PurchaseCard(purchase: purchase) {
                        onPurchaseSelected(purchase)
                    } onToggleComplete: {
                        togglePurchaseCompletion(purchase)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private func togglePurchaseCompletion(_ purchase: Purchase) {
        var updatedPurchase = purchase
        updatedPurchase.isCompleted.toggle()
        
        if updatedPurchase.isCompleted && updatedPurchase.actualAmount == nil {
            updatedPurchase.actualAmount = updatedPurchase.plannedAmount
        }
        
        viewModel.updatePurchase(updatedPurchase)
    }
}

struct PurchaseCard: View {
    let purchase: Purchase
    let onTap: () -> Void
    let onToggleComplete: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                VStack {
                    Image(systemName: purchase.category.icon)
                        .font(.system(size: 24))
                        .foregroundColor(Color.theme.primaryYellow)
                        .frame(width: 50, height: 50)
                        .background(Color.theme.primaryYellow.opacity(0.2))
                        .cornerRadius(25)
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(purchase.name)
                            .font(FontManager.playfairSemiBold(size: 16))
                            .foregroundColor(Color.theme.primaryWhite)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        if purchase.isCompleted {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.theme.lightGreen)
                                .font(.system(size: 16))
                        }
                    }
                    
                    Text(purchase.category.rawValue)
                        .font(FontManager.playfairRegular(size: 14))
                        .foregroundColor(Color.theme.primaryWhite.opacity(0.7))
                    
                    HStack {
                        Text(String(format: "$%.0f", purchase.plannedAmount))
                            .font(FontManager.playfairBold(size: 14))
                            .foregroundColor(Color.theme.primaryYellow)
                        
                        if let actualAmount = purchase.actualAmount, purchase.isCompleted {
                            Text("(Actual: \(String(format: "$%.0f", actualAmount)))")
                                .font(FontManager.playfairRegular(size: 12))
                                .foregroundColor(Color.theme.primaryWhite.opacity(0.6))
                        }
                        
                        Spacer()
                        
                        Text(purchase.date, style: .date)
                            .font(FontManager.playfairRegular(size: 12))
                            .foregroundColor(Color.theme.primaryWhite.opacity(0.6))
                    }
                    
                    if !purchase.notes.isEmpty {
                        Text(purchase.notes)
                            .font(FontManager.playfairRegular(size: 12))
                            .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
                            .lineLimit(2)
                    }
                }
                
                VStack {
                    Button(action: onToggleComplete) {
                        Image(systemName: purchase.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 24))
                            .foregroundColor(purchase.isCompleted ? Color.theme.lightGreen : Color.theme.primaryWhite.opacity(0.5))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                }
            }
            .padding(16)
            .background(Color.theme.cardGradient)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(purchase.isCompleted ? Color.theme.lightGreen.opacity(0.3) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MyPurchasesView(viewModel: PurchaseViewModel())
}
