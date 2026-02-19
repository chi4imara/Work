import SwiftUI

struct EditJewelryView: View {
    let jewelry: Jewelry
    @ObservedObject private var viewModel = JewelryViewModel.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String
    @State private var selectedStyle: String
    @State private var selectedType: JewelryType
    @State private var note: String
    @State private var showingCustomStyleAlert = false
    @State private var customStyleName: String = ""
    
    init(jewelry: Jewelry) {
        self.jewelry = jewelry
        self._name = State(initialValue: jewelry.name)
        self._selectedStyle = State(initialValue: jewelry.style)
        self._selectedType = State(initialValue: jewelry.type)
        self._note = State(initialValue: jewelry.note)
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Jewelry Name *")
                                .font(.playfairDisplay(16, weight: .medium))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            TextField("Enter jewelry name", text: $name)
                                .font(.playfairDisplay(16))
                                .foregroundColor(ColorTheme.primaryText)
                                .padding(16)
                                .background(ColorTheme.cardGradient)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(ColorTheme.accent.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Style")
                                .font(.playfairDisplay(16, weight: .medium))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            VStack(spacing: 8) {
                                ForEach(viewModel.availableStyles, id: \.self) { style in
                                    StyleSelectionRow(
                                        styleName: style,
                                        isSelected: selectedStyle == style,
                                        action: { selectedStyle = style }
                                    )
                                }
                                
                                Button(action: {
                                    showingCustomStyleAlert = true
                                }) {
                                    HStack {
                                        Image(systemName: "plus.circle")
                                        Text("Create Custom Style")
                                        Spacer()
                                    }
                                    .font(.playfairDisplay(16))
                                    .foregroundColor(ColorTheme.accentText)
                                    .padding(16)
                                    .background(ColorTheme.cardGradient)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(ColorTheme.lightBlue.opacity(0.3), lineWidth: 1)
                                    )
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Type")
                                .font(.playfairDisplay(16, weight: .medium))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 8) {
                                ForEach(JewelryType.allCases, id: \.self) { type in
                                    TypeSelectionButton(
                                        type: type,
                                        isSelected: selectedType == type,
                                        action: { selectedType = type }
                                    )
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Note")
                                .font(.playfairDisplay(16, weight: .medium))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            TextEditor(text: $note)
                                .font(.playfairDisplay(16))
                                .foregroundColor(ColorTheme.primaryText)
                                .scrollContentBackground(.hidden)
                                .frame(minHeight: 80)
                                .padding(12)
                                .background(ColorTheme.cardGradient)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(ColorTheme.accent.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        Button(action: saveChanges) {
                            Text("Save Changes")
                                .font(.playfairDisplay(18, weight: .semibold))
                                .foregroundColor(ColorTheme.primaryText)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    isFormValid ? ColorTheme.buttonGradient : ColorTheme.cardGradient
                                )
                                .cornerRadius(16)
                        }
                        .disabled(!isFormValid)
                        .opacity(isFormValid ? 1.0 : 0.6)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Edit Jewelry")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(ColorTheme.primaryText)
            )
            .preferredColorScheme(.dark)
        }
        .alert("Create Custom Style", isPresented: $showingCustomStyleAlert) {
            TextField("Style name", text: $customStyleName)
                .foregroundColor(.white)
            Button("Cancel", role: .cancel) {
                customStyleName = ""
            }
            Button("Create") {
                let trimmedName = customStyleName.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmedName.isEmpty {
                    viewModel.addCustomStyle(trimmedName)
                    selectedStyle = trimmedName
                    customStyleName = ""
                }
            }
        }
    }
    
    private func saveChanges() {
        var updatedJewelry = jewelry
        updatedJewelry.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedJewelry.style = selectedStyle
        updatedJewelry.type = selectedType
        updatedJewelry.note = note.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.updateJewelry(updatedJewelry)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    EditJewelryView(
        jewelry: Jewelry(name: "Sample Earrings", style: "Minimalism", type: .earrings, note: "Perfect for office wear")
    )
}
