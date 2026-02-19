import SwiftUI

struct ProductDetailView: View {
    let productId: UUID
    @ObservedObject var productViewModel: ProductViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @State private var showingStatusUpdate = false
    @State private var showingMarkUsedAlert = false
    
    private var product: Product? {
        productViewModel.products.first { $0.id == productId }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                if let product = product {
                    ScrollView {
                        VStack(spacing: 24) {
                            ProductHeaderView(product: product)
                            
                            ProductDetailsSection(product: product)
                            
                            ActionButtonsSection(
                                onMarkUsed: {
                                    showingMarkUsedAlert = true
                                },
                                onUpdateStatus: {
                                    showingStatusUpdate = true
                                },
                                onEdit: {
                                    showingEditView = true
                                },
                                onDelete: {
                                    showingDeleteAlert = true
                                }
                            )
                            
                            Spacer(minLength: 50)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    }
                } else {
                    VStack {
                        Text("Product not found")
                            .font(.playfairDisplay(18, weight: .medium))
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                }
            }
            .navigationTitle(product?.name ?? "Product")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(ColorTheme.lightBlue)
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            if let product = product {
                AddEditProductView(productViewModel: productViewModel, editingProduct: product)
            }
        }
        .sheet(isPresented: $showingStatusUpdate) {
            if let product = product {
                StatusUpdateView(product: product, productViewModel: productViewModel)
            }
        }
        .alert("Mark as Used", isPresented: $showingMarkUsedAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Mark Used") {
                if let product = product {
                    productViewModel.markProductAsUsed(product)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        } message: {
            Text("This will update the last used date to today.")
        }
        .alert("Delete Product", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let product = product {
                    productViewModel.deleteProduct(product)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        } message: {
            if let product = product {
                Text("Are you sure you want to delete \"\(product.name)\"? This action cannot be undone.")
            }
        }
    }
}

struct ProductHeaderView: View {
    let product: Product
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                statusColor.opacity(0.3),
                                statusColor.opacity(0.1)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Image(systemName: product.category.icon)
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(statusColor)
            }
            
            VStack(spacing: 8) {
                Text(product.name)
                    .font(.playfairDisplay(24, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(product.category.displayName)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(ColorTheme.secondaryText)
                
                StatusBadge(status: product.status)
            }
        }
        .padding(.vertical, 20)
    }
    
    private var statusColor: Color {
        switch product.status {
        case .inUse: return ColorTheme.inUse
        case .runningOut: return ColorTheme.runningOut
        }
    }
}

struct ProductDetailsSection: View {
    let product: Product
    
    var body: some View {
        VStack(spacing: 16) {
            DetailRow(
                icon: "clock.fill",
                iconColor: ColorTheme.orange,
                title: "Last Used",
                value: product.lastUsedText,
                subtitle: formatDate(product.lastUsed)
            )
            
            DetailRow(
                icon: "chart.bar.fill",
                iconColor: stockLevelColor,
                title: "Stock Level",
                value: product.stockLevel.displayName,
                customContent: {
                    StockLevelIndicator(level: product.stockLevel)
                }
            )
            
            DetailRow(
                icon: "calendar.badge.plus",
                iconColor: ColorTheme.green,
                title: "Added",
                value: formatDate(product.createdAt)
            )
            
            if !product.notes.isEmpty {
                DetailRow(
                    icon: "note.text",
                    iconColor: ColorTheme.yellow,
                    title: "Notes",
                    value: product.notes,
                    isMultiline: true
                )
            }
        }
        .padding(.horizontal, 4)
    }
    
    private var stockLevelColor: Color {
        switch product.stockLevel {
        case .low: return ColorTheme.lowStock
        case .medium: return ColorTheme.mediumStock
        case .normal: return ColorTheme.normalStock
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct DetailRow<Content: View>: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    let subtitle: String?
    let isMultiline: Bool
    let customContent: (() -> Content)?
    
    init(
        icon: String,
        iconColor: Color,
        title: String,
        value: String,
        subtitle: String? = nil,
        isMultiline: Bool = false,
        @ViewBuilder customContent: @escaping () -> Content = { EmptyView() }
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.isMultiline = isMultiline
        self.customContent = customContent
    }
    
    var body: some View {
        HStack(alignment: isMultiline ? .top : .center, spacing: 16) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.playfairDisplay(14, weight: .semibold))
                    .foregroundColor(ColorTheme.secondaryText)
                
                Text(value)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                    .lineLimit(isMultiline ? nil : 1)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.playfairDisplay(14, weight: .regular))
                        .foregroundColor(ColorTheme.tertiaryText)
                }
            }
            
