import SwiftUI

struct NewProcedureView: View {
    @ObservedObject var viewModel: ProcedureViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var procedureName = ""
    @State private var procedureDescription = ""
    @State private var steps: [String] = []
    @State private var newStepText = ""
    
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
            .navigationTitle("New Procedure")
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
        let procedure = Procedure(
            name: procedureName.trimmingCharacters(in: .whitespacesAndNewlines),
            description: procedureDescription.trimmingCharacters(in: .whitespacesAndNewlines),
            steps: steps
        )
        
        viewModel.addProcedure(procedure)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    NewProcedureView(viewModel: ProcedureViewModel())
}
