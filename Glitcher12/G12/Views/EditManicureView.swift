import SwiftUI

struct EditManicureView: View {
    let manicureId: UUID
    @ObservedObject var viewModel: ManicureViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var designName: String = ""
    @State private var colorsText: String = ""
    @State private var selectedMaster: Master?
    @State private var newMasterName = ""
    @State private var showingNewMasterField = false
    @State private var selectedDate: Date = Date()
    @State private var notes: String = ""
    
    private var manicure: Manicure? {
        viewModel.manicures.first { $0.id == manicureId }
    }
    
    private var canSave: Bool {
        !designName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        Group {
            if let currentManicure = manicure {
                editContentView(currentManicure: currentManicure)
            } else {
                Text("Manicure not found")
                    .foregroundColor(ColorManager.white)
            }
        }
        .onAppear {
            updateFields()
        }
        .onChange(of: viewModel.manicures) { _ in
            updateFields()
        }
    }
    
    private func updateFields() {
        if let currentManicure = manicure {
            designName = currentManicure.designName
            colorsText = currentManicure.colors.joined(separator: ", ")
            selectedMaster = currentManicure.master
            selectedDate = currentManicure.date
            notes = currentManicure.notes
        }
    }
    
    private func editContentView(currentManicure: Manicure) -> some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 20) {
                        FormField(title: "Design Name", isRequired: true) {
                            TextField("Enter design name", text: $designName)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        FormField(title: "Colors") {
                            TextField("e.g., nude, white, silver", text: $colorsText)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        FormField(title: "Master") {
                            VStack(spacing: 12) {
                                if !showingNewMasterField {
                                    Menu {
                                        ForEach(viewModel.masters, id: \.id) { master in
                                            Button(master.name) {
                                                selectedMaster = master
                                            }
                                        }
                                        
                                        Divider()
                                        
                                        Button("Create New Master") {
                                            showingNewMasterField = true
                                        }
                                    } label: {
                                        HStack {
                                            Text(selectedMaster?.name ?? "Select Master")
                                                .foregroundColor(selectedMaster == nil ? ColorManager.mediumGray : ColorManager.white)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(ColorManager.mediumGray)
                                        }
                                        .padding(12)
                                        .background(ColorManager.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(ColorManager.cardBorder, lineWidth: 1)
                                        )
                                        .cornerRadius(8)
                                    }
                                } else {
                                    HStack {
                                        TextField("Enter master name", text: $newMasterName)
                                            .textFieldStyle(CustomTextFieldStyle())
                                        
                                        Button("Add") {
                                            if !newMasterName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                                selectedMaster = viewModel.createMaster(name: newMasterName.trimmingCharacters(in: .whitespacesAndNewlines))
                                                newMasterName = ""
                                                showingNewMasterField = false
                                            }
                                        }
                                        .disabled(newMasterName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                                        .buttonStyle(SecondaryButtonStyle())
                                        
                                        Button("Cancel") {
                                            newMasterName = ""
                                            showingNewMasterField = false
                                        }
                                        .buttonStyle(CancelButtonStyle())
                                    }
                                }
                            }
                        }
                        
                        FormField(title: "Date") {
                            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .colorScheme(.dark)
                        }
                        
                        FormField(title: "Notes") {
                            TextField("Optional notes", text: $notes, axis: .vertical)
                                .lineLimit(3...6)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        Button(action: saveChanges) {
                            Text("Save Changes")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(ColorManager.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(canSave ? AnyShapeStyle(ColorManager.primaryButton) : AnyShapeStyle(ColorManager.mediumGray.opacity(0.3)))
                                .cornerRadius(25)
                        }
                        .disabled(!canSave)
                        .padding(.top, 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Edit Manicure")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(ColorManager.yellow)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    private func saveChanges() {
        guard let manicure = manicure else { return }
        
        let colors = colorsText
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        var updatedManicure = manicure
        updatedManicure.designName = designName.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedManicure.colors = colors
        updatedManicure.master = selectedMaster ?? Master(name: "Unknown")
        updatedManicure.date = selectedDate
        updatedManicure.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.updateManicure(updatedManicure)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    EditManicureView(
        manicureId: Manicure.sampleData[0].id,
        viewModel: ManicureViewModel()
    )
}
