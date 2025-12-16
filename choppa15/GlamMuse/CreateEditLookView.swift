import SwiftUI

struct CreateEditLookView: View {
    @ObservedObject var viewModel: MakeupLooksViewModel
    @Environment(\.dismiss) private var dismiss
    
    let lookToEdit: MakeupLook?
    
    @State private var name = ""
    @State private var selectedCategory: MakeupCategory = .daily
    @State private var mainShades = ""
    @State private var applicationSteps = ""
    @State private var products = ""
    @State private var result = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    init(viewModel: MakeupLooksViewModel, lookToEdit: MakeupLook? = nil) {
        self.viewModel = viewModel
        self.lookToEdit = lookToEdit
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        FormSection(title: "Look Name *") {
                            CustomTextField(
                                placeholder: "e.g., Pink Morning",
                                text: $name
                            )
                        }
                        
                        FormSection(title: "Category") {
                            CategorySelector(selectedCategory: $selectedCategory)
                        }
                        
                        FormSection(title: "Main Shades") {
                            CustomTextField(
                                placeholder: "e.g., pink, champagne, beige",
                                text: $mainShades
                            )
                        }
                        
                        FormSection(title: "Application Steps") {
                            CustomTextEditor(
                                placeholder: "1. Foundation - light coverage\n2. Warm blush\n3. Lip gloss",
                                text: $applicationSteps
                            )
                        }
                        
                        FormSection(title: "Products Used") {
                            CustomTextEditor(
                                placeholder: "NARS Orgasm Blush, Dior Lip Glow",
                                text: $products
                            )
                        }
                        
                        FormSection(title: "Final Result") {
                            CustomTextEditor(
                                placeholder: "Fresh, glowing look with emphasis on skin",
                                text: $result
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
            }
            .navigationTitle(lookToEdit == nil ? "New Look" : "Edit Look")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveLook()
                    }
                    .foregroundColor(AppColors.primaryText)
                    .fontWeight(.medium)
                }
            }
            .preferredColorScheme(.dark)
        }
        .onAppear {
            loadLookData()
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func loadLookData() {
        if let look = lookToEdit {
            name = look.name
            selectedCategory = look.category
            mainShades = look.mainShades.joined(separator: ", ")
            applicationSteps = look.applicationSteps
            products = look.products.joined(separator: ", ")
            result = look.result
        }
    }
    
    private func saveLook() {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Look name is required"
            showingAlert = true
            return
        }
        
        let shadesArray = mainShades.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        let productsArray = products.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        
        if let existingLook = lookToEdit {
            var updatedLook = existingLook
            updatedLook.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedLook.category = selectedCategory
            updatedLook.mainShades = shadesArray
            updatedLook.applicationSteps = applicationSteps.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedLook.products = productsArray
            updatedLook.result = result.trimmingCharacters(in: .whitespacesAndNewlines)
            
            viewModel.updateLook(updatedLook)
        } else {
            let newLook = MakeupLook(
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                category: selectedCategory,
                mainShades: shadesArray,
                applicationSteps: applicationSteps.trimmingCharacters(in: .whitespacesAndNewlines),
                products: productsArray,
                result: result.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            
            viewModel.addLook(newLook)
        }
        
        dismiss()
    }
}

struct FormSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            content
        }
    }
}

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .font(.ubuntu(16))
            .foregroundColor(AppColors.darkText)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
    }
}

struct CustomTextEditor: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.darkText.opacity(0.5))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
            }
            
            TextEditor(text: $text)
                .font(.ubuntu(16))
                .foregroundColor(AppColors.darkText)
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(minHeight: 80)
                .background(AppColors.cardBackground)
                .cornerRadius(12)
        }
    }
}

struct CategorySelector: View {
    @Binding var selectedCategory: MakeupCategory
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(MakeupCategory.allCases, id: \.self) { category in
                Button(action: {
                    selectedCategory = category
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: category.icon)
                            .font(.system(size: 14))
                        Text(category.rawValue)
                            .font(.ubuntu(14, weight: .medium))
                    }
                    .foregroundColor(selectedCategory == category ? AppColors.primaryText : AppColors.darkText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(selectedCategory == category ? AppColors.buttonPrimary : AppColors.cardBackground)
                    )
                }
                .animation(.easeInOut(duration: 0.2), value: selectedCategory)
            }
        }
    }
}

#Preview {
    CreateEditLookView(viewModel: MakeupLooksViewModel())
}
