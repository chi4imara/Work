import SwiftUI

struct PetProfileView: View {
    @ObservedObject var dataManager = DataManager.shared
    @State private var editedPet: Pet
    @State private var showingDatePicker = false
    @State private var showingValidationAlert = false
    @State private var validationMessage = ""
    @State private var showingUpdateVetAlert = false
    
    init() {
        _editedPet = State(initialValue: DataManager.shared.pet)
    }
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Pet Profile")
                        .font(.ubuntu(30, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 25) {
                        petInfoSection
                        
                        dietSection
                        
                        vitaminsSection
                        
                        veterinarianSection
                        
                        saveButton
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
            }
        }
        .alert("Validation Error", isPresented: $showingValidationAlert) {
            Button("OK") { }
        } message: {
            Text(validationMessage)
        }
        .alert("Update Vet Visit", isPresented: $showingUpdateVetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Update") {
                dataManager.updateVetVisitToToday()
                editedPet = dataManager.pet
            }
        } message: {
            Text("This will set the last vet visit to today and add a veterinarian event to your journal.")
        }
        .sheet(isPresented: $showingDatePicker) {
            VetDatePickerSheet(selectedDate: Binding(
                get: { editedPet.lastVetVisit ?? Date() },
                set: { editedPet.lastVetVisit = $0 }
            ))
        }
        .onAppear {
            editedPet = dataManager.pet
        }
    }
    
    private var petInfoSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Pet Information")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Name")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(.white)
                    
                    TextField("Enter pet's name", text: $editedPet.name)
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Species")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 12) {
                        ForEach(PetSpecies.allCases, id: \.self) { species in
                            Button(action: { editedPet.species = species }) {
                                HStack {
                                    Image(systemName: editedPet.species == species ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(editedPet.species == species ? Color.theme.primaryPurple : .white.opacity(0.5))
                                    
                                    Text(species.displayName)
                                        .font(.ubuntu(14, weight: .medium))
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(editedPet.species == species ? Color.white.opacity(0.2) : Color.white.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                        
                        Spacer()
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Age")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Years")
                                .font(.ubuntu(12, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                            
                            TextField("0", value: $editedPet.ageYears, format: .number)
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                                .keyboardType(.numberPad)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Months")
                                .font(.ubuntu(12, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                            
                            TextField("0", value: $editedPet.ageMonths, format: .number)
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                                .keyboardType(.numberPad)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Weight (kg) - Optional")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(.white)
                    
                    TextField("Enter weight", value: $editedPet.weight, format: .number)
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        .keyboardType(.decimalPad)
                }
            }
        }
        .padding(20)
        .background(Color.theme.cardGradient)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.theme.cardBorder, lineWidth: 1)
        )
    }
    
    private var dietSection: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Diet")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(editedPet.diet.count)/120")
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(editedPet.diet.count > 120 ? Color.theme.accentRed : .white.opacity(0.6))
            }
            
            TextField("Describe your pet's diet", text: $editedPet.diet, axis: .vertical)
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(.white)
                .padding(16)
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .lineLimit(3...5)
        }
        .padding(20)
        .background(Color.theme.cardGradient)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.theme.cardBorder, lineWidth: 1)
        )
    }
    
    private var vitaminsSection: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Vitamins")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(editedPet.vitaminsDescription.count)/120")
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(editedPet.vitaminsDescription.count > 120 ? Color.theme.accentRed : .white.opacity(0.6))
            }
            
            TextField("Describe vitamins or supplements", text: $editedPet.vitaminsDescription, axis: .vertical)
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(.white)
                .padding(16)
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .lineLimit(3...5)
            
            HStack {
                Image(systemName: "info.circle")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.6))
                
                Text("Use the vitamins event type on the main screen to track daily intake")
                    .font(.ubuntu(12, weight: .regular))
                    .foregroundColor(.white.opacity(0.6))
                
                Spacer()
            }
        }
        .padding(20)
        .background(Color.theme.cardGradient)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.theme.cardBorder, lineWidth: 1)
        )
    }
    
    private var veterinarianSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Veterinarian")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Last Visit")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(.white)
                    
                    Button(action: { showingDatePicker = true }) {
                        HStack {
                            Text(editedPet.lastVetVisit != nil ?
                                 DateFormatter.dayMonthYear.string(from: editedPet.lastVetVisit!) :
                                    "No visit recorded")
                            .font(.ubuntu(16, weight: .regular))
                            .foregroundColor(.white)
                            
                            Spacer()
                            
                            Image(systemName: "calendar")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(12)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Doctor / Clinic")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(.white)
                    
                    TextField("Enter veterinarian or clinic name", text: $editedPet.veterinarian)
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Comment")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(editedPet.vetComment.count)/120")
                            .font(.ubuntu(12, weight: .medium))
                            .foregroundColor(editedPet.vetComment.count > 120 ? Color.theme.accentRed : .white.opacity(0.6))
                    }
                    
                    TextField("Additional notes about vet visits", text: $editedPet.vetComment, axis: .vertical)
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        .lineLimit(2...4)
                }
                
                Button {
                    showingUpdateVetAlert = true
                } label: {
                    Text("Update Visit Date to Today")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color.theme.accentRed.opacity(0.8))
                        .cornerRadius(12)
                }
            }
        }
        .padding(20)
        .background(Color.theme.cardGradient)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.theme.cardBorder, lineWidth: 1)
        )
    }
    
    private var saveButton: some View {
        Button(action: savePetProfile) {
            HStack {
                Spacer()
                
                Text("Save Profile")
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.vertical, 16)
            .background(
                canSave ?
                LinearGradient(
                    gradient: Gradient(colors: [Color.theme.primaryPurple, Color.theme.secondaryPurple]),
                    startPoint: .leading,
                    endPoint: .trailing
                ) :
                    LinearGradient(
                        gradient: Gradient(colors: [Color.theme.buttonDisabled, Color.theme.buttonDisabled]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
            )
            .cornerRadius(16)
            .shadow(color: canSave ? Color.theme.primaryPurple.opacity(0.3) : Color.clear, radius: 10, x: 0, y: 5)
        }
        .disabled(!canSave)
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }
    
    private var canSave: Bool {
        guard editedPet.name.count <= 40 else { return false }
        guard editedPet.diet.count <= 120 else { return false }
        guard editedPet.vitaminsDescription.count <= 120 else { return false }
        guard editedPet.veterinarian.count <= 40 else { return false }
        guard editedPet.vetComment.count <= 120 else { return false }
        guard editedPet.ageYears >= 0 && editedPet.ageYears <= 30 else { return false }
        guard editedPet.ageMonths >= 0 && editedPet.ageMonths <= 11 else { return false }
        
        if let weight = editedPet.weight {
            guard weight >= 0 else { return false }
        }
        
        if let lastVisit = editedPet.lastVetVisit {
            guard lastVisit <= Date() else { return false }
        }
        
        return true
    }
    
    private func savePetProfile() {
        guard canSave else {
            showValidationError("Please check all fields for valid values")
            return
        }
        
        dataManager.updatePet(editedPet)
    }
    
    private func showValidationError(_ message: String) {
        validationMessage = message
        showingValidationAlert = true
    }
}

struct VetDatePickerSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedDate: Date
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack {
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        in: ...Date(),
                        displayedComponents: .date
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Last Vet Visit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Clear") {
                        selectedDate = Date()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct EmptyPetProfileView: View {
    let onAddInfo: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "pawprint.circle")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("Add Pet Information")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Add your pet's details to better track their care routine")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            Button("Add Information") {
                onAddInfo()
            }
            .font(.ubuntu(16, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.theme.primaryPurple)
            .cornerRadius(20)
        }
        .padding(40)
    }
}

#Preview {
    PetProfileView()
}
