import SwiftUI

struct AddProductView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var productViewModel: ProductViewModel
    
    @State private var name: String = ""
    @State private var selectedCategory: String = ""
    @State private var newCategoryName: String = ""
    @State private var showingNewCategoryField: Bool = false
    @State private var rating: Int = 5
    @State private var expirationDate: Date = Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date()
    @State private var comment: String = ""
    
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        (!showingNewCategoryField || !newCategoryName.trimmingCharacters(in: .whitespaces).isEmpty) &&
        (!selectedCategory.isEmpty || showingNewCategoryField)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColorScheme.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name")
                                .font(.playfairDisplay(16, weight: .medium))
                                .foregroundColor(.textPrimary)
                            
                            TextField("Enter product name", text: $name)
                                .font(.playfairDisplay(16))
                                .foregroundColor(.textPrimary)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 12)
                                .background(Color.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.cardBorder, lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.playfairDisplay(16, weight: .medium))
                                .foregroundColor(.textPrimary)
                            
                            if showingNewCategoryField {
                                HStack {
                                    TextField("Enter new category", text: $newCategoryName)
                                        .font(.playfairDisplay(16))
                                        .foregroundColor(.textPrimary)
                                        .padding(.horizontal, 15)
                                        .padding(.vertical, 12)
                                        .background(Color.cardBackground)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.cardBorder, lineWidth: 1)
                                        )
                                    
                                    Button("Cancel") {
                                        showingNewCategoryField = false
                                        newCategoryName = ""
                                    }
                                    .font(.playfairDisplay(14, weight: .medium))
                                    .foregroundColor(.textSecondary)
                                }
                            } else {
                                Menu {
                                    ForEach(productViewModel.categories, id: \.name) { category in
                                        Button(category.name) {
                                            selectedCategory = category.name
                                        }
                                    }
                                    
                                    Divider()
                                    
                                    Button("Create New Category") {
                                        showingNewCategoryField = true
                                        selectedCategory = ""
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedCategory.isEmpty ? "Select category" : selectedCategory)
                                            .font(.playfairDisplay(16))
                                            .foregroundColor(selectedCategory.isEmpty ? .textSecondary : .textPrimary)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(.textSecondary)
                                    }
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 12)
                                    .background(Color.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.cardBorder, lineWidth: 1)
                                    )
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Rating")
                                .font(.playfairDisplay(16, weight: .medium))
                                .foregroundColor(.textPrimary)
                            
                            HStack {
                                StarRatingView(rating: $rating, size: 24, interactive: true)
                                Spacer()
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 12)
                            .background(Color.cardBackground)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.cardBorder, lineWidth: 1)
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Expiration Date")
                                .font(.playfairDisplay(16, weight: .medium))
                                .foregroundColor(.textPrimary)
                            
                            DatePicker("", selection: $expirationDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .colorScheme(.dark)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 12)
                                .background(Color.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.cardBorder, lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment (Optional)")
                                .font(.playfairDisplay(16, weight: .medium))
                                .foregroundColor(.textPrimary)
                            
                            TextField("Add your notes...", text: $comment, axis: .vertical)
                                .font(.playfairDisplay(16))
                                .foregroundColor(.textPrimary)
                                .lineLimit(3...6)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 12)
                                .background(Color.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.cardBorder, lineWidth: 1)
                                )
                        }
                        
                        CustomButton(title: "Save", style: .primary, isEnabled: canSave, action: saveProduct)
                            .padding(.top, 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
            }
            .navigationTitle("New Product")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.textSecondary)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    private func saveProduct() {
        let finalCategory = showingNewCategoryField ? newCategoryName : selectedCategory
        
        let product = Product(
            name: name.trimmingCharacters(in: .whitespaces),
            category: finalCategory.trimmingCharacters(in: .whitespaces),
            rating: rating,
            expirationDate: expirationDate,
            comment: comment.trimmingCharacters(in: .whitespaces)
        )
        
        productViewModel.addProduct(product)
        dismiss()
    }
}

#Preview {
    AddProductView()
        .environmentObject(ProductViewModel())
}
