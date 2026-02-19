import SwiftUI

struct ToolTypesView: View {
    @ObservedObject var toolsViewModel: ToolsViewModel
    @State private var selectedTypeItem: TypeItem?
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Tool Types")
                    .font(.playfairDisplay(size: 32, weight: .bold))
                    .foregroundColor(.appWhite)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 16)
                
                if toolsViewModel.toolTypes.isEmpty {
                    EmptyTypesView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(toolsViewModel.toolTypes) { toolType in
                                Button(action: {
                                    selectedTypeItem = TypeItem(typeName: toolType.name)
                                }) {
                                    ToolTypeRowView(toolType: toolType)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .sheet(item: $selectedTypeItem) { item in
            ToolTypeDetailView(
                typeName: item.typeName,
                tools: toolsViewModel.tools(for: item.typeName),
                toolsViewModel: toolsViewModel
            )
        }
    }
}

struct TypeItem: Identifiable {
    let id = UUID()
    let typeName: String
}

struct ToolTypeRowView: View {
    let toolType: ToolType
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColors.buttonGradient)
                    .frame(width: 60, height: 60)
                
                Image(systemName: typeIcon(for: toolType.name))
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.appWhite)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(toolType.name)
                    .font(.playfairDisplay(size: 20, weight: .semibold))
                    .foregroundColor(.appWhite)
                    .lineLimit(1)
                
                Text("\(toolType.count) tool\(toolType.count == 1 ? "" : "s")")
                    .font(.playfairDisplay(size: 14, weight: .medium))
                    .foregroundColor(.appLightBlue)
            }
            
            Spacer()
            
            HStack {
                Text("Open")
                    .font(.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(.appLightBlue)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.appLightBlue)
            }
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.lightBlue.opacity(0.2), lineWidth: 1)
        )
    }
    
    private func typeIcon(for type: String) -> String {
        switch type.lowercased() {
        case let t where t.contains("mechanical") || t.contains("mechanic"):
            return "wrench.and.screwdriver"
        case let t where t.contains("wood") || t.contains("timber"):
            return "hammer"
        case let t where t.contains("electrical") || t.contains("electric"):
            return "bolt"
        default:
            return "folder"
        }
    }
}

struct EmptyTypesView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 100, height: 100)
                
                Image(systemName: "folder")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(.appMediumGray)
            }
            
            VStack(spacing: 8) {
                Text("No Categories Yet")
                    .font(.playfairDisplay(size: 24, weight: .bold))
                    .foregroundColor(.appWhite)
                
                Text("Categories are not created yet.")
                    .font(.playfairDisplay(size: 16, weight: .regular))
                    .foregroundColor(.appMediumGray)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct ToolTypeDetailView: View {
    let typeName: String
    let tools: [Tool]
    @ObservedObject var toolsViewModel: ToolsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    VStack(spacing: 8) {
                        Text(typeName)
                            .font(.playfairDisplay(size: 28, weight: .bold))
                            .foregroundColor(.appWhite)
                        
                        Text("\(tools.count) tool\(tools.count == 1 ? "" : "s")")
                            .font(.playfairDisplay(size: 16, weight: .medium))
                            .foregroundColor(.appLightBlue)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 16)
                    
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(tools) { tool in
                                NavigationLink(destination: ToolDetailView(tool: tool, toolsViewModel: toolsViewModel)) {
                                    TypeToolRowView(tool: tool)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.playfairDisplay(size: 16, weight: .medium))
                    .foregroundColor(.appLightBlue)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TypeToolRowView: View {
    let tool: Tool
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColors.lightBlue.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: toolIcon(for: tool.type))
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.appLightBlue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(tool.name)
                    .font(.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(.appWhite)
                    .lineLimit(1)
                
                Text(tool.condition)
                    .font(.playfairDisplay(size: 14, weight: .medium))
                    .foregroundColor(conditionColor(tool.condition))
            }
            
            Spacer()
            
            HStack {
                Text("Open")
                    .font(.playfairDisplay(size: 14, weight: .semibold))
                    .foregroundColor(.appLightBlue)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.appLightBlue)
            }
        }
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.lightBlue.opacity(0.2), lineWidth: 1)
        )
    }
    
    private func toolIcon(for type: String) -> String {
        switch type.lowercased() {
        case let t where t.contains("mechanical") || t.contains("mechanic"):
            return "wrench.and.screwdriver"
        case let t where t.contains("wood") || t.contains("timber"):
            return "hammer"
        case let t where t.contains("electrical") || t.contains("electric"):
            return "bolt"
        default:
            return "wrench.and.screwdriver"
        }
    }
    
    private func conditionColor(_ condition: String) -> Color {
        switch condition.lowercased() {
        case let c where c.contains("new"):
            return .appSoftGreen
        case let c where c.contains("working") || c.contains("good"):
            return .appLightBlue
        case let c where c.contains("repair") || c.contains("broken"):
            return .appOrange
        default:
            return .appMediumGray
        }
    }
}

#Preview {
    ToolTypesView(toolsViewModel: ToolsViewModel())
}
