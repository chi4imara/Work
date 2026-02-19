import SwiftUI

struct EditProjectView: View {
    let project: Project
    @ObservedObject var viewModel: ProjectViewModel
    @Binding var isPresented: Bool
    
    @State private var projectName: String
    @State private var category: String
    @State private var startDate: Date
    @State private var comment: String
    @State private var result: String
    
    init(project: Project, viewModel: ProjectViewModel, isPresented: Binding<Bool>) {
        self.project = project
        self.viewModel = viewModel
        self._isPresented = isPresented
        
        self._projectName = State(initialValue: project.name)
        self._category = State(initialValue: project.category)
        self._startDate = State(initialValue: project.startDate)
        self._comment = State(initialValue: project.comment)
        self._result = State(initialValue: project.result)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.primaryBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        HStack {
                            Button("Cancel") {
                                isPresented = false
                            }
                            .font(.ubuntu(16))
                            .foregroundColor(ColorManager.lightBlue)
                            
                            Spacer()
                            
                            Text("Edit Project")
                                .font(.ubuntu(24, weight: .bold))
                                .foregroundColor(ColorManager.primaryText)
                            
                            Spacer()
                            
                            Text("Cancel")
                                .font(.ubuntu(16))
                                .foregroundColor(.clear)
                        }
                        .padding(.horizontal, 20)
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
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Result")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                TextField("Add project result here", text: $result, axis: .vertical)
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
                        
                        Button(action: saveChanges) {
                            Text("Save Changes")
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
    }
    
    private func saveChanges() {
        var updatedProject = project
        updatedProject.name = projectName
        updatedProject.category = category
        updatedProject.startDate = startDate
        updatedProject.comment = comment
        updatedProject.result = result
        
        viewModel.updateProject(updatedProject)
        isPresented = false
    }
}

#Preview {
    EditProjectView(
        project: Project(name: "Fix Compressor", category: "repair", startDate: Date(), comment: "Remove cover, replace belt"),
        viewModel: ProjectViewModel(),
        isPresented: .constant(true)
    )
}
