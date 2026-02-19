import SwiftUI

struct PurchasesListView: View {
    @ObservedObject var budgetViewModel: BudgetViewModel
    @State private var showingNewPurchase = false
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Purchases")
                        .font(.lumierepolis(32, weight: .bold))
                        .foregroundColor(Color.theme.textWhite)
                    
                    Spacer()
                    
                    Button(action: {
                        showingNewPurchase = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Color.theme.accentYellow)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.theme.textBlack.opacity(0.5))
                        
                        TextField("Search purchases...", text: $budgetViewModel.searchText)
                            .font(.lumierepolis(16, weight: .light))
                            .foregroundColor(Color.theme.textBlack)
                    }
                    .padding(16)
                    .background(Color.theme.cardWhite)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    
                    Menu {
                        Button("All Categories") {
                            budgetViewModel.selectedCategory = ""
                        }
                        
                        ForEach(budgetViewModel.allCategories, id: \.self) { category in
                            Button(category) {
                                budgetViewModel.selectedCategory = category
                            }
                        }
                    } label: {
                        HStack {
                            Text(budgetViewModel.selectedCategory.isEmpty ? "All Categories" : budgetViewModel.selectedCategory)
                                .font(.lumierepolis(16, weight: .light))
                                .foregroundColor(Color.theme.textBlack)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                                .font(.system(size: 12))
                                .foregroundColor(Color.theme.textBlack.opacity(0.5))
                        }
                        .padding(16)
                        .background(Color.theme.cardWhite)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                if budgetViewModel.filteredPurchases.isEmpty {
                    Spacer()
                    EmptyPurchasesView(hasSearchOrFilter: !budgetViewModel.searchText.isEmpty || !budgetViewModel.selectedCategory.isEmpty)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(budgetViewModel.filteredPurchases) { purchase in
                                NavigationLink(destination: PurchaseDetailView(purchaseId: purchase.id, budgetViewModel: budgetViewModel)) {
                                    PurchaseListCard(purchase: purchase)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(isPresented: $showingNewPurchase) {
            NewPurchaseView(budgetViewModel: budgetViewModel)
        }
    }
}

struct PurchaseListCard: View {
    let purchase: Purchase
    
    var body: some View {
        HStack(spacing: 15) {
            VStack {
                Image(systemName: categoryIcon(for: purchase.category))
                    .font(.system(size: 20))
                    .foregroundColor(Color.theme.primaryPink)
                    .frame(width: 40, height: 40)
                    .background(Color.theme.lightPink.opacity(0.3))
                    .cornerRadius(20)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(purchase.name)
                    .font(.lumierepolis(16, weight: .bold))
                    .foregroundColor(Color.theme.textBlack)
                    .lineLimit(1)
                
                Text(purchase.category)
                    .font(.lumierepolis(14, weight: .light))
                    .foregroundColor(Color.theme.textBlack.opacity(0.6))
                
                Text(purchase.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.lumierepolis(12, weight: .light))
                    .foregroundColor(Color.theme.textBlack.opacity(0.5))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
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
    
    private func categoryIcon(for category: String) -> String {
        switch category.lowercased() {
        case "outerwear":
            return "tshirt"
        case "bottoms":
            return "rectangle.stack"
        case "shoes":
            return "shoe"
        case "accessories":
            return "bag"
        case "jewelry":
            return "sparkles"
        default:
            return "tag"
        }
    }
}

struct EmptyPurchasesView: View {
    let hasSearchOrFilter: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: hasSearchOrFilter ? "magnifyingglass" : "bag")
                .font(.system(size: 60))
                .foregroundColor(Color.theme.textWhite.opacity(0.5))
            
            VStack(spacing: 8) {
                Text(hasSearchOrFilter ? "No Results Found" : "No Purchases Yet")
                    .font(.lumierepolis(20, weight: .bold))
                    .foregroundColor(Color.theme.textWhite)
                
                Text(hasSearchOrFilter ? "Try adjusting your search or filter criteria" : "Your purchase list is empty. Add your first purchase to get started!")
                    .font(.lumierepolis(16, weight: .light))
                    .foregroundColor(Color.theme.textWhite.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(40)
    }
}

#Preview {
    PurchasesListView(budgetViewModel: BudgetViewModel())
}
