import SwiftUI

struct SetDetailView: View {
    @ObservedObject var appViewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
    
    let setId: UUID
    
    @State private var showingEditSet = false
    @State private var showingDeleteAlert = false
    
    private var cosmeticSet: CosmeticSet? {
        appViewModel.cosmeticSets.first { $0.id == setId }
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            if let set = cosmeticSet {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(set.name)
                                    .font(.titleMedium)
                                    .foregroundColor(.textPrimary)
                                
                                Spacer()
                                
                                StatusBadge(isReady: set.isReady)
                            }
                            
                            Text(set.category.displayName)
                                .font(.bodyMedium)
                                .foregroundColor(.textSecondary)
                            
                            if !set.comment.isEmpty {
                                Text(set.comment)
                                    .font(.bodyMedium)
                                    .foregroundColor(.textPrimary)
                                    .padding(.top, 8)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Products (\(set.products.count))")
                                .font(.titleSmall)
                                .foregroundColor(.textPrimary)
                            
                            if set.products.isEmpty {
                                VStack(spacing: 16) {
                                    Image(systemName: "waterbottle")
                                        .font(.system(size: 40, weight: .light))
                                        .foregroundColor(.textSecondary)
                                    
                                    Text("No products in this set yet")
                                        .font(.bodyMedium)
                                        .foregroundColor(.textSecondary)
                                        .multilineTextAlignment(.center)
                                    
                                    Text("Add needed items to complete preparation.")
                                        .font(.bodySmall)
                                        .foregroundColor(.textSecondary)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 40)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.cardBackground.opacity(0.5))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color.cardBorder.opacity(0.5), lineWidth: 1)
                                        )
                                )
                            } else {
                                VStack(spacing: 12) {
                                    ForEach(set.products) { product in
                                        ProductChecklistRow(
                                            product: product,
                                            isChecked: set.checkedProductIds.contains(product.id)
                                        ) {
                                            toggleProductCheck(product.id)
                                        }
                                    }
                                }
                            }
                        }
                        
                        VStack(spacing: 16) {
                            Button(action: {
                                showingEditSet = true
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 16, weight: .medium))
                                    Text("Edit Set")
                                        .font(.buttonMedium)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.buttonPrimary)
                                )
                            }
                            
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "trash")
                                        .font(.system(size: 16, weight: .medium))
                                    Text("Delete Set")
                                        .font(.buttonMedium)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.buttonDestructive)
                                )
                            }
                            
                            Button(action: {
                                toggleReadyStatus()
                            }) {
                                HStack {
                                    Image(systemName: set.isReady ? "checkmark.circle" : "circle")
                                        .font(.system(size: 16, weight: .medium))
                                    Text(set.isReady ? "Mark as Not Ready" : "Mark as Ready")
                                        .font(.buttonMedium)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(set.isReady ? Color.statusNotReady : Color.statusReady)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            } else {
                VStack(spacing: 20) {
                    Spacer()
                    
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(.textSecondary)
                    
                    Text("Set Not Found")
                        .font(.titleMedium)
                        .foregroundColor(.textPrimary)
                    
                    Text("This set may have been deleted.")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                    
                    Button("Go Back") {
                        dismiss()
                    }
                    .font(.buttonMedium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.buttonPrimary)
                    )
                    
                    Spacer()
                }
                .padding(.horizontal, 40)
            }
        }
        .navigationTitle("Set Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditSet) {
            if let set = cosmeticSet {
                CreateSetView(appViewModel: appViewModel, editingSet: set)
            }
        }
        .alert("Delete Set", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let set = cosmeticSet {
                    appViewModel.deleteCosmeticSet(set)
                    dismiss()
                }
            }
        } message: {
            if let set = cosmeticSet {
                Text("Are you sure you want to delete \(set.name)? This action cannot be undone.")
            }
        }
    }
    
    private func toggleProductCheck(_ productId: UUID) {
        guard var set = cosmeticSet else { return }
        
        if set.checkedProductIds.contains(productId) {
            set.checkedProductIds.remove(productId)
        } else {
            set.checkedProductIds.insert(productId)
        }
        
        appViewModel.updateCosmeticSet(set)
    }
    
    private func toggleReadyStatus() {
        guard var updatedSet = cosmeticSet else { return }
        updatedSet.isReady.toggle()
        appViewModel.updateCosmeticSet(updatedSet)
    }
}

struct ProductChecklistRow: View {
    let product: Product
    let isChecked: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(isChecked ? Color.statusReady : Color.buttonSecondary)
                        .frame(width: 24, height: 24)
                    
                    if isChecked {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(.bodyMedium)
                        .foregroundColor(isChecked ? .textSecondary : .textPrimary)
                        .strikethrough(isChecked)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        Text(product.category.displayName)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        
                        if !product.volume.isEmpty {
                            Text("• \(product.volume)")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                    }
                    
                    if !product.comment.isEmpty {
                        Text(product.comment)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                            .lineLimit(2)
                    }
                }
                
                Spacer()
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.cardBorder, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let appViewModel = AppViewModel()
    let previewSet = CosmeticSet(
        name: "Travel Set",
        category: .travel,
        products: [
            Product(name: "Foundation", category: .makeup, volume: "30ml"),
            Product(name: "Moisturizer", category: .skincare, volume: "50ml")
        ],
        comment: "Perfect for weekend trips",
        isReady: false
    )
    appViewModel.addCosmeticSet(previewSet)
    
    return NavigationView {
        SetDetailView(
            appViewModel: appViewModel,
            setId: previewSet.id
        )
    }
}
