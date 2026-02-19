import SwiftUI

struct BudgetView: View {
    @ObservedObject var budgetViewModel: BudgetViewModel
    @State private var showingBudgetSettings = false
    @State private var showingNewPurchase = false
    
    var body: some View {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        HStack {
                            Text("Budget")
                                .font(.lumierepolis(32, weight: .bold))
                                .foregroundColor(Color.theme.textWhite)
                            
                            Spacer()
                            
                            Button(action: {
                                showingBudgetSettings = true
                            }) {
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color.theme.accentYellow)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        
                        BudgetInfoCard(budget: budgetViewModel.budget)
                            .padding(.horizontal, 20)
                        
                        Button(action: {
                            showingNewPurchase = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 20))
                                Text("Add Purchase")
                                    .font(.lumierepolis(18, weight: .bold))
                            }
                            .foregroundColor(Color.theme.textBlack)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.theme.buttonGradient)
                            .cornerRadius(28)
                            .shadow(color: Color.theme.accentYellow.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Recent Purchases")
                                    .font(.lumierepolis(22, weight: .bold))
                                    .foregroundColor(Color.theme.textWhite)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            
                            if budgetViewModel.recentPurchases.isEmpty {
                                EmptyStateView(message: "No purchases. Add your first one.")
                                    .padding(.horizontal, 20)
                            } else {
                                LazyVStack(spacing: 12) {
                                    ForEach(budgetViewModel.recentPurchases) { purchase in
                                        NavigationLink(destination: PurchaseDetailView(purchaseId: purchase.id, budgetViewModel: budgetViewModel)) {
                                            PurchaseCard(purchase: purchase)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                }
            }
        .sheet(isPresented: $showingBudgetSettings) {
            BudgetSettingsView(budgetViewModel: budgetViewModel)
        }
        .sheet(isPresented: $showingNewPurchase) {
            NewPurchaseView(budgetViewModel: budgetViewModel)
        }
    }
}

struct BudgetInfoCard: View {
    let budget: Budget
    
    var body: some View {
        VStack(spacing: 16) {
            BudgetInfoRow(title: "Budget Limit", amount: budget.limit, color: Color.theme.textBlack)
            BudgetInfoRow(title: "Spent", amount: budget.spent, color: Color.theme.textBlack)
            BudgetInfoRow(title: "Remaining", amount: budget.remaining, color: budget.remaining < 0 ? Color.theme.warningRed : Color.theme.successGreen)
        }
        .padding(20)
        .background(Color.theme.cardGradient)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct BudgetInfoRow: View {
    let title: String
    let amount: Double
    let color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .font(.lumierepolis(16, weight: .light))
                .foregroundColor(Color.theme.textBlack.opacity(0.7))
            
            Spacer()
            
            Text(String(format: "$%.2f", amount))
                .font(.lumierepolis(18, weight: .bold))
                .foregroundColor(color)
        }
    }
}

struct PurchaseCard: View {
    let purchase: Purchase
    
    var body: some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 4) {
                Text(purchase.name)
                    .font(.lumierepolis(16, weight: .bold))
                    .foregroundColor(Color.theme.textBlack)
                    .lineLimit(1)
                
                Text(purchase.category)
                    .font(.lumierepolis(14, weight: .light))
                    .foregroundColor(Color.theme.textBlack.opacity(0.6))
                
                Text(purchase.date, style: .date)
                    .font(.lumierepolis(12, weight: .light))
                    .foregroundColor(Color.theme.textBlack.opacity(0.5))
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(String(format: "$%.2f", purchase.amount))
                    .font(.lumierepolis(16, weight: .bold))
                    .foregroundColor(Color.theme.textBlack)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(Color.theme.textBlack.opacity(0.4))
            }
        }
        .padding(16)
        .background(Color.theme.cardGradient)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct EmptyStateView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "bag")
                .font(.system(size: 50))
                .foregroundColor(Color.theme.textWhite.opacity(0.5))
            
            Text(message)
                .font(.lumierepolis(16, weight: .light))
                .foregroundColor(Color.theme.textWhite.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(40)
        .frame(maxWidth: .infinity)
        .background(Color.theme.cardWhite.opacity(0.1))
        .cornerRadius(16)
    }
}

#Preview {
    BudgetView(budgetViewModel: BudgetViewModel())
}
