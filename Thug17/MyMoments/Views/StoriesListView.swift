import SwiftUI

struct StoriesListView: View {
    @ObservedObject var viewModel: StoriesViewModel
    let sidebarToggleButton: AnyView
    @State private var showingAddStory = false
    @State private var showingSortMenu = false
    @State private var selectedStory: Story?
    @State private var showingStoryDetail = false
    @State private var editingStory: Story?
    
    init(viewModel: StoriesViewModel, sidebarToggleButton: some View) {
        self.viewModel = viewModel
        self.sidebarToggleButton = AnyView(sidebarToggleButton)
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.isSearching {
                    searchBar
                }
                
                if viewModel.filteredStories.isEmpty {
                    emptyStateView
                } else {
                    storiesListView
                }
            }
        }
        .sheet(isPresented: $showingAddStory) {
            StoryEditView(viewModel: viewModel, story: nil)
        }
        .sheet(item: $editingStory) { story in
            StoryEditView(viewModel: viewModel, story: story)
        }
        .sheet(item: $selectedStory) { story in
            StoryDetailView(storyId: story.id, viewModel: viewModel) {
                selectedStory = nil
            }
        }
        .actionSheet(isPresented: $showingSortMenu) {
            sortActionSheet
        }
    }
    
    private var headerView: some View {
        HStack {
            sidebarToggleButton
                .disabled(true)
                .opacity(0)
            
            Text("My Stories")
                .font(.screenTitle)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            HStack(spacing: 15) {
                Button(action: { showingAddStory = true }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.primaryBlue)
                }
                
                Button(action: {
                    withAnimation {
                        viewModel.isSearching.toggle()
                        if !viewModel.isSearching {
                            viewModel.searchText = ""
                        }
                    }
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.primaryBlue)
                }
                
                Button(action: { showingSortMenu = true }) {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.title2)
                        .foregroundColor(.primaryBlue)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.textSecondary)
            
            TextField("Enter text or tag...", text: $viewModel.searchText)
                .font(.bodyText)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !viewModel.searchText.isEmpty {
                Button(action: { viewModel.searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.textSecondary)
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(Color.cardBackground)
        .cornerRadius(10)
        .shadow(color: .shadowColor, radius: 2, x: 0, y: 1)
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
    
    private var storiesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredStories) { story in
                    StoryCardView(story: story) {
                        selectedStory = story
                        viewModel.incrementViewCount(for: story)
                    }
                    .contextMenu {
                        Button("Edit") {
                            editingStory = story
                        }
                        Button("Delete", role: .destructive) {
                            viewModel.deleteStory(story)
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("Delete", role: .destructive) {
                            viewModel.deleteStory(story)
                        }
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        Button("Edit") {
                            editingStory = story
                        }
                        .tint(.primaryBlue)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 30)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: viewModel.searchText.isEmpty ? "tray" : "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            
            Text(viewModel.searchText.isEmpty ? "You haven't added any stories yet" : "No stories found")
                .font(.cardTitle)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
            
            if viewModel.searchText.isEmpty {
                Button {
                    showingAddStory = true
                } label: {
                    Text("Add First Story")
                        .font(.buttonText)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .background(Color.primaryBlue)
                        .cornerRadius(20)
                }
            } else {
                Button("Clear Search") {
                    viewModel.searchText = ""
                }
                .font(.buttonText)
                .foregroundColor(.primaryBlue)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var sortActionSheet: ActionSheet {
        ActionSheet(
            title: Text("Sort Stories"),
            buttons: SortOption.allCases.map { option in
                .default(Text(option.displayName)) {
                    viewModel.setSortOption(option)
                }
            } + [.cancel()]
        )
    }
}

struct StoryCardView: View {
    let story: Story
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                Text(story.title)
                    .font(.cardTitle)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(story.preview)
                    .font(.bodyText)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(2)
                
                if !story.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(story.tags, id: \.self) { tag in
                                TagView(tag: tag, size: .small)
                            }
                        }
                        .padding(.horizontal, 15)
                    }
                    .padding(.horizontal, -15)
                }
                
                HStack {
                    Text(DateFormatter.shortDate.string(from: story.createdAt))
                        .font(.smallCaption)
                        .foregroundColor(.textSecondary)
                    
                    Spacer()
                    
                    if story.viewCount > 0 {
                        HStack(spacing: 4) {
                            Image(systemName: "eye")
                            Text("\(story.viewCount)")
                        }
                        .font(.smallCaption)
                        .foregroundColor(.textSecondary)
                    }
                }
            }
            .padding(16)
            .background(Color.cardBackground)
            .cornerRadius(12)
            .shadow(color: .shadowColor, radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}

#Preview {
    StoriesListView(
        viewModel: StoriesViewModel(),
        sidebarToggleButton: Button("Toggle") { }
    )
}
