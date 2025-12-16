import SwiftUI

struct TagsView: View {
    @StateObject private var viewModel = TagViewModel()
    @StateObject private var navigationState = NavigationState.shared
    @State private var showingAddTagAlert = false
    @State private var showingTagLengthError = false
    @State private var newTagName = ""
    @State private var tagToDelete: TagModel?
    @State private var showingDeleteAlert = false
    
    private let maxTagLength = 20
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                HStack {
                    Text("Tags")
                        .font(.builderSans(.bold, size: 28))
                        .foregroundColor(Color.app.textPrimary)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddTagAlert = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28, weight: .bold, design: .default))
                            .foregroundColor(Color.app.primaryPurple)
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                if viewModel.tags.isEmpty {
                    EmptyTagsView {
                        showingAddTagAlert = true
                    }
                    
                    Spacer()
                } else {
                    tagsList
                }
            }
        }
        .alert("Add New Tag", isPresented: $showingAddTagAlert) {
            TextField("Tag name (max \(maxTagLength) chars)", text: $newTagName)
                .onChange(of: newTagName) { newValue in
                    if newValue.count > maxTagLength {
                        newTagName = String(newValue.prefix(maxTagLength))
                        showingTagLengthError = true
                    }
                }
            Button("Add") {
                addNewTag()
            }
            .disabled(newTagName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            Button("Cancel", role: .cancel) {
                newTagName = ""
            }
        } message: {
            Text("Enter a name for the new tag (max \(maxTagLength) characters)")
        }
        .alert("Tag Name Too Long", isPresented: $showingTagLengthError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Tag name cannot exceed \(maxTagLength) characters")
        }
        .alert("Delete Tag", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let tag = tagToDelete {
                    deleteTag(tag)
                }
            }
            Button("Cancel", role: .cancel) {
                tagToDelete = nil
            }
        } message: {
            if let tag = tagToDelete {
                let dreamCount = viewModel.getDreamCount(for: tag)
                Text("Are you sure you want to delete '\(tag.name)'? This will remove it from \(dreamCount) dream(s).")
            }
        }
    }
    
    private var tagsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.tags, id: \.id) { tag in
                    TagRowView(tag: tag) {
                        navigationState.filterByTag(tag.name)
                    }
                    .swipeActions(edge: .trailing) {
                        Button("Delete", role: .destructive) {
                            tagToDelete = tag
                            showingDeleteAlert = true
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 100)
        }
    }
    
    private func addNewTag() {
        let trimmedName = newTagName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedName.count <= maxTagLength else {
            showingTagLengthError = true
            return
        }
        
        let success = viewModel.addTag(name: trimmedName)
        if success {
            newTagName = ""
        }
    }
    
    private func deleteTag(_ tag: TagModel) {
        viewModel.deleteTag(tag)
        tagToDelete = nil
    }
}

struct TagRowView: View {
    let tag: TagModel
    let onTap: () -> Void
    
    private var dreamCount: Int {
        DataManager.shared.getDreamCount(for: tag.name)
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Circle()
                    .fill(Color.app.primaryPurple.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "tag.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color.app.primaryPurple)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(tag.name.capitalized)
                        .font(.builderSans(.semiBold, size: 16))
                        .foregroundColor(Color.app.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Text("\(dreamCount) dream\(dreamCount == 1 ? "" : "s")")
                        .font(.builderSans(.regular, size: 14))
                        .foregroundColor(Color.app.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.app.textTertiary)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.app.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.app.cardBorder, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EmptyTagsView: View {
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "tag")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(Color.app.textTertiary)
            
            VStack(spacing: 8) {
                Text("No Tags Yet")
                    .font(.builderSans(.semiBold, size: 24))
                    .foregroundColor(Color.app.textPrimary)
                
                Text("Create tags to organize your dreams")
                    .font(.builderSans(.regular, size: 16))
                    .foregroundColor(Color.app.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: action) {
                Text("Create First Tag")
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

#Preview {
    TagsView()
}
