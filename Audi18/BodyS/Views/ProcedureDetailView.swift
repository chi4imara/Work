import SwiftUI

struct ProcedureDetailView: View {
    let procedureId: UUID
    @ObservedObject var viewModel: ProcedureViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var procedure: Procedure? {
        viewModel.procedures.first { $0.id == procedureId }
    }
    
    var body: some View {
        Group {
            if let procedure = procedure {
                ZStack {
                    AppColors.backgroundGradient
                        .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(procedure.name)
                                    .font(.bellGothic(size: 24, weight: .bold))
                                    .foregroundColor(AppColors.primaryBlue)
                                
                                if !procedure.description.isEmpty {
                                    Text(procedure.description)
                                        .font(.bellGothic(size: 16))
                                        .foregroundColor(AppColors.darkGray)
                                        .lineSpacing(2)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Checklist")
                                    .font(.bellGothic(size: 18, weight: .bold))
                                    .foregroundColor(AppColors.primaryBlue)
                                
                                if procedure.steps.isEmpty {
                                    VStack(spacing: 12) {
                                        Image(systemName: "list.bullet")
                                            .font(.system(size: 40))
                                            .foregroundColor(AppColors.primaryBlue.opacity(0.3))
                                        
                                        Text("No steps added for this procedure.")
                                            .font(.bellGothic(size: 16))
                                            .foregroundColor(AppColors.darkGray)
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 40)
                                    .background(AppColors.lightGray.opacity(0.3))
                                    .cornerRadius(12)
                                } else {
                                    VStack(spacing: 12) {
                                        ForEach(Array(procedure.steps.enumerated()), id: \.offset) { index, step in
                                            HStack(alignment: .top, spacing: 12) {
                                                Text("\(index + 1).")
                                                    .font(.bellGothic(size: 16, weight: .bold))
                                                    .foregroundColor(AppColors.primaryBlue)
                                                    .frame(width: 25, alignment: .leading)
                                                
                                                Text(step)
                                                    .font(.bellGothic(size: 16))
                                                    .foregroundColor(AppColors.darkGray)
                                                    .lineSpacing(2)
                                                
                                                Spacer()
                                            }
                                            .padding(16)
                                            .background(AppColors.cardGradient)
                                            .cornerRadius(10)
                                            .shadow(color: AppColors.primaryBlue.opacity(0.05), radius: 2, x: 0, y: 1)
                                        }
                                    }
                                }
                            }
                            
                            VStack(spacing: 12) {
                                Button(action: {
                                    showingEditView = true
                                }) {
                                    HStack {
                                        Image(systemName: "pencil")
                                            .font(.system(size: 16, weight: .bold))
                                        Text("Edit")
                                            .font(.bellGothic(size: 16, weight: .bold))
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(AppColors.primaryYellow)
                                    .cornerRadius(10)
                                    .shadow(color: AppColors.primaryYellow.opacity(0.3), radius: 4, x: 0, y: 2)
                                }
                                
                                Button(action: {
                                    showingDeleteAlert = true
                                }) {
                                    HStack {
                                        Image(systemName: "trash")
                                            .font(.system(size: 16, weight: .bold))
                                        Text("Delete")
                                            .font(.bellGothic(size: 16, weight: .bold))
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color.red)
                                    .cornerRadius(10)
                                    .shadow(color: Color.red.opacity(0.3), radius: 4, x: 0, y: 2)
                                }
                            }
                            .padding(.top, 20)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .bold))
                                Text("Back")
                                    .font(.bellGothic(size: 16))
                            }
                            .foregroundColor(AppColors.primaryBlue)
                        }
                    }
                }
                .sheet(isPresented: $showingEditView) {
                    EditProcedureView(procedureId: procedure.id, viewModel: viewModel)
                }
                .alert("Delete Procedure", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        viewModel.deleteProcedure(procedure)
                        presentationMode.wrappedValue.dismiss()
                    }
                } message: {
                    Text("Are you sure you want to delete this procedure? This action cannot be undone.")
                }
            }
        }
    }
}

