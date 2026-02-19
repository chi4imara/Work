import SwiftUI

struct TodayView: View {
    @ObservedObject var viewModel: PurchaseViewModel
    @State private var showingNewPurchase = false
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12: return "Good Morning"
        case 12..<18: return "Good Afternoon"
        default: return "Good Evening"
        }
    }
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(greeting)
                                    .font(FontManager.playfairBold(size: 28))
                                    .foregroundColor(Color.theme.primaryWhite)
                                
                                Text("Planning to shop today?")
                                    .font(FontManager.playfairRegular(size: 16))
                                    .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
                            }
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    DailyBudgetCard(budget: viewModel.dailyBudget) {
                        showingNewPurchase = true
                    }
                    .padding(.horizontal, 20)
                    
                    ShoppingListsSection(viewModel: viewModel) {
                        showingNewPurchase = true
                    }
                    .padding(.horizontal, 20)
                    
                    CollectionSection(viewModel: viewModel)
                        .padding(.horizontal, 20)
                    
                    DailyProgressIndicator(viewModel: viewModel)
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 30)
            }
        }
        .sheet(isPresented: $showingNewPurchase) {
            NewPurchaseView(viewModel: viewModel)
        }
    }
}

struct DailyBudgetCard: View {
    let budget: DailyBudget
    let onAddExpense: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Daily Budget")
                    .font(FontManager.playfairSemiBold(size: 20))
                    .foregroundColor(Color.theme.primaryWhite)
                Spacer()
            }
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Remaining")
                        .font(FontManager.playfairRegular(size: 14))
                        .foregroundColor(Color.theme.primaryWhite.opacity(0.7))
                    Text("$\(budget.remaining, specifier: "%.0f")")
                        .font(FontManager.playfairBold(size: 24))
                        .foregroundColor(Color.theme.primaryYellow)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Spent: $\(budget.spent, specifier: "%.0f")")
                        .font(FontManager.playfairRegular(size: 12))
                        .foregroundColor(Color.theme.primaryWhite.opacity(0.7))
                    Text("Limit: $\(budget.limit, specifier: "%.0f")")
                        .font(FontManager.playfairRegular(size: 12))
                        .foregroundColor(Color.theme.primaryWhite.opacity(0.7))
                }
            }
            
            ProgressView(value: budget.progress)
                .progressViewStyle(LinearProgressViewStyle(tint: Color.theme.primaryYellow))
                .scaleEffect(x: 1, y: 2, anchor: .center)
            
            Button(action: onAddExpense) {
                Text("Add Expense")
                    .font(FontManager.playfairMedium(size: 16))
                    .foregroundColor(Color.theme.darkBlue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.theme.primaryYellow)
                    .cornerRadius(22)
            }
        }
        .padding(20)
        .background(Color.theme.cardGradient)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct ShoppingListsSection: View {
    @ObservedObject var viewModel: PurchaseViewModel
    let onAddPurchase: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Shopping Lists")
                    .font(FontManager.playfairSemiBold(size: 20))
                    .foregroundColor(Color.theme.primaryWhite)
                Spacer()
                Button(action: onAddPurchase) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color.theme.primaryYellow)
                }
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(PurchaseCategory.allCases, id: \.self) { category in
                    CategoryCard(
                        category: category,
                        purchases: viewModel.purchasesForCategory(category).filter { !$0.isCompleted }
                    )
                }
            }
        }
    }
}

