import SwiftUI

struct AddToolView: View {
    @ObservedObject var viewModel: ToolsViewModel
    @State private var name = ""
    @State private var storageLocation = ""
    @State private var selectedCategory = ToolCategory.manual
    @State private var comment = ""
    @State private var showingConfirmation = false
    @State private var createdTool: Tool?
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    Text("Add Tool")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                        .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter tool name", text: $name)
                                .font(.ubuntu(16))
                                .foregroundColor(AppColors.primaryText)
                                .padding()
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Storage Location")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter storage location", text: $storageLocation)
                                .font(.ubuntu(16))
                                .foregroundColor(AppColors.primaryText)
                                .padding()
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.primaryText)
                            
                            Picker("Category", selection: $selectedCategory) {
                                ForEach(ToolCategory.allCases) { category in
                                    Text(category.rawValue)
                                        .tag(category)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(AppColors.cardBackground)
                            .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter comment (optional)", text: $comment)
                                .font(.ubuntu(16))
                                .foregroundColor(AppColors.primaryText)
                                .padding()
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Button(action: saveTool) {
                        Text("Save")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(AppColors.lightBlue)
                            .cornerRadius(25)
                    }
                    .padding(.horizontal, 20)
                    .disabled(name.isEmpty || storageLocation.isEmpty)
                    .opacity(name.isEmpty || storageLocation.isEmpty ? 0.6 : 1.0)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .sheet(isPresented: $showingConfirmation) {
            if let tool = createdTool {
                ToolAddedView(tool: tool, isPresented: $showingConfirmation) {
                    clearForm()
                }
            }
        }
    }
    
    private func saveTool() {
        let newTool = Tool(
            name: name,
            storageLocation: storageLocation,
            category: selectedCategory,
            comment: comment
        )
        
        viewModel.addTool(newTool)
        createdTool = newTool
        showingConfirmation = true
    }
    
    private func clearForm() {
        name = ""
        storageLocation = ""
        selectedCategory = .manual
        comment = ""
    }
}

#Preview {
    AddToolView(viewModel: ToolsViewModel())
}