struct EditProcedureView: View {
    let procedureId: UUID
    @ObservedObject var viewModel: ProcedureViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var procedureName: String
    @State private var procedureDescription: String
    @State private var steps: [String]
    @State private var newStepText = ""
    
    private var procedure: Procedure? {
        viewModel.procedures.first { $0.id == procedureId }
    }
    
    init(procedureId: UUID, viewModel: ProcedureViewModel) {
        self.procedureId = procedureId
        self.viewModel = viewModel
        if let procedure = viewModel.procedures.first(where: { $0.id == procedureId }) {
            self._procedureName = State(initialValue: procedure.name)
            self._procedureDescription = State(initialValue: procedure.description)
            self._steps = State(initialValue: procedure.steps)
        } else {
            self._procedureName = State(initialValue: "")
            self._procedureDescription = State(initialValue: "")
            self._steps = State(initialValue: [])
        }
    }
    
    var isValid: Bool {
        !procedureName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Procedure Name")
                                .font(.bellGothic(size: 16, weight: .bold))
                                .foregroundColor(AppColors.primaryBlue)
                            
                            TextField("Enter procedure name", text: $procedureName)
                                .font(.bellGothic(size: 16))
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(AppColors.primaryBlue.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description (Optional)")
                                .font(.bellGothic(size: 16, weight: .bold))
                                .foregroundColor(AppColors.primaryBlue)
                            
                            TextField("Enter description", text: $procedureDescription, axis: .vertical)
                                .font(.bellGothic(size: 16))
                                .lineLimit(3...6)
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(AppColors.primaryBlue.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Checklist")
                                .font(.bellGothic(size: 16, weight: .bold))
                                .foregroundColor(AppColors.primaryBlue)
                            
                            HStack {
                                TextField("Enter step", text: $newStepText)
                                    .font(.bellGothic(size: 16))
                                    .padding(12)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(AppColors.primaryBlue.opacity(0.3), lineWidth: 1)
                                    )
                                
                                Button(action: addStep) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 44, height: 44)
                                        .background(newStepText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? AppColors.lightGray : AppColors.primaryYellow)
                                        .cornerRadius(8)
                                }
                                .disabled(newStepText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                            }
                            
                            if !steps.isEmpty {
                                VStack(spacing: 8) {
                                    ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                                        HStack {
                                            Text("\(index + 1).")
                                                .font(.bellGothic(size: 14, weight: .bold))
                                                .foregroundColor(AppColors.primaryBlue)
                                                .frame(width: 20, alignment: .leading)
                                            
                                            Text(step)
                                                .font(.bellGothic(size: 14))
                                                .foregroundColor(AppColors.darkGray)
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                                removeStep(at: index)
                                            }) {
                                                Image(systemName: "trash")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.red)
                                            }
                                        }
                                        .padding(8)
                                        .background(AppColors.lightGray.opacity(0.5))
                                        .cornerRadius(6)
                                    }
                                }
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Edit Procedure")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.bellGothic(size: 16))
                    .foregroundColor(AppColors.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProcedure()
                    }
                    .font(.bellGothic(size: 16, weight: .bold))
                    .foregroundColor(isValid ? AppColors.primaryYellow : AppColors.lightGray)
                    .disabled(!isValid)
                }
            }
        }
    }
    
    private func addStep() {
        let trimmedStep = newStepText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedStep.isEmpty {
            steps.append(trimmedStep)
            newStepText = ""
        }
    }
    
    private func removeStep(at index: Int) {
        steps.remove(at: index)
    }
    
    private func saveProcedure() {
        guard var updatedProcedure = procedure else { return }
        updatedProcedure.name = procedureName.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedProcedure.description = procedureDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedProcedure.steps = steps
        
        viewModel.updateProcedure(updatedProcedure)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    let viewModel = ProcedureViewModel()
    let procedure = Procedure(name: "Morning Skincare", description: "Daily morning routine", steps: ["Cleanse face", "Apply toner", "Moisturize"])
    viewModel.addProcedure(procedure)
    
    return NavigationView {
        ProcedureDetailView(
            procedureId: procedure.id,
            viewModel: viewModel
        )
    }
}
