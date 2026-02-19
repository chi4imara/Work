import SwiftUI

struct CategoryItem: Identifiable {
    let id = UUID()
    let name: String
}

struct CategoriesView: View {
    @ObservedObject var viewModel: ProjectViewModel
    @State private var selectedCategory: CategoryItem?
    @State private var selectedProject: Project?
    @State private var pendingProject: Project?
    
    var body: some View {
        ZStack {
            ColorManager.primaryBackground
                .ignoresSafeArea()
            
            VStack {
                Text("Categories")
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                    .padding(.vertical, 10)
                
                if viewModel.projects.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "tag")
                            .font(.system(size: 60))
                            .foregroundColor(ColorManager.primaryText.opacity(0.5))
                        
                        Text("Categories have not been created yet.")
                            .font(.ubuntu(18))
                            .foregroundColor(ColorManager.primaryText.opacity(0.7))
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.getCategoriesWithCount(), id: \.category) { categoryInfo in
                                CategoryRowView(
                                    category: categoryInfo.category,
                                    count: categoryInfo.count
                                ) {
                                    selectedCategory = CategoryItem(name: categoryInfo.category)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(item: $selectedCategory, onDismiss: {
            if let project = pendingProject {
                selectedProject = project
                pendingProject = nil
            }
        }) { categoryItem in
            CategoryProjectsView(
                category: categoryItem.name,
                projects: viewModel.getProjectsByCategory()[categoryItem.name] ?? [],
                onProjectSelected: { project in
                    pendingProject = project
                    selectedCategory = nil
                }
            )
        }
        .sheet(item: $selectedProject) { project in
            ProjectDetailView(projectId: project.id, viewModel: viewModel, isPresented: .constant(true))
        }
    }
}

struct CategoryRowView: View {
    let category: String
    let count: Int
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(category.capitalized)
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                
                Text("\(count) project\(count == 1 ? "" : "s")")
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
        .padding(16)
        .background(ColorManager.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorManager.lightBlue.opacity(0.2), lineWidth: 1)
        )
    }
}

struct CategoryProjectsView: View {
    let category: String
    let projects: [Project]
    let onProjectSelected: (Project) -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.primaryBackground
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Button("Close") {
                            dismiss()
                        }
                        .font(.ubuntu(16))
                        .foregroundColor(ColorManager.lightBlue)
                        
                        Spacer()
                        
                        Text(category.capitalized)
                            .font(.ubuntu(24, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Spacer()
                        
                        Text("Close")
                            .font(.ubuntu(16))
                            .foregroundColor(.clear)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(projects) { project in
                                CategoryProjectRowView(project: project) {
                                    onProjectSelected(project)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
    }
}

struct CategoryProjectRowView: View {
    let project: Project
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(project.name)
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                
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
    CategoriesView(viewModel: ProjectViewModel())
}
