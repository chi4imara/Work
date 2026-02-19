import SwiftUI

struct ToolDetailView: View {
    @Environment(\.dismiss) var dismiss
    @State var tool: Tool
    @ObservedObject var viewModel: ToolsViewModel
    @Binding var isPresented: Bool
    @State private var selectedDate = Date()
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        Text(tool.name)
                            .font(.ubuntu(24, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                            .padding(.top, 20)
                        
                        VStack(spacing: 15) {
                            InfoRow(title: "Storage Location", value: tool.storageLocation)
                            InfoRow(title: "Category", value: tool.category.rawValue)
                            InfoRow(title: "Comment", value: tool.comment.isEmpty ? "Comment not added." : tool.comment)
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Mark Usage")
                                .font(.ubuntu(20, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            HStack {
                                DatePicker("Usage Date", selection: $selectedDate, displayedComponents: .date)
                                    .font(.ubuntu(16))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Button(action: addUsageDate) {
                                    Text("Add Date")
                                        .font(.ubuntu(14, weight: .medium))
                                        .foregroundColor(AppColors.primaryText)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(AppColors.orange)
                                        .cornerRadius(20)
                                }
                            }
                            .padding()
                            .background(AppColors.cardBackground)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Usage History")
                                .font(.ubuntu(18, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            if tool.usageDates.isEmpty {
                                Text("Usage not marked yet.")
                                    .font(.ubuntu(16))
                                    .foregroundColor(AppColors.secondaryText)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(12)
                            } else {
                                ForEach(tool.usageDates) { usageDate in
                                    HStack {
                                        Text(usageDate.formattedDate)
                                            .font(.ubuntu(16))
                                            .foregroundColor(AppColors.primaryText)
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            removeUsageDate(usageDate.id)
                                        }) {
                                            Text("Delete")
                                                .font(.ubuntu(12, weight: .medium))
                                                .foregroundColor(AppColors.error)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(AppColors.error.opacity(0.2))
                                                .cornerRadius(15)
                                        }
                                    }
                                    .padding()
                                    .background(AppColors.cardBackground)
                                    .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 15) {
                            Button(action: {
                                showingEditView = true
                            }) {
                                Text("Edit")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(AppColors.primaryText)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(AppColors.lightBlue)
                                    .cornerRadius(25)
                            }
                            
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                Text("Delete Tool")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(AppColors.primaryText)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(AppColors.error)
                                    .cornerRadius(25)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 50)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.lightBlue)
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            EditToolView(tool: $tool, viewModel: viewModel, isPresented: $showingEditView)
        }
        .alert("Delete Tool", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteTool(withId: tool.id)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this tool? This action cannot be undone.")
        }
    }
    
    private func addUsageDate() {
        viewModel.addUsageDate(to: tool.id, date: selectedDate)
        if let updatedTool = viewModel.tools.first(where: { $0.id == tool.id }) {
            tool = updatedTool
        }
    }
    
    private func removeUsageDate(_ usageDateId: UUID) {
        viewModel.removeUsageDate(from: tool.id, usageDateId: usageDateId)
        if let updatedTool = viewModel.tools.first(where: { $0.id == tool.id }) {
            tool = updatedTool
        }
    }
}

#Preview {
    ToolDetailView(
        tool: Tool(name: "Drill", storageLocation: "Garage", category: .electric),
        viewModel: ToolsViewModel(),
        isPresented: .constant(true)
    )
}
