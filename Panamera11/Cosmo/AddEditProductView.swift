import SwiftUI
import PhotosUI

struct AddEditProductView: View {
    @ObservedObject var viewModel: CosmeticsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let editingProduct: CosmeticProduct?
    
    @State private var name: String = ""
    @State private var shade: String = ""
    @State private var selectedTexture: Texture = .creamy
    @State private var selectedProductType: ProductType = .other
    @State private var suitableFor: String = ""
    @State private var notes: String = ""
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var imagePickerItem: PhotosPickerItem?
    
    init(viewModel: CosmeticsViewModel, editingProduct: CosmeticProduct? = nil) {
        self.viewModel = viewModel
        self.editingProduct = editingProduct
    }
    
    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.primaryGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        imageSection
                        
                        VStack(spacing: 20) {
                            nameField
                            shadeField
                            textureSelector
                            productTypeSelector
                            suitableForField
                            notesField
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle(editingProduct == nil ? "New Product" : "Edit Product")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProduct()
                    }
                    .foregroundColor(isFormValid ? AppColors.accentYellow : AppColors.secondaryText)
                    .disabled(!isFormValid)
                }
            }
        }
        .onAppear {
            setupForEditing()
        }
        .photosPicker(isPresented: $showingImagePicker, selection: $imagePickerItem)
        .onChange(of: imagePickerItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    selectedImage = image
                }
            }
        }
    }
    
    private var imageSection: some View {
        VStack(spacing: 16) {
            Group {
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Image(systemName: "photo.badge.plus")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            .frame(width: 120, height: 120)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.accentYellow.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [5]))
            )
            .onTapGesture {
                showingImagePicker = true
            }
            
            HStack(spacing: 16) {
                Button {
                    showingImagePicker = true
                } label: {
                    Text("Add Photo")
                        .font(.bellGothic(14, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.accentYellow)
                        )
                }
                
                if selectedImage != nil {
                    Button("Remove") {
                        selectedImage = nil
                    }
                    .font(.bellGothic(14))
                    .foregroundColor(AppColors.errorRed)
                }
            }
        }
    }
    
    private var nameField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Product Name *")
                .font(.bellGothic(16, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            TextField("Enter product name", text: $name)
                .font(.bellGothic(16))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.accentYellow.opacity(0.3), lineWidth: 1)
                        )
                )
        }
    }
    
    private var shadeField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Shade")
                .font(.bellGothic(16, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            TextField("Enter shade", text: $shade)
                .font(.bellGothic(16))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.accentYellow.opacity(0.3), lineWidth: 1)
                        )
                )
        }
    }
    
    private var textureSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Texture")
                .font(.bellGothic(16, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Menu {
                ForEach(Texture.allCases, id: \.self) { texture in
                    Button(texture.displayName) {
                        selectedTexture = texture
                    }
                }
            } label: {
                HStack {
                    Text(selectedTexture.displayName)
                        .font(.bellGothic(16))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.secondaryText)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.accentYellow.opacity(0.3), lineWidth: 1)
                        )
                )
            }
        }
    }
    
    private var productTypeSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Product Type")
                .font(.bellGothic(16, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Menu {
                ForEach(ProductType.allCases, id: \.self) { type in
                    Button(type.displayName) {
                        selectedProductType = type
                    }
                }
            } label: {
                HStack {
                    Text(selectedProductType.displayName)
                        .font(.bellGothic(16))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.secondaryText)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.accentYellow.opacity(0.3), lineWidth: 1)
                        )
                )
            }
        }
    }
    
    private var suitableForField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("When and Where It Fits")
                .font(.bellGothic(16, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            TextField("e.g., office, evening, daily wear", text: $suitableFor)
                .font(.bellGothic(16))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.accentYellow.opacity(0.3), lineWidth: 1)
                        )
                )
        }
    }
    
    private var notesField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Notes (Optional)")
                .font(.bellGothic(16, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            TextField("Additional notes...", text: $notes, axis: .vertical)
                .font(.bellGothic(16))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.accentYellow.opacity(0.3), lineWidth: 1)
                        )
                )
                .frame(minHeight: 80, alignment: .topLeading)
        }
    }
    
    private func setupForEditing() {
        if let product = editingProduct {
            name = product.name
            shade = product.shade
            selectedTexture = product.texture
            selectedProductType = product.productType
            suitableFor = product.suitableFor
            notes = product.notes
            
            if let imageData = product.imageData {
                selectedImage = UIImage(data: imageData)
            }
        }
    }
    
    private func saveProduct() {
        let imageData = selectedImage?.compressedForStorage()
        
        if let existingProduct = editingProduct {
            var updatedProduct = existingProduct
            updatedProduct.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedProduct.shade = shade.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedProduct.texture = selectedTexture
            updatedProduct.productType = selectedProductType
            updatedProduct.suitableFor = suitableFor.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedProduct.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedProduct.imageData = imageData
            
            viewModel.updateProduct(updatedProduct)
        } else {
            let newProduct = CosmeticProduct(
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                shade: shade.trimmingCharacters(in: .whitespacesAndNewlines),
                texture: selectedTexture,
                productType: selectedProductType,
                suitableFor: suitableFor.trimmingCharacters(in: .whitespacesAndNewlines),
                notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
                imageData: imageData
            )
            
            viewModel.addProduct(newProduct)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddEditProductView(viewModel: CosmeticsViewModel())
}
