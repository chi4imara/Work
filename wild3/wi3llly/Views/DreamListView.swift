import SwiftUI

struct DreamIdentifier: Identifiable {
    let id: UUID
}

struct DreamListView: View {
    @StateObject private var viewModel = DreamViewModel()
    @StateObject private var navigationState = NavigationState.shared
    @State private var showingAddDream = false
    @State private var showingDreamDetail: DreamIdentifier?
    @State private var showingEditDream: DreamIdentifier?
    
    @Binding var selectedTab: TabItem
    
    init(selectedTab: Binding<TabItem>) {
        self._selectedTab = selectedTab
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                HStack {
                    Text("My Dreams")
                        .font(.builderSans(.bold, size: 28))
                        .foregroundColor(Color.app.textPrimary)
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        if let activeTag = navigationState.selectedTagForFilter {
                            HStack(spacing: 8) {
                                TagBadge(text: activeTag, color: Color.yellow)
                                
                                Button(action: {
                                    clearTagFilter()
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(Color.app.textTertiary)
                                }
                            }
                        }
                        
                        Button(action: {
                            viewModel.showingFilterSheet = true
                        }) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .font(.system(size: 28, weight: .bold, design: .default))
                                .foregroundColor(Color.app.textPrimary)
                        }
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                if viewModel.filteredDreams.isEmpty && viewModel.dreams.isEmpty {
                    EmptyStateView {
                        withAnimation {
                            selectedTab = .addDream
                        }
                    }
                    
                    Spacer()
                } else if viewModel.filteredDreams.isEmpty {
                    NoResultsView {
                        viewModel.clearFilters()
                    }
                    
                    Spacer()
                } else {
                    dreamsList
                }
            }
        }
        .sheet(isPresented: $showingAddDream) {
            AddEditDreamView()
        }
        .sheet(item: $showingDreamDetail) { identifier in
            DreamDetailView(dreamId: identifier.id)
        }
        .sheet(item: $showingEditDream) { identifier in
            AddEditDreamView(dreamToEditId: identifier.id)
        }
        .sheet(isPresented: $viewModel.showingFilterSheet) {
            FilterSheet(viewModel: viewModel)
        }
        .onAppear {
            applyTagFilterIfNeeded()
            viewModel.applyFiltersAndSort()
        }
        .onChange(of: navigationState.selectedTagForFilter) { _ in
            applyTagFilterIfNeeded()
            viewModel.applyFiltersAndSort()
        }
    }
    
    private func applyTagFilterIfNeeded() {
        if let tag = navigationState.selectedTagForFilter {
            viewModel.selectedTags = [tag]
        }
    }
    
    private func clearTagFilter() {
        navigationState.clearFilter()
        viewModel.selectedTags.removeAll()
        viewModel.applyFiltersAndSort()
    }
    
    private var dreamsList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.filteredDreams, id: \.id) { dream in
                    DreamCard(dream: dream)
                        .onTapGesture {
                            showingDreamDetail = DreamIdentifier(id: dream.id)
                        }
                        .swipeActions(edge: .trailing) {
                            Button("Delete", role: .destructive) {
                                viewModel.deleteDream(dream)
                            }
                        }
                        .swipeActions(edge: .leading) {
                            Button("Edit") {
                                showingEditDream = DreamIdentifier(id: dream.id)
                            }
                            .tint(Color.app.primaryPurple)
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 100)
        }
    }
}

struct DreamCard: View {
    let dream: DreamModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(dream.title)
                    .font(.builderSans(.semiBold, size: 18))
                    .foregroundColor(Color.app.textPrimary)
                    .lineLimit(2)
                
                Spacer()
                
                Text(dream.createdAt, style: .date)
                    .font(.builderSans(.regular, size: 12))
                    .foregroundColor(Color.app.textTertiary)
            }
            
            if !dream.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(dream.tags, id: \.self) { tag in
                            TagBadge(text: tag, color: Color.yellow)
                        }
                    }
                    .padding(.horizontal, 2)
                }
            }
            
            Text(dream.content)
                .font(.builderSans(.regular, size: 14))
                .foregroundColor(Color.app.textSecondary)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
            
            HStack {
                Spacer()
                Text(dream.createdAt, style: .time)
                    .font(.builderSans(.light, size: 11))
                    .foregroundColor(Color.app.textTertiary)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.app.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.app.cardBorder, lineWidth: 1)
                )
        )
    }
}

