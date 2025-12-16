import SwiftUI

struct AddProductView: View {
    @ObservedObject var viewModel: BeautyProductViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var selectedCategory = ProductCategory.skincare
    @State private var description = ""
    @State private var rating = 5
    @State private var comment = ""
    @State private var showingValidationAlert = false
    
    private let colorManager = ColorManager.shared
    
    var body: some View {
        NavigationView {
            ZStack {
                colorManager.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Product Name")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                                .foregroundColor(colorManager.primaryWhite)
                            
                            TextField("Enter product name", text: $name)
                                .font(.custom("PlayfairDisplay-Regular", size: 16))
                                .foregroundColor(colorManager.secondaryText)
                                .padding(15)
                                .background(colorManager.primaryWhite)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.1), radius: 3)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                                .foregroundColor(colorManager.primaryWhite)
                            
                            HStack(spacing: 12) {
                                ForEach(ProductCategory.allCases, id: \.self) { category in
                                    CategoryButton(
                                        category: category,
                                        isSelected: selectedCategory == category
                                    ) {
                                        selectedCategory = category
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description / Impressions")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                                .foregroundColor(colorManager.primaryWhite)
                            
                            TextEditor(text: $description)
                                .font(.custom("PlayfairDisplay-Regular", size: 16))
                                .foregroundColor(colorManager.secondaryText)
                                .scrollContentBackground(.hidden)
                                .padding(15)
                                .frame(minHeight: 100)
                                .background(colorManager.primaryWhite)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.1), radius: 3)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Rating")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                                .foregroundColor(colorManager.primaryWhite)
                            
                            HStack(spacing: 8) {
                                ForEach(1...5, id: \.self) { star in
                                    Button(action: {
                                        rating = star
                                    }) {
                                        Image(systemName: star <= rating ? "star.fill" : "star")
                                            .font(.system(size: 24))
                                            .foregroundColor(star <= rating ? colorManager.primaryYellow : colorManager.primaryWhite.opacity(0.5))
                                    }
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 5)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment (Optional)")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                                .foregroundColor(colorManager.primaryWhite)
                            
                            TextEditor(text: $comment)
                                .font(.custom("PlayfairDisplay-Regular", size: 16))
                                .foregroundColor(colorManager.secondaryText)
                                .scrollContentBackground(.hidden)
                                .padding(15)
                                .frame(minHeight: 80)
                                .background(colorManager.primaryWhite)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.1), radius: 3)
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("New Discovery")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.clear, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(colorManager.primaryWhite)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProduct()
                    }
                    .foregroundColor(colorManager.primaryWhite)
                    .fontWeight(.semibold)
                }
            }
            .preferredColorScheme(.dark)
        }
        .alert("Validation Error", isPresented: $showingValidationAlert) {
            Button("OK") { }
        } message: {
            Text("To save the discovery, specify at least the name and category.")
        }
    }
    
    private func saveProduct() {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showingValidationAlert = true
            return
        }
        
        let product = BeautyProduct(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            category: selectedCategory,
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            rating: rating,
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        viewModel.addProduct(product)
        dismiss()
    }
}

struct CategoryButton: View {
    let category: ProductCategory
    let isSelected: Bool
    let action: () -> Void
    
    private let colorManager = ColorManager.shared
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? colorManager.secondaryText : colorManager.primaryWhite)
                
                Text(category.rawValue)
                    .font(.custom("PlayfairDisplay-Medium", size: 12))
                    .foregroundColor(isSelected ? colorManager.secondaryText : colorManager.primaryWhite)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? colorManager.primaryWhite : colorManager.primaryWhite.opacity(0.2))
            )
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    AddProductView(viewModel: BeautyProductViewModel())
}
