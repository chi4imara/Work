import SwiftUI

struct ToolDetailView: View {
    let tool: Tool
    @ObservedObject var viewModel: ToolViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 24) {
                        toolHeaderSection
                        
                        toolInfoSection
                        
                        actionButtonsSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingEditView) {
            EditToolView(tool: tool, viewModel: viewModel)
        }
        .alert(isPresented: $showingDeleteAlert) {
            deleteAlert
        }
        .onDisappear {
            viewModel.selectedToolId = nil
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(ColorTheme.accentOrange)
            }
            
            Spacer()
            
            Text("Tool Details")
                .font(FontManager.headline(.medium))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
            
            Button(action: {
                showingEditView = true
            }) {
                Text("Edit")
                    .font(FontManager.body(.medium))
                    .foregroundColor(ColorTheme.accentOrange)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }
    
    private var toolHeaderSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(ColorTheme.cardGradient)
                    .frame(width: 100, height: 100)
                
                Image(systemName: tool.type.icon)
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(ColorTheme.accentOrange)
            }
            
            Text(tool.name)
                .font(FontManager.title(.bold))
                .foregroundColor(ColorTheme.primaryText)
                .multilineTextAlignment(.center)
            
            Text(tool.type.rawValue)
                .font(FontManager.caption(.medium))
                .foregroundColor(ColorTheme.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(ColorTheme.accentOrange.opacity(0.2))
                .cornerRadius(16)
        }
    }
    
    private var toolInfoSection: some View {
        VStack(spacing: 16) {
            if !tool.size.isEmpty {
                InfoRow(
                    icon: "ruler",
                    title: "Size",
                    value: tool.size
                )
            }
            
            if !tool.brand.isEmpty {
                InfoRow(
                    icon: "tag",
                    title: "Brand",
                    value: tool.brand
                )
            }
            
            if !tool.storageLocation.isEmpty {
                InfoRow(
                    icon: "location",
                    title: "Storage Location",
                    value: tool.storageLocation
                )
            }
            
            InfoRow(
                icon: "calendar",
                title: "Date Added",
                value: DateFormatter.shortDate.string(from: tool.dateCreated)
            )
            
            if !tool.description.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "text.alignleft")
                            .font(.system(size: 18))
                            .foregroundColor(ColorTheme.accentOrange)
                            .frame(width: 24)
                        
                        Text("Description")
                            .font(FontManager.body(.medium))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        Spacer()
                    }
                    
                    Text(tool.description)
                        .font(FontManager.body(.regular))
                        .foregroundColor(ColorTheme.secondaryText)
                        .lineSpacing(4)
                        .padding(.leading, 32)
                }
                .padding(16)
                .background(ColorTheme.cardBackground)
                .cornerRadius(12)
            }
        }
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: 12) {
            Button(action: {
                showingEditView = true
            }) {
                HStack {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("Edit Tool")
                        .font(FontManager.body(.medium))
                }
                .foregroundColor(ColorTheme.primaryText)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(ColorTheme.accentGradient)
                .cornerRadius(25)
            }
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                HStack {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("Delete Tool")
                        .font(FontManager.body(.medium))
                }
                .foregroundColor(ColorTheme.errorRed)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(ColorTheme.cardBackground)
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(ColorTheme.errorRed.opacity(0.3), lineWidth: 1)
                )
            }
        }
        .padding(.top, 20)
    }
    
    private var deleteAlert: Alert {
        Alert(
            title: Text("Delete Tool"),
            message: Text("Are you sure you want to delete \"\(tool.name)\"? This action cannot be undone."),
            primaryButton: .destructive(Text("Delete")) {
                viewModel.deleteTool(tool)
                viewModel.selectedToolId = nil
                presentationMode.wrappedValue.dismiss()
            },
            secondaryButton: .cancel()
        )
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(ColorTheme.accentOrange)
                .frame(width: 24)
            
            Text(title)
                .font(FontManager.body(.medium))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
            
            Text(value)
                .font(FontManager.body(.regular))
                .foregroundColor(ColorTheme.secondaryText)
        }
        .padding(16)
        .background(ColorTheme.cardBackground)
        .cornerRadius(12)
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

#Preview {
    ToolDetailView(
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
