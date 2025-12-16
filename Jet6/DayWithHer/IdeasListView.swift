import SwiftUI

struct IdeasListView: View {
    @StateObject private var viewModel = IdeaViewModel()
    @State private var showingAddIdea = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
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
            AddEditIdeaView(viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Shared Activities")
                    .font(.playfair(size: 28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Plan your moments together")
                    .font(.playfair(size: 16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            Button(action: {
                showingAddIdea = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(AppColors.blueText)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var searchAndFiltersView: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.secondaryText)
                
                TextField("Search by title or date...", text: $viewModel.searchText)
                    .font(.playfair(size: 16))
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
            .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 5, x: 0, y: 2)
            
            HStack(spacing: 12) {
                ForEach(FilterType.allCases, id: \.self) { filter in
                    Button(action: {
                        viewModel.selectedFilter = filter
                    }) {
                        Text(filter.rawValue)
                            .font(.playfair(size: 14, weight: .medium))
                            .foregroundColor(viewModel.selectedFilter == filter ? .white : AppColors.blueText)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                viewModel.selectedFilter == filter ?
                                AppColors.blueText : AppColors.cardBackground
                            )
                            .cornerRadius(20)
                    }
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    
    private var ideasListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredIdeas) { idea in
                    IdeaCardView(ideaId: idea.id, viewModel: viewModel)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "heart.circle")
                .font(.system(size: 80))
                .foregroundColor(AppColors.lightText)
            
            VStack(spacing: 12) {
                Text(viewModel.searchText.isEmpty && viewModel.selectedFilter == .all ?
                     "No ideas yet" : "No matching ideas")
                .font(.playfair(size: 24, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
                
                Text(viewModel.searchText.isEmpty && viewModel.selectedFilter == .all ?
                     "Add something you've always wanted to do together — a walk, photoshoot, or mini trip." :
                        "Try adjusting your search or filter.")
                .font(.playfair(size: 16))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
            }
            .padding(.horizontal, 40)
            
            if viewModel.searchText.isEmpty && viewModel.selectedFilter == .all {
                Button(action: {
                    showingAddIdea = true
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Idea")
                    }
                    .font(.playfair(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(AppColors.purpleGradient)
                    .cornerRadius(25)
                    .shadow(color: AppColors.primaryPurple.opacity(0.3), radius: 10, x: 0, y: 5)
                }
            }
            
            Spacer()
        }
    }
}

struct IdeaCardView: View {
    let ideaId: UUID
    @ObservedObject var viewModel: IdeaViewModel
    @State private var selectedIdeaId: UUID?
    
    private var idea: Idea? {
        viewModel.ideas.first { $0.id == ideaId }
    }
    
    var body: some View {
        Group {
            if let idea = idea {
                cardContent(for: idea)
            } else {
                EmptyView()
            }
        }
        .sheet(item: Binding(
            get: { selectedIdeaId.map { IdeaDetailItem(id: $0) } },
            set: { selectedIdeaId = $0?.id }
        )) { item in
            IdeaDetailView(ideaId: item.id, viewModel: viewModel)
        }
    }
    
    @ViewBuilder
    private func cardContent(for idea: Idea) -> some View {
        Button(action: {
            selectedIdeaId = idea.id
        }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(idea.title)
                            .font(.playfair(size: 18, weight: .semibold))
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.leading)
                        
                        HStack(spacing: 8) {
                            Image(systemName: idea.category.icon)
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.blueText)
                            
                            Text(idea.category.rawValue)
                                .font(.playfair(size: 12, weight: .medium))
                                .foregroundColor(AppColors.blueText)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack(spacing: 4) {
                            Image(systemName: idea.status.icon)
                                .font(.system(size: 12))
                                .foregroundColor(idea.status == .completed ? AppColors.mintGreen : AppColors.yellowAccent)
                            
                            Text(idea.status.rawValue)
                                .font(.playfair(size: 12, weight: .medium))
                                .foregroundColor(idea.status == .completed ? AppColors.mintGreen : AppColors.yellowAccent)
                        }
                        
                        Text(idea.shortDateString)
                            .font(.playfair(size: 11))
                            .foregroundColor(AppColors.lightText)
                    }
                }
                
                if !idea.description.isEmpty {
                    Text(idea.description)
                        .font(.playfair(size: 14))
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                HStack {
                    Button(action: {
                        viewModel.toggleIdeaStatus(idea)
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: idea.status == .planned ? "checkmark" : "arrow.counterclockwise")
                                .font(.system(size: 12))
                            Text(idea.status == .planned ? "Mark Done" : "Mark Planned")
                                .font(.playfair(size: 12, weight: .medium))
                        }
                        .foregroundColor(AppColors.blueText)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(AppColors.lightPurple)
                        .cornerRadius(15)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        selectedIdeaId = idea.id
                    }) {
                        Text("Open")
                            .font(.playfair(size: 12, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(AppColors.blueText)
                            .cornerRadius(15)
                    }
                }
            }
            .padding(16)
            .background(AppColors.cardGradient)
            .cornerRadius(16)
            .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    IdeasListView()
}
