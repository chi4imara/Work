import SwiftUI

struct AddProcedureView: View {
    @ObservedObject var viewModel: ProcedureViewModel
    @Environment(\.dismiss) private var dismiss
    
    let editingProcedure: Procedure?
    
    @State private var selectedType: ProcedureType = .trim
    @State private var selectedDate = Date()
    @State private var product = ""
    @State private var note = ""
    
    init(viewModel: ProcedureViewModel, editingProcedure: Procedure? = nil) {
        self.viewModel = viewModel
        self.editingProcedure = editingProcedure
        
        if let procedure = editingProcedure {
            _selectedType = State(initialValue: procedure.type)
            _selectedDate = State(initialValue: procedure.date)
            _product = State(initialValue: procedure.product)
            _note = State(initialValue: procedure.note)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        typeSelectionSection
                        
                        dateSelectionSection
                        
                        productInputSection
                        
                        noteInputSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(editingProcedure == nil ? "New Procedure" : "Edit Procedure")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorManager.accent)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProcedure()
                    }
                    .foregroundColor(ColorManager.accent)
                    .font(FontManager.ubuntu(16, weight: .medium))
                }
            }
        }
    }
    
    private var typeSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Procedure Type")
                .font(FontManager.ubuntu(16, weight: .medium))
                .foregroundColor(ColorManager.primaryText)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(ProcedureType.allCases, id: \.self) { type in
                    ProcedureTypeButton(
                        type: type,
                        isSelected: selectedType == type
                    ) {
                        selectedType = type
                    }
                }
            }
        }
    }
    
    private var dateSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Date")
                .font(FontManager.ubuntu(16, weight: .medium))
                .foregroundColor(ColorManager.primaryText)
            
            DatePicker("", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(CompactDatePickerStyle())
                .padding(16)
                .background(ColorManager.cardGradient)
                .cornerRadius(12)
                .colorScheme(.dark)
        }
    }
    
    private var productInputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Product (Optional)")
                .font(FontManager.ubuntu(16, weight: .medium))
                .foregroundColor(ColorManager.primaryText)
            
            TextField("Enter product name", text: $product)
                .font(FontManager.ubuntu(16, weight: .regular))
                .foregroundColor(ColorManager.primaryText)
                .padding(16)
                .background(ColorManager.cardGradient)
                .cornerRadius(12)
        }
    }
    
    private var noteInputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Note (Optional)")
                .font(FontManager.ubuntu(16, weight: .medium))
                .foregroundColor(ColorManager.primaryText)
            
            TextField("Add a note about this procedure", text: $note, axis: .vertical)
                .font(FontManager.ubuntu(16, weight: .regular))
                .foregroundColor(ColorManager.primaryText)
                .lineLimit(3...6)
                .padding(16)
                .background(ColorManager.cardGradient)
                .cornerRadius(12)
        }
    }
    
    private func saveProcedure() {
        if let editingProcedure = editingProcedure {
            let updatedProcedure = Procedure(
                type: selectedType,
                date: selectedDate,
                product: product.trimmingCharacters(in: .whitespacesAndNewlines),
                note: note.trimmingCharacters(in: .whitespacesAndNewlines),
                id: editingProcedure.id
            )
            viewModel.updateProcedure(updatedProcedure)
        } else {
            let procedure = Procedure(
                type: selectedType,
                date: selectedDate,
                product: product.trimmingCharacters(in: .whitespacesAndNewlines),
                note: note.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            viewModel.addProcedure(procedure)
        }
        
        dismiss()
    }
}

struct ProcedureTypeButton: View {
    let type: ProcedureType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: type.iconName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isSelected ? ColorManager.primaryText : ColorManager.accent)
                
                Text(type.displayName)
                    .font(FontManager.ubuntu(14, weight: .medium))
                    .foregroundColor(isSelected ? ColorManager.primaryText : ColorManager.primaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                isSelected ? ColorManager.accentGradient : ColorManager.cardGradient
            )
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AddProcedureView(viewModel: ProcedureViewModel())
}
