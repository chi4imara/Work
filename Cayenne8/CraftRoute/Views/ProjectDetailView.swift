import SwiftUI

struct ProjectDetailView: View {
    let projectId: UUID
    @ObservedObject var viewModel: ProjectsViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var project: Project? {
        viewModel.getProject(by: projectId)
    }
    
    var body: some View {
        Group {
            if let project = project {
                projectDetailContent(project: project)
            } else {
                ZStack {
                    ColorManager.primaryGradient.ignoresSafeArea()
                    Text("Project not found")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(ColorManager.primaryText)
                }
            }
        }
    }
    
    @ViewBuilder
    private func projectDetailContent(project: Project) -> some View {
        ZStack {
            ColorManager.primaryGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(project.name)
                                    .font(.ubuntu(24, weight: .bold))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                Text(project.formattedDate)
                                    .font(.ubuntu(16, weight: .regular))
                                    .foregroundColor(ColorManager.secondaryText)
                            }
                            
                            Spacer()
                            
                            Text(project.category.displayName)
                                .font(.ubuntu(12, weight: .medium))
                                .foregroundColor(ColorManager.primaryText)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(ColorManager.categoryColors[project.category.rawValue] ?? ColorManager.accentBlue)
                                )
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(ColorManager.cardGradient)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(ColorManager.separatorColor, lineWidth: 1)
                            )
                    )
                    
                    if !project.tools.isEmpty {
                        DetailSection(
                            title: "Tools Used",
                            icon: "hammer.fill",
                            items: project.tools
                        )
                    }
                    
                    if !project.materials.isEmpty {
                        DetailSection(
                            title: "Materials Used",
                            icon: "cube.box.fill",
                            items: project.materials
                        )
                    }
                    
                    if !project.description.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "text.alignleft")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(ColorManager.accentBlue)
                                
                                Text("Description")
                                    .font(.ubuntu(18, weight: .bold))
                                    .foregroundColor(ColorManager.primaryText)
                            }
                            
                            Text(project.description)
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(ColorManager.secondaryText)
                                .lineSpacing(4)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(ColorManager.cardGradient)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(ColorManager.separatorColor, lineWidth: 1)
                                )
                        )
                    }
                    
                    VStack(spacing: 12) {
                        Button(action: {
                            showingEditView = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "pencil")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Edit Project")
                                    .font(.ubuntu(16, weight: .medium))
                            }
                            .foregroundColor(ColorManager.primaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(ColorManager.accentBlue)
                            )
                        }
                        
                        Button(action: {
                            showingDeleteAlert = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "trash")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Delete Project")
                                    .font(.ubuntu(16, weight: .medium))
                            }
                            .foregroundColor(ColorManager.primaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.red.opacity(0.8))
                            )
                        }
                    }
                }
                .padding(20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditView) {
            EditProjectView(projectId: project.id, viewModel: viewModel)
        }
        .alert("Delete Project?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteProject(project)
                dismiss()
            }
        } message: {
            Text("This action cannot be undone.")
        }
    }
}

struct DetailSection: View {
    let title: String
    let icon: String
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(ColorManager.accentOrange)
                
                Text(title)
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 8) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorManager.primaryText)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(ColorManager.buttonBackground)
                        )
                }
            }
        }
        .padding(20)
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

#Preview {
    let viewModel = ProjectsViewModel()
    let project = Project(
        name: "Door Hinge Replacement",
        date: Date(),
        category: .home,
        tools: ["Screwdriver", "Drill", "Hammer"],
        materials: ["Hinges", "Screws", "Wood filler"],
        description: "Replaced old door hinges with new ones. Had to drill new holes and fill old ones."
    )
    viewModel.addProject(project)
    
    return NavigationView {
        ProjectDetailView(
            projectId: project.id,
            viewModel: viewModel
        )
    }
}
