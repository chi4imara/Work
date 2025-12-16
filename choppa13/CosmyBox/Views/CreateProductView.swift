import SwiftUI

struct CreateProductView: View {
    @ObservedObject var viewModel: CosmeticBagViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let cosmeticBagId: UUID
    let productToEdit: Product?
    
    @State private var name: String = ""
    @State private var selectedCategory: ProductCategory = .skincare
    @State private var volume: String = ""
    @State private var expirationDate: Date = Date()
    @State private var selectedStatus: ProductStatus = .available
    @State private var note: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    init(viewModel: CosmeticBagViewModel, cosmeticBagId: UUID, productToEdit: Product? = nil) {
        self.viewModel = viewModel
        self.cosmeticBagId = cosmeticBagId
        self.productToEdit = productToEdit
    }
    
    var isEditing: Bool {
        productToEdit != nil
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text(isEditing ? "Edit Product" : "New Product")
                                .font(.ubuntu(24, weight: .bold))
                                .foregroundColor(Color.theme.primaryWhite)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 20) {
                            FormField(title: "Name") {
                                TextField("Enter product name", text: $name)
                                    .font(.ubuntu(16, weight: .regular))
                                    .padding(16)
                                    .background(Color.theme.primaryWhite)
                                    .cornerRadius(12)
                            }
                            
                            FormField(title: "Category") {
                                Menu {
                                    ForEach(ProductCategory.allCases, id: \.self) { category in
                                        Button(category.displayName) {
                                            selectedCategory = category
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedCategory.displayName)
                                            .font(.ubuntu(16, weight: .regular))
                                            .foregroundColor(Color.theme.darkGray)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(Color.theme.darkGray.opacity(0.5))
                                    }
                                    .padding(16)
                                    .background(Color.theme.primaryWhite)
                                    .cornerRadius(12)
                                }
                            }
                            
                            FormField(title: "Volume/Weight") {
                                TextField("e.g., 50 ml, 30 g", text: $volume)
                                    .font(.ubuntu(16, weight: .regular))
                                    .padding(16)
                                    .background(Color.theme.primaryWhite)
                                    .cornerRadius(12)
                            }
                            
                            FormField(title: "Expiration Date") {
                                DatePicker("", selection: $expirationDate, displayedComponents: [.date])
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .padding(16)
                                    .background(Color.theme.primaryWhite)
                                    .cornerRadius(12)
                            }
                            
                            FormField(title: "Status") {
                                HStack(spacing: 20) {
                                    ForEach(ProductStatus.allCases, id: \.self) { status in
                                        Button(action: {
                                            selectedStatus = status
                                        }) {
                                            HStack(spacing: 8) {
                                                Image(systemName: status.icon)
                                                    .font(.system(size: 16, weight: .medium))
                                                    .foregroundColor(selectedStatus == status ? Color.theme.primaryWhite : (status == .available ? Color.theme.accentGreen : Color.theme.accentRed))
                                                
                                                Text(status.displayName)
                                                    .font(.ubuntu(14, weight: .medium))
                                                    .foregroundColor(selectedStatus == status ? Color.theme.primaryWhite : Color.theme.darkGray)
                                            }
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .fill(selectedStatus == status ? Color.theme.primaryPurple : Color.theme.primaryWhite)
                                            )
                                        }
                                    }
                                    
                                    Spacer()
                                }
                                .padding(16)
                                .background(Color.theme.primaryWhite.opacity(0.1))
                                .cornerRadius(12)
                            }
                            
                            FormField(title: "Note (Optional)") {
                                TextField("Add any notes or reminders", text: $note, axis: .vertical)
                                    .font(.ubuntu(16, weight: .regular))
                                    .lineLimit(3...6)
                                    .padding(16)
                                    .background(Color.theme.primaryWhite)
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Button(action: saveProduct) {
                            Text("Save")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(Color.theme.primaryWhite)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.theme.buttonGradient)
                                .cornerRadius(28)
                                .shadow(color: Color.theme.primaryPurple.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(Color.theme.primaryWhite)
                }
            }
        }
        .onAppear {
            setupInitialValues()
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func setupInitialValues() {
        if let product = productToEdit {
            name = product.name
            selectedCategory = product.category
            volume = product.volume
            expirationDate = product.expirationDate
            selectedStatus = product.status
            note = product.note
        }
    }
    
    private func saveProduct() {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Please enter a product name."
            showingAlert = true
            return
        }
        
        guard !volume.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Please enter the volume or weight."
            showingAlert = true
            return
        }
        
        if let productToEdit = productToEdit {
            var updatedProduct = productToEdit
            updatedProduct.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedProduct.category = selectedCategory
            updatedProduct.volume = volume.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedProduct.expirationDate = expirationDate
            updatedProduct.status = selectedStatus
            updatedProduct.note = note.trimmingCharacters(in: .whitespacesAndNewlines)
            
            viewModel.updateProduct(updatedProduct)
        } else {
            let newProduct = Product(
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                category: selectedCategory,
                volume: volume.trimmingCharacters(in: .whitespacesAndNewlines),
                expirationDate: expirationDate,
                status: selectedStatus,
                note: note.trimmingCharacters(in: .whitespacesAndNewlines),
                cosmeticBagId: cosmeticBagId
            )
            
            viewModel.addProduct(newProduct, to: cosmeticBagId)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    CreateProductView(viewModel: CosmeticBagViewModel(), cosmeticBagId: UUID())
}
