import SwiftUI

struct CatalogView: View {
    @ObservedObject var viewModel: ToolsViewModel
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            VStack {
                Text("Catalog")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .padding(.top, 20)
                
                if viewModel.tools.isEmpty {
                    Spacer()
                    Text("You haven't added any tools yet.")
                        .font(.ubuntu(18))
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(viewModel.tools) { tool in
                                ToolCard(tool: tool, viewModel: viewModel)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                    }
                }
            }
        }
    }
}

struct ToolCard: View {
    let tool: Tool
    @ObservedObject var viewModel: ToolsViewModel
    @State private var showingDetails = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(tool.name)
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(tool.storageLocation)
                        .font(.ubuntu(14))
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text(tool.category.rawValue)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(AppColors.orange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(AppColors.orange.opacity(0.2))
                        .cornerRadius(8)
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.selectedTool = tool
                    showingDetails = true
                }) {
                    Text("Open")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(AppColors.lightBlue)
                        .cornerRadius(20)
                }
            }
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(15)
        .sheet(isPresented: $showingDetails) {
            if let selectedTool = viewModel.selectedTool {
                ToolDetailView(tool: selectedTool, viewModel: viewModel, isPresented: $showingDetails)
            }
        }
    }
}

#Preview {
    CatalogView(viewModel: ToolsViewModel())
}
