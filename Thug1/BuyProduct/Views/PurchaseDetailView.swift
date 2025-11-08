import SwiftUI

struct PurchaseDetailView: View {
    @EnvironmentObject var purchaseStore: PurchaseStore
    @Environment(\.dismiss) private var dismiss
    
    let purchase: Purchase
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(purchase.name)
                                    .font(.titleLarge)
                                    .foregroundColor(.primary)
                                
                                Text(purchase.category.rawValue)
                                    .font(.bodyLarge)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                purchaseStore.toggleFavorite(purchase)
                            }) {
                                Image(systemName: purchase.isFavorite ? "star.fill" : "star")
                                    .font(.system(size: 24))
                                    .foregroundColor(.primaryYellow)
                            }
                        }
                        
                        StatusBadge(status: purchase.status)
                    }
                    .padding(20)
                    .background(Color.cardBackground)
                    .cornerRadius(16)
                    
                    VStack(spacing: 16) {
                        DetailCard(
                            title: "Purchase Date",
                            value: purchase.purchaseDate.formatted(date: .long, time: .omitted),
                            icon: "calendar"
                        )
                        
                        DetailCard(
                            title: "Service Life",
                            value: "\(purchase.serviceLifeYears) years",
                            icon: "clock"
                        )
                        
                        DetailCard(
                            title: "End Date",
                            value: purchase.endDate.formatted(date: .long, time: .omitted),
                            icon: "calendar.badge.clock"
                        )
                        
                        DetailCard(
                            title: "Days Remaining",
                            value: purchase.daysRemaining >= 0 ? "\(purchase.daysRemaining) days" : "Overdue by \(abs(purchase.daysRemaining)) days",
                            icon: "hourglass"
                        )
                        
                        if !purchase.comment.isEmpty {
                            DetailCard(
                                title: "Comment",
                                value: purchase.comment,
                                icon: "text.bubble"
                            )
                        }
                        
                        DetailCard(
                            title: "Added",
                            value: purchase.dateAdded.formatted(date: .long, time: .shortened),
                            icon: "plus.circle"
                        )
                        
                        if purchase.dateUpdated != purchase.dateAdded {
                            DetailCard(
                                title: "Last Updated",
                                value: purchase.dateUpdated.formatted(date: .long, time: .shortened),
                                icon: "pencil.circle"
                            )
                        }
                    }
                    
                    VStack(spacing: 12) {
                        Button(action: { showingEditView = true }) {
                            HStack {
                                Image(systemName: "pencil")
                                Text("Edit Purchase")
                            }
                            .font(.bodyLarge)
                            .foregroundColor(.primaryBlue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.primaryYellow)
                            .cornerRadius(12)
                        }
                        
                        Button(action: { showingDeleteAlert = true }) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete Purchase")
                            }
                            .font(.bodyLarge)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.statusDanger)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(20)
                .padding(.bottom, 80)
            }
        }
        .navigationTitle("Purchase Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditView) {
            AddEditPurchaseView(purchase: purchase)
        }
        .alert("Delete Purchase", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                purchaseStore.deletePurchase(purchase)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this purchase? This action cannot be undone.")
        }
    }
}

struct DetailCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.primaryYellow)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.bodyMedium)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.bodyLarge)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
}

#Preview {
    NavigationView {
        PurchaseDetailView(purchase: Purchase(
            name: "Sample Purchase",
            category: .furniture,
            purchaseDate: Date(),
            serviceLifeYears: 5,
            comment: "This is a sample comment"
        ))
    }
    .environmentObject(PurchaseStore())
}
