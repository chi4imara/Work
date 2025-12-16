import SwiftUI

struct ItemDetailsView: View {
    @EnvironmentObject var itemsViewModel: ItemsViewModel
    @Environment(\.dismiss) private var dismiss
    
    let itemId: UUID
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var item: Item? {
        itemsViewModel.items.first { $0.id == itemId }
    }
    
    var body: some View {
        Group {
            if let item = item {
                NavigationView {
                    ZStack {
                        AppColors.backgroundGradient
                            .ignoresSafeArea()
                        
                        ScrollView {
                            VStack(spacing: 24) {
                                headerView
                                
                                itemDetailsCard(item: item)
                                
                                actionButtonsView(item: item)
                                
                                Spacer(minLength: 40)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Close") {
                            dismiss()
                        }
                        .foregroundColor(AppColors.neutralGray)
                    }
                }
                .sheet(isPresented: $showingEditView) {
                    EditItemView(itemId: itemId)
                        .environmentObject(itemsViewModel)
                }
            } else {
                Text("Item not found")
                    .foregroundColor(AppColors.neutralGray)
            }
        }
        .alert("Delete Item", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteItem()
            }
        } message: {
            Text("Are you sure you want to delete this item? This action cannot be undone.")
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Item Details")
                .font(AppTypography.title1)
                .foregroundColor(AppColors.primaryPurple)
            
            Text("View and manage your item")
                .font(AppTypography.callout)
                .foregroundColor(AppColors.neutralGray)
        }
    }
    
    private func itemDetailsCard(item: Item) -> some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(item.name)
                        .font(AppTypography.title2)
                        .foregroundColor(AppColors.darkGray)
                        .strikethrough(item.status == .purchased)
                    
                    Spacer()
                    
                    StatusBadge(status: item.status)
                }
                
                Divider()
                    .background(AppColors.neutralGray.opacity(0.3))
            }
            
            VStack(spacing: 16) {
                DetailRow(
                    title: "Price",
                    value: "$\(Int(item.estimatedPrice))",
                    valueColor: AppColors.blueText
                )
                
                DetailRow(
                    title: "Priority",
                    value: item.priority.displayName,
                    valueColor: AppColors.priorityColor(for: item.priority),
                    showColorIndicator: true
                )
                
                DetailRow(
                    title: "Status",
                    value: item.status.displayName,
                    valueColor: AppColors.statusColor(for: item.status)
                )
                
                DetailRow(
                    title: "Date Added",
                    value: formatDate(item.dateAdded),
                    valueColor: AppColors.neutralGray
                )
                
                if let purchaseDate = item.datePurchased {
                    DetailRow(
                        title: "Date Purchased",
                        value: formatDate(purchaseDate),
                        valueColor: AppColors.successGreen
                    )
                }
            }
            
            if !item.comment.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                        .background(AppColors.neutralGray.opacity(0.3))
                    
                    Text("Comment")
                        .font(AppTypography.subheadline)
                        .foregroundColor(AppColors.darkGray)
                    
                    Text(item.comment)
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.neutralGray)
                        .lineSpacing(2)
                }
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                        .background(AppColors.neutralGray.opacity(0.3))
                    
                    Text("Comment")
                        .font(AppTypography.subheadline)
                        .foregroundColor(AppColors.darkGray)
                    
                    Text("No comment available")
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.neutralGray.opacity(0.7))
                        .italic()
                }
            }
        }
        .padding(20)
        .cardStyle()
    }
    
    private func actionButtonsView(item: Item) -> some View {
        VStack(spacing: 16) {
            Button(action: {
                togglePurchaseStatus(item: item)
            }) {
                HStack {
                    Image(systemName: item.status == .purchased ? "xmark.circle" : "checkmark.circle")
                        .font(.system(size: 18, weight: .medium))
                    
                    Text(item.status == .purchased ? "Mark as Not Purchased" : "Mark as Purchased")
                        .font(AppTypography.buttonText)
                }
                .frame(maxWidth: .infinity)
                .primaryButtonStyle()
            }
            
            HStack(spacing: 12) {
                Button(action: { showingEditView = true }) {
                    HStack {
                        Image(systemName: "pencil")
                            .font(.system(size: 16, weight: .medium))
                        
                        Text("Edit")
                            .font(AppTypography.callout)
                    }
                    .frame(maxWidth: .infinity)
                    .secondaryButtonStyle()
                }
                
                Button(action: { showingDeleteAlert = true }) {
                    HStack {
                        Image(systemName: "trash")
                            .font(.system(size: 16, weight: .medium))
                        
                        Text("Delete")
                            .font(AppTypography.callout)
                    }
                    .foregroundColor(AppColors.errorRed)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(AppColors.errorRed.opacity(0.1))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(AppColors.errorRed.opacity(0.3), lineWidth: 1)
                    )
                }
            }
        }
    }
    
    private func togglePurchaseStatus(item: Item) {
        withAnimation(.easeInOut(duration: 0.3)) {
            itemsViewModel.toggleItemStatus(item)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            dismiss()
        }
    }
    
    private func deleteItem() {
        guard let item = item else { return }
        itemsViewModel.deleteItem(item)
        dismiss()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

struct StatusBadge: View {
    let status: ItemStatus
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: status == .purchased ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 12))
            
            Text(status.displayName)
                .font(AppTypography.caption)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.statusColor(for: status))
        )
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    let valueColor: Color
    let showColorIndicator: Bool
    
    init(title: String, value: String, valueColor: Color, showColorIndicator: Bool = false) {
        self.title = title
        self.value = value
        self.valueColor = valueColor
        self.showColorIndicator = showColorIndicator
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(AppTypography.subheadline)
                .foregroundColor(AppColors.neutralGray)
            
            Spacer()
            
            HStack(spacing: 6) {
                if showColorIndicator {
                    Circle()
                        .fill(valueColor)
                        .frame(width: 8, height: 8)
                }
                
                Text(value)
                    .font(AppTypography.bodyMedium)
                    .foregroundColor(valueColor)
            }
        }
    }
}

#Preview {
    let sampleItem = Item(
        name: "Sample Item",
        estimatedPrice: 120,
        priority: .high,
        comment: "This is a sample comment for the item."
    )
    let viewModel = ItemsViewModel()
    viewModel.addItem(sampleItem)
    
    return ItemDetailsView(itemId: sampleItem.id)
        .environmentObject(viewModel)
}
