import SwiftUI

extension String: Identifiable {
    public var id: String { self }
}

struct TagsView: View {
    @ObservedObject var viewModel: StoriesViewModel
    let sidebarToggleButton: AnyView
    @State private var selectedTag: String?
    
    init(viewModel: StoriesViewModel, sidebarToggleButton: some View) {
        self.viewModel = viewModel
        self.sidebarToggleButton = AnyView(sidebarToggleButton)
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.sortedTags.isEmpty {
                    emptyStateView
                } else {
                    tagsListView
                }
            }
        }
        .sheet(item: $selectedTag) { tag in
            TagStoriesView(
                tag: tag, 
                viewModel: viewModel,
                onDismiss: {
                    selectedTag = nil
                },
                sidebarToggleButton: sidebarToggleButton
            )
        }
    }
    
    private var headerView: some View {
        HStack {
            sidebarToggleButton
                .disabled(true)
                .opacity(0)
            
            Text("Tags")
                .font(.screenTitle)
                .foregroundColor(.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
    }
    
    private var tagsListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.sortedTags, id: \.tag) { tagData in
                    TagCardView(tag: tagData.tag, count: tagData.count) {
                        selectedTag = tagData.tag
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
            
            Image(systemName: "tag")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            
            Text("You haven't added stories with tags yet")
                .font(.cardTitle)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct TagCardView: View {
    let tag: String
    let count: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 15) {
                Circle()
                    .fill(Color.tagColor(for: tag))
                    .frame(width: 12, height: 12)
                
                Text(tag)
                    .font(.cardTitle)
                    .foregroundColor(.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("\(count)")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.backgroundGray)
                    .cornerRadius(8)
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            .padding(16)
            .background(Color.cardBackground)
            .cornerRadius(12)
            .shadow(color: .shadowColor, radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TagStoriesView: View {
    let tag: String
    @ObservedObject var viewModel: StoriesViewModel
    let onDismiss: () -> Void
    let sidebarToggleButton: AnyView
    
    @State private var searchText: String = ""
    @State private var selectedStory: Story?
    @State private var showingStoryDetail = false
    @State private var editingStory: Story?
    
    init(tag: String, viewModel: StoriesViewModel, onDismiss: @escaping () -> Void, sidebarToggleButton: some View) {
        self.tag = tag
        self.viewModel = viewModel
        self.onDismiss = onDismiss
        self.sidebarToggleButton = AnyView(sidebarToggleButton)
    }
    
    private var tagStories: [Story] {
        let stories = viewModel.storiesWithTag(tag)
        if searchText.isEmpty {
            return viewModel.sortOption.sort(stories)
        } else {
            let filtered = stories.filter { story in
                story.title.localizedCaseInsensitiveContains(searchText) ||
                story.content.localizedCaseInsensitiveContains(searchText)
            }
            return viewModel.sortOption.sort(filtered)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    searchBar
                    
                    if tagStories.isEmpty {
                        emptyStateView
                    } else {
                        storiesListView
                    }
                }
            }
            .navigationTitle("Tag: \(tag)")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        onDismiss()
                    }
                    .foregroundColor(.primaryBlue)
                }
            }
        }
        .sheet(item: $editingStory) { story in
            StoryEditView(viewModel: viewModel, story: story)
        }
        .sheet(item: $selectedStory) { story in
            StoryDetailView(storyId: story.id, viewModel: viewModel) {
                selectedStory = nil
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.textSecondary)
            
            TextField("Search in \(tag) stories...", text: $searchText)
                .font(.bodyText)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
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
        .padding(.vertical, 10)
    }
    
    private var storiesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(tagStories) { story in
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
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: searchText.isEmpty ? "tray" : "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.textSecondary)
            
            Text(searchText.isEmpty ? "No stories with this tag" : "No stories found")
                .font(.cardTitle)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
            
            if !searchText.isEmpty {
                Button("Clear Search") {
                    searchText = ""
                }
                .font(.buttonText)
                .foregroundColor(.primaryBlue)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    TagsView(
        viewModel: StoriesViewModel(),
        sidebarToggleButton: Button("Toggle") { }
    )
}
