import SwiftUI

struct ToolsView: View {
    @ObservedObject var viewModel: ProjectsViewModel
    
    var body: some View {
        ZStack {
            ColorManager.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Tools")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.allTools.isEmpty {
                    EmptyToolsView()
                } else {
                    ToolsListView(viewModel: viewModel)
                }
            }
        }
    }
}

struct EmptyToolsView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "hammer")
                .font(.system(size: 64, weight: .light))
                .foregroundColor(ColorManager.secondaryText)
            
            VStack(spacing: 8) {
                Text("No tools yet")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text("Tools will appear here when you add projects")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
}

struct ToolsListView: View {
    @ObservedObject var viewModel: ProjectsViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.allTools) { tool in
                    NavigationLink(destination: ToolProjectsView(tool: tool, viewModel: viewModel)) {
                        ToolCardView(tool: tool)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
}

struct ToolCardView: View {
    let tool: Tool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "hammer.fill")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(ColorManager.accentOrange)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(ColorManager.accentOrange.opacity(0.2))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(tool.name)
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                    .lineLimit(1)
                
                Text("\(tool.projectCount) project\(tool.projectCount == 1 ? "" : "s")")
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(ColorManager.tertiaryText)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ColorManager.separatorColor, lineWidth: 1)
                )
        )
    }
}

struct ToolProjectsView: View {
    let tool: Tool
    @ObservedObject var viewModel: ProjectsViewModel
    
    private var currentProjects: [Project] {
        viewModel.getProjects(byToolName: tool.name)
    }
    
    var body: some View {
        ZStack {
            ColorManager.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text(tool.name)
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Text("Used in \(currentProjects.count) project\(currentProjects.count == 1 ? "" : "s")")
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(ColorManager.secondaryText)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(currentProjects) { project in
                            NavigationLink(destination: ProjectDetailView(projectId: project.id, viewModel: viewModel)) {
                                ProjectCardView(project: project)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ToolsView(viewModel: ProjectsViewModel())
}
