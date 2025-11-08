import SwiftUI

struct TagsManagementView: View {
    @ObservedObject private var viewModel = TagViewModel.shared
    @State private var showingRecipePreview = false
    @State private var selectedTag: Tag?
    
    private func addTestTag() {
        let testTagName = "TestTag_\(Date().timeIntervalSince1970)"
        viewModel.newTagName = testTagName
        viewModel.addTag()
        print("🧪 Added test tag: \(testTagName)")
    }
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Tags & Categories")
                        .font(AppFonts.titleLarge)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: { viewModel.presentAddTagAlert() }) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.trailing, 20)
                }
                .padding()
                
                searchSection
                
                if viewModel.isLoading {
                    loadingView
                } else if viewModel.isEmptyState {
                    emptyStateView
                } else if viewModel.noSearchResults {
                    noSearchResultsView
                } else {
                    tagListView
                }
            }
        }
        .sheet(item: $selectedTag) { tag in
            TagRecipePreviewView(tag: tag, viewModel: viewModel)
        }
            .alert("Add New Tag", isPresented: $viewModel.showingAddTagAlert) {
                TextField("Tag name", text: $viewModel.newTagName)
                    .onChange(of: viewModel.newTagName) { newValue in
                        if newValue.count > 24 {
                            viewModel.newTagName = String(newValue.prefix(24))
                        }
                    }
                Button("Add", action: viewModel.addTag)
                Button("Cancel", role: .cancel, action: viewModel.dismissAlerts)
            } message: {
                if let error = viewModel.errorMessage {
                    Text(error)
                } else {
                    Text("Enter a name for the new tag (max 24 characters)")
                }
            }
        .alert("Edit Tag", isPresented: $viewModel.showingEditTagAlert) {
            TextField("Tag name", text: $viewModel.newTagName)
                .onChange(of: viewModel.newTagName) { newValue in
                    if newValue.count > 24 {
                        viewModel.newTagName = String(newValue.prefix(24))
                    }
                }
            Button("Save", action: viewModel.updateTag)
            Button("Cancel", role: .cancel, action: viewModel.dismissAlerts)
        } message: {
            if let error = viewModel.errorMessage {
                Text(error)
            } else {
                Text("Edit the tag name (max 24 characters)")
            }
        }
        .alert("Delete Tag", isPresented: $viewModel.showingDeleteTagAlert) {
            Button("Delete", role: .destructive, action: viewModel.deleteTag)
            Button("Cancel", role: .cancel, action: viewModel.dismissAlerts)
        } message: {
            if let tag = viewModel.tagToDelete {
                let count = viewModel.getTagUsageCount(tag)
                Text("Are you sure you want to delete '#\(tag.name)'? This will remove it from \(count) recipe\(count == 1 ? "" : "s").")
            }
        }
    }

    
    private var searchSection: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondaryText)
            
            TextField("Search tags...", text: $viewModel.searchText)
                .font(AppFonts.bodyMedium)
                .foregroundColor(.white)
                .accentColor(.primaryPurple)
            
            if !viewModel.searchText.isEmpty {
                Button(action: { viewModel.searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondaryText)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.2))
        .cornerRadius(12)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
            
            Text("Loading tags...")
                .font(AppFonts.bodyMedium)
                .foregroundColor(.secondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "tag")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No Tags Yet")
                    .font(AppFonts.titleMedium)
                    .foregroundColor(.white)
                
                Text("Create tags to organize your recipes")
                    .font(AppFonts.bodyMedium)
                    .foregroundColor(.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { viewModel.presentAddTagAlert() }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add First Tag")
                }
                .font(AppFonts.buttonMedium)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.primaryPurple)
                .cornerRadius(12)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
    
    private var noSearchResultsView: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.white.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No Tags Found")
                    .font(AppFonts.titleMedium)
                    .foregroundColor(.white)
                
                Text("No tags match your search")
                    .font(AppFonts.bodyMedium)
                    .foregroundColor(.secondaryText)
            }
            
            Button(action: { viewModel.searchText = "" }) {
                Text("Clear Search")
                    .font(AppFonts.buttonMedium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.primaryPurple)
                    .cornerRadius(10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
    
    private var tagListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredTags) { tag in
                    TagRow(tag: tag, viewModel: viewModel) { action in
                        handleTagAction(action, for: tag)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private func handleTagAction(_ action: TagRowAction, for tag: Tag) {
        switch action {
        case .tap:
            selectedTag = tag
            showingRecipePreview = true
        case .edit:
            viewModel.presentEditTagAlert(for: tag)
        case .delete:
            viewModel.presentDeleteTagAlert(for: tag)
        }
    }
}

struct TagRow: View {
    let tag: Tag
    @ObservedObject var viewModel: TagViewModel
    let onAction: (TagRowAction) -> Void
    
    var body: some View {
        Button(action: { onAction(.tap) }) {
            HStack(spacing: 16) {
                HStack(spacing: 12) {
                    Image(systemName: "tag.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.primaryPurple)
                        .frame(width: 24)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("#\(tag.name)")
                            .font(AppFonts.bodyMedium)
                            .foregroundColor(.darkText)
                            .multilineTextAlignment(.leading)
                        
                        let count = viewModel.getTagUsageCount(tag)
                        Text("\(count) recipe\(count == 1 ? "" : "s")")
                            .font(AppFonts.bodySmall)
                            .foregroundColor(.darkGray)
                    }
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    Button(action: { onAction(.edit) }) {
                        Image(systemName: "pencil")
                            .font(.system(size: 14))
                            .foregroundColor(.primaryPurple)
                            .frame(width: 32, height: 32)
                            .background(Color.primaryPurple.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Button(action: { onAction(.delete) }) {
                        Image(systemName: "trash")
                            .font(.system(size: 14))
                            .foregroundColor(.errorRed)
                            .frame(width: 32, height: 32)
                            .background(Color.errorRed.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
            }
            .padding(16)
            .background(Color.cardBackground)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
    }
}

struct TagRecipePreviewView: View {
    let tag: Tag
    @ObservedObject var viewModel: TagViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var recipes: [Recipe] {
        viewModel.getRecipesWithTag(tag)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("#\(tag.name)")
                            .font(AppFonts.titleMedium)
                            .foregroundColor(.white)
                        
                        Text("\(recipes.count) recipe\(recipes.count == 1 ? "" : "s")")
                            .font(AppFonts.bodyMedium)
                            .foregroundColor(.secondaryText)
                    }
                    .padding(.horizontal, 20)
                    
                    if recipes.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "tray")
                                .font(.system(size: 40))
                                .foregroundColor(.white.opacity(0.6))
                            
                            Text("No recipes with this tag")
                                .font(AppFonts.bodyMedium)
                                .foregroundColor(.secondaryText)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(recipes) { recipe in
                                    RecipePreviewCard(recipe: recipe)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
            }
            .navigationTitle("Tag Preview")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .preferredColorScheme(.dark)
        }
    }
}

struct RecipePreviewCard: View {
    let recipe: Recipe
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(AppFonts.bodyMedium)
                    .foregroundColor(.darkText)
                    .multilineTextAlignment(.leading)
                
                Text(recipe.metadataString)
                    .font(AppFonts.bodySmall)
                    .foregroundColor(.darkGray)
            }
            
            Spacer()
            
            if recipe.isFavorite {
                Image(systemName: "heart.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.errorRed)
            }
        }
        .padding(12)
        .background(Color.cardBackground)
        .cornerRadius(10)
    }
}

enum TagRowAction {
    case tap
    case edit
    case delete
}

#Preview {
    TagsManagementView()
}
