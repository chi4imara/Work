import SwiftUI

struct AddItemView: View {
    @EnvironmentObject var inventoryViewModel: InventoryViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var itemName = ""
    @State private var location = ""
    @State private var owner = ""
    @State private var notes = ""
    
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
                        
                        Text("New Item")
                            .font(.playfairDisplay(20, weight: .bold))
                            .foregroundColor(AppColors.primaryTextWhite)
                        
                        Spacer()
                        
                        Button("Save") {
                            saveItem()
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
        !owner.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func saveItem() {
        let newItem = Item(
            name: itemName.trimmingCharacters(in: .whitespacesAndNewlines),
            location: location.trimmingCharacters(in: .whitespacesAndNewlines),
            owner: owner.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        inventoryViewModel.addItem(newItem)
        presentationMode.wrappedValue.dismiss()
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
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(AppColors.primaryTextWhite)
            
            if isMultiline {
                TextField(placeholder, text: $text, axis: .vertical)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(AppColors.secondaryTextWhite)
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppColors.gridWhite.opacity(0.3), lineWidth: 1)
                            )
                    )
                    .lineLimit(3...6)
            } else {
                TextField(placeholder, text: $text)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(AppColors.secondaryTextWhite)
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppColors.gridWhite.opacity(0.3), lineWidth: 1)
                            )
                    )
            }
        }
    }
}

#Preview {
    AddItemView()
        .environmentObject(InventoryViewModel())
}
