import SwiftUI

struct EditToolView: View {
    @State private var tool: Tool
    @ObservedObject var toolsViewModel: ToolsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var toolName: String
    @State private var toolType: String
    @State private var toolCondition: String
    @State private var toolComment: String
    
    init(tool: Tool, toolsViewModel: ToolsViewModel) {
        self.tool = tool
        self.toolsViewModel = toolsViewModel
        self._toolName = State(initialValue: tool.name)
        self._toolType = State(initialValue: tool.type)
        self._toolCondition = State(initialValue: tool.condition)
        self._toolComment = State(initialValue: tool.comment)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text("Edit Tool")
                                .font(.playfairDisplay(size: 32, weight: .bold))
                                .foregroundColor(.appWhite)
                            
                            Text("Update your tool information")
                                .font(.playfairDisplay(size: 16, weight: .regular))
                                .foregroundColor(.appSoftGray)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 20) {
                            CustomTextField(
                                title: "Tool Name",
                                placeholder: "Enter tool name",
                                text: $toolName,
                                icon: "wrench.and.screwdriver"
                            )
                            
                            CustomTextField(
                                title: "Tool Type",
                                placeholder: "e.g., Mechanical, Woodworking, Electrical",
                                text: $toolType,
                                icon: "folder"
                            )
                            
                            CustomTextField(
                                title: "Condition",
                                placeholder: "e.g., New, Working, Needs Repair",
                                text: $toolCondition,
                                icon: "checkmark.shield"
                            )
                            
                            CustomTextField(
                                title: "Comment (Optional)",
                                placeholder: "Add any notes about this tool",
                                text: $toolComment,
                                icon: "text.bubble",
                                isMultiline: true
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        Button(action: saveChanges) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                
                                Text("Save Changes")
                                    .font(.playfairDisplay(size: 18, weight: .semibold))
                            }
                            .foregroundColor(.appWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                toolName.isEmpty || toolType.isEmpty || toolCondition.isEmpty ?
                                AnyShapeStyle(AppColors.mediumGray.opacity(0.5)) : AnyShapeStyle(AppColors.buttonGradient)
                            )
                            .cornerRadius(16)
                            .shadow(
                                color: toolName.isEmpty || toolType.isEmpty || toolCondition.isEmpty ?
                                Color.clear : AppColors.lightBlue.opacity(0.3),
                                radius: 8, x: 0, y: 4
                            )
                        }
                        .disabled(toolName.isEmpty || toolType.isEmpty || toolCondition.isEmpty)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.playfairDisplay(size: 16, weight: .medium))
                    .foregroundColor(.appLightBlue)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func saveChanges() {
        var updatedTool = tool
        updatedTool.name = toolName.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedTool.type = toolType.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedTool.condition = toolCondition.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedTool.comment = toolComment.trimmingCharacters(in: .whitespacesAndNewlines)
        
        toolsViewModel.updateTool(updatedTool)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    EditToolView(
        tool: Tool(name: "Hammer", type: "Mechanical", condition: "New", comment: "Heavy duty hammer"),
        toolsViewModel: ToolsViewModel()
    )
}
