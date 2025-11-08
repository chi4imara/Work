import SwiftUI

struct IdeasListView: View {
    @EnvironmentObject var ideaStore: IdeaStore
    @EnvironmentObject var appState: AppState
    @State private var showingFilters = false
    @State private var showingSearch = false
    @State private var selectedIdea: Idea?
    @State private var ideaToDelete: Idea?
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if showingSearch {
                        searchBar
                    }
                    
                    if ideaStore.filteredIdeas.isEmpty {
                        emptyStateView
                    } else {
                        ideasList
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(item: $selectedIdea) { idea in
                IdeaDetailView(idea: idea)
                    .environmentObject(ideaStore)
                    .environmentObject(appState)
            }
            .confirmationDialog("Filter & Sort", isPresented: $showingFilters) {
                Button("All Categories") {
                    ideaStore.selectedCategory = nil
                }
                Button("Work") {
                    ideaStore.selectedCategory = .work
                }
                Button("Hobby") {
                    ideaStore.selectedCategory = .hobby
                }
                Button("Travel") {
                    ideaStore.selectedCategory = .travel
                }
                Button("Family") {
                    ideaStore.selectedCategory = .family
                }
                Button("Other") {
                    ideaStore.selectedCategory = .other
                }
                Button("Sort by Date") {
                    ideaStore.sortOption = .dateCreated
                }
                Button("Sort Alphabetically") {
                    ideaStore.sortOption = .alphabetical
                }
                Button("Sort by Category") {
                    ideaStore.sortOption = .category
                }
                Button("Clear All Filters") {
                    ideaStore.clearFilters()
                }
                Button("Cancel", role: .cancel) { }
            }
            .alert("Delete Idea", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    if let idea = ideaToDelete {
                        ideaStore.deleteIdea(idea)
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to delete this idea? This action cannot be undone.")
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("My Ideas")
                    .font(.nunito(.bold, size: 28))
                    .foregroundColor(AppColors.primaryText)
                
                if !ideaStore.filteredIdeas.isEmpty {
                    Text("\(ideaStore.filteredIdeas.count) ideas")
                        .font(.nunito(.medium, size: 14))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showingSearch.toggle()
                    }
                    if !showingSearch {
                        ideaStore.searchText = ""
                    }
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .frame(width: 44, height: 44)
                        .background(AppColors.elementBackground)
                        .clipShape(Circle())
                }
                
                Button(action: { showingFilters = true }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .frame(width: 44, height: 44)
                        .background(AppColors.elementBackground)
                        .clipShape(Circle())
                }
                
                Button(action: { appState.addNewIdea() }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(AppColors.primaryBlue)
                        .frame(width: 44, height: 44)
                        .background(Color.white)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 16)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.secondaryText)
            
            TextField("Search ideas and tags...", text: $ideaStore.searchText)
                .font(.nunito(.regular, size: 16))
                .foregroundColor(AppColors.primaryText)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !ideaStore.searchText.isEmpty {
                Button(action: {
                    ideaStore.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColors.secondaryText)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(AppColors.elementBackground)
        .cornerRadius(12)
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
    
    private var ideasList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(ideaStore.filteredIdeas) { idea in
                    IdeaCardView(
                        idea: idea,
                        onTap: { selectedIdea = idea },
                        onEdit: { 
                            appState.editIdea(idea)
                        },
                        onDelete: { 
                            ideaToDelete = idea
                            showingDeleteAlert = true 
                        },
                        onToggleFavorite: { ideaStore.toggleFavorite(idea) }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "lightbulb")
                .font(.system(size: 80, weight: .thin))
                .foregroundColor(AppColors.primaryText.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No Ideas Yet")
                    .font(.nunito(.bold, size: 24))
                    .foregroundColor(AppColors.primaryText)
                
                Text("You haven't added any ideas yet")
                    .font(.nunito(.regular, size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { appState.addNewIdea() }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Your First Idea")
                }
                .font(.nunito(.semiBold, size: 18))
                .foregroundColor(AppColors.primaryBlue)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.white)
                .cornerRadius(12)
            }
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
}

struct IdeasListView_Previews: PreviewProvider {
    static var previews: some View {
        IdeasListView()
            .environmentObject(IdeaStore())
            .environmentObject(AppState())
    }
}
