import SwiftUI

struct AddProcedureView: View {
    @ObservedObject var viewModel: SkinCareViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String
    @State private var selectedType: Procedure.ProcedureType
    @State private var selectedFrequency: Procedure.ProcedureFrequency
    @State private var selectedTimeOfDay: Procedure.TimeOfDay
    @State private var duration: String
    @State private var notes: String
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var isEditMode: Bool = false
    var onSave: ((String, Procedure.ProcedureType, Procedure.ProcedureFrequency, Procedure.TimeOfDay, Int?, String) -> Void)?
    
    init(
        viewModel: SkinCareViewModel,
        initialName: String? = nil,
        initialType: Procedure.ProcedureType? = nil,
        initialFrequency: Procedure.ProcedureFrequency? = nil,
        initialTimeOfDay: Procedure.TimeOfDay? = nil,
        initialDuration: String? = nil,
        initialNotes: String? = nil,
        isEditMode: Bool = false,
        onSave: ((String, Procedure.ProcedureType, Procedure.ProcedureFrequency, Procedure.TimeOfDay, Int?, String) -> Void)? = nil
    ) {
        self.viewModel = viewModel
        self.isEditMode = isEditMode
        self.onSave = onSave
        _name = State(initialValue: initialName ?? "")
        _selectedType = State(initialValue: initialType ?? .daily)
        _selectedFrequency = State(initialValue: initialFrequency ?? .onceDaily)
        _selectedTimeOfDay = State(initialValue: initialTimeOfDay ?? .anytime)
        _duration = State(initialValue: initialDuration ?? "")
        _notes = State(initialValue: initialNotes ?? "")
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Procedure Name *")
                                .font(.bodyLarge)
                                .foregroundColor(ColorManager.primaryText)
                                .fontWeight(.medium)
                            
                            TextField("Enter procedure name", text: $name)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Type")
                                .font(.bodyLarge)
                                .foregroundColor(ColorManager.primaryText)
                                .fontWeight(.medium)
                            
                            Picker("Type", selection: $selectedType) {
                                ForEach(Procedure.ProcedureType.allCases, id: \.self) { type in
                                    Text(type.rawValue).tag(type)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Frequency")
                                .font(.bodyLarge)
                                .foregroundColor(ColorManager.primaryText)
                                .fontWeight(.medium)
                            
                            Menu {
                                ForEach(Procedure.ProcedureFrequency.allCases, id: \.self) { frequency in
                                    Button(frequency.rawValue) {
                                        selectedFrequency = frequency
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedFrequency.rawValue)
                                        .foregroundColor(ColorManager.darkText)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(ColorManager.secondaryText)
                                }
                                .padding(16)
                                .background(ColorManager.cardBackground)
                                .cornerRadius(12)
                                .shadow(color: ColorManager.shadowColor, radius: 2, x: 0, y: 1)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Time of Day")
                                .font(.bodyLarge)
                                .foregroundColor(ColorManager.primaryText)
                                .fontWeight(.medium)
                            
                            HStack(spacing: 12) {
                                ForEach(Procedure.TimeOfDay.allCases, id: \.self) { time in
                                    TimeOfDayButton(
                                        time: time,
                                        isSelected: selectedTimeOfDay == time,
                                        action: { selectedTimeOfDay = time }
                                    )
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Duration (minutes)")
                                .font(.bodyLarge)
                                .foregroundColor(ColorManager.primaryText)
                                .fontWeight(.medium)
                            
                            TextField("Optional", text: $duration)
                                .textFieldStyle(CustomTextFieldStyle())
                                .keyboardType(.numberPad)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes")
                                .font(.bodyLarge)
                                .foregroundColor(ColorManager.primaryText)
                                .fontWeight(.medium)
                            
                            TextField("Optional notes", text: $notes, axis: .vertical)
                                .textFieldStyle(CustomTextFieldStyle())
                                .lineLimit(3...6)
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle(isEditMode ? "Edit Procedure" : "New Procedure")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(ColorManager.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProcedure()
                    }
                    .foregroundColor(ColorManager.primaryBlue)
                    .fontWeight(.semibold)
                }
            }
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func saveProcedure() {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Please enter a procedure name"
            showingAlert = true
            return
        }
        
        let durationInt = Int(duration.trimmingCharacters(in: .whitespacesAndNewlines))
        let nameTrimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let notesTrimmed = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let onSave = onSave {
            onSave(nameTrimmed, selectedType, selectedFrequency, selectedTimeOfDay, durationInt, notesTrimmed)
        } else {
            let procedure = Procedure(
                name: nameTrimmed,
                type: selectedType,
                frequency: selectedFrequency,
                timeOfDay: selectedTimeOfDay,
                duration: durationInt,
                notes: notesTrimmed
            )
            viewModel.addProcedure(procedure)
        }
        presentationMode.wrappedValue.dismiss()
    }
}

struct TimeOfDayButton: View {
    let time: Procedure.TimeOfDay
    let isSelected: Bool
    let action: () -> Void
    
    private var backgroundGradient: LinearGradient {
        if isSelected {
            LinearGradient(
                gradient: Gradient(colors: [ColorManager.primaryBlue, ColorManager.primaryYellow]),
                startPoint: .leading,
                endPoint: .trailing
            )
        } else {
            LinearGradient(
                gradient: Gradient(colors: [ColorManager.cardBackground, ColorManager.cardBackground]),
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }
    
    var body: some View {
        Button(action: action) {
            Text(time.rawValue)
                .font(.bodyMedium)
                .foregroundColor(isSelected ? .white : ColorManager.primaryBlue)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(backgroundGradient)
                .cornerRadius(20)
                .shadow(color: ColorManager.shadowColor, radius: isSelected ? 5 : 2, x: 0, y: isSelected ? 3 : 1)
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.bodyMedium)
            .padding(16)
            .background(ColorManager.cardBackground)
            .cornerRadius(12)
            .shadow(color: ColorManager.shadowColor, radius: 2, x: 0, y: 1)
    }
}

#Preview {
    AddProcedureView(viewModel: SkinCareViewModel())
}
