import SwiftUI

struct EditToolView: View {
    let tool: Tool
    @ObservedObject var viewModel: ToolsViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String
    @State private var selectedCategory: ToolCategory
    @State private var storageLocation: String
    @State private var lastUsedDate: Date
    @State private var comment: String
    
    init(tool: Tool, viewModel: ToolsViewModel) {
        self.tool = tool
        self.viewModel = viewModel
        self._name = State(initialValue: tool.name)
        self._selectedCategory = State(initialValue: tool.category)
        self._storageLocation = State(initialValue: tool.storageLocation)
        self._lastUsedDate = State(initialValue: tool.lastUsedDate)
        self._comment = State(initialValue: tool.comment)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        FormField(title: "Tool Name", text: $name, placeholder: "Enter tool name")
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.white)
                            
                            Menu {
                                ForEach(ToolCategory.allCases) { category in
                                    Button(category.displayName) {
                                        selectedCategory = category
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedCategory.displayName)
                                        .font(.playfairDisplay(16))
                                        .foregroundColor(Color.theme.white)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(Color.theme.white.opacity(0.7))
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.theme.white.opacity(0.1))
                                )
                            }
                        }
                        
                        FormField(title: "Storage Location", text: $storageLocation, placeholder: "e.g., Shelf #2, Drawer #3")
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Last Used Date")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.white)
                            
                            DatePicker("", selection: $lastUsedDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .colorScheme(.dark)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.theme.white.opacity(0.1))
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment (Optional)")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.white)
                            
                            TextField("Add any notes about this tool...", text: $comment, axis: .vertical)
                                .font(.playfairDisplay(16))
                                .foregroundColor(Color.theme.white)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.theme.white.opacity(0.1))
                                )
                                .lineLimit(3...6)
                        }
                        
                        Button(action: saveChanges) {
                            Text("Save Changes")
                                .font(.playfairDisplay(18, weight: .semibold))
                                .foregroundColor(Color.theme.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(isFormValid ? Color.theme.orange : Color.theme.gray)
                                )
                        }
                        .disabled(!isFormValid)
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Edit Tool")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.orange)
                    .font(.playfairDisplay(16, weight: .medium))
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !storageLocation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func saveChanges() {
        var updatedTool = tool
        updatedTool.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedTool.category = selectedCategory
        updatedTool.storageLocation = storageLocation.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedTool.lastUsedDate = lastUsedDate
        updatedTool.comment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.updateTool(updatedTool)
        dismiss()
    }
}

#Preview {
    let sampleTool = Tool(
        name: "Electric Wrench",
        category: .electric,
        storageLocation: "Shelf #2",
        comment: "Used for brake repairs"
    )
    
    EditToolView(tool: sampleTool, viewModel: ToolsViewModel())
}
