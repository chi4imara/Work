import SwiftUI

struct IdeasView: View {
    @StateObject private var viewModel = ContentIdeasViewModel()
    @State private var showingCreateIdea = false
    @State private var selectedIdeaID: IdeaID?
    
    var body: some View {
        ZStack {
            Color.theme.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                searchBar
                
                filterBar
                
                if viewModel.filteredIdeas.isEmpty {
                    emptyStateView
                } else {
                    ideasList
                }
            }
        }
        .sheet(isPresented: $showingCreateIdea) {
            IdeaCreationView(viewModel: viewModel)
        }
        .sheet(item: $selectedIdeaID) { ideaID in
            IdeaDetailsView(ideaID: ideaID.id, viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Content Ideas")
                        .font(.playfairDisplay(28, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Text("All records by types and statuses")
                        .font(.playfairDisplay(14, weight: .regular))
                        .foregroundColor(Color.theme.secondaryText)
                }
                
                Spacer()
                
                Button(action: {
                    showingCreateIdea = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(
                            Circle()
                                .fill(Color.theme.purpleGradient)
                        )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.theme.secondaryText)
            
            TextField("Search by title or hashtag...", text: $viewModel.searchText)
                .font(.playfairDisplay(16))
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.theme.primaryWhite)
                .shadow(color: Color.theme.shadowColor, radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal, 20)
        .padding(.top, 15)
    }
    
    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(FilterType.allCases, id: \.self) { filter in
                    FilterButton(
                        title: filter.displayName,
                        isSelected: viewModel.selectedFilter == filter
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.selectedFilter = filter
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 15)
        .padding(.bottom, 8)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "lightbulb")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(Color.theme.secondaryText.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No ideas yet")
                    .font(.playfairDisplay(22, weight: .semibold))
                    .foregroundColor(Color.theme.primaryText)
                
                Text("Add your first idea — inspiration starts with one thought.")
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: {
                showingCreateIdea = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("New Idea")
                }
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.theme.purpleGradient)
                )
            }
            .padding(.top, 10)
            
            Spacer()
        }
    }
    
    private var ideasList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredIdeas) { idea in
                    IdeaCard(idea: idea) {
                        selectedIdeaID = IdeaID(id: idea.id)
                    } onEdit: {
                        selectedIdeaID = IdeaID(id: idea.id)
                    } onDelete: {
                        viewModel.deleteIdea(idea)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 15)
            .padding(.bottom, 100)
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
                .font(.playfairDisplay(14, weight: .medium))
                .foregroundColor(isSelected ? .white : Color.theme.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? AnyShapeStyle(Color.theme.purpleGradient) : AnyShapeStyle(Color.theme.primaryWhite))
                        .shadow(color: Color.theme.shadowColor, radius: isSelected ? 8 : 3, x: 0, y: 2)
                )
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct IdeaCard: View {
    let idea: ContentIdea
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                VStack {
                    Image(systemName: idea.contentType.icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(Color.theme.primaryBlue)
                        .frame(width: 50, height: 50)
                        .background(
                            Circle()
                                .fill(Color.theme.lightBlue.opacity(0.3))
                        )
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(idea.title)
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(Color.theme.primaryText)
                            .lineLimit(2)
                        
                        Spacer()
                        
                        Circle()
                            .fill(idea.status.color)
                            .frame(width: 12, height: 12)
                    }
                    
                    Text(idea.contentType.displayName)
                        .font(.playfairDisplay(14, weight: .medium))
                        .foregroundColor(Color.theme.accentText)
                    
                    if let publishDate = idea.publishDate {
                        Text(publishDate, style: .date)
                            .font(.playfairDisplay(12, weight: .regular))
                            .foregroundColor(Color.theme.secondaryText)
                    }
                    
                    Text(idea.status.displayName)
                        .font(.playfairDisplay(12, weight: .medium))
                        .foregroundColor(idea.status.color)
                    
                    Spacer()
                }
                
                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.theme.cardGradient)
                    .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button("Delete") {
                showingDeleteAlert = true
            }
            .tint(.red)
            
            Button("Edit") {
                onEdit()
            }
            .tint(Color.theme.primaryBlue)
        }
        .alert("Delete Idea", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete \"\(idea.title)\"?")
        }
    }
}

#Preview {
    IdeasView()
}
