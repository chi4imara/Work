import SwiftUI

struct NewProjectView: View {
    @ObservedObject var viewModel: ProjectViewModel
    @State private var projectName = ""
    @State private var category = ""
    @State private var startDate = Date()
    @State private var comment = ""
    @State private var showingProjectSaved = false
    @State private var savedProject: Project?
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.primaryBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        Text("New Project")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                            .padding(.top, 20)
                        
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Project Name")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                TextField("Enter project name", text: $projectName)
                                    .font(.ubuntu(16))
                                    .foregroundColor(ColorManager.primaryText)
                                    .padding()
                                    .background(ColorManager.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Category")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                TextField("repair, painting, upgrade", text: $category)
                                    .font(.ubuntu(16))
                                    .foregroundColor(ColorManager.primaryText)
                                    .padding()
                                    .background(ColorManager.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Start Date")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                DatePicker("", selection: $startDate, displayedComponents: .date)
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .colorScheme(.dark)
                                    .padding()
                                    .background(ColorManager.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Comment")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                TextField("Add your comment here", text: $comment, axis: .vertical)
                                    .font(.ubuntu(16))
                                    .foregroundColor(ColorManager.primaryText)
                                    .padding()
                                    .background(ColorManager.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
                                    )
                                    .frame(minHeight: 80)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Button(action: saveProject) {
                            Text("Save")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [ColorManager.lightBlue, ColorManager.orange]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(16)
                                .shadow(color: ColorManager.lightBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .disabled(projectName.isEmpty || category.isEmpty)
                        .opacity(projectName.isEmpty || category.isEmpty ? 0.6 : 1.0)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
        }
        .sheet(isPresented: $showingProjectSaved) {
            if let project = savedProject {
                ProjectSavedView(project: project, isPresented: $showingProjectSaved) {
                    clearForm()
                }
            }
        }
    }
    
    private func saveProject() {
        let project = Project(
            name: projectName,
            category: category,
            startDate: startDate,
            comment: comment
        )
        
        viewModel.addProject(project)
        savedProject = project
        showingProjectSaved = true
    }
    
    private func clearForm() {
        projectName = ""
        category = ""
        startDate = Date()
        comment = ""
    }
}

#Preview {
    NewProjectView(viewModel: ProjectViewModel())
}
