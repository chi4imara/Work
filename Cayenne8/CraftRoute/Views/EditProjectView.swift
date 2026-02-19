import SwiftUI

struct EditProjectView: View {
    let projectId: UUID
    @ObservedObject var viewModel: ProjectsViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var projectName: String = ""
    @State private var selectedDate: Date = Date()
    @State private var selectedCategory: ProjectCategory = .home
    @State private var toolsText: String = ""
    @State private var materialsText: String = ""
    @State private var description: String = ""
    
    private var project: Project? {
        viewModel.getProject(by: projectId)
    }
    
    init(projectId: UUID, viewModel: ProjectsViewModel) {
        self.projectId = projectId
        self.viewModel = viewModel
    }
    
    var body: some View {
        Group {
            if let project = project {
                editProjectContent(project: project)
            } else {
                ZStack {
                    ColorManager.primaryGradient.ignoresSafeArea()
                    Text("Project not found")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(ColorManager.primaryText)
                }
            }
        }
        .onAppear {
            loadProjectData()
        }
    }
    
    private func loadProjectData() {
        guard let project = project else { return }
        guard projectName.isEmpty else { return }
        
        projectName = project.name
        selectedDate = project.date
        selectedCategory = project.category
        toolsText = project.tools.joined(separator: ", ")
        materialsText = project.materials.joined(separator: ", ")
        description = project.description
    }
    
    @ViewBuilder
    private func editProjectContent(project: Project) -> some View {
        NavigationView {
            ZStack {
                ColorManager.primaryGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        FormField(
                            title: "Project Name",
                            text: $projectName,
                            placeholder: "Enter project name"
                        )
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Completion Date")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorManager.primaryText)
                            
                            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .colorScheme(.dark)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(ColorManager.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(ColorManager.separatorColor, lineWidth: 1)
                                        )
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorManager.primaryText)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(ProjectCategory.allCases, id: \.self) { category in
                                        CategoryButton(
                                            category: category,
                                            isSelected: selectedCategory == category,
                                            action: { selectedCategory = category }
                                        )
                                    }
                                }
                                .padding(.horizontal, 4)
                            }
                        }
                        
                        FormField(
                            title: "Tools Used",
                            text: $toolsText,
                            placeholder: "Hammer, Screwdriver, Drill...",
                            isMultiline: true
                        )
                        
                        FormField(
                            title: "Materials Used",
                            text: $materialsText,
                            placeholder: "Screws, Wood, Paint...",
                            isMultiline: true
                        )
                        
                        FormField(
                            title: "Project Description",
                            text: $description,
                            placeholder: "Describe what you did...",
                            isMultiline: true,
                            minHeight: 100
                        )
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Edit Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorManager.secondaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save Changes") {
                        saveChanges()
                    }
                    .foregroundColor(ColorManager.accentOrange)
                    .disabled(projectName.isEmpty)
                }
            }
        }
    }
    
    private func saveChanges() {
        guard var project = project else { return }
        
        let tools = toolsText.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        let materials = materialsText.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        
        project.update(
            name: projectName,
            date: selectedDate,
            category: selectedCategory,
            tools: tools,
            materials: materials,
            description: description
        )
        
        viewModel.updateProject(project)
        dismiss()
    }
}

#Preview {
    let viewModel = ProjectsViewModel()
    let project = Project(
        name: "Door Hinge Replacement",
        date: Date(),
        category: .home,
        tools: ["Screwdriver", "Drill"],
        materials: ["Hinges", "Screws"],
        description: "Replaced old door hinges"
    )
    viewModel.addProject(project)
    
    return EditProjectView(
        projectId: project.id,
        viewModel: viewModel
    )
}
