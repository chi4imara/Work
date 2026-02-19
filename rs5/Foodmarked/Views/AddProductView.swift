import SwiftUI

struct AddProductView: View {
    @EnvironmentObject var productStore: ProductStore
    @EnvironmentObject var achievementManager: AchievementManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var productName = ""
    @State private var selectedStatus: ProductStatus = .suitable
    @State private var showingAlert = false
    
    var isFormValid: Bool {
        !productName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        VStack(spacing: 8) {
                            Text("Add New Product")
                                .font(.playfairDisplay(size: 28, weight: .bold))
                                .foregroundColor(ColorManager.primaryText)
                            
                            Text("Add a product to your personal list")
                                .font(.playfairDisplay(size: 14, weight: .regular))
                                .foregroundColor(ColorManager.secondaryText)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 25) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Product Name")
                                    .font(.playfairDisplay(size: 16, weight: .semibold))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                TextField("Enter product name", text: $productName)
                                    .font(.playfairDisplay(size: 16, weight: .regular))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.white)
                                            .shadow(color: ColorManager.primaryBlue.opacity(0.1), radius: 2, x: 0, y: 1)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(ColorManager.lightBlue, lineWidth: 1)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Status")
                                    .font(.playfairDisplay(size: 16, weight: .semibold))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                HStack(spacing: 12) {
                                    StatusButton(
                                        title: "Suitable",
                                        status: .suitable,
                                        isSelected: selectedStatus == .suitable,
                                        action: { selectedStatus = .suitable }
                                    )
                                    
                                    StatusButton(
                                        title: "Not Suitable",
                                        status: .unsuitable,
                                        isSelected: selectedStatus == .unsuitable,
                                        action: { selectedStatus = .unsuitable }
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Button(action: saveProduct) {
                            HStack {
                                Image(systemName: "checkmark")
                                Text("Save Product")
                            }
                            .font(.playfairDisplay(size: 18, weight: .semibold))
                            .foregroundColor(ColorManager.whiteText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(isFormValid ? AnyShapeStyle(ColorManager.buttonGradient) : AnyShapeStyle(ColorManager.secondaryText.opacity(0.3)))
                            )
                        }
                        .disabled(!isFormValid)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        Spacer(minLength: 50)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(ColorManager.primaryBlue)
                }
            }
        }
        .alert("Product Added", isPresented: $showingAlert) {
            Button("OK") {
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("'\(productName)' has been added to your list.")
        }
    }
    
    private func saveProduct() {
        let trimmedName = productName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        let newProduct = Product(name: trimmedName, status: selectedStatus)
        productStore.addProduct(newProduct)
        
        achievementManager.recordActivity()
        achievementManager.checkAchievements(productStore: productStore)
        
        showingAlert = true
    }
}
