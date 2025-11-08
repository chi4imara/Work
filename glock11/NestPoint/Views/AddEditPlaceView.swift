import SwiftUI

struct AddEditPlaceView: View {
    @ObservedObject var viewModel: PlacesViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let placeToEdit: Place?
    
    @State private var name: String = ""
    @State private var selectedCategory: String = ""
    @State private var address: String = ""
    @State private var note: String = ""
    @State private var isFavorite: Bool = false
    @State private var showingNewCategoryAlert = false
    @State private var newCategoryName = ""
    
    init(viewModel: PlacesViewModel, placeToEdit: Place? = nil) {
        self.viewModel = viewModel
        self.placeToEdit = placeToEdit
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name *")
                                .font(FontManager.subheadline)
                                .foregroundColor(ColorTheme.primaryText)
                            
                            TextField("Enter place name", text: $name)
                                .font(FontManager.body)
                                .padding(16)
                                .background(ColorTheme.backgroundWhite)
                                .cornerRadius(12)
                                .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 2, x: 0, y: 1)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category *")
                                .font(FontManager.subheadline)
                                .foregroundColor(ColorTheme.primaryText)
                            
                            HStack {
                                Menu {
                                    ForEach(viewModel.categoryNames, id: \.self) { category in
                                        Button(category) {
                                            print("Selected category: \(category)")
                                            selectedCategory = category
                                        }
                                    }
                                    
                                    Divider()
                                    
                                    Button("Add New Category...") {
                                        showingNewCategoryAlert = true
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedCategory.isEmpty ? "Select category" : selectedCategory)
                                            .font(FontManager.body)
                                            .foregroundColor(selectedCategory.isEmpty ? ColorTheme.secondaryText : ColorTheme.primaryText)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 14))
                                            .foregroundColor(ColorTheme.secondaryText)
                                    }
                                    .padding(16)
                                    .background(ColorTheme.backgroundWhite)
                                    .cornerRadius(12)
                                    .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 2, x: 0, y: 1)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Address")
                                .font(FontManager.subheadline)
                                .foregroundColor(ColorTheme.primaryText)
                            
                            TextField("Enter address (optional)", text: $address)
                                .font(FontManager.body)
                                .padding(16)
                                .background(ColorTheme.backgroundWhite)
                                .cornerRadius(12)
                                .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 2, x: 0, y: 1)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Note")
                                .font(FontManager.subheadline)
                                .foregroundColor(ColorTheme.primaryText)
                            
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(ColorTheme.backgroundWhite)
                                    .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 2, x: 0, y: 1)
                                    .frame(minHeight: 100)
                                
                                TextEditor(text: $note)
                                    .font(FontManager.body)
                                    .padding(12)
                                    .background(Color.clear)
                                    .scrollContentBackground(.hidden)
                                
                                if note.isEmpty {
                                    Text("Add your thoughts about this place...")
                                        .font(FontManager.body)
                                        .foregroundColor(ColorTheme.secondaryText)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 20)
                                        .allowsHitTesting(false)
                                }
                            }
                        }
                        
                        HStack {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .font(.system(size: 20))
                                .foregroundColor(isFavorite ? ColorTheme.accentOrange : ColorTheme.secondaryText)
                            
                            Text("Mark as Favorite")
                                .font(FontManager.body)
                                .foregroundColor(ColorTheme.primaryText)
                            
                            Spacer()
                            
                            Toggle("", isOn: $isFavorite)
                                .toggleStyle(SwitchToggleStyle(tint: ColorTheme.primaryBlue))
                        }
                        .padding(16)
                        .background(ColorTheme.backgroundWhite)
                        .cornerRadius(12)
                        .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 2, x: 0, y: 1)
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(placeToEdit == nil ? "Add Place" : "Edit Place")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    savePlace()
                }
                .disabled(!canSave)
                .foregroundColor(canSave ? ColorTheme.primaryBlue : ColorTheme.secondaryText)
            )
        }
        .alert("New Category", isPresented: $showingNewCategoryAlert) {
            TextField("Category name", text: $newCategoryName)
            Button("Cancel", role: .cancel) {
                newCategoryName = ""
            }
            Button("Add") {
                if !newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    viewModel.addCategory(newCategoryName)
                    selectedCategory = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
                    newCategoryName = ""
                }
            }
        } message: {
            Text("Enter a name for the new category")
        }
        .onAppear {
            print("AddEditPlaceView appeared. Available categories: \(viewModel.categoryNames)")
            setupInitialValues()
        }
    }
    
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !selectedCategory.isEmpty
    }
    
    private func setupInitialValues() {
        if let place = placeToEdit {
            name = place.name
            selectedCategory = place.category
            address = place.address
            note = place.note
            isFavorite = place.isFavorite
        }
    }
    
    private func savePlace() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAddress = address.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let existingPlace = placeToEdit {
            var updatedPlace = existingPlace
            updatedPlace.name = trimmedName
            updatedPlace.category = selectedCategory
            updatedPlace.address = trimmedAddress
            updatedPlace.note = trimmedNote
            updatedPlace.isFavorite = isFavorite
            
            viewModel.updatePlace(updatedPlace)
        } else {
            let newPlace = Place(
                name: trimmedName,
                category: selectedCategory,
                address: trimmedAddress,
                note: trimmedNote,
                isFavorite: isFavorite
            )
            
            viewModel.addPlace(newPlace)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddEditPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditPlaceView(viewModel: PlacesViewModel())
    }
}
