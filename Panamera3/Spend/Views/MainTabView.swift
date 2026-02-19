import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var budgetViewModel: BudgetViewModel
    
    var body: some View {
        TabView {
            BudgetView(budgetViewModel: budgetViewModel)
                .tabItem {
                    Image(systemName: "creditcard")
                    Text("Budget")
                }
                .tag(0)
            
            PurchasesListView(budgetViewModel: budgetViewModel)
                .tabItem {
                    Image(systemName: "bag")
                    Text("Purchases")
                }
                .tag(1)
            
            AnalyticsView(budgetViewModel: budgetViewModel)
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Analytics")
                }
                .tag(2)
            
            CategoriesView(budgetViewModel: budgetViewModel)
                .tabItem {
                    Image(systemName: "tag")
                    Text("Categories")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(Color.theme.accentYellow)
    }
}

struct AnalyticsView: View {
    @ObservedObject var budgetViewModel: BudgetViewModel
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                HStack {
                    Text("Analytics")
                        .font(.lumierepolis(32, weight: .bold))
                        .foregroundColor(Color.theme.textWhite)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if budgetViewModel.budget.purchases.isEmpty {
                    Spacer()
                    EmptyAnalyticsView()
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            BudgetOverviewCard(budget: budgetViewModel.budget)
                            
                            CategoryBreakdownCard(purchases: budgetViewModel.budget.purchases)
                            
                            SpendingTrendCard(purchases: budgetViewModel.budget.purchases)
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
    }
}

struct CategoriesView: View {
    @ObservedObject var budgetViewModel: BudgetViewModel
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Text("Categories")
                        .font(.lumierepolis(32, weight: .bold))
                        .foregroundColor(Color.theme.textWhite)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(PurchaseCategory.allCases, id: \.self) { category in
                            CategoryCard(
                                name: category.displayName,
                                purchases: budgetViewModel.budget.purchases.filter { $0.category == category.displayName },
                                isDefault: true
                            )
                        }
                        
                        ForEach(budgetViewModel.customCategories, id: \.self) { category in
                            CategoryCard(
                                name: category,
                                purchases: budgetViewModel.budget.purchases.filter { $0.category == category },
                                isDefault: false
                            )
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}

struct EmptyAnalyticsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.bar")
                .font(.system(size: 60))
                .foregroundColor(Color.theme.textWhite.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("No Data to Analyze")
                    .font(.lumierepolis(20, weight: .bold))
                    .foregroundColor(Color.theme.textWhite)
                
                Text("Add some purchases to see your spending analytics and insights.")
                    .font(.lumierepolis(16, weight: .light))
                    .foregroundColor(Color.theme.textWhite.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(40)
    }
}

struct BudgetOverviewCard: View {
    let budget: Budget
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Budget Overview")
                .font(.lumierepolis(18, weight: .bold))
                .foregroundColor(Color.theme.textBlack)
            
            HStack(spacing: 20) {
                OverviewItem(title: "Limit", amount: budget.limit, color: Color.theme.infoBlue)
                OverviewItem(title: "Spent", amount: budget.spent, color: Color.theme.warningRed)
                OverviewItem(title: "Left", amount: budget.remaining, color: Color.theme.successGreen)
            }
        }
        .padding(20)
        .background(Color.theme.cardGradient)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct OverviewItem: View {
    let title: String
    let amount: Double
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.lumierepolis(12, weight: .light))
                .foregroundColor(Color.theme.textBlack.opacity(0.6))
            
            Text(String(format: "$%.0f", amount))
                .font(.lumierepolis(16, weight: .bold))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
    }
}

struct CategoryBreakdownCard: View {
    let purchases: [Purchase]
    
    var categoryTotals: [(String, Double)] {
        let grouped = Dictionary(grouping: purchases, by: { $0.category })
        return grouped.map { (category, purchases) in
            (category, purchases.reduce(0) { $0 + $1.amount })
        }.sorted { $0.1 > $1.1 }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Category Breakdown")
                .font(.lumierepolis(18, weight: .bold))
                .foregroundColor(Color.theme.textBlack)
            
            VStack(spacing: 12) {
                ForEach(categoryTotals, id: \.0) { category, total in
                    HStack {
                        Text(category)
                            .font(.lumierepolis(14, weight: .light))
                            .foregroundColor(Color.theme.textBlack)
                        
                        Spacer()
                        
                        Text(String(format: "$%.2f", total))
                            .font(.lumierepolis(14, weight: .bold))
                            .foregroundColor(Color.theme.primaryPink)
                    }
                }
            }
        }
        .padding(20)
        .background(Color.theme.cardGradient)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct SpendingTrendCard: View {
    let purchases: [Purchase]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(.lumierepolis(18, weight: .bold))
                .foregroundColor(Color.theme.textBlack)
            
            Text("Total Purchases: \(purchases.count)")
                .font(.lumierepolis(14, weight: .light))
                .foregroundColor(Color.theme.textBlack.opacity(0.7))
            
            if let lastPurchase = purchases.sorted(by: { $0.date > $1.date }).first {
                Text("Last Purchase: \(lastPurchase.date.formatted(date: .abbreviated, time: .omitted))")
                    .font(.lumierepolis(14, weight: .light))
                    .foregroundColor(Color.theme.textBlack.opacity(0.7))
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.theme.cardGradient)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct CategoryCard: View {
    let name: String
    let purchases: [Purchase]
    let isDefault: Bool
    
    var totalSpent: Double {
        purchases.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: categoryIcon)
                .font(.system(size: 24))
                .foregroundColor(Color.theme.primaryPink)
                .frame(width: 50, height: 50)
                .background(Color.theme.lightPink.opacity(0.3))
                .cornerRadius(25)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.lumierepolis(16, weight: .bold))
                    .foregroundColor(Color.theme.textBlack)
                
                Text("\(purchases.count) purchases")
                    .font(.lumierepolis(14, weight: .light))
                    .foregroundColor(Color.theme.textBlack.opacity(0.6))
            }
            
            Spacer()
            
            Text(String(format: "$%.2f", totalSpent))
                .font(.lumierepolis(16, weight: .bold))
                .foregroundColor(Color.theme.primaryPink)
        }
        .padding(16)
        .background(Color.theme.cardGradient)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private var categoryIcon: String {
        switch name.lowercased() {
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

#Preview {
    MainTabView()
}
