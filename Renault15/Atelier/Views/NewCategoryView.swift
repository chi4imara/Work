import SwiftUI

struct NewCategoryView: View {
    @ObservedObject var viewModel: HairstyleViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var isRepeating = false
    
    private var isFormValid: Bool {
        !name.isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.primaryGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(spacing: 20) {
                        CustomTextField(
                            title: "Category Name",
                            text: $name,
                            placeholder: "Enter category name"
                        )
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Type")
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.primaryWhite)
                            
                            Toggle("Repeating Category", isOn: $isRepeating)
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.primaryWhite)
                        }
                    }
                    
                    VStack(spacing: 16) {
                        Button("Save Category") {
                            saveCategory()
                        }
                        .font(AppFonts.button)
                        .foregroundColor(isFormValid ? AppColors.darkBlue : AppColors.darkGray)
                        .frame(maxWidth: .infinity)
                        .frame(height: AppDimensions.buttonHeight)
                        .background(isFormValid ? AppColors.primaryYellow : AppColors.lightGray)
                        .cornerRadius(AppDimensions.cornerRadius)
                        .disabled(!isFormValid)
                        
                        Button("Cancel") {
                            dismiss()
                        }
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                    }
                    .padding(.bottom, 30)
                    
                    Spacer()
                }
                .padding(.horizontal, AppDimensions.screenPadding)
            }
            .navigationTitle("New Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryYellow)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    private func saveCategory() {
        let category = CustomCategory(name: name, isRepeating: isRepeating)
        viewModel.addCustomCategory(category)
        dismiss()
    }
}

#Preview {
    NewCategoryView(viewModel: HairstyleViewModel())
}
