import SwiftUI

struct IdeasView: View {
    @StateObject private var viewModel = IdeasViewModel()
    @State private var showingAddIdea = false
    @State private var selectedIdeaId: UUID?
    @State private var editingIdea: CraftIdea?
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                searchAndFiltersView
                
                if viewModel.filteredIdeas.isEmpty {
                    emptyStateView
                } else {
                    ideasListView
                }
            }
        }
        .sheet(isPresented: $showingAddIdea) {
            AddIdeaView(viewModel: viewModel)
        }
        .sheet(item: Binding(
            get: { selectedIdeaId.map { IdeaDetailItem(id: $0) } },
            set: { selectedIdeaId = $0?.id }
        )) { item in
            IdeaDetailView(ideaId: item.id, viewModel: viewModel)
        }
        .sheet(item: $editingIdea) { idea in
            EditIdeaView(idea: idea, viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("My Ideas")
                .font(.playfairDisplay(32, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            Spacer()
            
            Button(action: {
                showingAddIdea = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(Color.theme.primaryYellow)
                    .background(
                        Circle()
                            .fill(Color.theme.primaryText)
                            .frame(width: 32, height: 32)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchAndFiltersView: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.theme.secondaryText)
                
                TextField("Search by title or category...", text: $viewModel.searchText)
                    .font(.playfairDisplay(16))
                    .foregroundColor(Color.theme.primaryText)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color.theme.secondaryText)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.theme.cardBackground)
                    .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
            )
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(IdeaFilter.allCases, id: \.self) { filter in
                        FilterButton(
                            title: filter.displayName,
                            isSelected: viewModel.selectedFilter == filter
                        ) {
                            viewModel.selectedFilter = filter
                        }
                    }
                    
                    ForEach(CraftType.allCases, id: \.self) { craftType in
                        FilterButton(
                            title: craftType.displayName,
                            isSelected: viewModel.selectedCraftType == craftType
                        ) {
                            viewModel.selectedCraftType = viewModel.selectedCraftType == craftType ? nil : craftType
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 4)
            }
            .padding(.horizontal, -20)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 60))
                .foregroundColor(Color.theme.primaryPurple.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No ideas yet")
                    .font(.playfairDisplay(24, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
                
                Text("Add your first idea — maybe you just thought of a new project?")
                    .font(.playfairDisplay(16))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: {
                showingAddIdea = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("Add Idea")
                }
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(Color.theme.buttonText)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.theme.buttonBackground)
                        .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
                )
            }
            .padding(.bottom, 30)
            
            Spacer()
        }
    }
    
    private var ideasListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.filteredIdeas) { idea in
                    IdeaCardView(idea: idea) {
                        selectedIdeaId = idea.id
                    } onDelete: {
                        viewModel.deleteIdea(idea)
                    } onEdit: {
                        editingIdea = idea
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
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
                .font(.playfairDisplay(14, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? Color.theme.buttonText : Color.theme.secondaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.theme.buttonBackground : Color.theme.cardBackground)
                        .shadow(color: Color.theme.shadowColor, radius: isSelected ? 4 : 2, x: 0, y: 2)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct IdeaCardView: View {
    let idea: CraftIdea
    let onTap: () -> Void
    let onDelete: () -> Void
    let onEdit: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(idea.title)
                            .font(.playfairDisplay(20, weight: .bold))
                            .foregroundColor(Color.theme.primaryText)
                            .multilineTextAlignment(.leading)
                        
                        Text(idea.craftType.displayName)
                            .font(.playfairDisplay(14, weight: .medium))
                            .foregroundColor(Color.theme.primaryPurple)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.theme.lightPurple.opacity(0.3))
                            )
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(idea.status)
                            .font(.playfairDisplay(12, weight: .semibold))
                            .foregroundColor(idea.isCompleted ? Color.green : Color.theme.primaryBlue)
                        
                        if idea.totalStepsCount > 0 {
                            Text("\(idea.completedStepsCount)/\(idea.totalStepsCount) steps")
                                .font(.playfairDisplay(12))
                                .foregroundColor(Color.theme.secondaryText)
                        }
                    }
                }
                
                if !idea.description.isEmpty {
                    Text(idea.description)
                        .font(.playfairDisplay(14))
                        .foregroundColor(Color.theme.secondaryText)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                if idea.totalStepsCount > 0 {
                    ProgressView(value: idea.progressPercentage)
                        .progressViewStyle(LinearProgressViewStyle(tint: Color.theme.primaryYellow))
                        .background(Color.theme.lightBlue.opacity(0.3))
                        .cornerRadius(4)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.theme.cardBackground)
                    .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .contextMenu {
            Button(action: onEdit) {
                Label("Edit", systemImage: "pencil")
            }
            
            Button(action: onDelete) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

#Preview {
    IdeasView()
}
