import SwiftUI

struct AddItemView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: ItemsViewModel
    
    @State private var itemName = ""
    @State private var selectedCategory = ItemCategory.tools
    @State private var characteristics = ""
    @State private var notes = ""
    @State private var showingCategoryPicker = false
    @Binding var selectedTab: Int
    
    private var isFormValid: Bool {
        !itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
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
                        
                        bottomButtonsView
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 120)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("New Item")
                .font(.playfairDisplay(32, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            Spacer()
        }
        .padding(.vertical, 10)
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
        VStack(spacing: 16) {
            Button {
                saveItem()
            } label: {
                Text("Save")
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(isFormValid ? ColorTheme.textPrimary : ColorTheme.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isFormValid ? AnyShapeStyle(ColorTheme.primaryButtonGradient) : AnyShapeStyle(Color.gray.opacity(0.3)))
                    )
                
            }
            .disabled(!isFormValid)
            
            Button {
                withAnimation {
                    itemName = ""
                    selectedCategory = ItemCategory.tools
                    characteristics = ""
                    notes = ""
                    showingCategoryPicker = false
                }
            } label: {
                Text("Reset")
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(ColorTheme.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(ColorTheme.textSecondary.opacity(0.3), lineWidth: 1)
                    )
                
            }
        }
    }
    
    private func saveItem() {
        HapticManager.notification(.success)
        viewModel.addItem(
            name: itemName.trimmingCharacters(in: .whitespacesAndNewlines),
            category: selectedCategory,
            characteristics: characteristics.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        dismiss()
        
        withAnimation {
            selectedTab = 0
            itemName = ""
            selectedCategory = ItemCategory.tools
            characteristics = ""
            notes = ""
            showingCategoryPicker = false
        }
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(ColorTheme.textPrimary)
            
            TextField(placeholder, text: $text)
                .font(.playfairDisplay(16, weight: .medium))
                .foregroundColor(ColorTheme.textPrimary)
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
    }
}

struct CustomTextEditor: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(ColorTheme.textPrimary)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorTheme.backgroundWhite)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(ColorTheme.lightBlue, lineWidth: 1)
                    }
                    .frame(minHeight: 100)
                
                if text.isEmpty {
                    Text(placeholder)
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary.opacity(0.6))
                        .padding(16)
                }
                
                TextEditor(text: $text)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(ColorTheme.textPrimary)
                    .scrollContentBackground(.hidden)
                    .padding(12)
                    .background(Color.clear)
            }
        }
    }
}
