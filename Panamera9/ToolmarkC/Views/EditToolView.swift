import SwiftUI

struct EditToolView: View {
    let tool: Tool
    @ObservedObject var viewModel: ToolViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var toolName: String
    @State private var selectedType: ToolType
    @State private var toolSize: String
    @State private var toolBrand: String
    @State private var storageLocation: String
    @State private var toolDescription: String
    @State private var showingTypePicker = false
    
    init(tool: Tool, viewModel: ToolViewModel) {
        self.tool = tool
        self.viewModel = viewModel
        
        _toolName = State(initialValue: tool.name)
        _selectedType = State(initialValue: tool.type)
        _toolSize = State(initialValue: tool.size)
        _toolBrand = State(initialValue: tool.brand)
        _storageLocation = State(initialValue: tool.storageLocation)
        _toolDescription = State(initialValue: tool.description)
    }
    
    var isFormValid: Bool {
        !toolName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var hasChanges: Bool {
        toolName != tool.name ||
        selectedType != tool.type ||
        toolSize != tool.size ||
        toolBrand != tool.brand ||
        storageLocation != tool.storageLocation ||
        toolDescription != tool.description
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
                    .padding(.bottom, 40)
                }
            }
        }
        .sheet(isPresented: $showingTypePicker) {
            typePickerSheet
        }
    }
    
    private var headerView: some View {
        HStack {
            Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }
            .font(FontManager.body(.regular))
            .foregroundColor(ColorTheme.accentOrange)
            
            Spacer()
            
            Text("Edit Tool")
                .font(FontManager.headline(.medium))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
            
            Button("Cancel") {
            }
            .font(FontManager.body(.regular))
            .foregroundColor(.clear)
            .disabled(true)
        }
        .padding(.vertical, 20)
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
        Button(action: saveChanges) {
            Text("Save Changes")
                .font(FontManager.body(.medium))
                .foregroundColor(ColorTheme.primaryText)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(isFormValid && hasChanges ? AnyShapeStyle(ColorTheme.accentGradient) : AnyShapeStyle(ColorTheme.mutedText.opacity(0.3)))
                .cornerRadius(25)
        }
        .disabled(!isFormValid || !hasChanges)
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
    
    private func saveChanges() {
        var updatedTool = tool
        updatedTool.name = toolName.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedTool.type = selectedType
        updatedTool.size = toolSize.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedTool.brand = toolBrand.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedTool.storageLocation = storageLocation.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedTool.description = toolDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.updateTool(updatedTool)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    EditToolView(
        tool: Tool(
            name: "Adjustable Wrench 10\"",
            type: .wrench,
            size: "10 inches",
            brand: "Stanley",
            storageLocation: "Garage Toolbox",
            description: "Heavy-duty adjustable wrench for general use"
        ),
        viewModel: ToolViewModel()
    )
}
