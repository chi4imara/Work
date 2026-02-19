import SwiftUI

struct UsageView: View {
    @ObservedObject var viewModel: ToolsViewModel
    @State private var selectedTool: Tool?
    @State private var showingToolDetail = false
    
    var toolsWithUsage: [Tool] {
        viewModel.getToolsWithUsage()
    }
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            VStack {
                Text("Usage")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .padding(.top, 20)
                
                if toolsWithUsage.isEmpty {
                    Spacer()
                    Text("No usage information available.")
                        .font(.ubuntu(18))
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(toolsWithUsage) { tool in
                                UsageCard(tool: tool) {
                                    selectedTool = tool
                                    showingToolDetail = true
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                    }
                }
            }
        }
        .sheet(item: $selectedTool) { tool in
            ToolDetailView(tool: tool, viewModel: viewModel, isPresented: $showingToolDetail)
        }
    }
}

struct UsageCard: View {
    let tool: Tool
    let onTap: () -> Void
    @State private var showingDates = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(tool.name)
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("\(tool.usageCount) usage\(tool.usageCount == 1 ? "" : "s")")
                        .font(.ubuntu(14))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                Button(action: {
                    showingDates.toggle()
                }) {
                    Text(showingDates ? "Hide" : "Open")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(AppColors.lightBlue)
                        .cornerRadius(20)
                }
            }
            
            if showingDates {
                VStack(spacing: 8) {
                    ForEach(tool.usageDates) { usageDate in
                        HStack {
                            Text(usageDate.formattedDate)
                                .font(.ubuntu(14))
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                            
                            Button(action: onTap) {
                                Text("Open")
                                    .font(.ubuntu(12, weight: .medium))
                                    .foregroundColor(AppColors.primaryText)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(AppColors.orange)
                                    .cornerRadius(15)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(AppColors.buttonBackground)
                        .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(15)
    }
}

#Preview {
    UsageView(viewModel: ToolsViewModel())
}
