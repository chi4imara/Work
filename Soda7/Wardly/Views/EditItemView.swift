import SwiftUI

struct EditItemView: View {
    @EnvironmentObject var itemsViewModel: ItemsViewModel
    @Environment(\.dismiss) private var dismiss
    
    let itemId: UUID
    
    @State private var itemName: String = ""
    @State private var estimatedPrice: String = ""
    @State private var selectedPriority: Priority = .medium
    @State private var comment: String = ""
    @State private var showingPriorityPicker = false
    
    private var item: Item? {
        itemsViewModel.items.first { $0.id == itemId }
    }
    
    private var isFormValid: Bool {
        !itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var priceValue: Double {
        Double(estimatedPrice) ?? 0.0
    }
    
    private var hasChanges: Bool {
        guard let item = item else { return false }
        return itemName != item.name ||
        priceValue != item.estimatedPrice ||
        selectedPriority != item.priority ||
        comment != item.comment
    }
    
    var body: some View {
        Group {
            if let item = item {
                ZStack {
                    AppColors.backgroundGradient
                        .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        ScrollView {
                            VStack(spacing: 24) {
                                headerView
                                
                                VStack(spacing: 20) {
                                    itemNameField(item: item)
                                    estimatedPriceField(item: item)
                                    priorityField(item: item)
                                    commentField(item: item)
                                }
                                .padding(.horizontal, 20)
                                
                                if hasChanges {
                                    changesIndicatorView(item: item)
                                }
                                
                                Button(action: saveChanges) {
                                    Text("Save Changes")
                                        .font(AppTypography.buttonText)
                                        .frame(maxWidth: .infinity)
                                        .primaryButtonStyle(isEnabled: isFormValid && hasChanges)
                                }
                                .padding(.horizontal, 20)
                            }
                            .padding(.vertical, 20)
                            .padding(.bottom, 100)
                        }
                    }
                }
                .onAppear {
                    loadItemData(item: item)
                }
                .sheet(isPresented: $showingPriorityPicker) {
                    PriorityPickerView(selectedPriority: $selectedPriority)
                }
            } else {
                Text("Item not found")
                    .foregroundColor(AppColors.neutralGray)
            }
        }
    }
    
    private func loadItemData(item: Item) {
        itemName = item.name
        estimatedPrice = String(Int(item.estimatedPrice))
        selectedPriority = item.priority
        comment = item.comment
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Edit Purchase")
                .font(AppTypography.title1)
                .foregroundColor(AppColors.primaryPurple)
            
            Text("Update your item details")
                .font(AppTypography.callout)
                .foregroundColor(AppColors.neutralGray)
        }
    }
    
    private func itemNameField(item: Item) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Item Name")
                .font(AppTypography.subheadline)
                .foregroundColor(AppColors.darkGray)
            
            TextField("e.g., White Cardigan", text: $itemName)
                .font(AppTypography.body)
                .padding(16)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            itemName.isEmpty ? AppColors.errorRed.opacity(0.5) :
                                (itemName != item.name ? AppColors.yellowAccent.opacity(0.7) : AppColors.neutralGray.opacity(0.3)),
                            lineWidth: itemName.isEmpty ? 2 : 1
                        )
                )
        }
    }
    
    private func estimatedPriceField(item: Item) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Estimated Price ($)")
                .font(AppTypography.subheadline)
                .foregroundColor(AppColors.darkGray)
            
            TextField("0", text: $estimatedPrice)
                .font(AppTypography.body)
                .keyboardType(.decimalPad)
                .padding(16)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            priceValue != item.estimatedPrice ? AppColors.yellowAccent.opacity(0.7) : AppColors.neutralGray.opacity(0.3),
                            lineWidth: 1
                        )
                )
        }
    }
    
    private func priorityField(item: Item) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Priority")
                .font(AppTypography.subheadline)
                .foregroundColor(AppColors.darkGray)
            
            Button(action: { showingPriorityPicker = true }) {
                HStack {
                    Text(selectedPriority.displayName)
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.darkGray)
                    
                    Spacer()
                    
                    Circle()
                        .fill(AppColors.priorityColor(for: selectedPriority))
                        .frame(width: 12, height: 12)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.neutralGray)
                }
                .padding(16)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            selectedPriority != item.priority ? AppColors.yellowAccent.opacity(0.7) : AppColors.neutralGray.opacity(0.3),
                            lineWidth: 1
                        )
                )
            }
        }
    }
    
    private func commentField(item: Item) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Comment (Optional)")
                .font(AppTypography.subheadline)
                .foregroundColor(AppColors.darkGray)
            
            TextField("e.g., Goes with jeans and boots", text: $comment, axis: .vertical)
                .font(AppTypography.body)
                .lineLimit(3...6)
                .padding(16)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            comment != item.comment ? AppColors.yellowAccent.opacity(0.7) : AppColors.neutralGray.opacity(0.3),
                            lineWidth: 1
                        )
                )
        }
    }
    
    private func changesIndicatorView(item: Item) -> some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(AppColors.yellowAccent)
                
                Text("You have unsaved changes")
                    .font(AppTypography.callout)
                    .foregroundColor(AppColors.darkGray)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                if itemName != item.name {
                    ChangeIndicatorRow(field: "Name", oldValue: item.name, newValue: itemName)
                }
                
                if priceValue != item.estimatedPrice {
                    ChangeIndicatorRow(
                        field: "Price",
                        oldValue: "$\(Int(item.estimatedPrice))",
                        newValue: "$\(Int(priceValue))"
                    )
                }
                
                if selectedPriority != item.priority {
                    ChangeIndicatorRow(
                        field: "Priority",
                        oldValue: item.priority.displayName,
                        newValue: selectedPriority.displayName
                    )
                }
                
                if comment != item.comment {
                    ChangeIndicatorRow(
                        field: "Comment",
                        oldValue: item.comment.isEmpty ? "None" : item.comment,
                        newValue: comment.isEmpty ? "None" : comment
                    )
                }
            }
        }
        .padding(16)
        .background(AppColors.lightYellow.opacity(0.3))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.yellowAccent.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }
    
    private func saveChanges() {
        guard var updatedItem = item else { return }
        updatedItem.name = itemName.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedItem.estimatedPrice = priceValue
        updatedItem.priority = selectedPriority
        updatedItem.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
        
        itemsViewModel.updateItem(updatedItem)
        dismiss()
    }
}

struct ChangeIndicatorRow: View {
    let field: String
    let oldValue: String
    let newValue: String
    
    var body: some View {
        HStack {
            Text(field + ":")
                .font(AppTypography.caption)
                .foregroundColor(AppColors.neutralGray)
                .frame(width: 60, alignment: .leading)
            
            Text(oldValue)
                .font(AppTypography.caption)
                .foregroundColor(AppColors.neutralGray)
                .strikethrough()
            
            Image(systemName: "arrow.right")
                .font(.system(size: 10))
                .foregroundColor(AppColors.yellowAccent)
            
            Text(newValue)
                .font(AppTypography.caption)
                .foregroundColor(AppColors.darkGray)
                .fontWeight(.medium)
            
            Spacer()
        }
    }
}

#Preview {
    let sampleItem = Item(
        name: "Sample Item",
        estimatedPrice: 120,
        priority: .high,
        comment: "This is a sample comment."
    )
    let viewModel = ItemsViewModel()
    viewModel.addItem(sampleItem)
    
    return EditItemView(itemId: sampleItem.id)
        .environmentObject(viewModel)
}
