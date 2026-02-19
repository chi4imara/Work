import SwiftUI

struct AddEditProductView: View {
    @ObservedObject var productViewModel: ProductViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let editingProduct: Product?
    
    @State private var name: String = ""
    @State private var selectedCategory: ProductCategory = .cream
    @State private var selectedStatus: ProductStatus = .inUse
    @State private var lastUsed: Date = Date()
    @State private var selectedStockLevel: StockLevel = .normal
    @State private var notes: String = ""
    
    @State private var showingCategoryPicker = false
    @State private var showingStatusPicker = false
    @State private var showingStockPicker = false
    @State private var showingDatePicker = false
    
    init(productViewModel: ProductViewModel, editingProduct: Product? = nil) {
        self.productViewModel = productViewModel
        self.editingProduct = editingProduct
    }
    
    var isEditing: Bool {
        editingProduct != nil
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        FormSection(title: "Product Name") {
                            TextField("Enter product name", text: $name)
                                .font(.playfairDisplay(16, weight: .regular))
                                .foregroundColor(ColorTheme.primaryText)
                                .padding(16)
                                .background(ColorTheme.tertiaryBackground.opacity(0.5))
                                .cornerRadius(12)
                        }
                        
                        FormSection(title: "Category") {
                            Button(action: {
                                showingCategoryPicker = true
                            }) {
                                HStack {
                                    Image(systemName: selectedCategory.icon)
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(ColorTheme.lightBlue)
                                    
                                    Text(selectedCategory.displayName)
                                        .font(.playfairDisplay(16, weight: .regular))
                                        .foregroundColor(ColorTheme.primaryText)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(ColorTheme.secondaryText)
                                }
                                .padding(16)
                                .background(ColorTheme.tertiaryBackground.opacity(0.5))
                                .cornerRadius(12)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        FormSection(title: "Status") {
                            Button(action: {
                                showingStatusPicker = true
                            }) {
                                HStack {
                                    Circle()
                                        .fill(statusColor)
                                        .frame(width: 12, height: 12)
                                    
                                    Text(selectedStatus.displayName)
                                        .font(.playfairDisplay(16, weight: .regular))
                                        .foregroundColor(ColorTheme.primaryText)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(ColorTheme.secondaryText)
                                }
                                .padding(16)
                                .background(ColorTheme.tertiaryBackground.opacity(0.5))
                                .cornerRadius(12)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        FormSection(title: "Last Used") {
                            Button(action: {
                                showingDatePicker = true
                            }) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(ColorTheme.orange)
                                    
                                    Text(formatDate(lastUsed))
                                        .font(.playfairDisplay(16, weight: .regular))
                                        .foregroundColor(ColorTheme.primaryText)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(ColorTheme.secondaryText)
                                }
                                .padding(16)
                                .background(ColorTheme.tertiaryBackground.opacity(0.5))
                                .cornerRadius(12)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        FormSection(title: "Stock Level") {
                            Button(action: {
                                showingStockPicker = true
                            }) {
                                HStack {
                                    StockLevelIndicator(level: selectedStockLevel)
                                    
                                    Text(selectedStockLevel.displayName)
                                        .font(.playfairDisplay(16, weight: .regular))
                                        .foregroundColor(ColorTheme.primaryText)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(ColorTheme.secondaryText)
                                }
                                .padding(16)
                                .background(ColorTheme.tertiaryBackground.opacity(0.5))
                                .cornerRadius(12)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        FormSection(title: "Notes") {
                            TextField("Add notes (optional)", text: $notes, axis: .vertical)
                                .font(.playfairDisplay(16, weight: .regular))
                                .foregroundColor(ColorTheme.primaryText)
                                .padding(16)
                                .background(ColorTheme.tertiaryBackground.opacity(0.5))
                                .cornerRadius(12)
                                .lineLimit(3...6)
                        }
                        
                        Button(action: saveProduct) {
                            Text(isEditing ? "Update Product" : "Save Product")
                                .font(.playfairDisplay(18, weight: .semibold))
                                .foregroundColor(ColorTheme.primaryText)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(ColorTheme.buttonGradient)
                                .cornerRadius(12)
                                .shadow(color: ColorTheme.lightBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .opacity(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1.0)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle(isEditing ? "Edit Product" : "New Product")
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
        .onAppear {
            setupInitialValues()
        }
        .sheet(isPresented: $showingCategoryPicker) {
            CategoryPickerView(selectedCategory: $selectedCategory)
        }
        .sheet(isPresented: $showingStatusPicker) {
            StatusPickerView(selectedStatus: $selectedStatus)
        }
        .sheet(isPresented: $showingStockPicker) {
            StockLevelPickerView(selectedStockLevel: $selectedStockLevel)
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerView(selectedDate: $lastUsed)
        }
    }
    
    private var statusColor: Color {
        switch selectedStatus {
        case .inUse: return ColorTheme.inUse
        case .runningOut: return ColorTheme.runningOut
        }
    }
    
    private func setupInitialValues() {
        if let product = editingProduct {
            name = product.name
            selectedCategory = product.category
            selectedStatus = product.status
            lastUsed = product.lastUsed
            selectedStockLevel = product.stockLevel
            notes = product.notes
        }
    }
    
    private func saveProduct() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        if let existingProduct = editingProduct {
            var updatedProduct = existingProduct
            updatedProduct.name = trimmedName
            updatedProduct.category = selectedCategory
            updatedProduct.status = selectedStatus
            updatedProduct.lastUsed = lastUsed
            updatedProduct.stockLevel = selectedStockLevel
            updatedProduct.notes = notes
            updatedProduct.updatedAt = Date()
            
            productViewModel.updateProduct(updatedProduct)
        } else {
            let newProduct = Product(
                name: trimmedName,
                category: selectedCategory,
                status: selectedStatus,
                lastUsed: lastUsed,
                stockLevel: selectedStockLevel,
                notes: notes
            )
            
            productViewModel.addProduct(newProduct)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct FormSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            content
        }
    }
}

struct CategoryPickerView: View {
    @Binding var selectedCategory: ProductCategory
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                List {
                    ForEach(ProductCategory.allCases) { category in
                        Button(action: {
                            selectedCategory = category
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Image(systemName: category.icon)
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(ColorTheme.lightBlue)
                                    .frame(width: 30)
                                
                                Text(category.displayName)
                                    .font(.playfairDisplay(16, weight: .regular))
                                    .foregroundColor(ColorTheme.primaryText)
                                
                                Spacer()
                                
                                if selectedCategory == category {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(ColorTheme.lightBlue)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .listRowBackground(ColorTheme.tertiaryBackground.opacity(0.3))
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color.clear)
            }
            .navigationTitle("Select Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(ColorTheme.lightBlue)
                }
            }
        }
    }
}

struct StatusPickerView: View {
    @Binding var selectedStatus: ProductStatus
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                List {
                    ForEach(ProductStatus.allCases) { status in
                        Button(action: {
                            selectedStatus = status
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Circle()
                                    .fill(statusColor(for: status))
                                    .frame(width: 12, height: 12)
                                
                                Text(status.displayName)
                                    .font(.playfairDisplay(16, weight: .regular))
                                    .foregroundColor(ColorTheme.primaryText)
                                
                                Spacer()
                                
                                if selectedStatus == status {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(ColorTheme.lightBlue)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .listRowBackground(ColorTheme.tertiaryBackground.opacity(0.3))
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color.clear)
            }
            .navigationTitle("Select Status")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(ColorTheme.lightBlue)
                }
            }
        }
    }
    
    private func statusColor(for status: ProductStatus) -> Color {
        switch status {
        case .inUse: return ColorTheme.inUse
        case .runningOut: return ColorTheme.runningOut
        }
    }
}

struct StockLevelPickerView: View {
    @Binding var selectedStockLevel: StockLevel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                List {
                    ForEach(StockLevel.allCases.reversed(), id: \.self) { level in
                        Button(action: {
                            selectedStockLevel = level
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                StockLevelIndicator(level: level)
                                
                                Text(level.displayName)
                                    .font(.playfairDisplay(16, weight: .regular))
                                    .foregroundColor(ColorTheme.primaryText)
                                
                                Spacer()
                                
                                if selectedStockLevel == level {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(ColorTheme.lightBlue)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .listRowBackground(ColorTheme.tertiaryBackground.opacity(0.3))
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color.clear)
            }
            .navigationTitle("Select Stock Level")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(ColorTheme.lightBlue)
                }
            }
        }
    }
}

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack {
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        in: ...Date(),
                        displayedComponents: .date
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .colorScheme(.dark)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Last Used Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(ColorTheme.lightBlue)
                }
            }
        }
    }
}

#Preview {
    AddEditProductView(productViewModel: ProductViewModel())
}
