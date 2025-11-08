import SwiftUI

struct AddEditVaccinationView: View {
    @ObservedObject var petStore: PetStore
    let petId: UUID
    let vaccination: Vaccination?
    @Environment(\.dismiss) var dismiss
    
    @State private var vaccineName: String = ""
    @State private var date: Date = Date()
    @State private var clinic: String = ""
    @State private var serialNumber: String = ""
    @State private var comment: String = ""
    
    @State private var showingDeleteAlert = false
    
    private var isEditing: Bool {
        vaccination != nil
    }
    
    private var isFormValid: Bool {
        !vaccineName.trimmingCharacters(in: .whitespaces).isEmpty &&
        date <= Date()
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
                        petInfoSection
                        
                        vaccinationDetailsSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(isEditing ? "Edit Vaccination" : "Add Vaccination")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: HStack {
                    if isEditing {
                        Button("Delete") {
                            showingDeleteAlert = true
                        }
                        .foregroundColor(AppColors.error)
                    }
                    
                    Button("Save") {
                        saveVaccination()
                    }
                    .disabled(!isFormValid)
                    .foregroundColor(isFormValid ? AppColors.primaryBlue : AppColors.secondaryText)
                }
            )
        }
        .onAppear {
            loadVaccinationData()
        }
        .alert("Delete Vaccination", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let vaccination = vaccination {
                    petStore.archiveVaccination(vaccination)
                    dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to delete this vaccination record?")
        }
    }
    
    private var petInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pet Information")
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            if let pet = petStore.pets.first(where: { $0.id == petId }) {
                HStack(spacing: 16) {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    AppColors.primaryBlue.opacity(0.8),
                                    AppColors.accentPurple.opacity(0.8)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                        .overlay(
                            Text(String(pet.name.prefix(1)).uppercased())
                                .font(FontManager.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(pet.name)
                            .font(FontManager.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(AppColors.primaryText)
                        
                        Text(pet.speciesBreed)
                            .font(FontManager.body)
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Spacer()
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
    
    private var vaccinationDetailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Vaccination Details")
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 16) {
                FormField(title: "Vaccine Name *", text: $vaccineName, placeholder: "Enter vaccine name")
                
                DatePickerField(title: "Date *", date: $date, displayedComponents: .date)
                
                FormField(title: "Clinic/Veterinarian", text: $clinic, placeholder: "Enter clinic or vet name")
                
                FormField(title: "Serial Number", text: $serialNumber, placeholder: "Enter batch/serial number")
                
                FormTextArea(title: "Comments", text: $comment, placeholder: "Any additional notes")
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
    
    private func loadVaccinationData() {
        guard let vaccination = vaccination else { return }
        
        vaccineName = vaccination.vaccineName
        date = vaccination.date
        clinic = vaccination.clinic ?? ""
        serialNumber = vaccination.serialNumber ?? ""
        comment = vaccination.comment ?? ""
    }
    
    private func saveVaccination() {
        let newVaccination = Vaccination(
            petId: petId,
            vaccineName: vaccineName.trimmingCharacters(in: .whitespaces),
            date: date,
            clinic: clinic.trimmingCharacters(in: .whitespaces).isEmpty ? nil : clinic.trimmingCharacters(in: .whitespaces),
            serialNumber: serialNumber.trimmingCharacters(in: .whitespaces).isEmpty ? nil : serialNumber.trimmingCharacters(in: .whitespaces),
            comment: comment.trimmingCharacters(in: .whitespaces).isEmpty ? nil : comment.trimmingCharacters(in: .whitespaces)
        )
        
        if isEditing {
            var updatedVaccination = newVaccination
            updatedVaccination.id = vaccination!.id
            petStore.updateVaccination(updatedVaccination)
        } else {
            petStore.addVaccination(newVaccination)
        }
        
        dismiss()
    }
}

struct AddEditVaccinationView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditVaccinationView(petStore: PetStore(), petId: UUID(), vaccination: nil)
    }
}
