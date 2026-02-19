import SwiftUI

struct AddToolView: View {
    @ObservedObject var toolsViewModel: ToolsViewModel
    @State private var toolName = ""
    @State private var toolType = ""
    @State private var toolCondition = ""
    @State private var toolComment = ""
    @State private var showingSuccessView = false
    @State private var savedTool: Tool?
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("New Tool")
                            .font(.playfairDisplay(size: 32, weight: .bold))
                            .foregroundColor(.appWhite)
                        
                        Text("Add a new tool to your catalog")
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
                    
                    Button(action: saveTool) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 18, weight: .semibold))
                            
                            Text("Save Tool")
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
                }
                .padding(.bottom, 120)
            }
        }
        .fullScreenCover(isPresented: $showingSuccessView) {
            if let tool = savedTool {
                ToolSavedView(tool: tool, isPresented: $showingSuccessView) {
                    clearForm()
                }
            }
        }
    }
    
    private func saveTool() {
        let newTool = Tool(
            name: toolName.trimmingCharacters(in: .whitespacesAndNewlines),
            type: toolType.trimmingCharacters(in: .whitespacesAndNewlines),
            condition: toolCondition.trimmingCharacters(in: .whitespacesAndNewlines),
            comment: toolComment.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        toolsViewModel.addTool(newTool)
        savedTool = newTool
        showingSuccessView = true
    }
    
    private func clearForm() {
        toolName = ""
        toolType = ""
        toolCondition = ""
        toolComment = ""
        savedTool = nil
    }
}

struct CustomTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let icon: String
    var isMultiline: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.appLightBlue)
                
                Text(title)
                    .font(.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(.appWhite)
            }
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.lightBlue.opacity(0.3), lineWidth: 1)
                    )
                    .frame(minHeight: isMultiline ? 80 : 48)
                
                if isMultiline {
                    TextEditor(text: $text)
                        .font(.playfairDisplay(size: 16, weight: .regular))
                        .foregroundColor(.appWhite)
                        .background(Color.clear)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .scrollContentBackground(.hidden)
                } else {
                    TextField(placeholder, text: $text)
                        .font(.playfairDisplay(size: 16, weight: .regular))
                        .foregroundColor(.appWhite)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                }
                
                if text.isEmpty {
                    Text(placeholder)
                        .font(.playfairDisplay(size: 16, weight: .regular))
                        .foregroundColor(.appMediumGray)
                        .padding(.horizontal, 16)
                        .padding(.vertical, isMultiline ? 20 : 12)
                        .allowsHitTesting(false)
                }
            }
        }
    }
}

#Preview {
    AddToolView(toolsViewModel: ToolsViewModel())
}
