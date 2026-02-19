import SwiftUI

struct ToolTypesView: View {
    @ObservedObject var viewModel: ToolViewModel
    @State private var selectedType: ToolType?
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.toolTypes.isEmpty {
                    emptyStateView
                } else {
                    typesListView
                }
            }
        }
        .sheet(item: Binding<ToolTypeWrapper?>(
            get: { selectedType.map(ToolTypeWrapper.init) },
            set: { selectedType = $0?.type }
        )) { wrapper in
            ToolsByTypeView(toolType: wrapper.type, viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Tool Types")
                .font(FontManager.title(.bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(ColorTheme.cardGradient)
                    .frame(width: 120, height: 120)
                
                Image(systemName: "folder")
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(ColorTheme.accentOrange)
            }
            
            VStack(spacing: 12) {
                Text("No Tool Types")
                    .font(FontManager.headline(.medium))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Tool types will appear automatically after adding tools to your catalog")
                    .font(FontManager.body(.regular))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                withAnimation {
                    selectedTab = 3
                }
            }) {
                Text("Add First Tool")
                    .font(FontManager.body(.medium))
                    .foregroundColor(ColorTheme.primaryText)
                    .frame(width: 140, height: 44)
                    .background(ColorTheme.accentGradient)
                    .cornerRadius(22)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var typesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.toolTypes, id: \.type) { typeInfo in
                    ToolTypeCard(
                        type: typeInfo.type,
                        count: typeInfo.count
                    ) {
                        selectedType = typeInfo.type
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
}

struct ToolTypeCard: View {
    let type: ToolType
    let count: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(ColorTheme.accentOrange.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: type.icon)
                        .font(.system(size: 26, weight: .medium))
                        .foregroundColor(ColorTheme.accentOrange)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(type.rawValue)
                        .font(FontManager.body(.medium))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text("\(count) tool\(count == 1 ? "" : "s")")
                        .font(FontManager.caption(.regular))
                        .foregroundColor(ColorTheme.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(ColorTheme.mutedText)
            }
            .padding(20)
            .background(ColorTheme.cardGradient)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(ColorTheme.borderColor, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ToolsByTypeView: View {
    let toolType: ToolType
    @ObservedObject var viewModel: ToolViewModel
    @Environment(\.presentationMode) var presentationMode
    
    private var toolsOfType: [Tool] {
        viewModel.toolsOfType(toolType)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 0) {
                    HStack {
                        Button("Done") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(FontManager.body(.regular))
                        .foregroundColor(ColorTheme.accentOrange)
                        .opacity(0)
                        .disabled(true)
                        
                        Spacer()
                        
                        Text(toolType.rawValue)
                            .font(FontManager.headline(.medium))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        Spacer()
                        
                        Button("Done") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(FontManager.body(.regular))
                        .foregroundColor(ColorTheme.accentOrange)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                    
                    if toolsOfType.isEmpty {
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Image(systemName: toolType.icon)
                                .font(.system(size: 60, weight: .light))
                                .foregroundColor(ColorTheme.mutedText)
                            
                            Text("No \(toolType.rawValue.lowercased()) found")
                                .font(FontManager.body(.regular))
                                .foregroundColor(ColorTheme.secondaryText)
                            
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(toolsOfType) { tool in
                                    ToolCardView(tool: tool) {
                                        viewModel.selectedToolId = tool.id
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 40)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct ToolTypeWrapper: Identifiable {
    let id = UUID()
    let type: ToolType
}
