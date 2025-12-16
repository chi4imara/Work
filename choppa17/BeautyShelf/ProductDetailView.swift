import SwiftUI
import StoreKit

struct ProductDetailView: View {
    let product: Product
    @EnvironmentObject var appViewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditProduct = false
    @State private var showingDeleteAlert = false
    @State private var showingMoveSheet = false
    
    private var storageLocation: StorageLocation? {
        appViewModel.getStorageLocation(for: product.id)
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(AppColors.primaryYellow.opacity(0.2))
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: categoryIcon(for: product.category))
                                .font(.system(size: 36, weight: .medium))
                                .foregroundColor(AppColors.primaryYellow)
                        }
                        
                        VStack(spacing: 8) {
                            Text(product.name)
                                .font(.ubuntu(24, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                                .multilineTextAlignment(.center)
                            
                            Text(product.brand)
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(AppColors.secondaryText)
                        }
                        
                        if product.isExpiringSoon {
                            HStack {
                                Image(systemName: product.isExpired ? "xmark.circle.fill" : "exclamationmark.triangle.fill")
                                    .foregroundColor(AppColors.warningRed)
                                
                                Text(product.isExpired ? "This product has expired" : "This product is expiring soon")
                                    .font(.ubuntu(14, weight: .medium))
                                    .foregroundColor(AppColors.warningRed)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(AppColors.warningRed.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        ProductDetailRow(
                            title: "Category",
                            value: product.category.displayName,
                            icon: "tag.fill"
                        )
                        
                        ProductDetailRow(
                            title: "Brand",
                            value: product.brand,
                            icon: "building.2.fill"
                        )
                        
                        if let location = storageLocation {
                            ProductDetailRow(
                                title: "Storage Location",
                                value: location.name,
                                icon: location.icon
                            )
                        }
                        
                        if let expirationDate = product.expirationDate {
                            ProductDetailRow(
                                title: "Expiration Date",
                                value: DateFormatter.longDate.string(from: expirationDate),
                                icon: "calendar.circle.fill",
                                isWarning: product.isExpiringSoon
                            )
                        }
                        
                        if !product.notes.isEmpty {
                            ProductDetailNotesRow(
                                title: "Notes",
                                value: product.notes,
                                icon: "note.text"
                            )
                        } else {
                            ProductDetailRow(
                                title: "Notes",
                                value: "No notes added. You can add them through editing.",
                                icon: "note.text",
                                isPlaceholder: true
                            )
                        }
                        
                        ProductDetailRow(
                            title: "Added",
                            value: DateFormatter.longDate.string(from: product.createdAt),
                            icon: "clock.fill"
                        )
                        
                        if product.usageCount > 0 {
                            ProductDetailRow(
                                title: "Usage",
                                value: "Used \(product.usageCount) time\(product.usageCount == 1 ? "" : "s")",
                                icon: "checkmark.circle.fill"
                            )
                            
                            if let lastUsed = product.lastUsedDate {
                                ProductDetailRow(
                                    title: "Last Used",
                                    value: DateFormatter.longDate.string(from: lastUsed),
                                    icon: "clock.arrow.circlepath"
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 16) {
                        Button(action: {
                            appViewModel.markProductAsUsed(product)
                        }) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Mark as Used")
                                    .font(.ubuntu(18, weight: .medium))
                            }
                            .foregroundColor(AppColors.buttonText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(AppColors.successGreen)
                            .cornerRadius(16)
                        }
                        
                        Button(action: {
                            showingEditProduct = true
                        }) {
                            HStack {
                                Image(systemName: "pencil")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Edit Product")
                                    .font(.ubuntu(18, weight: .medium))
                            }
                            .foregroundColor(AppColors.buttonText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(AppColors.buttonBackground)
                            .cornerRadius(16)
                        }
                        
                        if appViewModel.storageLocations.count > 1 {
                            Button(action: {
                                showingMoveSheet = true
                            }) {
                                HStack {
                                    Image(systemName: "arrow.right.circle")
                                        .font(.system(size: 16, weight: .medium))
                                    Text("Move to Another Location")
                                        .font(.ubuntu(18, weight: .medium))
                                }
                                .foregroundColor(AppColors.primaryText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(AppColors.secondaryButtonBackground)
                                .cornerRadius(16)
                            }
                        }
                        
                        Button(action: {
                            showingDeleteAlert = true
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Delete Product")
                                    .font(.ubuntu(18, weight: .medium))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(AppColors.warningRed)
                            .cornerRadius(16)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
                .padding(.bottom, 100)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .sheet(isPresented: $showingEditProduct) {
            AddProductView(
                storageLocationId: product.storageLocationId,
                editingProduct: product
            )
            .environmentObject(appViewModel)
        }
        .sheet(isPresented: $showingMoveSheet) {
            MoveProductSheet(
                product: product,
                onMove: { newLocationId in
                    appViewModel.moveProduct(product, to: newLocationId)
                }
            )
            .environmentObject(appViewModel)
        }
        .alert("Delete Product", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                appViewModel.deleteProduct(product)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete \"\(product.name)\"? This action cannot be undone.")
        }
    }
    
    private func categoryIcon(for category: ProductCategory) -> String {
        switch category {
        case .lipstick, .lipgloss: return "mouth.fill"
        case .foundation, .concealer: return "face.smiling.fill"
        case .eyeshadow: return "eye.fill"
        case .mascara, .eyeliner: return "eye.trianglebadge.exclamationmark.fill"
        case .blush, .bronzer: return "face.dashed.fill"
        case .highlighter: return "sparkles"
        case .primer, .powder: return "circle.fill"
        case .skincare: return "drop.fill"
        case .other: return "star.fill"
        }
    }
}

struct ProductDetailRow: View {
    let title: String
    let value: String
    let icon: String
    var isWarning: Bool = false
    var isPlaceholder: Bool = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                Circle()
                    .fill(isWarning ? AppColors.warningRed.opacity(0.2) : AppColors.primaryYellow.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isWarning ? AppColors.warningRed : AppColors.primaryYellow)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(Color.gray)
                
                Text(value)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(isPlaceholder ? Color.black : (isWarning ? AppColors.warningRed : Color.black))
                    .italic(isPlaceholder)
            }
            
            Spacer()
        }
        .padding(16)
        .background(AppColors.cardBackground.opacity(0.7))
        .cornerRadius(12)
    }
}

struct ProductDetailNotesRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppColors.primaryYellow.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.primaryYellow)
                }
                
                Text(title)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(Color.gray)
                
                Spacer()
            }
            
            Text(value)
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(Color.black)
                .padding(.leading, 56)
        }
        .padding(16)
        .background(AppColors.cardBackground.opacity(0.7))
        .cornerRadius(12)
    }
}

