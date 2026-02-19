import SwiftUI

struct AddToolView: View {
    @ObservedObject var viewModel: ToolViewModel
    @Binding var selectedTab: Int
    
    @State private var toolName = ""
    @State private var selectedType: ToolType = .other
    @State private var toolSize = ""
    @State private var toolBrand = ""
    @State private var storageLocation = ""
    @State private var toolDescription = ""
    @State private var showingTypePicker = false
    
    var isFormValid: Bool {
        !toolName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                headerView
                    .padding(.horizontal, 20)
                
                ScrollView {
                    VStack(spacing: 20) {
                        formView
                        
                        saveButton
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .sheet(isPresented: $showingTypePicker) {
            typePickerSheet
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("New Tool")
                .font(FontManager.title(.bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
        }
        .padding(.vertical, 10)
    }
    
    private var formView: some View {
        VStack(spacing: 16) {
            FormField(
                title: "Tool Name / Model",
                text: $toolName,
                placeholder: "e.g., Adjustable Wrench 10\""
            )
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Tool Type")
                    .font(FontManager.body(.medium))
                    .foregroundColor(ColorTheme.primaryText)
                
                Button(action: {
                    showingTypePicker = true
                }) {
                    HStack {
                        Image(systemName: selectedType.icon)
                            .font(.system(size: 18))
                            .foregroundColor(ColorTheme.accentOrange)
                        
                        Text(selectedType.rawValue)
                            .font(FontManager.body(.regular))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 14))
                            .foregroundColor(ColorTheme.mutedText)
                    }
                    .padding(16)
                    .background(ColorTheme.inputBackground)
                    .cornerRadius(12)
                }
            }
            
            FormField(
                title: "Size",
                text: $toolSize,
                placeholder: "e.g., 10 inches, PH2, 18V"
            )
            
            FormField(
                title: "Brand (Optional)",
                text: $toolBrand,
                placeholder: "e.g., Stanley, DeWalt, Klein"
            )
            
            FormField(
                title: "Storage Location",
                text: $storageLocation,
                placeholder: "e.g., Garage Toolbox, Workshop"
            )
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Description / Notes (Optional)")
                    .font(FontManager.body(.medium))
                    .foregroundColor(ColorTheme.primaryText)
                
                TextField("Additional notes about this tool...", text: $toolDescription, axis: .vertical)
                    .font(FontManager.body(.regular))
                    .foregroundColor(ColorTheme.primaryText)
                    .padding(16)
                    .background(ColorTheme.inputBackground)
                    .cornerRadius(12)
                    .lineLimit(3...6)
            }
        }
    }
    
    private var saveButton: some View {
        Button(action: saveTool) {
            Text("Save Tool")
                .font(FontManager.body(.medium))
                .foregroundColor(ColorTheme.primaryText)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(isFormValid ? AnyShapeStyle(ColorTheme.accentGradient) : AnyShapeStyle(ColorTheme.mutedText.opacity(0.3)))
                .cornerRadius(25)
        }
        .disabled(!isFormValid)
        .padding(.top, 20)
    }
    
    private var typePickerSheet: some View {
        NavigationView {
            ZStack {
                ColorTheme.primaryBackground.ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(ToolType.allCases, id: \.self) { type in
                            Button(action: {
                                selectedType = type
                                showingTypePicker = false
                            }) {
                                HStack {
                                    Image(systemName: type.icon)
                                        .font(.system(size: 20))
                                        .foregroundColor(ColorTheme.accentOrange)
                                        .frame(width: 30)
                                    
                                    Text(type.rawValue)
                                        .font(FontManager.body(.regular))
                                        .foregroundColor(ColorTheme.primaryText)
                                    
                                    Spacer()
                                    
                                    if selectedType == type {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(ColorTheme.accentOrange)
                                    }
                                }
                                .padding(16)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Select Tool Type")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    showingTypePicker = false
                }
                    .foregroundColor(ColorTheme.accentOrange)
            )
        }
    }
    
    private func saveTool() {
        let newTool = Tool(
            name: toolName.trimmingCharacters(in: .whitespacesAndNewlines),
            type: selectedType,
            size: toolSize.trimmingCharacters(in: .whitespacesAndNewlines),
            brand: toolBrand.trimmingCharacters(in: .whitespacesAndNewlines),
            storageLocation: storageLocation.trimmingCharacters(in: .whitespacesAndNewlines),
            description: toolDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        viewModel.addTool(newTool)
        
        toolName = ""
        selectedType = .other
        toolSize = ""
        toolBrand = ""
        storageLocation = ""
        toolDescription = ""
        
        withAnimation {
            selectedTab = 0
        }
    }
}

struct FormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(FontManager.body(.medium))
                .foregroundColor(ColorTheme.primaryText)
            
            TextField(placeholder, text: $text)
                .font(FontManager.body(.regular))
                .foregroundColor(ColorTheme.primaryText)
                .padding(16)
                .background(ColorTheme.inputBackground)
                .cornerRadius(12)
        }
    }
}

#Preview {
    AddToolView(viewModel: ToolViewModel(), selectedTab: .constant(3))
}
