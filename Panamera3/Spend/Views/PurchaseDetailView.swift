import SwiftUI

struct PurchaseDetailView: View {
    let purchaseId: UUID
    @ObservedObject var budgetViewModel: BudgetViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var purchase: Purchase? {
        budgetViewModel.getPurchase(byId: purchaseId)
    }
    
    var body: some View {
        Group {
            if let currentPurchase = purchase {
                purchaseDetailContent(purchase: currentPurchase)
            } else {
                ZStack {
                    Color.theme.backgroundGradient
                        .ignoresSafeArea()
                    
                    Text("Purchase not found")
                        .font(.lumierepolis(18, weight: .light))
                        .foregroundColor(Color.theme.textWhite)
                }
            }
        }
    }
    
    private func purchaseDetailContent(purchase: Purchase) -> some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .medium))
                            Text("Back")
                                .font(.lumierepolis(16, weight: .light))
                        }
                        .foregroundColor(Color.theme.textWhite)
                    }
                    
                    Spacer()
                    
                    Text(purchase.name.count > 15 ? String(purchase.name.prefix(15)) + "..." : purchase.name)
                        .font(.lumierepolis(20, weight: .bold))
                        .foregroundColor(Color.theme.textWhite)
                    
                    Spacer()
                    
                    Button("") { }
                        .font(.lumierepolis(16, weight: .light))
                        .foregroundColor(Color.clear)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 30)
                
                ScrollView {
                    VStack(spacing: 25) {
                        VStack(spacing: 20) {
                            DetailRow(title: "Item Name", value: purchase.name)
                            
                            Divider()
                                .background(Color.theme.textBlack.opacity(0.1))
                            
                            DetailRow(title: "Category", value: purchase.category)
                            
                            Divider()
                                .background(Color.theme.textBlack.opacity(0.1))
                            
                            DetailRow(title: "Amount", value: String(format: "$%.2f", purchase.amount), valueColor: Color.theme.primaryPink)
                            
                            Divider()
                                .background(Color.theme.textBlack.opacity(0.1))
                            
                            DetailRow(title: "Purchase Date", value: purchase.date.formatted(date: .abbreviated, time: .omitted))
                            
                            Divider()
                                .background(Color.theme.textBlack.opacity(0.1))
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Description")
                                        .font(.lumierepolis(16, weight: .bold))
                                        .foregroundColor(Color.theme.textBlack.opacity(0.7))
                                    Spacer()
                                }
                                
                                Text(purchase.description.isEmpty ? "No description provided" : purchase.description)
                                    .font(.lumierepolis(16, weight: .light))
                                    .foregroundColor(purchase.description.isEmpty ? Color.theme.textBlack.opacity(0.5) : Color.theme.textBlack)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(24)
                        .background(Color.theme.cardGradient)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 15) {
                            Button(action: {
                                showingEditView = true
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 18))
                                    Text("Edit Purchase")
                                        .font(.lumierepolis(18, weight: .bold))
                                }
                                .foregroundColor(Color.theme.textBlack)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.theme.buttonGradient)
                                .cornerRadius(28)
                                .shadow(color: Color.theme.accentYellow.opacity(0.3), radius: 10, x: 0, y: 5)
                            }
                            
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "trash")
                                        .font(.system(size: 18))
                                    Text("Delete Purchase")
                                        .font(.lumierepolis(18, weight: .bold))
                                }
                                .foregroundColor(Color.theme.textWhite)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.theme.warningRed)
                                .cornerRadius(28)
                                .shadow(color: Color.theme.warningRed.opacity(0.3), radius: 10, x: 0, y: 5)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 50)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingEditView) {
            EditPurchaseView(purchaseId: purchaseId, budgetViewModel: budgetViewModel)
        }
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Delete Purchase"),
                message: Text("Are you sure you want to delete this purchase? This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    budgetViewModel.removePurchase(withId: purchaseId)
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    let valueColor: Color
    
    init(title: String, value: String, valueColor: Color = Color.theme.textBlack) {
        self.title = title
        self.value = value
        self.valueColor = valueColor
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.lumierepolis(16, weight: .bold))
                .foregroundColor(Color.theme.textBlack.opacity(0.7))
            
            Spacer()
            
            Text(value)
                .font(.lumierepolis(16, weight: .bold))
                .foregroundColor(valueColor)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    let samplePurchase = Purchase(
        name: "Designer Coat",
        category: "Outerwear",
        amount: 299.99,
        date: Date(),
        description: "A beautiful winter coat from a premium brand. Perfect for cold weather and formal occasions."
    )
    let viewModel = BudgetViewModel()
    viewModel.addPurchase(samplePurchase)
    
    return PurchaseDetailView(purchaseId: samplePurchase.id, budgetViewModel: viewModel)
}
