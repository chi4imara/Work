import SwiftUI

struct ProjectListView: View {
    @ObservedObject var viewModel: ProjectViewModel
    @State private var selectedProject: Project?
    @State private var showingProjectDetail = false
    
    var body: some View {
        ZStack {
            ColorManager.primaryBackground
                .ignoresSafeArea()
            
            VStack {
                Text("Project List")
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                    .padding(.vertical, 10)
                
                if viewModel.projects.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "folder")
                            .font(.system(size: 60))
                            .foregroundColor(ColorManager.primaryText.opacity(0.5))
                        
                        Text("You haven't added any projects yet.")
                            .font(.ubuntu(18))
                            .foregroundColor(ColorManager.primaryText.opacity(0.7))
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.projects) { project in
                                ProjectRowView(project: project) {
                                    selectedProject = project
                                    showingProjectDetail = true
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(item: $selectedProject) { project in
            ProjectDetailView(projectId: project.id, viewModel: viewModel, isPresented: $showingProjectDetail)
        }
    }
}

struct ProjectRowView: View {
    let project: Project
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(project.name)
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Text(project.category)
                        .font(.ubuntu(14))
                        .foregroundColor(ColorManager.lightBlue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(ColorManager.lightBlue.opacity(0.2))
                        .cornerRadius(8)
                    
                    Text(DateFormatter.shortDate.string(from: project.startDate))
                        .font(.ubuntu(14))
                        .foregroundColor(ColorManager.primaryText.opacity(0.7))
                }
                
                Spacer()
                
                Button(action: onTap) {
                    Text("Open")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(ColorManager.orange)
                        .cornerRadius(8)
                }
            }
        }
        .padding(16)
        .background(ColorManager.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorManager.lightBlue.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    ProjectListView(viewModel: ProjectViewModel())
}
