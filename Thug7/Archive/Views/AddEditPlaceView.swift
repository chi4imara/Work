import SwiftUI

struct AddEditPlaceView: View {
    @ObservedObject var placeStore: PlaceStore
    @Environment(\.presentationMode) var presentationMode
    
    let editingPlace: Place?
    let preselectedCategory: PlaceCategory?
    
    @State private var name: String = ""
    @State private var selectedCategory: PlaceCategory = .school
    @State private var description: String = ""
    @State private var showingCategoryPicker = false
    @State private var circleOffset: CGFloat = 0
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var isEditing: Bool {
        editingPlace != nil
    }
    
    init(placeStore: PlaceStore, editingPlace: Place? = nil, preselectedCategory: PlaceCategory? = nil) {
        self.placeStore = placeStore
        self.editingPlace = editingPlace
        self.preselectedCategory = preselectedCategory
        
        if let place = editingPlace {
            _name = State(initialValue: place.name)
            _selectedCategory = State(initialValue: place.category)
            _description = State(initialValue: place.description)
        } else if let preselectedCategory = preselectedCategory {
            _selectedCategory = State(initialValue: preselectedCategory)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Place Name")
                                    .font(AppTheme.headlineFont)
                                    .foregroundColor(AppTheme.textPrimary)
                                
                                TextField("Enter place name", text: $name)
                                    .font(AppTheme.bodyFont)
                                    .padding(16)
                                    .background(Color.white)
                                    .cornerRadius(AppTheme.cornerRadius)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                            .stroke(AppTheme.primaryBlue.opacity(0.3), lineWidth: 1)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Category")
                                        .font(AppTheme.headlineFont)
                                        .foregroundColor(AppTheme.textPrimary)
                                    
                                    if preselectedCategory != nil && editingPlace == nil {
                                        Text("(Pre-selected)")
                                            .font(AppTheme.captionFont)
                                            .foregroundColor(AppTheme.primaryBlue)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 2)
                                            .background(AppTheme.lightBlue.opacity(0.3))
                                            .cornerRadius(8)
                                    }
                                }
                                
                                Button(action: { 
                                    if preselectedCategory == nil || editingPlace != nil {
                                        showingCategoryPicker = true 
                                    }
                                }) {
                                    HStack {
                                        Text(selectedCategory.displayName)
                                            .font(AppTheme.bodyFont)
                                            .foregroundColor(AppTheme.textPrimary)
                                        
                                        Spacer()
                                        
                                        if preselectedCategory == nil || editingPlace != nil {
                                            Image(systemName: "chevron.down")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(AppTheme.primaryBlue)
                                        } else {
                                            Image(systemName: "lock.fill")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(AppTheme.textSecondary)
                                        }
                                    }
                                    .padding(16)
                                    .background(Color.white)
                                    .cornerRadius(AppTheme.cornerRadius)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                            .stroke(AppTheme.primaryBlue.opacity(0.3), lineWidth: 1)
                                    )
                                }
                                .disabled(preselectedCategory != nil && editingPlace == nil)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description (Optional)")
                                    .font(AppTheme.headlineFont)
                                    .foregroundColor(AppTheme.textPrimary)
                                
                                ZStack(alignment: .topLeading) {
                                    if description.isEmpty {
                                        Text("Share your memories about this place...")
                                            .font(AppTheme.bodyFont)
                                            .foregroundColor(AppTheme.textSecondary.opacity(0.6))
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 16)
                                    }
                                    
                                    TextEditor(text: $description)
                                        .font(AppTheme.bodyFont)
                                        .padding(12)
                                        .background(Color.white)
                                        .cornerRadius(AppTheme.cornerRadius)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                                .stroke(AppTheme.primaryBlue.opacity(0.3), lineWidth: 1)
                                        )
                                        .frame(minHeight: 120)
                                }
                            }
                            
                            if isEditing, let place = editingPlace {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Date Added")
                                        .font(AppTheme.headlineFont)
                                        .foregroundColor(AppTheme.textPrimary)
                                    
                                    Text(place.dateAdded, style: .date)
                                        .font(AppTheme.bodyFont)
                                        .foregroundColor(AppTheme.textSecondary)
                                        .padding(16)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(AppTheme.cornerRadius)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        Spacer(minLength: 100)
                    }
                }
                
                VStack {
                    Spacer()
                    
                    HStack(spacing: 15) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                                .font(AppTheme.buttonFont)
                                .foregroundColor(AppTheme.primaryBlue)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppTheme.buttonCornerRadius)
                                        .stroke(AppTheme.primaryBlue, lineWidth: 2)
                                )
                                .cornerRadius(AppTheme.buttonCornerRadius)
                        }
                        
                        Button {
                            savePlace()
                        } label: {
                            Text("Save")
                                .font(AppTheme.buttonFont)
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(AppTheme.buttonGradient)
                                .cornerRadius(AppTheme.buttonCornerRadius)
                                .shadow(color: AppTheme.buttonShadow, radius: 4, x: 0, y: 2)
                        }
                        .disabled(!isFormValid)
                        .opacity(isFormValid ? 1.0 : 0.6)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle(isEditing ? "Edit Place" : "New Place")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    savePlace()
                }
                .disabled(!isFormValid)
            )
            .actionSheet(isPresented: $showingCategoryPicker) {
                categoryActionSheet
            }
        }
    }
    
    private var categoryActionSheet: ActionSheet {
        let buttons = PlaceCategory.allCases.map { category in
            ActionSheet.Button.default(Text(category.displayName)) {
                selectedCategory = category
            }
        } + [ActionSheet.Button.cancel()]
        
        return ActionSheet(
            title: Text("Select Category"),
            buttons: buttons
        )
    }
    
    private func savePlace() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let editingPlace = editingPlace {
            let updatedPlace = Place(
                id: editingPlace.id,
                name: trimmedName,
                category: selectedCategory,
                description: trimmedDescription,
                dateAdded: editingPlace.dateAdded
            )
            placeStore.updatePlace(updatedPlace)
        } else {
            let newPlace = Place(
                name: trimmedName,
                category: selectedCategory,
                description: trimmedDescription
            )
            placeStore.addPlace(newPlace)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddEditPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditPlaceView(placeStore: PlaceStore.shared)
    }
}
