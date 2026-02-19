import SwiftUI

struct EditItemView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var selectedCategory: ItemCategory
    @State private var location: String
    @State private var selectedStatus: ItemStatus
    @State private var comment: String
    @State private var showingCategoryPicker = false
    @State private var showingStatusPicker = false
    
    let item: InventoryItem
    let onSave: (InventoryItem) -> Void
    
    init(item: InventoryItem, onSave: @escaping (InventoryItem) -> Void) {
        self.item = item
        self.onSave = onSave
        
        _name = State(initialValue: item.name)
        _selectedCategory = State(initialValue: item.category)
        _location = State(initialValue: item.location)
        _selectedStatus = State(initialValue: item.status)
        _comment = State(initialValue: item.comment)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        FormField(title: "Name", text: $name, placeholder: "Enter item name")
                        
                        FormPickerField(
                            title: "Category",
                            selectedValue: selectedCategory.displayName,
                            showingPicker: $showingCategoryPicker
                        )
                        
                        FormField(title: "Storage Location", text: $location, placeholder: "Where is it stored?")
                        
                        FormPickerField(
                            title: "Condition",
                            selectedValue: selectedStatus.displayName,
                            showingPicker: $showingStatusPicker
                        )
                        
                        FormTextArea(title: "Comment", text: $comment, placeholder: "Additional notes (optional)")
                        
                        Button(action: saveChanges) {
                            Text("Save Changes")
                                .font(.playfairDisplay(18, weight: .semibold))
                                .foregroundColor(AppColors.primaryText)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(isFormValid ? AnyShapeStyle(AppColors.buttonGradient) : AnyShapeStyle(AppColors.borderColor))
                                .cornerRadius(25)
                                .shadow(color: AppColors.shadowColor, radius: isFormValid ? 10 : 0, x: 0, y: isFormValid ? 5 : 0)
                        }
                        .disabled(!isFormValid)
                        .padding(.top, 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
            }
            .navigationTitle("Edit Item")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.accentText)
                }
            }
        }
        .sheet(isPresented: $showingCategoryPicker) {
            CategoryPickerView(selectedCategory: $selectedCategory)
        }
        .sheet(isPresented: $showingStatusPicker) {
            StatusPickerView(selectedStatus: $selectedStatus)
        }
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func saveChanges() {
        var updatedItem = item
        updatedItem.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedItem.category = selectedCategory
        updatedItem.location = location.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedItem.status = selectedStatus
        updatedItem.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
        
        onSave(updatedItem)
        dismiss()
    }
}

#Preview {
    EditItemView(
        item: InventoryItem(
            name: "Drill",
            category: .tools,
            location: "Garage",
            status: .working,
            comment: "Test comment"
        )
    ) { _ in }
}
