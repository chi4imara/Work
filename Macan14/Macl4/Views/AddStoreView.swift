import SwiftUI

struct AddStoreView: View {
    @ObservedObject var viewModel: StoreViewModel
    @Binding var selectedTab: Int
    @Environment(\.dismiss) private var dismiss
    
    @State private var storeName = ""
    @State private var selectedType = StoreType.boutique
    @State private var selectedCategory = StoreCategory.clothing
    @State private var selectedPriceLevel = PriceLevel.medium
    @State private var review = ""
    
    private var isFormValid: Bool {
        !storeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("New Store")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(.appText)
                        
                        Text("Add your favorite shopping destination")
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
                        Button(action: saveStore) {
                            Text("Save Store")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    isFormValid ?
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
                                .shadow(color: Color.appShadow, radius: isFormValid ? 10 : 5, x: 0, y: 5)
                        }
                        .disabled(!isFormValid)
                        
                        Button(action: {
                            storeName = ""
                            selectedType = StoreType.boutique
                            selectedCategory = StoreCategory.clothing
                            selectedPriceLevel = PriceLevel.medium
                            review = ""
                        }) {
                            Text("Clear")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(.appTextSecondary)
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                }
            }
        }
    }
    
    private func saveStore() {
        let newStore = Store(
            name: storeName.trimmingCharacters(in: .whitespacesAndNewlines),
            type: selectedType,
            category: selectedCategory,
            priceLevel: selectedPriceLevel,
            review: review.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        viewModel.addStore(newStore)
        dismiss()
        
        withAnimation {
            selectedTab = 0
            storeName = ""
            selectedType = StoreType.boutique
            selectedCategory = StoreCategory.clothing
            selectedPriceLevel = PriceLevel.medium
            review = ""
        }
    }
}