struct TagBadge: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.builderSans(.medium, size: 12))
            .foregroundColor(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
            )
    }
}

struct EmptyStateView: View {
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "moon.stars")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(Color.app.textTertiary)
            
            VStack(spacing: 8) {
                Text("No Dreams Yet")
                    .font(.builderSans(.semiBold, size: 24))
                    .foregroundColor(Color.app.textPrimary)
                
                Text("Start capturing your unusual dreams")
                    .font(.builderSans(.regular, size: 16))
                    .foregroundColor(Color.app.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: action) {
                Text("Record First Dream")
                    .font(.builderSans(.semiBold, size: 16))
                    .foregroundColor(Color.app.buttonText)
                    .frame(width: 200, height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.app.buttonBackground)
                    )
            }
            
            Spacer()
        }
        .padding(32)
    }
}

struct NoResultsView: View {
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(Color.app.textTertiary)
            
            VStack(spacing: 8) {
                Text("No Matches Found")
                    .font(.builderSans(.semiBold, size: 24))
                    .foregroundColor(Color.app.textPrimary)
                
                Text("Try adjusting your filters")
                    .font(.builderSans(.regular, size: 16))
                    .foregroundColor(Color.app.textSecondary)
            }
            
            Button(action: action) {
                Text("Clear Filters")
                    .font(.builderSans(.semiBold, size: 16))
                    .foregroundColor(Color.app.buttonText)
                    .frame(width: 160, height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.app.buttonBackground)
                    )
            }
            
            Spacer()
        }
        .padding(32)
    }
}

struct FilterSheet: View {
    @ObservedObject var viewModel: DreamViewModel
    @StateObject private var navigationState = NavigationState.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Sort By")
                            .font(.builderSans(.semiBold, size: 18))
                            .foregroundColor(Color.app.textPrimary)
                        
                        ForEach(DreamSortOption.allCases, id: \.self) { option in
                            Button(action: {
                                viewModel.sortOption = option
                                viewModel.applyFiltersAndSort()
                            }) {
                                HStack {
                                    Text(option.rawValue)
                                        .font(.builderSans(.regular, size: 16))
                                        .foregroundColor(Color.app.textPrimary)
                                    
                                    Spacer()
                                    
                                    if viewModel.sortOption == option {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(Color.app.primaryPurple)
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                    
                    Divider()
                        .background(Color.app.cardBorder)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Filter by Tags")
                            .font(.builderSans(.semiBold, size: 18))
                            .foregroundColor(Color.app.textPrimary)
                        
                        let allTags = viewModel.getAllTags()
                        
                        if allTags.isEmpty {
                            Text("No tags available")
                                .font(.builderSans(.regular, size: 14))
                                .foregroundColor(Color.app.textTertiary)
                        } else {
                            LazyVGrid(columns: [
                                GridItem(.adaptive(minimum: 100))
                            ], spacing: 8) {
                                ForEach(allTags, id: \.self) { tag in
                                    Button(action: {
                                        if viewModel.selectedTags.contains(tag) {
                                            viewModel.selectedTags.remove(tag)
                                        } else {
                                            viewModel.selectedTags.insert(tag)
                                        }
                                        viewModel.applyFiltersAndSort()
                                    }) {
                                        TagBadge(
                                            text: tag,
                                            color: viewModel.selectedTags.contains(tag) ? Color.yellow : Color.app.textSecondary
                                        )
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    if !viewModel.selectedTags.isEmpty {
                        Button(action: {
                            viewModel.clearFilters()
                            navigationState.clearFilter()
                        }) {
                            Text("Clear All Filters")
                                .font(.builderSans(.semiBold, size: 16))
                                .foregroundColor(Color.app.accentPink)
                                .frame(maxWidth: .infinity, minHeight: 48)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.app.accentPink, lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(20)
                .navigationTitle("Filters & Sort")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                        .foregroundColor(Color.app.primaryPurple)
                    }
                }
                .preferredColorScheme(.dark)
            }
        }
    }
}
