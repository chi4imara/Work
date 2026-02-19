import SwiftUI

struct ProjectsView: View {
    @ObservedObject var viewModel: ProjectsViewModel
    @State private var showingNewProject = false
    
    var body: some View {
        ZStack {
            ColorManager.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Projects")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Spacer()
                    
                    Button(action: {
                        showingNewProject = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(ColorManager.accentOrange)
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        FilterButton(
                            title: "All",
                            isSelected: viewModel.selectedCategory == nil,
                            action: { viewModel.setFilter(nil) }
                        )
                        
                        ForEach(ProjectCategory.allCases, id: \.self) { category in
                            FilterButton(
                                title: category.displayName,
                                isSelected: viewModel.selectedCategory == category,
                                action: { viewModel.setFilter(category) }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                if viewModel.filteredProjects.isEmpty {
                    EmptyProjectsView(showingNewProject: $showingNewProject)
                } else {
                    ProjectsListView(
                        projects: viewModel.filteredProjects,
                        viewModel: viewModel
                    )
                }
            }
        }
        .sheet(isPresented: $showingNewProject) {
            NewProjectView(viewModel: viewModel)
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(isSelected ? ColorManager.primaryText : ColorManager.secondaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? ColorManager.accentBlue : ColorManager.cardBackground)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EmptyProjectsView: View {
    @Binding var showingNewProject: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "folder.badge.plus")
                .font(.system(size: 64, weight: .light))
                .foregroundColor(ColorManager.secondaryText)
            
            VStack(spacing: 8) {
                Text("Add your first project")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text("Start tracking your tool-based projects")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
            }
            
            Button(action: {
                showingNewProject = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .bold))
                    Text("New Project")
                        .font(.ubuntu(16, weight: .medium))
                }
                .foregroundColor(ColorManager.primaryText)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ColorManager.accentOrange)
                )
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ProjectsListView: View {
    let projects: [Project]
    @ObservedObject var viewModel: ProjectsViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                    ForEach(projects) { project in
                        NavigationLink(destination: ProjectDetailView(projectId: project.id, viewModel: viewModel)) {
                            ProjectCardView(project: project)
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

struct ProjectCardView: View {
    let project: Project
    
    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 8)
                .fill(ColorManager.categoryColors[project.category.rawValue] ?? ColorManager.accentBlue)
                .frame(width: 4, height: 60)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(project.name)
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                    .lineLimit(1)
                
                Text(project.formattedDate)
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                
                if !project.tools.isEmpty {
                    Text(project.primaryTool)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(ColorManager.accentBlue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(ColorManager.accentBlue.opacity(0.2))
                        )
                }
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

#Preview {
    ProjectsView(viewModel: ProjectsViewModel())
}
