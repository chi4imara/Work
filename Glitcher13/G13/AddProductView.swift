import SwiftUI

struct AddProductView: View {
    @ObservedObject var viewModel: ProductViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var productName = ""
    @State private var selectedCategory = ProductCategory.skincare
    @State private var firstUseDate = Date()
    @State private var selectedResult = ProductResult.neutral
    @State private var notes = ""
    
    private var canSave: Bool {
        !productName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Product Name *")
                                .font(.playfair(16, weight: .semibold))
                                .foregroundColor(AppColors.blueText)
                            
                            TextField("Enter product name", text: $productName)
                                .font(.playfair(16))
                                .foregroundColor(AppColors.blueText)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardGradient)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.playfair(16, weight: .semibold))
                                .foregroundColor(AppColors.blueText)
                            
                            Menu {
                                ForEach(ProductCategory.allCases, id: \.self) { category in
                                    Button(category.displayName) {
                                        selectedCategory = category
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedCategory.displayName)
                                        .font(.playfair(16))
                                        .foregroundColor(AppColors.blueText)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 14))
                                        .foregroundColor(AppColors.mediumGray)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardGradient)
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("First Use Date")
                                .font(.playfair(16, weight: .semibold))
                                .foregroundColor(AppColors.blueText)
                            
                            DatePicker("", selection: $firstUseDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .colorScheme(.light)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardGradient)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Result")
                                .font(.playfair(16, weight: .semibold))
                                .foregroundColor(AppColors.blueText)
                            
                            HStack(spacing: 12) {
                                ForEach(ProductResult.allCases, id: \.self) { result in
                                    ResultSelectionButton(
                                        result: result,
                                        isSelected: selectedResult == result
                                    ) {
                                        selectedResult = result
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes (Optional)")
                                .font(.playfair(16, weight: .semibold))
                                .foregroundColor(AppColors.blueText)
                            
                            TextField("Add your notes here...", text: $notes, axis: .vertical)
                                .font(.playfair(16))
                                .foregroundColor(AppColors.blueText)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardGradient)
                                )
                                .lineLimit(3...6)
                        }
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("New Experiment")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(AppColors.lightBlue),
                
                trailing: Button("Save") {
                    saveProduct()
                }
                .foregroundColor(canSave ? AppColors.yellow : AppColors.mediumGray)
                .disabled(!canSave)
            )
        }
    }
    
    private func saveProduct() {
        let product = Product(
            name: productName.trimmingCharacters(in: .whitespacesAndNewlines),
            category: selectedCategory,
            firstUseDate: firstUseDate,
            result: selectedResult,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        viewModel.addProduct(product)
        presentationMode.wrappedValue.dismiss()
    }
}

struct ResultSelectionButton: View {
    let result: ProductResult
    let isSelected: Bool
    let action: () -> Void
    
    private var color: Color {
        switch result {
        case .liked:
            return AppColors.likedColor
        case .neutral:
            return AppColors.neutralColor
        case .disliked:
            return AppColors.dislikedColor
        }
    }
    
    var body: some View {
        Button(action: action) {
            Text(result.displayName)
                .font(.playfair(14, weight: .semibold))
                .foregroundColor(isSelected ? AppColors.white : color)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? color : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(color, lineWidth: 2)
                        )
                )
        }
    }
}

#Preview {
    AddProductView(viewModel: ProductViewModel())
}
