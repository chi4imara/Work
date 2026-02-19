import SwiftUI

struct EditProcedureView: View {
    @EnvironmentObject var viewModel: GroomingViewModel
    @Environment(\.dismiss) private var dismiss
    
    let procedureId: UUID
    
    @State private var name: String = ""
    @State private var selectedCategory: Procedure.ProcedureCategory = .skincare
    @State private var frequency: String = ""
    @State private var notes: String = ""
    @State private var didLoad = false
    
    private var procedure: Procedure? {
        viewModel.procedure(byId: procedureId)
    }
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button("Cancel") { dismiss() }
                        .font(FontManager.playfairDisplay(.medium, size: 16))
                        .foregroundColor(.primaryWhite.opacity(0.8))
                    
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Text("Edit Procedure")
                            .font(FontManager.playfairDisplay(.bold, size: 16))
                            .foregroundColor(.primaryWhite)
                        Text("Update your routine")
                            .font(FontManager.playfairDisplay(.regular, size: 12))
                            .foregroundColor(.primaryWhite.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    Button("Save") { saveProcedure() }
                        .font(FontManager.playfairDisplay(.semibold, size: 16))
                        .foregroundColor(canSave ? .primaryOrange : .primaryWhite.opacity(0.3))
                        .disabled(!canSave)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                ScrollView {
                    VStack(spacing: 20) {
                        FormField(
                            title: "Name",
                            placeholder: "Enter procedure name",
                            text: $name
                        )
                        CategorySelector(selectedCategory: $selectedCategory)
                        FormField(
                            title: "Frequency",
                            placeholder: "e.g., Daily, Weekly, Every 2 days",
                            text: $frequency
                        )
                        NotesField(notes: $notes)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .onAppear {
            if !didLoad, let procedure = procedure {
                name = procedure.name
                selectedCategory = procedure.category
                frequency = procedure.frequency
                notes = procedure.notes
                didLoad = true
            }
        }
    }
    
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func saveProcedure() {
        guard var existing = procedure else { return }
        existing.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        existing.category = selectedCategory
        existing.frequency = frequency.isEmpty ? "Daily" : frequency
        existing.notes = notes
        viewModel.updateProcedure(existing)
        dismiss()
    }
}

struct EditProcedureView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = GroomingViewModel()
        let id = UUID()
        return EditProcedureView(procedureId: id)
            .environmentObject(vm)
    }
}
