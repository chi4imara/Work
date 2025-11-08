import SwiftUI

struct CategoryManagerView: View {
    @ObservedObject var viewModel: RecipeViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var newCategoryName = ""
    @State private var showingAddCategory = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.primaryPurple)
                    .opacity(0)
                    .disabled(true)
                    
                    Spacer()
                    
                    Text("Categories")
                        .foregroundColor(.white)
                        .font(Font.custom("Ubuntu-Regular", size: 17))
                    
                    Spacer()
                    
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.primaryPurple)
                }
                .padding()
                
                HStack {
                    Text("Manage Categories")
                        .font(.ubuntuHeadline)
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddCategory = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.primaryPurple)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Default Categories")
                                .font(.ubuntuCaption)
                                .foregroundColor(.textSecondary)
                                .padding(.horizontal, 20)
                            
                            ForEach(RecipeCategory.allCases.filter { $0 != .custom }, id: \.self) { category in
                                CategoryRowView(
                                    name: category.displayName,
                                    isDefault: true
                                )
                            }
                        }
                        
                        if !viewModel.getAllCustomCategories().isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Custom Categories")
                                    .font(.ubuntuCaption)
                                    .foregroundColor(.textSecondary)
                                    .padding(.horizontal, 20)
                                    .padding(.top, 20)
                                
                                ForEach(viewModel.getAllCustomCategories()) { category in
                                    CategoryRowView(
                                        name: category.name,
                                        isDefault: false,
                                        onDelete: {
                                            viewModel.deleteCustomCategory(category)
                                        }
                                    )
                                }
                            }
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
            .sheet(isPresented: $showingAddCategory) {
                AddCategorySheet(
                    newCategoryName: $newCategoryName,
                    onAdd: {
                        viewModel.addCustomCategory(newCategoryName)
                        newCategoryName = ""
                    }
                )
            }
        }
    }
}

struct CategoryRowView: View {
    let name: String
    let isDefault: Bool
    let onDelete: (() -> Void)?
    
    init(name: String, isDefault: Bool, onDelete: (() -> Void)? = nil) {
        self.name = name
        self.isDefault = isDefault
        self.onDelete = onDelete
    }
    
    var body: some View {
        HStack {
            Text(name)
                .font(.ubuntuBody)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            if isDefault {
                Text("Default")
                    .font(.ubuntuCaption)
                    .foregroundColor(.textSecondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
            } else if let onDelete = onDelete {
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.system(size: 16))
                        .foregroundColor(.accentRed)
                }
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }
}

struct AddCategorySheet: View {
    @Binding var newCategoryName: String
    let onAdd: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 30) {
                VStack(spacing: 16) {
                    Text("Add Custom Category")
                        .font(.ubuntuHeadline)
                        .foregroundColor(.textPrimary)
                    
                    TextField("Category name", text: $newCategoryName)
                        .font(.ubuntuBody)
                        .foregroundColor(.textPrimary)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                }
                .padding(.horizontal, 30)
                .padding(.top, 50)
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .font(.ubuntuHeadline)
                            .foregroundColor(.textSecondary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                    }
                    
                    Button {
                        onAdd()
                        dismiss()
                    } label: {
                        Text("Add")
                            .font(.ubuntuHeadline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                LinearGradient(
                                    colors: [Color.primaryPurple, Color.primaryBlue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                    }
                    .disabled(newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
    }
}

#Preview {
    CategoryManagerView(viewModel: RecipeViewModel())
}
