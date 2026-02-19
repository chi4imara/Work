import SwiftUI

struct AddManicureView: View {
    @ObservedObject var viewModel: ManicureViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var designName = ""
    @State private var colorsText = ""
    @State private var selectedMaster: Master?
    @State private var newMasterName = ""
    @State private var showingNewMasterField = false
    @State private var selectedDate = Date()
    @State private var notes = ""
    
    private var canSave: Bool {
        !designName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
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
                        
                        Button(action: saveManicure) {
                            Text("Save Record")
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
            .navigationTitle("New Manicure")
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
    
    private func saveManicure() {
        let colors = colorsText
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        let manicure = Manicure(
            designName: designName.trimmingCharacters(in: .whitespacesAndNewlines),
            colors: colors,
            master: selectedMaster ?? Master(name: "Unknown"),
            date: selectedDate,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        viewModel.addManicure(manicure)
        presentationMode.wrappedValue.dismiss()
    }
}

struct FormField<Content: View>: View {
    let title: String
    let isRequired: Bool
    let content: () -> Content
    
    init(title: String, isRequired: Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.isRequired = isRequired
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorManager.white)
                
                if isRequired {
                    Text("*")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(ColorManager.yellow)
                }
            }
            
            content()
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.ubuntu(16, weight: .regular))
            .foregroundColor(ColorManager.white)
            .padding(12)
            .background(ColorManager.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(ColorManager.cardBorder, lineWidth: 1)
            )
            .cornerRadius(8)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.ubuntu(14, weight: .medium))
            .foregroundColor(ColorManager.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(ColorManager.secondaryButton)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct CancelButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.ubuntu(14, weight: .medium))
            .foregroundColor(ColorManager.mediumGray)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(ColorManager.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(ColorManager.cardBorder, lineWidth: 1)
            )
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

#Preview {
    AddManicureView(viewModel: ManicureViewModel())
}