            Spacer()
            
            customContent?()
        }
        .padding(16)
        .cardStyle()
    }
}

struct ActionButtonsSection: View {
    let onMarkUsed: () -> Void
    let onUpdateStatus: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                ActionButton(
                    title: "Mark Used",
                    icon: "checkmark.circle.fill",
                    color: ColorTheme.green,
                    action: onMarkUsed
                )
                
                ActionButton(
                    title: "Update Status",
                    icon: "arrow.triangle.2.circlepath",
                    color: ColorTheme.orange,
                    action: onUpdateStatus
                )
            }
            
            HStack(spacing: 12) {
                ActionButton(
                    title: "Edit",
                    icon: "pencil.circle.fill",
                    color: ColorTheme.lightBlue,
                    action: onEdit
                )
                
                ActionButton(
                    title: "Delete",
                    icon: "trash.circle.fill",
                    color: ColorTheme.red,
                    action: onDelete
                )
            }
        }
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.playfairDisplay(14, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(color.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StatusUpdateView: View {
    let product: Product
    @ObservedObject var productViewModel: ProductViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedStatus: ProductStatus
    @State private var selectedStockLevel: StockLevel
    
    init(product: Product, productViewModel: ProductViewModel) {
        self.product = product
        self.productViewModel = productViewModel
        self._selectedStatus = State(initialValue: product.status)
        self._selectedStockLevel = State(initialValue: product.stockLevel)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Status")
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        VStack(spacing: 8) {
                            ForEach(ProductStatus.allCases) { status in
                                StatusSelectionRow(
                                    status: status,
                                    isSelected: selectedStatus == status
                                ) {
                                    selectedStatus = status
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Stock Level")
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        VStack(spacing: 8) {
                            ForEach(StockLevel.allCases.reversed(), id: \.self) { level in
                                StockLevelSelectionRow(
                                    level: level,
                                    isSelected: selectedStockLevel == level
                                ) {
                                    selectedStockLevel = level
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: saveChanges) {
                        Text("Save Changes")
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(ColorTheme.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(ColorTheme.buttonGradient)
                            .cornerRadius(12)
                            .shadow(color: ColorTheme.lightBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }
            .navigationTitle("Update Status")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(ColorTheme.secondaryText)
                }
            }
        }
    }
    
    private func saveChanges() {
        productViewModel.updateProductStatus(product, status: selectedStatus, stockLevel: selectedStockLevel)
        presentationMode.wrappedValue.dismiss()
    }
}

struct StatusSelectionRow: View {
    let status: ProductStatus
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Circle()
                    .fill(statusColor)
                    .frame(width: 12, height: 12)
                
                Text(status.displayName)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(ColorTheme.lightBlue)
                }
            }
            .padding(16)
            .background(isSelected ? ColorTheme.lightBlue.opacity(0.1) : ColorTheme.tertiaryBackground.opacity(0.3))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? ColorTheme.lightBlue.opacity(0.5) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var statusColor: Color {
        switch status {
        case .inUse: return ColorTheme.inUse
        case .runningOut: return ColorTheme.runningOut
        }
    }
}

struct StockLevelSelectionRow: View {
    let level: StockLevel
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                StockLevelIndicator(level: level)
                
                Text(level.displayName)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(ColorTheme.lightBlue)
                }
            }
            .padding(16)
            .background(isSelected ? ColorTheme.lightBlue.opacity(0.1) : ColorTheme.tertiaryBackground.opacity(0.3))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? ColorTheme.lightBlue.opacity(0.5) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let viewModel = ProductViewModel()
    if let firstProduct = Product.sampleProducts.first {
        viewModel.addProduct(firstProduct)
        return ProductDetailView(productId: firstProduct.id, productViewModel: viewModel)
    }
    return ProductDetailView(productId: UUID(), productViewModel: viewModel)
}
