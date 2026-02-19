import SwiftUI

struct AddRecipeView: View {
    @ObservedObject var viewModel: RecipeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var selectedCategory = RecipeCategory.scrubs
    @State private var ingredients = ""
    @State private var proportions = ""
    @State private var process = ""
    @State private var notes = ""
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        HStack {
                            Button("Cancel") {
                                presentationMode.wrappedValue.dismiss()
                            }
                            .font(.ubuntu(16))
                            .foregroundColor(ColorManager.accent)
                            
                            Spacer()
                            
                            Text("New Recipe")
                                .font(.ubuntu(20, weight: .medium))
                                .foregroundColor(ColorManager.primaryText)
                            
                            Spacer()
                            
                            Button("Save") {
                                saveRecipe()
                            }
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(isFormValid ? ColorManager.primaryText : ColorManager.secondaryText)
                            .disabled(!isFormValid)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 14)
                        
                        VStack(spacing: 16) {
                            FormFieldView(title: "Recipe Name", isRequired: true) {
                                TextField("Enter recipe name", text: $name)
                                    .font(.ubuntu(16))
                                    .foregroundColor(ColorManager.primaryText)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(ColorManager.cardBackground)
                                    )
                            }
                            
                            FormFieldView(title: "Category") {
                                Menu {
                                    ForEach(RecipeCategory.allCases) { category in
                                        Button(category.displayName) {
                                            selectedCategory = category
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedCategory.displayName)
                                            .font(.ubuntu(16))
                                            .foregroundColor(ColorManager.primaryText)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 14))
                                            .foregroundColor(ColorManager.secondaryText)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(ColorManager.cardBackground)
                                    )
                                }
                            }
                            
                            FormFieldView(title: "Ingredients") {
                                TextEditor(text: $ingredients)
                                    .font(.ubuntu(16))
                                    .foregroundColor(ColorManager.primaryText)
                                    .scrollContentBackground(.hidden)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minHeight: 80)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(ColorManager.cardBackground)
                                    )
                            }
                            
                            FormFieldView(title: "Proportions / Formula") {
                                TextEditor(text: $proportions)
                                    .font(.ubuntu(16))
                                    .foregroundColor(ColorManager.primaryText)
                                    .scrollContentBackground(.hidden)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minHeight: 60)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(ColorManager.cardBackground)
                                    )
                            }
                            
                            FormFieldView(title: "Preparation Process") {
                                TextEditor(text: $process)
                                    .font(.ubuntu(16))
                                    .foregroundColor(ColorManager.primaryText)
                                    .scrollContentBackground(.hidden)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minHeight: 100)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(ColorManager.cardBackground)
                                    )
                            }
                            
                            FormFieldView(title: "Notes (Optional)") {
                                TextEditor(text: $notes)
                                    .font(.ubuntu(16))
                                    .foregroundColor(ColorManager.primaryText)
                                    .scrollContentBackground(.hidden)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minHeight: 60)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(ColorManager.cardBackground)
                                    )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func saveRecipe() {
        let recipe = Recipe(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            category: selectedCategory,
            ingredients: ingredients,
            proportions: proportions,
            process: process,
            notes: notes
        )
        
        viewModel.addRecipe(recipe)
        presentationMode.wrappedValue.dismiss()
    }
}

struct FormFieldView<Content: View>: View {
    let title: String
    let isRequired: Bool
    let content: Content
    
    init(title: String, isRequired: Bool = false, @ViewBuilder content: () -> Content) {
        self.title = title
        self.isRequired = isRequired
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                
                if isRequired {
                    Text("*")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorManager.yellow)
                }
            }
            
            content
        }
    }
}

#Preview {
    AddRecipeView(viewModel: RecipeViewModel())
}
