import SwiftUI

struct EditItemView: View {
    let item: ShoppingItem
    @ObservedObject var viewModel: ShoppingViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String
    @State private var category: String
    @State private var quantity: String
    @State private var comment: String
    
    init(item: ShoppingItem, viewModel: ShoppingViewModel) {
        self.item = item
        self.viewModel = viewModel
        self._name = State(initialValue: item.name)
        self._category = State(initialValue: item.category)
        self._quantity = State(initialValue: item.quantity)
        self._comment = State(initialValue: item.comment)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text("Edit Item")
                                .font(FontManager.ubuntu(size: 28, weight: .bold))
                                .foregroundColor(ColorManager.white)
                            
                            Text("Update your item details")
                                .font(FontManager.ubuntu(size: 16))
                                .foregroundColor(ColorManager.white.opacity(0.7))
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
                        
                        Button(action: saveChanges) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Save Changes")
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
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(FontManager.ubuntu(size: 16))
                    .foregroundColor(ColorManager.lightBlue)
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !category.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !quantity.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var hasChanges: Bool {
        name.trimmingCharacters(in: .whitespacesAndNewlines) != item.name ||
        category.trimmingCharacters(in: .whitespacesAndNewlines) != item.category ||
        quantity.trimmingCharacters(in: .whitespacesAndNewlines) != item.quantity ||
        comment.trimmingCharacters(in: .whitespacesAndNewlines) != item.comment
    }
    
    private func saveChanges() {
        let updatedItem = ShoppingItem(
            id: item.id,
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            category: category.trimmingCharacters(in: .whitespacesAndNewlines),
            quantity: quantity.trimmingCharacters(in: .whitespacesAndNewlines),
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines),
            dateCreated: item.dateCreated
        )
        
        viewModel.updateItem(updatedItem)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    EditItemView(
        item: ShoppingItem(
            name: "Motor Oil 5W-30",
            category: "Oils",
            quantity: "1",
            comment: "For winter maintenance"
        ),
        viewModel: ShoppingViewModel()
    )
}
