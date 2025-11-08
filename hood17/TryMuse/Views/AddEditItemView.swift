import SwiftUI

struct AddEditItemView: View {
    @ObservedObject var viewModel: ListViewModel
    let listId: UUID
    let itemToEdit: ListItemModel?
    
    @Environment(\.presentationMode) var presentationMode
    @State private var itemName = ""
    @State private var itemNotes = ""
    
    private var isEditing: Bool {
        itemToEdit != nil
    }
    
    private var isFormValid: Bool {
        !itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    HStack {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(.appBody)
                        .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Text(isEditing ? "Edit Item" : "New Item")
                            .font(.appNavTitle)
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Button("Save") {
                            saveItem()
                        }
                        .font(.appButton)
                        .foregroundColor(isFormValid ? AppColors.yellow : AppColors.secondaryText)
                        .disabled(!isFormValid)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name")
                                .font(.appHeadline)
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter item name", text: $itemName)
                                .font(.appBody)
                                .foregroundColor(AppColors.primaryText)
                                .padding(16)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes (Optional)")
                                .font(.appHeadline)
                                .foregroundColor(AppColors.primaryText)
                            
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                    .frame(minHeight: 100)
                                
                                TextEditor(text: $itemNotes)
                                    .font(.appBody)
                                    .foregroundColor(AppColors.primaryText)
                                    .padding(12)
                                    .background(Color.clear)
                                    .scrollContentBackground(.hidden)
                                
                                if itemNotes.isEmpty {
                                    Text("Add any additional notes...")
                                        .font(.appBody)
                                        .foregroundColor(AppColors.secondaryText)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 20)
                                        .allowsHitTesting(false)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: saveItem) {
                            Text("Save Item")
                                .font(.appButton)
                                .foregroundColor(AppColors.primaryText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(isFormValid ? AppColors.yellow : AppColors.secondaryText.opacity(0.3))
                                .cornerRadius(25)
                                .shadow(color: isFormValid ? AppColors.yellow.opacity(0.3) : Color.clear, radius: 10, x: 0, y: 5)
                        }
                        .disabled(!isFormValid)
                        .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            if let item = itemToEdit {
                itemName = item.name
                itemNotes = item.notes
            }
        }
    }
    
    private func saveItem() {
        let trimmedName = itemName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNotes = itemNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let existingItem = itemToEdit {
            var updatedItem = existingItem
            updatedItem.name = trimmedName
            updatedItem.notes = trimmedNotes
            viewModel.updateItem(updatedItem)
        } else {
            let newItem = ListItemModel(name: trimmedName, notes: trimmedNotes, listId: listId)
            viewModel.addItem(newItem)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddEditItemView(viewModel: ListViewModel(), listId: UUID(), itemToEdit: nil)
}
