import SwiftUI

struct AddJewelryView: View {
    @ObservedObject private var viewModel = JewelryViewModel.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var selectedStyle: String = "Minimalism"
    @State private var selectedType: JewelryType = .earrings
    @State private var note: String = ""
    @State private var showingCustomStyleAlert = false
    @State private var customStyleName: String = ""
    
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
                        
                        Button(action: addJewelry) {
                            Text("Add Jewelry")
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
            .navigationTitle("New Jewelry")
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
                .foregroundColor(.black)
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
    
    private func addJewelry() {
        let jewelry = Jewelry(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            style: selectedStyle,
            type: selectedType,
            note: note.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        viewModel.addJewelry(jewelry)
        presentationMode.wrappedValue.dismiss()
    }
}

struct StyleSelectionRow: View {
    let styleName: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(styleName)
                    .font(.playfairDisplay(16))
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(ColorTheme.lightBlue)
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(ColorTheme.secondaryText)
                }
            }
            .padding(16)
            .background(
                isSelected ? AnyShapeStyle(ColorTheme.lightBlue.opacity(0.2)) : AnyShapeStyle(ColorTheme.cardGradient)
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? ColorTheme.lightBlue : ColorTheme.accent.opacity(0.3),
                        lineWidth: 1
                    )
            )
        }
    }
}

struct TypeSelectionButton: View {
    let type: JewelryType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(type.displayName)
                .font(.playfairDisplay(14, weight: .medium))
                .foregroundColor(isSelected ? ColorTheme.primaryText : ColorTheme.secondaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    isSelected ? ColorTheme.buttonGradient : ColorTheme.cardGradient
                )
                .cornerRadius(20)
        }
    }
}

#Preview {
    AddJewelryView()
}
