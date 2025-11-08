import SwiftUI

struct AddEditPetView: View {
    @ObservedObject var petStore: PetStore
    @Environment(\.presentationMode) var presentationMode
    
    let pet: Pet?
    
    @State private var name: String = ""
    @State private var species: String = ""
    @State private var breed: String = ""
    @State private var gender: Pet.Gender = .unknown
    @State private var birthDate: Date = Date()
    @State private var adoptionDate: Date = Date()
    @State private var hasAdoptionDate: Bool = false
    @State private var weight: String = ""
    @State private var identification: String = ""
    @State private var color: String = ""
    @State private var allergies: String = ""
    @State private var notes: String = ""
    
    @State private var showingDeleteAlert = false
    @State private var showingSpeciesSheet = false
    
    private let speciesOptions = ["Dog", "Cat", "Bird", "Rodent", "Reptile", "Fish", "Other"]
    
    private var isEditing: Bool {
        pet != nil
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !species.trimmingCharacters(in: .whitespaces).isEmpty &&
        birthDate <= Date()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        AppColors.backgroundGradientStart,
                        AppColors.backgroundGradientEnd
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        FormSection(title: "Basic Information") {
                            VStack(spacing: 16) {
                                FormField(title: "Name *", text: $name, placeholder: "Enter pet name")
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Species *")
                                        .font(FontManager.subheadline)
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    Button(action: { showingSpeciesSheet = true }) {
                                        HStack {
                                            Text(species.isEmpty ? "Select species" : species)
                                                .font(FontManager.body)
                                                .foregroundColor(species.isEmpty ? AppColors.secondaryText : AppColors.primaryText)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.down")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(AppColors.secondaryText)
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(Color.white.opacity(0.9))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(AppColors.primaryBlue.opacity(0.2), lineWidth: 1)
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                
                                FormField(title: "Breed", text: $breed, placeholder: "Enter breed (optional)")
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Gender")
                                        .font(FontManager.subheadline)
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    Picker("Gender", selection: $gender) {
                                        ForEach(Pet.Gender.allCases, id: \.self) { genderOption in
                                            Text(genderOption.rawValue).tag(genderOption)
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                }
                            }
                        }
                        
                        FormSection(title: "Important Dates") {
                            VStack(spacing: 16) {
                                DatePickerField(title: "Birth Date *", date: $birthDate, displayedComponents: .date)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Toggle("Has adoption date", isOn: $hasAdoptionDate)
                                        .font(FontManager.subheadline)
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    if hasAdoptionDate {
                                        DatePickerField(title: "Adoption Date", date: $adoptionDate, displayedComponents: .date)
                                    }
                                }
                            }
                        }
                        
                        FormSection(title: "Additional Information") {
                            VStack(spacing: 16) {
                                FormField(title: "Weight (kg)", text: $weight, placeholder: "Enter weight", keyboardType: .decimalPad)
                                
                                FormField(title: "Identification", text: $identification, placeholder: "Chip/tattoo number")
                                
                                FormField(title: "Color", text: $color, placeholder: "Pet color/markings")
                                
                                FormTextArea(title: "Allergies/Special Needs", text: $allergies, placeholder: "Any allergies or special requirements")
                                
                                FormTextArea(title: "Notes", text: $notes, placeholder: "Any additional notes")
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(isEditing ? "Edit Pet" : "Add Pet")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: HStack {
                    if isEditing {
                        Button("Delete") {
                            showingDeleteAlert = true
                        }
                        .foregroundColor(AppColors.error)
                    }
                    
                    Button("Save") {
                        savePet()
                    }
                    .disabled(!isFormValid)
                    .foregroundColor(isFormValid ? AppColors.primaryBlue : AppColors.secondaryText)
                }
            )
        }
        .onAppear {
            loadPetData()
        }
        .actionSheet(isPresented: $showingSpeciesSheet) {
            ActionSheet(
                title: Text("Select Species"),
                buttons: speciesOptions.map { speciesOption in
                    .default(Text(speciesOption)) {
                        species = speciesOption
                    }
                } + [.cancel()]
            )
        }
        .alert("Delete Pet", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let pet = pet {
                    petStore.archivePet(pet)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to delete this pet? This action will move the pet and all its records to the archive.")
        }
    }
    
    private func loadPetData() {
        guard let pet = pet else { return }
        
        name = pet.name
        species = pet.species
        breed = pet.breed ?? ""
        gender = pet.gender
        birthDate = pet.birthDate
        
        if let adoptionDate = pet.adoptionDate {
            self.adoptionDate = adoptionDate
            hasAdoptionDate = true
        }
        
        weight = pet.weight != nil ? String(pet.weight!) : ""
        identification = pet.identification ?? ""
        color = pet.color ?? ""
        allergies = pet.allergies ?? ""
        notes = pet.notes ?? ""
    }
    
    private func savePet() {
        let weightValue = Double(weight.trimmingCharacters(in: .whitespaces))
        
        let newPet = Pet(
            name: name.trimmingCharacters(in: .whitespaces),
            species: species,
            breed: breed.trimmingCharacters(in: .whitespaces).isEmpty ? nil : breed.trimmingCharacters(in: .whitespaces),
            gender: gender,
            birthDate: birthDate,
            adoptionDate: hasAdoptionDate ? adoptionDate : nil,
            weight: weightValue,
            identification: identification.trimmingCharacters(in: .whitespaces).isEmpty ? nil : identification.trimmingCharacters(in: .whitespaces),
            color: color.trimmingCharacters(in: .whitespaces).isEmpty ? nil : color.trimmingCharacters(in: .whitespaces),
            allergies: allergies.trimmingCharacters(in: .whitespaces).isEmpty ? nil : allergies.trimmingCharacters(in: .whitespaces),
            notes: notes.trimmingCharacters(in: .whitespaces).isEmpty ? nil : notes.trimmingCharacters(in: .whitespaces)
        )
        
        if isEditing {
            var updatedPet = newPet
            updatedPet.id = pet!.id
            petStore.updatePet(updatedPet)
        } else {
            petStore.addPet(newPet)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct FormSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                content
            }
            .padding(16)
            .background(Color.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.primaryBlue.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

struct FormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(FontManager.subheadline)
                .foregroundColor(AppColors.primaryText)
            
            TextField(placeholder, text: $text)
                .font(FontManager.body)
                .keyboardType(keyboardType)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.primaryBlue.opacity(0.2), lineWidth: 1)
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
                .font(FontManager.subheadline)
                .foregroundColor(AppColors.primaryText)
            
            TextEditor(text: $text)
                .font(FontManager.body)
                .frame(minHeight: 80)
                .padding(12)
                .background(Color.white.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.primaryBlue.opacity(0.2), lineWidth: 1)
                )
                .overlay(
                    Group {
                        if text.isEmpty {
                            HStack {
                                VStack {
                                    Text(placeholder)
                                        .font(FontManager.body)
                                        .foregroundColor(AppColors.secondaryText)
                                        .padding(.top, 20)
                                        .padding(.leading, 16)
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                    }
                )
        }
    }
}

struct DatePickerField: View {
    let title: String
    @Binding var date: Date
    let displayedComponents: DatePickerComponents
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(FontManager.subheadline)
                .foregroundColor(AppColors.primaryText)
            
            DatePicker("", selection: $date, displayedComponents: displayedComponents)
                .datePickerStyle(CompactDatePickerStyle())
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.primaryBlue.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

struct AddEditPetView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditPetView(petStore: PetStore(), pet: nil)
    }
}
