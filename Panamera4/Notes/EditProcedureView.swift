import SwiftUI

struct EditProcedureView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var procedureStore: ProcedureStore
    
    let procedure: HairCareProcedure
    
    @State private var name: String
    @State private var selectedCategory: ProcedureCategory
    @State private var selectedDate: Date
    @State private var effect: String
    @State private var description: String
    
    init(procedure: HairCareProcedure) {
        self.procedure = procedure
        self._name = State(initialValue: procedure.name)
        self._selectedCategory = State(initialValue: procedure.category)
        self._selectedDate = State(initialValue: procedure.date)
        self._effect = State(initialValue: procedure.effect)
        self._description = State(initialValue: procedure.description)
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(.bellGothic(16, weight: .regular))
                        .foregroundColor(AppColors.primaryWhite)
                        
                        Spacer()
                        
                        Text("Edit Procedure")
                            .font(.bellGothic(20, weight: .bold))
                            .foregroundColor(AppColors.primaryWhite)
                        
                        Spacer()
                        
                        Button("Save") {
                            saveProcedure()
                        }
                        .font(.bellGothic(16, weight: .bold))
                        .foregroundColor(isFormValid ? AppColors.accentYellow : AppColors.primaryWhite.opacity(0.5))
                        .disabled(!isFormValid)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            FormFieldView(title: "Procedure Name*", isRequired: true) {
                                TextField("Enter procedure name", text: $name)
                                    .font(.bellGothic(16, weight: .regular))
                                    .foregroundColor(AppColors.darkGray)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.primaryWhite)
                                    )
                            }
                            
                            FormFieldView(title: "Category") {
                                CategoryPickerView(selectedCategory: $selectedCategory)
                            }
                            
                            FormFieldView(title: "Date") {
                                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .font(.bellGothic(16, weight: .regular))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.primaryWhite)
                                    )
                            }
                            
                            FormFieldView(title: "Effect") {
                                TextField("e.g., smoother hair, more volume", text: $effect)
                                    .font(.bellGothic(16, weight: .regular))
                                    .foregroundColor(AppColors.darkGray)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.primaryWhite)
                                    )
                            }
                            
                            FormFieldView(title: "Description") {
                                TextEditor(text: $description)
                                    .font(.bellGothic(16, weight: .regular))
                                    .foregroundColor(AppColors.darkGray)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppColors.primaryWhite)
                                    )
                                    .frame(minHeight: 100)
                            }
                            
                            Spacer().frame(height: 100)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func saveProcedure() {
        var updatedProcedure = procedure
        updatedProcedure.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedProcedure.category = selectedCategory
        updatedProcedure.date = selectedDate
        updatedProcedure.effect = effect.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedProcedure.description = description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        procedureStore.updateProcedure(updatedProcedure)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    let sampleProcedure = HairCareProcedure(
        name: "Keratin Hair Mask",
        category: .masks,
        date: Date(),
        effect: "Smoother and shinier hair",
        description: "Applied keratin mask for 30 minutes"
    )
    
    return EditProcedureView(procedure: sampleProcedure)
        .environmentObject(ProcedureStore())
}
