import SwiftUI

struct AddEditItemView: View {
    @EnvironmentObject var itemStore: ItemStore
    @Environment(\.dismiss) private var dismiss
    
    let item: Item?
    
    @State private var name: String = ""
    @State private var selectedCategory: String = ""
    @State private var story: String = ""
    @State private var datePeriod: String = ""
    @State private var showingNewCategoryAlert = false
    @State private var newCategoryName = ""
    
    private var isEditing: Bool {
        item != nil
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !selectedCategory.isEmpty &&
        !story.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 20) {
                            FormField(
                                title: "Item Name",
                                text: $name,
                                placeholder: "Enter item name"
                            )
                            
                            CategoryPickerField()
                            
                            FormTextEditor(
                                title: "Story",
                                text: $story,
                                placeholder: "Tell the story of this item..."
                            )
                            
                            FormField(
                                title: "Date/Period (Optional)",
                                text: $datePeriod,
                                placeholder: "e.g., 1950s, Grandmother's era"
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Item" : "New Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveItem()
                    }
                    .foregroundColor(isFormValid ? .primaryYellow : .textTertiary)
                    .disabled(!isFormValid)
                }
            }
        }
        .onAppear {
            setupForm()
        }
        .alert("New Category", isPresented: $showingNewCategoryAlert) {
            TextField("Category Name", text: $newCategoryName)
            Button("Cancel", role: .cancel) {
                newCategoryName = ""
            }
            Button("Add") {
                addNewCategory()
            }
        } message: {
            Text("Enter the name for the new category")
        }
    }
    
    @ViewBuilder
    private func CategoryPickerField() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Category")
                    .font(.playfairHeadingMedium(16))
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Button("New") {
                    showingNewCategoryAlert = true
                }
                .font(.playfairCaptionMedium(14))
                .foregroundColor(.primaryYellow)
            }
            
            Menu {
                ForEach(itemStore.categories, id: \.id) { category in
                    Button(category.name) {
                        selectedCategory = category.name
                    }
                }
            } label: {
                HStack {
                    Text(selectedCategory.isEmpty ? "Select category" : selectedCategory)
                        .font(.playfairBody(16))
                        .foregroundColor(selectedCategory.isEmpty ? .textTertiary : .textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.textSecondary)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.cardBorder, lineWidth: 1)
                        )
                )
            }
        }
    }
    
    private func setupForm() {
        if let item = item {
            name = item.name
            selectedCategory = item.category
            story = item.story
            datePeriod = item.datePeriod ?? ""
        } else {
            if let firstCategory = itemStore.categories.first {
                selectedCategory = firstCategory.name
            }
        }
    }
    
    private func addNewCategory() {
        let trimmedName = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedName.isEmpty {
            let newCategory = Category(name: trimmedName)
            itemStore.addCategory(newCategory)
            selectedCategory = trimmedName
        }
        newCategoryName = ""
    }
    
    private func saveItem() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedStory = story.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDatePeriod = datePeriod.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isEditing, var existingItem = item {
            existingItem.name = trimmedName
            existingItem.category = selectedCategory
            existingItem.story = trimmedStory
            existingItem.datePeriod = trimmedDatePeriod.isEmpty ? nil : trimmedDatePeriod
            itemStore.updateItem(existingItem)
        } else {
            let newItem = Item(
                name: trimmedName,
                category: selectedCategory,
                story: trimmedStory,
                datePeriod: trimmedDatePeriod.isEmpty ? nil : trimmedDatePeriod
            )
            itemStore.addItem(newItem)
        }
        
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
                .font(.playfairHeadingMedium(16))
                .foregroundColor(.textPrimary)
            
            TextField(placeholder, text: $text)
                .font(.playfairBody(16))
                .foregroundColor(.textPrimary)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.cardBorder, lineWidth: 1)
                        )
                )
        }
    }
}

struct FormTextEditor: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfairHeadingMedium(16))
                .foregroundColor(.textPrimary)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.cardBorder, lineWidth: 1)
                    )
                    .frame(minHeight: 120)
                
                if text.isEmpty {
                    Text(placeholder)
                        .font(.playfairBody(16))
                        .foregroundColor(.textTertiary)
                        .padding(16)
                }
                
                TextEditor(text: $text)
                    .font(.playfairBody(16))
                    .foregroundColor(.textPrimary)
                    .padding(12)
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
            }
        }
    }
}

#Preview {
    AddEditItemView(item: nil)
        .environmentObject(ItemStore())
}
