import SwiftUI

struct ProjectDetailView: View {
    @Environment(\.dismiss) var dismiss
    let projectId: UUID
    @ObservedObject var viewModel: ProjectViewModel
    @Binding var isPresented: Bool
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var project: Project? {
        viewModel.getProject(by: projectId)
    }
    
    var body: some View {
        Group {
            if let project = project {
                projectDetailContent(currentProject: project)
            } else {
                ColorManager.primaryBackground
                    .ignoresSafeArea()
            }
        }
    }
    
    @ViewBuilder
    private func projectDetailContent(currentProject: Project) -> some View {
        NavigationView {
            ZStack {
                ColorManager.primaryBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        HStack {
                            Button("Close") {
                                dismiss()
                            }
                            .font(.ubuntu(16))
                            .foregroundColor(ColorManager.lightBlue)
                            
                            Spacer()
                            
                            Text(currentProject.name)
                                .font(.ubuntu(24, weight: .bold))
                                .foregroundColor(ColorManager.primaryText)
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                            
                            Text("Close")
                                .font(.ubuntu(16))
                                .foregroundColor(.clear)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        VStack(spacing: 20) {
                            ProjectDetailRow(title: "Category", value: currentProject.category)
                            ProjectDetailRow(title: "Start Date", value: DateFormatter.shortDate.string(from: currentProject.startDate))
                            ProjectDetailRow(title: "Comment", value: currentProject.comment.isEmpty ? "Comment not added." : currentProject.comment)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Result")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                Text(currentProject.result.isEmpty ? "Result not added." : currentProject.result)
                                    .font(.ubuntu(16))
                                    .foregroundColor(currentProject.result.isEmpty ? ColorManager.primaryText.opacity(0.6) : ColorManager.primaryText)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(ColorManager.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(ColorManager.lightBlue.opacity(0.2), lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 16) {
                            Button(action: {
                                showingEditView = true
                            }) {
                                Text("Edit")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(ColorManager.primaryButton)
                                    .cornerRadius(16)
                            }
                            
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                Text("Delete Project")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(ColorManager.destructiveButton)
                                    .cornerRadius(16)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .sheet(isPresented: $showingEditView) {
                if let projectToEdit = self.project {
                    EditProjectView(project: projectToEdit, viewModel: viewModel, isPresented: $showingEditView)
                }
            }
            .alert("Delete Project", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    if let projectToDelete = self.project {
                        viewModel.deleteProject(projectToDelete)
                        dismiss()
                    }
                }
            } message: {
                Text("Are you sure you want to delete this project? This action cannot be undone.")
            }
        }
    }
}

struct ProjectDetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(ColorManager.primaryText.opacity(0.7))
            
            Text(value)
                .font(.ubuntu(16))
                .foregroundColor(ColorManager.primaryText)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(ColorManager.cardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(ColorManager.lightBlue.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

#Preview {
    let viewModel = ProjectViewModel()
    let project = Project(name: "Fix Compressor", category: "repair", startDate: Date(), comment: "Remove cover, replace belt", result: "Belt replaced, noise eliminated")
    viewModel.addProject(project)
    return ProjectDetailView(
        projectId: project.id,
        viewModel: viewModel,
        isPresented: .constant(true)
    )
}
