import SwiftUI

struct EditItemView: View {
    let item: Item
    @EnvironmentObject var inventoryViewModel: InventoryViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var itemName: String
    @State private var location: String
    @State private var owner: String
    @State private var notes: String
    
    init(item: Item) {
        self.item = item
        self._itemName = State(initialValue: item.name)
        self._location = State(initialValue: item.location)
        self._owner = State(initialValue: item.owner)
        self._notes = State(initialValue: item.notes)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                GridBackgroundView()
                
                VStack(spacing: 0) {
                    HStack {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(AppColors.primaryTextWhite)
                        
                        Spacer()
                        
                        Text("Edit Item")
                            .font(.playfairDisplay(20, weight: .bold))
                            .foregroundColor(AppColors.primaryTextWhite)
                        
                        Spacer()
                        
                        Button("Save Changes") {
                            saveChanges()
                        }
                        .font(.playfairDisplay(16, weight: .semibold))
                        .foregroundColor(canSave ? AppColors.accentGreen : AppColors.secondaryTextWhite.opacity(0.5))
                        .disabled(!canSave)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            CustomTextField(
                                title: "Item Name",
                                text: $itemName,
                                placeholder: "Enter item name"
                            )
                            
                            CustomTextField(
                                title: "Storage Location",
                                text: $location,
                                placeholder: "Where is it stored?"
                            )
                            
                            CustomTextField(
                                title: "Owner",
                                text: $owner,
                                placeholder: "Who does it belong to?"
                            )
                            
                            CustomTextField(
                                title: "Notes",
                                text: $notes,
                                placeholder: "Additional notes (optional)",
                                isMultiline: true
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var canSave: Bool {
        !itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !owner.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        (itemName != item.name || location != item.location || owner != item.owner || notes != item.notes)
    }
    
    private func saveChanges() {
        var updatedItem = item
        updatedItem.name = itemName.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedItem.location = location.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedItem.owner = owner.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedItem.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        inventoryViewModel.updateItem(updatedItem)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    EditItemView(item: Item.sampleItems[0])
        .environmentObject(InventoryViewModel())
}