struct MoveProductSheet: View {
    let product: Product
    let onMove: (UUID) -> Void
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appViewModel: AppViewModel
    
    private var availableLocations: [StorageLocation] {
        appViewModel.storageLocations.filter { $0.id != product.storageLocationId }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 20) {
                    VStack(spacing: 8) {
                        Text("Move Product")
                            .font(.ubuntu(24, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("Select a new storage location for \"\(product.name)\"")
                            .font(.ubuntu(16, weight: .regular))
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(availableLocations) { location in
                                Button(action: {
                                    onMove(location.id)
                                    dismiss()
                                }) {
                                    HStack(spacing: 16) {
                                        Image(systemName: location.icon)
                                            .font(.system(size: 24, weight: .medium))
                                            .foregroundColor(AppColors.primaryYellow)
                                            .frame(width: 40)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(location.name)
                                                .font(.ubuntu(18, weight: .bold))
                                                .foregroundColor(AppColors.darkText)
                                            
                                            if !location.description.isEmpty {
                                                Text(location.description)
                                                    .font(.ubuntu(14, weight: .regular))
                                                    .foregroundColor(AppColors.darkText.opacity(0.7))
                                            }
                                            
                                            Text("\(location.productCount) products")
                                                .font(.ubuntu(12, weight: .medium))
                                                .foregroundColor(AppColors.accentPurple)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(AppColors.darkText.opacity(0.5))
                                    }
                                    .padding(16)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(12)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                }
            }
        }
    }
}

extension DateFormatter {
    static let longDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
}

#Preview {
    NavigationView {
        ProductDetailView(
            product: Product(
                name: "Rouge Dior Lipstick",
                category: .lipstick,
                brand: "Dior",
                storageLocationId: UUID(),
                expirationDate: Date(),
                notes: "Perfect for evening makeup"
            )
        )
        .environmentObject(AppViewModel())
    }
}
