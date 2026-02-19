import SwiftUI

struct AddCategoryView: View {
    @EnvironmentObject var viewModel: WardrobeViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var isRepeating = true
    
    private var isFormValid: Bool {
        !name.isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.gradient
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Image(systemName: "folder.fill.badge.plus")
                        .font(.system(size: 60))
                        .foregroundColor(AppColors.primary)
                        .padding(.top, 40)
                    
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category Name *")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.textPrimary)
                            
                            TextField("Enter category name", text: $name)
                                .font(.ubuntu(18))
                                .foregroundColor(AppColors.textPrimary)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(AppColors.cardBackground)
                                        .shadow(color: AppColors.shadow, radius: 4, x: 0, y: 2)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Category Type")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.textPrimary)
                            
                            VStack(spacing: 12) {
                                CategoryTypeOption(
                                    title: "Repeating",
                                    description: "Items that can be worn multiple times",
                                    isSelected: isRepeating
                                ) {
                                    isRepeating = true
                                }
                                
                                CategoryTypeOption(
                                    title: "One-time",
                                    description: "Special occasion items",
                                    isSelected: !isRepeating
                                ) {
                                    isRepeating = false
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
            .navigationTitle("New Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveCategory()
                    }
                    .foregroundColor(isFormValid ? AppColors.primary : AppColors.textSecondary)
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    private func saveCategory() {
        let category = Category(name: name, isRepeating: isRepeating)
        viewModel.addCategory(category)
        dismiss()
    }
}

struct CategoryTypeOption: View {
    let title: String
    let description: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Circle()
                    .fill(isSelected ? AppColors.primary : Color.clear)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Circle()
                            .stroke(isSelected ? AppColors.primary : AppColors.textSecondary, lineWidth: 2)
                    )
                    .overlay(
                        Circle()
                            .fill(.white)
                            .frame(width: 8, height: 8)
                            .opacity(isSelected ? 1 : 0)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text(description)
                        .font(.ubuntu(12))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppColors.primary.opacity(0.1) : AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? AppColors.primary : Color.clear, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AddCategoryView()
        .environmentObject(WardrobeViewModel())
}
