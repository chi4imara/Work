import SwiftUI

struct PurchaseListView: View {
    @EnvironmentObject var purchaseStore: PurchaseStore
    @State private var showingAddPurchase = false
    @State private var showingFilters = false
    @State private var purchaseToEdit: Purchase?
    @State private var purchaseToDelete: Purchase?
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("My Purchases")
                                .font(.titleLarge)
                                .foregroundColor(.primaryWhite)
                            
                            Text("\(purchaseStore.filteredPurchases.count) items")
                                .font(.bodySmall)
                                .foregroundColor(.primaryWhite.opacity(0.7))
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 15) {
                            Button(action: { showingFilters = true }) {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                                    .font(.system(size: 24))
                                    .foregroundColor(.primaryYellow)
                            }
                            
                            Button(action: { showingAddPurchase = true }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.primaryYellow)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    if purchaseStore.filteredPurchases.isEmpty {
                        EmptyStateView(
                            icon: "house",
                            title: "No purchases yet",
                            description: "Add your first purchase to get started",
                            buttonTitle: "Add First Purchase",
                            buttonAction: { showingAddPurchase = true }
                        )
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(purchaseStore.filteredPurchases) { purchase in
                                    NavigationLink(destination: PurchaseDetailView(purchase: purchase)) {
                                        PurchaseCardView(purchase: purchase)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .swipeActions(edge: .trailing) {
                                        Button("Delete") {
                                            purchaseToDelete = purchase
                                            showingDeleteAlert = true
                                        }
                                        .tint(.red)
                                    }
                                    .swipeActions(edge: .leading) {
                                        Button("Edit") {
                                            purchaseToEdit = purchase
                                        }
                                        .tint(.blue)
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
        .sheet(isPresented: $showingAddPurchase) {
            AddEditPurchaseView()
        }
        .sheet(item: $purchaseToEdit) { purchase in
            AddEditPurchaseView(purchase: purchase)
        }
        .sheet(isPresented: $showingFilters) {
            FilterView()
        }
        .alert("Delete Purchase", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let purchase = purchaseToDelete {
                    purchaseStore.deletePurchase(purchase)
                }
            }
        } message: {
            Text("Are you sure you want to delete this purchase? This action cannot be undone.")
        }
    }
}

struct PurchaseCardView: View {
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
                
                if purchase.isFavorite {
                    Image(systemName: "star.fill")
                        .foregroundColor(.primaryYellow)
                }
            }
            
            HStack {
                Text("Service: \(purchase.serviceLifeYears) years")
                    .font(.bodySmall)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                StatusBadge(status: purchase.status)
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct StatusBadge: View {
    let status: PurchaseStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
    
    private var backgroundColor: Color {
        switch status {
        case .normal:
            return .statusNormal
        case .soonReplacement:
            return .statusWarning
        case .overdue:
            return .statusDanger
        }
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let description: String
    let buttonTitle: String
    let buttonAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.primaryYellow.opacity(0.7))
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.titleMedium)
                    .foregroundColor(.primaryWhite)
                
                Text(description)
                    .font(.bodyMedium)
                    .foregroundColor(.primaryWhite.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            
            Button(action: buttonAction) {
                Text(buttonTitle)
                    .font(.bodyLarge)
                    .foregroundColor(.primaryBlue)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.primaryYellow)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}

#Preview {
    PurchaseListView()
        .environmentObject(PurchaseStore())
}
