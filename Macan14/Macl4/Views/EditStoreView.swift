import SwiftUI

struct EditStoreView: View {
    let storeId: UUID
    @ObservedObject var viewModel: StoreViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var storeName: String = ""
    @State private var selectedType: StoreType = .boutique
    @State private var selectedCategory: StoreCategory = .clothing
    @State private var selectedPriceLevel: PriceLevel = .medium
    @State private var review: String = ""
    
    private var store: Store? {
        viewModel.stores.first(where: { $0.id == storeId })
    }
    
    private var isFormValid: Bool {
        !storeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var hasChanges: Bool {
        guard let store = store else { return false }
        return storeName != store.name ||
        selectedType != store.type ||
        selectedCategory != store.category ||
        selectedPriceLevel != store.priceLevel ||
        review != store.review
    }
    
    var body: some View {
        Group {
            if let store = store {
                editView(store: store)
            }
        }
        .onAppear {
            loadStoreData()
        }
        .onChange(of: viewModel.stores) { _ in
            loadStoreData()
        }
    }
    
    private func loadStoreData() {
        if let store = store {
            storeName = store.name
            selectedType = store.type
            selectedCategory = store.category
            selectedPriceLevel = store.priceLevel
            review = store.review
        }
    }
    
    @ViewBuilder
    private func editView(store: Store) -> some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text("Edit Store")
                                .font(.ubuntu(28, weight: .bold))
                                .foregroundColor(.appText)
                            
                            Text("Update your store information")
                                .font(.ubuntu(16))
                                .foregroundColor(.appTextSecondary)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 20) {
                            FormFieldView(title: "Store Name") {
                                TextField("Enter store name", text: $storeName)
                                    .font(.ubuntu(16))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(Color.appCardBackground)
                                    .cornerRadius(12)
                                    .shadow(color: Color.appShadow, radius: 5, x: 0, y: 2)
                            }
                            
                            FormFieldView(title: "Store Type") {
                                SegmentedPickerView(
                                    selection: $selectedType,
                                    options: StoreType.allCases,
                                    displayName: { $0.displayName }
                                )
                            }
                            
                            FormFieldView(title: "Category") {
                                SegmentedPickerView(
                                    selection: $selectedCategory,
                                    options: StoreCategory.allCases,
                                    displayName: { $0.displayName }
                                )
                            }
                            
                            FormFieldView(title: "Price Level") {
                                HStack(spacing: 16) {
                                    ForEach(PriceLevel.allCases, id: \.self) { level in
                                        Button(action: {
                                            selectedPriceLevel = level
                                        }) {
                                            Text(level.displayName)
                                                .font(.ubuntu(16, weight: .medium))
                                                .foregroundColor(selectedPriceLevel == level ? .white : .appPrimary)
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 12)
                                                .background(
                                                    selectedPriceLevel == level ? 
                                                    Color.appAccent : Color.appCardBackground
                                                )
                                                .cornerRadius(12)
                                                .shadow(color: Color.appShadow, radius: 5, x: 0, y: 2)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                            
                            FormFieldView(title: "Review (Optional)") {
                                TextField("Share your thoughts about this store", text: $review, axis: .vertical)
                                    .font(.ubuntu(16))
                                    .lineLimit(3...6)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(Color.appCardBackground)
                                    .cornerRadius(12)
                                    .shadow(color: Color.appShadow, radius: 5, x: 0, y: 2)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            Button(action: saveChanges) {
                                Text("Save Changes")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(
                                        (isFormValid && hasChanges) ? 
                                        LinearGradient(
                                            colors: [Color.appPrimary, Color.appAccent],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ) : 
                                        LinearGradient(
                                            colors: [Color.gray.opacity(0.5), Color.gray.opacity(0.3)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(25)
                                    .shadow(color: Color.appShadow, radius: (isFormValid && hasChanges) ? 10 : 5, x: 0, y: 5)
                            }
                            .disabled(!isFormValid || !hasChanges)
                            
                            Button(action: { dismiss() }) {
                                Text("Cancel")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.appTextSecondary)
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func saveChanges() {
        guard let store = store else { return }
        var updatedStore = store
        updatedStore.name = storeName.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedStore.type = selectedType
        updatedStore.category = selectedCategory
        updatedStore.priceLevel = selectedPriceLevel
        updatedStore.review = review.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.updateStore(updatedStore)
        dismiss()
    }
}

#Preview {
    let store = Store(
        name: "Zara",
        type: .boutique,
        category: .clothing,
        priceLevel: .medium,
        review: "Great selection of basic items"
    )
    let viewModel = StoreViewModel()
    viewModel.addStore(store)
    return EditStoreView(storeId: store.id, viewModel: viewModel)
}
