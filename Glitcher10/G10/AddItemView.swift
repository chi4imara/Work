import SwiftUI

struct AddItemView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ShoppingViewModel
    @State private var name = ""
    @State private var category = ""
    @State private var quantity = ""
    @State private var comment = ""
    @State private var showingSavedView = false
    @State private var savedItem: ShoppingItem?
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("New Item")
                            .font(FontManager.ubuntu(size: 28, weight: .bold))
                            .foregroundColor(ColorManager.white)
                        
                        Text("Add a new item to your garage shopping list")
                            .font(FontManager.ubuntu(size: 16))
                            .foregroundColor(ColorManager.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        CustomTextField(
                            title: "Name",
                            text: $name,
                            placeholder: "e.g., Motor oil 5W-30"
                        )
                        
                        CustomTextField(
                            title: "Category",
                            text: $category,
                            placeholder: "e.g., Oils, Parts, Tools"
                        )
                        
                        CustomTextField(
                            title: "Quantity",
                            text: $quantity,
                            placeholder: "e.g., 1, 4, 10, 2L"
                        )
                        
                        CustomTextField(
                            title: "Comment",
                            text: $comment,
                            placeholder: "Optional notes...",
                            isMultiline: true
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    Button(action: saveItem) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Save")
                        }
                        .font(FontManager.ubuntu(size: 18, weight: .medium))
                        .foregroundColor(ColorManager.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            isFormValid ? AnyShapeStyle(ColorManager.buttonGradient) : AnyShapeStyle(ColorManager.darkGray.opacity(0.5))
                        )
                        .cornerRadius(16)
                        .shadow(
                            color: isFormValid ? ColorManager.lightBlue.opacity(0.3) : Color.clear,
                            radius: 10, x: 0, y: 5
                        )
                    }
                    .disabled(!isFormValid)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
                .padding(.bottom, 10)
            }
        }
        .sheet(item: $savedItem) { item in
            ItemSavedView(item: item) {
                clearForm()
                dismiss()
                savedItem = nil
            }
        }
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !category.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !quantity.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func saveItem() {
        let newItem = ShoppingItem(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            category: category.trimmingCharacters(in: .whitespacesAndNewlines),
            quantity: quantity.trimmingCharacters(in: .whitespacesAndNewlines),
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        viewModel.addItem(newItem)
        savedItem = newItem
        showingSavedView = true
    }
    
    private func clearForm() {
        name = ""
        category = ""
        quantity = ""
        comment = ""
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var isMultiline: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(FontManager.ubuntu(size: 16, weight: .medium))
                .foregroundColor(ColorManager.white)
            
            Group {
                if isMultiline {
                    TextField(placeholder, text: $text, axis: .vertical)
                        .lineLimit(3...6)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .font(FontManager.ubuntu(size: 16))
            .foregroundColor(ColorManager.white)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorManager.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
}

#Preview {
    AddItemView(viewModel: ShoppingViewModel())
}
