import SwiftUI

struct ToolDetailView: View {
    let tool: Tool
    @ObservedObject var viewModel: ToolsViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            Image(systemName: iconForCategory(tool.category))
                                .font(.system(size: 60, weight: .light))
                                .foregroundColor(Color.theme.lightBlue)
                                .frame(width: 100, height: 100)
                                .background(
                                    Circle()
                                        .fill(Color.theme.white.opacity(0.1))
                                )
                            
                            Text(tool.name)
                                .font(.playfairDisplay(28, weight: .bold))
                                .foregroundColor(Color.theme.white)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 16) {
                            DetailRow(title: "Category", value: tool.category.displayName, icon: "tag")
                            DetailRow(title: "Storage Location", value: tool.storageLocation, icon: "location")
                            DetailRow(title: "Last Used", value: formattedDate(tool.lastUsedDate), icon: "clock")
                            
                            if !tool.comment.isEmpty {
                                DetailRow(title: "Comment", value: tool.comment, icon: "text.bubble")
                            }
                        }
                        
                        VStack(spacing: 16) {
                            Button(action: markAsUsedToday) {
                                HStack(spacing: 12) {
                                    Image(systemName: "checkmark.circle")
                                        .font(.system(size: 20, weight: .medium))
                                    Text("Mark as Used Today")
                                        .font(.playfairDisplay(18, weight: .semibold))
                                }
                                .foregroundColor(Color.theme.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.theme.green)
                                )
                            }
                            
                            Button(action: {
                                showingEditView = true
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 20, weight: .medium))
                                    Text("Edit Tool")
                                        .font(.playfairDisplay(18, weight: .semibold))
                                }
                                .foregroundColor(Color.theme.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.theme.orange)
                                )
                            }
                            
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "trash")
                                        .font(.system(size: 20, weight: .medium))
                                    Text("Delete Tool")
                                        .font(.playfairDisplay(18, weight: .semibold))
                                }
                                .foregroundColor(Color.theme.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.theme.red)
                                )
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Tool Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.orange)
                    .font(.playfairDisplay(16, weight: .medium))
                }
            }
            .preferredColorScheme(.dark)
        }
        .sheet(isPresented: $showingEditView) {
            EditToolView(tool: tool, viewModel: viewModel)
        }
        .alert("Delete Tool", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.deleteTool(tool)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this tool? This action cannot be undone.")
        }
    }
    
    private func iconForCategory(_ category: ToolCategory) -> String {
        switch category {
        case .manual:
            return "wrench"
        case .electric:
            return "bolt"
        case .measuring:
            return "ruler"
        case .automotive:
            return "car"
        case .other:
            return "questionmark"
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func markAsUsedToday() {
        viewModel.markToolAsUsedToday(tool)
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color.theme.lightBlue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.playfairDisplay(14, weight: .semibold))
                    .foregroundColor(Color.theme.orange)
                
                Text(value)
                    .font(.playfairDisplay(16))
                    .foregroundColor(Color.theme.white)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.theme.cardGradient)
        )
    }
}

#Preview {
    let sampleTool = Tool(
        name: "Electric Wrench",
        category: .electric,
        storageLocation: "Shelf #2",
        comment: "Used for brake repairs"
    )
    
    ToolDetailView(tool: sampleTool, viewModel: ToolsViewModel())
}
