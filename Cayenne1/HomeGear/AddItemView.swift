import SwiftUI

struct AddItemView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var selectedCategory = ItemCategory.tools
    @State private var location = ""
    @State private var selectedStatus = ItemStatus.working
    @State private var comment = ""
    @State private var showingCategoryPicker = false
    @State private var showingStatusPicker = false
    
    let onSave: (InventoryItem) -> Void
    
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
                        
                        Button(action: saveItem) {
                            Text("Save")
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
            .navigationTitle("New Item")
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
    
    private func saveItem() {
        let item = InventoryItem(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            category: selectedCategory,
            location: location.trimmingCharacters(in: .whitespacesAndNewlines),
            status: selectedStatus,
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        onSave(item)
        dismiss()
    }
}

struct FormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            TextField(placeholder, text: $text)
                .font(.playfairDisplay(16, weight: .regular))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(AppColors.cardGradient)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.borderColor, lineWidth: 1)
                )
        }
    }
}

struct FormTextArea: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            TextField(placeholder, text: $text, axis: .vertical)
                .font(.playfairDisplay(16, weight: .regular))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(minHeight: 80)
                .background(AppColors.cardGradient)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.borderColor, lineWidth: 1)
                )
        }
    }
}

struct FormPickerField: View {
    let title: String
    let selectedValue: String
    @Binding var showingPicker: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            Button(action: { showingPicker = true }) {
                HStack {
                    Text(selectedValue)
                        .font(.playfairDisplay(16, weight: .regular))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.accentText)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(AppColors.cardGradient)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.borderColor, lineWidth: 1)
                )
            }
        }
    }
}

struct CategoryPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedCategory: ItemCategory
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                List {
                    ForEach(ItemCategory.allCases) { category in
                        Button(action: {
                            selectedCategory = category
                            dismiss()
                        }) {
                            HStack {
                                Text(category.displayName)
                                    .font(.playfairDisplay(16, weight: .regular))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Spacer()
                                
                                if selectedCategory == category {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(AppColors.lightBlue)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .listRowBackground(AppColors.cardGradient)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Select Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.accentText)
                }
            }
        }
    }
}

struct StatusPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedStatus: ItemStatus
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                List {
                    ForEach(ItemStatus.allCases) { status in
                        Button(action: {
                            selectedStatus = status
                            dismiss()
                        }) {
                            HStack {
                                Text(status.displayName)
                                    .font(.playfairDisplay(16, weight: .regular))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Spacer()
                                
                                if selectedStatus == status {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(AppColors.lightBlue)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .listRowBackground(AppColors.cardGradient)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Select Condition")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.accentText)
                }
            }
        }
    }
}

#Preview {
    AddItemView { item in
        print("Added item: \(item.name)")
    }
}