struct CategoryCard: View {
    let category: PurchaseCategory
    let purchases: [Purchase]
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: category.icon)
                    .font(.system(size: 20))
                    .foregroundColor(Color.theme.primaryYellow)
                Spacer()
                Text("\(purchases.count)")
                    .font(FontManager.playfairBold(size: 16))
                    .foregroundColor(Color.theme.primaryWhite)
            }
            
            HStack {
                Text(category.rawValue)
                    .font(FontManager.playfairMedium(size: 14))
                    .foregroundColor(Color.theme.primaryWhite)
                Spacer()
            }
            
            if !purchases.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(purchases.prefix(2)) { purchase in
                        HStack {
                            Text("• \(purchase.name)")
                                .font(FontManager.playfairRegular(size: 12))
                                .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
                            Spacer()
                        }
                    }
                    if purchases.count > 2 {
                        Text("and \(purchases.count - 2) more...")
                            .font(FontManager.playfairRegular(size: 10))
                            .foregroundColor(Color.theme.primaryWhite.opacity(0.6))
                    }
                }
            } else {
                Text("No items")
                    .font(FontManager.playfairRegular(size: 12))
                    .foregroundColor(Color.theme.primaryWhite.opacity(0.6))
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.theme.cardGradient)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct CollectionSection: View {
    @ObservedObject var viewModel: PurchaseViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Acquired Collection")
                    .font(FontManager.playfairSemiBold(size: 20))
                    .foregroundColor(Color.theme.primaryWhite)
                Spacer()
            }
            
            let completedPurchases = viewModel.completedPurchases()
            
            if completedPurchases.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "photo.on.rectangle")
                        .font(.system(size: 40))
                        .foregroundColor(Color.theme.primaryWhite.opacity(0.4))
                    Text("No purchases yet")
                        .font(FontManager.playfairRegular(size: 14))
                        .foregroundColor(Color.theme.primaryWhite.opacity(0.6))
                    Text("Add your first purchase to start building your collection")
                        .font(FontManager.playfairRegular(size: 12))
                        .foregroundColor(Color.theme.primaryWhite.opacity(0.5))
                        .multilineTextAlignment(.center)
                }
                .padding(30)
                .frame(maxWidth: .infinity)
                .background(Color.theme.cardGradient)
                .cornerRadius(12)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(completedPurchases.prefix(10)) { purchase in
                            CollectionItemView(purchase: purchase)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.horizontal, -20)
            }
        }
    }
}

struct CollectionItemView: View {
    let purchase: Purchase
    
    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.theme.primaryYellow.opacity(0.3))
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: purchase.category.icon)
                        .font(.system(size: 24))
                        .foregroundColor(Color.theme.primaryYellow)
                )
            
            Text(purchase.name)
                .font(FontManager.playfairRegular(size: 10))
                .foregroundColor(Color.theme.primaryWhite)
                .lineLimit(1)
                .multilineTextAlignment(.center)
        }
        .frame(width: 80)
    }
}

struct DailyProgressIndicator: View {
    @ObservedObject var viewModel: PurchaseViewModel
    
    var body: some View {
        let todayPurchases = viewModel.purchasesForDate(Date())
        let completedCount = todayPurchases.filter { $0.isCompleted }.count
        let totalCount = todayPurchases.count
        let progress = totalCount > 0 ? Double(completedCount) / Double(totalCount) : 0
        
        VStack(spacing: 16) {
            HStack {
                Text("Today's Progress")
                    .font(FontManager.playfairSemiBold(size: 20))
                    .foregroundColor(Color.theme.primaryWhite)
                Spacer()
            }
            
            HStack(spacing: 20) {
                VStack(spacing: 4) {
                    Text("\(completedCount)/\(totalCount)")
                        .font(FontManager.playfairBold(size: 24))
                        .foregroundColor(Color.theme.primaryYellow)
                    Text("Purchases")
                        .font(FontManager.playfairRegular(size: 12))
                        .foregroundColor(Color.theme.primaryWhite.opacity(0.7))
                }
                
                Spacer()
                
                CircularProgressView(progress: progress)
                    .frame(width: 60, height: 60)
            }
        }
        .padding(20)
        .background(Color.theme.cardGradient)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.theme.primaryWhite.opacity(0.3), lineWidth: 4)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.theme.primaryYellow, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1), value: progress)
            
            Text("\(Int(progress * 100))%")
                .font(FontManager.playfairBold(size: 12))
                .foregroundColor(Color.theme.primaryWhite)
        }
    }
}

#Preview {
    TodayView(viewModel: PurchaseViewModel())
}
