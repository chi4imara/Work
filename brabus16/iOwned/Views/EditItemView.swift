import SwiftUI

struct EditItemView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ItemsViewModel()
    
    let item: Item
    
    @State private var itemName: String
    @State private var selectedCategory: ItemCategory
    @State private var characteristics: String
    @State private var notes: String
    @State private var showingCategoryPicker = false
    
    init(item: Item) {
        self.item = item
        self._itemName = State(initialValue: item.name)
        self._selectedCategory = State(initialValue: item.category)
        self._characteristics = State(initialValue: item.characteristics)
        self._notes = State(initialValue: item.notes)
    }
    
    private var isFormValid: Bool {
        !itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var hasChanges: Bool {
        itemName != item.name ||
        selectedCategory != item.category ||
        characteristics != item.characteristics ||
        notes != item.notes
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerView
                        
                        VStack(spacing: 20) {
                            CustomTextField(
                                title: "Item Name",
                                text: $itemName,
                                placeholder: "Enter item name"
                            )
                            
                            categoryPickerView
                            
                            CustomTextEditor(
                                title: "Characteristics",
                                text: $characteristics,
                                placeholder: "Enter item characteristics (optional)"
                            )
                            
                            CustomTextEditor(
                                title: "Notes",
                                text: $notes,
                                placeholder: "Enter notes (optional)"
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 100)
                    }
                }
                
                VStack {
                    Spacer()
                    bottomButtonsView
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private var headerView: some View {
        HStack {
            Button("Cancel") {
                dismiss()
            }
            .font(.playfairDisplay(16, weight: .medium))
            .foregroundColor(ColorTheme.textSecondary)
            
            Spacer()
            
            Text("Edit Item")
                .font(.playfairDisplay(24, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            Spacer()
            
            Button("Cancel") {
            }
            .font(.playfairDisplay(16, weight: .medium))
            .foregroundColor(.clear)
            .disabled(true)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var categoryPickerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Category")
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(ColorTheme.textPrimary)
            
            Button(action: {
                showingCategoryPicker = true
            }) {
                HStack {
                    Image(systemName: selectedCategory.icon)
                        .foregroundColor(ColorTheme.primaryBlue)
                    
                    Text(selectedCategory.displayName)
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(ColorTheme.textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ColorTheme.backgroundWhite)
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                            .stroke(ColorTheme.lightBlue, lineWidth: 1)
                        }
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .actionSheet(isPresented: $showingCategoryPicker) {
            ActionSheet(
                title: Text("Select Category"),
                buttons: ItemCategory.allCases.map { category in
                    .default(Text(category.displayName)) {
                        selectedCategory = category
                    }
                } + [.cancel()]
            )
        }
    }
    
    private var bottomButtonsView: some View {
        HStack(spacing: 16) {
            Button {
                dismiss()
            } label: {
                Text("Cancel")
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(ColorTheme.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(ColorTheme.textSecondary.opacity(0.3), lineWidth: 1)
                    )
            }
            
            Button {
                saveChanges()
            } label: {
                Text("Save Changes")
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor((isFormValid && hasChanges) ? ColorTheme.textPrimary : ColorTheme.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill((isFormValid && hasChanges) ? AnyShapeStyle(ColorTheme.primaryButtonGradient) : AnyShapeStyle(Color.gray.opacity(0.3)))
                    )
            }
            .disabled(!isFormValid || !hasChanges)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    private func saveChanges() {
        HapticManager.notification(.success)
        viewModel.updateItem(
            item,
            name: itemName.trimmingCharacters(in: .whitespacesAndNewlines),
            category: selectedCategory,
            characteristics: characteristics.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        dismiss()
    }
}

#Preview {
    EditItemView(item: Item(
        name: "Sample Item",
        category: .tools,
        characteristics: "Sample characteristics",
        notes: "Sample notes"
    ))
}
