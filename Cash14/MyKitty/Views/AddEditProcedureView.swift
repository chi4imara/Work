import SwiftUI

struct AddEditProcedureView: View {
    @ObservedObject var petStore: PetStore
    let petId: UUID
    let procedure: Procedure?
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedType: Procedure.ProcedureType = .examination
    @State private var date: Date = Date()
    @State private var result: String = ""
    @State private var comment: String = ""
    
    @State private var showingDeleteAlert = false
    
    private var isEditing: Bool {
        procedure != nil
    }
    
    private var isFormValid: Bool {
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
                        
                        procedureDetailsSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(isEditing ? "Edit Procedure" : "Add Procedure")
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
                        saveProcedure()
                    }
                    .disabled(!isFormValid)
                    .foregroundColor(isFormValid ? AppColors.primaryBlue : AppColors.secondaryText)
                }
            )
        }
        .onAppear {
            loadProcedureData()
        }
        .alert("Delete Procedure", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let procedure = procedure {
                    petStore.archiveProcedure(procedure)
                    dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to delete this procedure record?")
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
    
    private var procedureDetailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Procedure Details")
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Procedure Type *")
                        .font(FontManager.subheadline)
                        .foregroundColor(AppColors.primaryText)
                    
                    Picker("Procedure Type", selection: $selectedType) {
                        ForEach(Procedure.ProcedureType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.white.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.primaryBlue.opacity(0.2), lineWidth: 1)
                    )
                }
                
                DatePickerField(title: "Date *", date: $date, displayedComponents: .date)
                
                FormTextArea(title: "Result/Outcome", text: $result, placeholder: "Describe the procedure result or outcome")
                
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
    
    private func loadProcedureData() {
        guard let procedure = procedure else { return }
        
        selectedType = procedure.type
        date = procedure.date
        result = procedure.result ?? ""
        comment = procedure.comment ?? ""
    }
    
    private func saveProcedure() {
        let newProcedure = Procedure(
            petId: petId,
            type: selectedType,
            date: date,
            result: result.trimmingCharacters(in: .whitespaces).isEmpty ? nil : result.trimmingCharacters(in: .whitespaces),
            comment: comment.trimmingCharacters(in: .whitespaces).isEmpty ? nil : comment.trimmingCharacters(in: .whitespaces)
        )
        
        if isEditing {
            var updatedProcedure = newProcedure
            updatedProcedure.id = procedure!.id
            petStore.updateProcedure(updatedProcedure)
        } else {
            petStore.addProcedure(newProcedure)
        }
        
        dismiss()
    }
}

struct AddEditProcedureView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditProcedureView(petStore: PetStore(), petId: UUID(), procedure: nil)
    }
}
