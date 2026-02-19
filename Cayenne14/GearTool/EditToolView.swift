import SwiftUI

struct EditToolView: View {
    @Binding var tool: Tool
    @ObservedObject var viewModel: ToolsViewModel
    @Binding var isPresented: Bool
    
    @State private var name: String = ""
    @State private var storageLocation: String = ""
    @State private var selectedCategory: ToolCategory = .manual
    @State private var comment: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        Text("Edit Tool")
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
                        
                        Button(action: saveChanges) {
                            Text("Save Changes")
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(AppColors.lightBlue)
                }
            }
        }
        .onAppear {
            loadToolData()
        }
    }
    
    private func loadToolData() {
        name = tool.name
        storageLocation = tool.storageLocation
        selectedCategory = tool.category
        comment = tool.comment
    }
    
    private func saveChanges() {
        tool.name = name
        tool.storageLocation = storageLocation
        tool.category = selectedCategory
        tool.comment = comment
        
        viewModel.updateTool(tool)
        isPresented = false
    }
}

#Preview {
    EditToolView(
        tool: .constant(Tool(name: "Drill", storageLocation: "Garage", category: .electric)),
        viewModel: ToolsViewModel(),
        isPresented: .constant(true)
    )
}
