import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = MakeupIdeaViewModel()
    
    var body: some View {
        TabView {
            IdeasView()
                .environmentObject(viewModel)
                .tabItem {
                    Image(systemName: "lightbulb")
                    Text("Ideas")
                }
                .tag(0)
            
            CategoriesView()
                .environmentObject(viewModel)
                .tabItem {
                    Image(systemName: "folder")
                    Text("Categories")
                }
                .tag(1)
            
            NotesView()
                .environmentObject(viewModel)
                .tabItem {
                    Image(systemName: "note.text")
                    Text("Notes")
                }
                .tag(2)
            
            StatisticsView()
                .environmentObject(viewModel)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Statistics")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(AppColors.tabBarSelected)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(AppColors.tabBarBackground)
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColors.tabBarSelected)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.tabBarSelected),
            .font: UIFont(name: "Ubuntu-Medium", size: 10) ?? UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.black)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.black),
            .font: UIFont(name: "Ubuntu-Regular", size: 10) ?? UIFont.systemFont(ofSize: 10, weight: .regular)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

enum EditMode: Identifiable {
    case new
    case edit(MakeupIdea)
    
    var id: String {
        switch self {
        case .new: return "new"
        case .edit(let idea): return idea.id.uuidString
        }
    }
}

struct IdeasView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: MakeupIdeaViewModel
    @State private var editMode: EditMode?
    @State private var ideaToView: MakeupIdea?
    
    var body: some View {
        ZStack {
            BackgroundGradient()
            
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    HStack {
                        Text("My Makeup Ideas")
                            .font(AppFonts.largeTitle)
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Button(action: {
                            editMode = .new
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(AppColors.primaryYellow)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(FilterType.allCases, id: \.self) { filter in
                                FilterButton(
                                    title: filter.rawValue,
                                    isSelected: viewModel.selectedFilter == filter
                                ) {
                                    viewModel.setFilter(filter)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                if viewModel.filteredIdeas.isEmpty {
                    EmptyStateView()
                } else {
                    IdeasListView(
                        ideas: viewModel.filteredIdeas,
                        onIdeaTapped: { idea in
                            ideaToView = idea
                        },
                        onEditTapped: { idea in
                            editMode = .edit(idea)
                        },
                        onDeleteIdea: { idea in
                            viewModel.deleteIdea(idea)
                        }
                    )
                }
            }
        }
        .sheet(item: $editMode) { mode in
            switch mode {
            case .new:
                AddEditIdeaView(ideaToEdit: nil) { idea in
                    viewModel.addIdea(idea)
                }
                .environmentObject(viewModel)
            case .edit(let idea):
                AddEditIdeaView(ideaToEdit: idea) { updatedIdea in
                    viewModel.updateIdea(updatedIdea)
                }
                .environmentObject(viewModel)
            }
        }
        .sheet(item: $ideaToView) { idea in
            IdeaDetailView(idea: idea) { updatedIdea in
                viewModel.updateIdea(updatedIdea)
            } onDelete: { ideaToDelete in
                viewModel.deleteIdea(ideaToDelete)
            } onEdit: { ideaToEdit in
                ideaToView = nil
                editMode = .edit(ideaToEdit)
            }
            .environmentObject(viewModel)
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
                .font(AppFonts.callout)
                .foregroundColor(isSelected ? AppColors.buttonText : AppColors.secondaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? AppColors.buttonBackground : AppColors.cardBackground)
                )
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "paintbrush.pointed")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.primaryYellow)
            
            Text("Your collection is empty")
                .font(AppFonts.title2)
                .foregroundColor(AppColors.primaryText)
            
            Text("Add your first idea to start inspiring yourself!")
                .font(AppFonts.body)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct IdeasListView: View {
    let ideas: [MakeupIdea]
    let onIdeaTapped: (MakeupIdea) -> Void
    let onEditTapped: (MakeupIdea) -> Void
    let onDeleteIdea: (MakeupIdea) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(ideas) { idea in
                    IdeaCardView(
                        idea: idea,
                        onTap: { onIdeaTapped(idea) },
                        onEdit: { onEditTapped(idea) },
                        onDelete: { onDeleteIdea(idea) }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
}

struct IdeaCardView: View {
    let idea: MakeupIdea
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(idea.title)
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        Text(idea.tag.displayName)
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.accentText)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppColors.primaryYellow.opacity(0.2))
                            )
                    }
                    
                    Text(idea.description)
                        .font(AppFonts.subheadline)
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    HStack {
                        Image(systemName: idea.tag.icon)
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.primaryYellow)
                        
                        Spacer()
                        
                        Button(action: onEdit) {
                            Image(systemName: "pencil")
                                .font(.system(size: 16))
                                .foregroundColor(AppColors.primaryYellow)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                Spacer()
            }
            .padding(16)
            .background(CardBackground())
        }
        .buttonStyle(PlainButtonStyle())
        .contextMenu {
            Button("Edit", action: onEdit)
            Button("Delete", role: .destructive) {
                showingDeleteAlert = true
            }
        }
        .alert("Delete Idea", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete this makeup idea?")
        }
    }
}
