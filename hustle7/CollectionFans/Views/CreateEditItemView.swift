import SwiftUI

struct CreateEditItemView: View {
    @ObservedObject var store: CollectionStore
    let collectionId: UUID
    @Binding var item: Item?
    
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var selectedStatus: ItemStatus = .inCollection
    @State private var description: String = ""
    @State private var selectedCondition: ItemCondition? = nil
    @State private var notes: String = ""
    @State private var showingDeleteAlert = false
    @State private var showingDiscardAlert = false
    @State private var hasChanges = false
    
    private var isEditing: Bool {
        item != nil
    }
    
    private var isValidForm: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        name.count <= 50 &&
        description.count <= 300 &&
        notes.count <= 200
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Item Name")
                                    .font(.captionLarge)
                                    .foregroundColor(.textPrimary)
                                
                                TextField("Enter item name", text: $name)
                                    .font(.bodyLarge)
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                               .fill(Color.cardBackground)
                                               .overlay(
                                                   RoundedRectangle(cornerRadius: 12)
                                                       .stroke(name.isEmpty ? Color.red.opacity(0.3) : Color.clear, lineWidth: 1)
                                               )
                                    )
                                    .onChange(of: name) { _ in
                                        hasChanges = true
                                    }
                                
                                if name.isEmpty {
                                    Text("Item name is required")
                                        .font(.captionSmall)
                                        .foregroundColor(.red)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Status")
                                    .font(.captionLarge)
                                    .foregroundColor(.textPrimary)
                                
                                VStack(spacing: 12) {
                                    ForEach(ItemStatus.allCases) { status in
                                        StatusButton(
                                            status: status,
                                            isSelected: selectedStatus == status
                                        ) {
                                            selectedStatus = status
                                            hasChanges = true
                                        }
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Condition")
                                        .font(.captionLarge)
                                        .foregroundColor(.textPrimary)
                                    
                                    Spacer()
                                    
                                    Text("Optional")
                                        .font(.captionSmall)
                                        .foregroundColor(.textSecondary)
                                }
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                    ForEach(ItemCondition.allCases) { condition in
                                        ConditionButton(
                                            condition: condition,
                                            isSelected: selectedCondition == condition
                                        ) {
                                            selectedCondition = selectedCondition == condition ? nil : condition
                                            hasChanges = true
                                        }
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Description")
                                        .font(.captionLarge)
                                        .foregroundColor(.textPrimary)
                                    
                                    Spacer()
                                    
                                    Text("Optional")
                                        .font(.captionSmall)
                                        .foregroundColor(.textSecondary)
                                }
                                
                                ZStack(alignment: .topLeading) {
                                    TextEditor(text: $description)
                                        .font(.bodyMedium)
                                        .padding(12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.cardBackground)
                                        )
                                        .frame(height: 100)
                                        .onChange(of: description) { _ in
                                            hasChanges = true
                                        }
                                    
                                    if description.isEmpty {
                                        Text("Add a description...")
                                            .font(.bodyMedium)
                                            .foregroundColor(.textSecondary)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 20)
                                            .allowsHitTesting(false)
                                    }
                                }
                                
                                HStack {
                                    Spacer()
                                    Text("\(description.count)/300")
                                        .font(.captionSmall)
                                        .foregroundColor(description.count > 300 ? .red : .textSecondary)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Notes")
                                        .font(.captionLarge)
                                        .foregroundColor(.textPrimary)
                                    
                                    Spacer()
                                    
                                    Text("Optional")
                                        .font(.captionSmall)
                                        .foregroundColor(.textSecondary)
                                }
                                
                                ZStack(alignment: .topLeading) {
                                    TextEditor(text: $notes)
                                        .font(.bodyMedium)
                                        .padding(12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.cardBackground)
                                        )
                                        .onChange(of: notes) { _ in
                                            hasChanges = true
                                        }
                                    
                                    if notes.isEmpty {
                                        Text("Add personal notes...")
                                            .font(.bodyMedium)
                                            .foregroundColor(.textSecondary)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 20)
                                            .allowsHitTesting(false)
                                    }
                                }
                                
                                HStack {
                                    Spacer()
                                    Text("\(notes.count)/200")
                                        .font(.captionSmall)
                                        .foregroundColor(notes.count > 200 ? .red : .textSecondary)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        VStack(spacing: 16) {
                            Button(action: saveItem) {
                                Text(isEditing ? "Update Item" : "Add Item")
                                    .font(.buttonLarge)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(isValidForm ? Color.primaryBlue : Color.textSecondary)
                                    )
                            }
                            .disabled(!isValidForm)
                            
                            if isEditing {
                                Button(action: { showingDeleteAlert = true }) {
                                    Text("Delete Item")
                                        .font(.buttonMedium)
                                        .foregroundColor(.red)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.red, lineWidth: 1)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Item" : "New Item")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        if hasChanges {
                            showingDiscardAlert = true
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
        .onAppear {
            setupForm()
        }
        .alert("Delete Item", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let item = item {
                    store.deleteItem(item, from: collectionId)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this item?")
        }
        .alert("Discard Changes", isPresented: $showingDiscardAlert) {
            Button("Discard", role: .destructive) {
                presentationMode.wrappedValue.dismiss()
            }
            Button("Keep Editing", role: .cancel) { }
        } message: {
            Text("You have unsaved changes. Are you sure you want to discard them?")
        }
    }
    
    private func setupForm() {
        if let item = item {
            name = item.name
            selectedStatus = item.status
            description = item.description
            selectedCondition = item.condition
            notes = item.notes
        }
    }
    
    private func saveItem() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let existingItem = item {
            var updatedItem = existingItem
            updatedItem.name = trimmedName
            updatedItem.status = selectedStatus
            updatedItem.description = description
            updatedItem.condition = selectedCondition
            updatedItem.notes = notes
            store.updateItem(updatedItem, in: collectionId)
        } else {
            let newItem = Item(
                name: trimmedName,
                status: selectedStatus,
                description: description,
                condition: selectedCondition,
                notes: notes
            )
            store.addItem(newItem, to: collectionId)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct StatusButton: View {
    let status: ItemStatus
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: status.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? .white : statusColor(for: status))
                    .frame(width: 30)
                
                Text(status.rawValue)
                    .font(.bodyMedium)
                    .foregroundColor(isSelected ? .white : .textPrimary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .padding(16)
            .background(backgroundView)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var backgroundView: some View {
        let fillColor = isSelected ? statusColor(for: status) : Color.cardBackground
        let strokeColor = isSelected ? Color.clear : statusColor(for: status).opacity(0.3)
        
        return RoundedRectangle(cornerRadius: 12)
            .fill(fillColor)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(strokeColor, lineWidth: 1)
            )
    }
    
    private func statusColor(for status: ItemStatus) -> Color {
        switch status {
        case .inCollection: return .statusInCollection
        case .wishlist: return .statusWishlist
        case .forTrade: return .statusForTrade
        }
    }
}

struct ConditionButton: View {
    let condition: ItemCondition
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(condition.rawValue)
                .font(.bodyMedium)
                .foregroundColor(isSelected ? .white : .textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(conditionBackgroundView)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var conditionBackgroundView: some View {
        let fillColor = isSelected ? Color.primaryBlue : Color.cardBackground
        let strokeColor = isSelected ? Color.clear : Color.lightBlue
        
        return RoundedRectangle(cornerRadius: 12)
            .fill(fillColor)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(strokeColor, lineWidth: 1)
            )
    }
}
