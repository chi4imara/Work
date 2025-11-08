import SwiftUI

struct WishlistFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var dataManager = DataManager.shared
    
    let item: WishlistItem?
    
    @State private var title = ""
    @State private var country = ""
    @State private var city = ""
    @State private var notes = ""
    @State private var isPriority = false
    
    @State private var showingDeleteAlert = false
    @State private var showingCancelAlert = false
    
    private var isEditing: Bool {
        item != nil
    }
    
    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Destination Details")
                                .font(FontManager.headline)
                                .foregroundColor(ColorTheme.primaryText)
                            
                            CustomTextField(title: "Destination Name", text: $title, isRequired: true)
                            CustomTextField(title: "Country (Optional)", text: $country)
                            CustomTextField(title: "City (Optional)", text: $city)
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Priority")
                                .font(FontManager.headline)
                                .foregroundColor(ColorTheme.primaryText)
                            
                            Toggle(isOn: $isPriority) {
                                Text("Mark as priority destination")
                                    .font(FontManager.body)
                                    .foregroundColor(ColorTheme.secondaryText)
                            }
                            .toggleStyle(SwitchToggleStyle(tint: ColorTheme.primaryText))
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Notes")
                                .font(FontManager.headline)
                                .foregroundColor(ColorTheme.primaryText)
                            
                            CustomTextEditor(text: $notes, placeholder: "Why do you want to visit this place? What do you hope to see or do?")
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(isEditing ? "Edit Destination" : "New Destination")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    if hasUnsavedChanges() {
                        showingCancelAlert = true
                    } else {
                        presentationMode.wrappedValue.dismiss()
                    }
                },
                trailing: HStack {
                    if isEditing {
                        Button("Delete") {
                            showingDeleteAlert = true
                        }
                        .foregroundColor(ColorTheme.error)
                    }
                    
                    Button("Save") {
                        saveItem()
                    }
                    .disabled(!canSave)
                    .foregroundColor(canSave ? ColorTheme.primaryText : ColorTheme.borderColor)
                }
            )
        }
        .onAppear {
            setupForm()
        }
        .alert("Delete Destination", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let item = item {
                    dataManager.deleteWishlistItem(item)
                }
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("This destination will be permanently removed from your wishlist.")
        }
        .alert("Discard Changes", isPresented: $showingCancelAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Discard", role: .destructive) {
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("You have unsaved changes. Are you sure you want to discard them?")
        }
    }
    
    private func setupForm() {
        if let item = item {
            title = item.title
            country = item.country ?? ""
            city = item.city ?? ""
            notes = item.notes
            isPriority = item.isPriority
        }
    }
    
    private func saveItem() {
        if let existingItem = item {
            var updatedItem = existingItem
            updatedItem.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedItem.country = country.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : country.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedItem.city = city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : city.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedItem.notes = notes
            updatedItem.isPriority = isPriority
            
            dataManager.updateWishlistItem(updatedItem)
        } else {
            let newItem = WishlistItem(
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                country: country.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : country.trimmingCharacters(in: .whitespacesAndNewlines),
                city: city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : city.trimmingCharacters(in: .whitespacesAndNewlines),
                notes: notes,
                isPriority: isPriority
            )
            
            dataManager.addWishlistItem(newItem)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
    
    private func hasUnsavedChanges() -> Bool {
        if let item = item {
            return title != item.title ||
                   country != (item.country ?? "") ||
                   city != (item.city ?? "") ||
                   notes != item.notes ||
                   isPriority != item.isPriority
        } else {
            return !title.isEmpty || !country.isEmpty || !city.isEmpty || !notes.isEmpty || isPriority
        }
    }
}

#Preview {
    WishlistFormView(item: nil)
}

