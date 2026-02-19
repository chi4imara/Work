import SwiftUI

struct NewProjectView: View {
    @ObservedObject var viewModel: ProjectsViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var projectName = ""
    @State private var selectedDate = Date()
    @State private var selectedCategory = ProjectCategory.home
    @State private var toolsText = ""
    @State private var materialsText = ""
    @State private var description = ""
    
    var body: some View {
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
                                .padding(.horizontal, 20)
                            }
                            .padding(.horizontal, -20)
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
            .navigationTitle("New Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorManager.secondaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProject()
                    }
                    .foregroundColor(ColorManager.accentOrange)
                    .disabled(projectName.isEmpty)
                }
            }
        }
    }
    
    private func saveProject() {
        let tools = toolsText.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        let materials = materialsText.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        
        let project = Project(
            name: projectName,
            date: selectedDate,
            category: selectedCategory,
            tools: tools,
            materials: materials,
            description: description
        )
        
        viewModel.addProject(project)
        dismiss()
    }
}

struct CategoryButton: View {
    let category: ProjectCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(category.displayName)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(isSelected ? ColorManager.primaryText : ColorManager.secondaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? (ColorManager.categoryColors[category.rawValue] ?? ColorManager.accentBlue) : ColorManager.cardBackground)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var isMultiline: Bool = false
    var minHeight: CGFloat = 50
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(ColorManager.primaryText)
            
            if isMultiline {
                TextEditor(text: $text)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.primaryText)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: minHeight)
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(ColorManager.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(ColorManager.separatorColor, lineWidth: 1)
                            )
                    )
            } else {
                TextField(placeholder, text: $text)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.primaryText)
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
        }
    }
}

#Preview {
    NewProjectView(viewModel: ProjectsViewModel())
}
