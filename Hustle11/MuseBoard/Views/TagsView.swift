import SwiftUI

struct TagsView: View {
    @EnvironmentObject var ideaStore: IdeaStore
    @State private var showingAddTag = false
    @State private var newTagName = ""
    @State private var selectedColor = AppColors.tagColors.first ?? .blue
    @State private var tagToDelete: Tag?
    @State private var showingDeleteAlert = false
    @State private var selectedTag: Tag?
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                    
                    if ideaStore.tags.isEmpty {
                        emptyStateView
                    } else {
                        tagsList
                    }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddTag) {
                addTagSheet
            }
            .alert("Delete Tag", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    if let tag = tagToDelete {
                        ideaStore.deleteTag(tag)
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                if let tag = tagToDelete {
                    let usageCount = ideaStore.getTagUsageCount(tag)
                    if usageCount > 0 {
                        Text("This tag is used in \(usageCount) idea(s). Deleting it will remove the tag from all ideas. This action cannot be undone.")
                    } else {
                        Text("Are you sure you want to delete this tag? This action cannot be undone.")
                    }
                }
            }
            .sheet(item: $selectedTag) { tag in
                TagDetailView(tag: tag)
                    .environmentObject(ideaStore)
            }
            .onChange(of: ideaStore.tags) { _ in
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Tags")
                    .font(.nunito(.bold, size: 28))
                    .foregroundColor(AppColors.primaryText)
                
                if !ideaStore.tags.isEmpty {
                    Text("\(ideaStore.tags.count) tags")
                        .font(.nunito(.medium, size: 14))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            
            Spacer()
            
            Button(action: { showingAddTag = true }) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(AppColors.primaryBlue)
                    .frame(width: 44, height: 44)
                    .background(Color.white)
                    .clipShape(Circle())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 16)
    }
    
    private var tagsList: some View {
        ScrollView {
            headerView
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(ideaStore.tags, id: \.id) { tag in
                    TagCard(
                        tag: tag,
                        usageCount: ideaStore.getTagUsageCount(tag),
                        onTap: {
                            selectedTag = tag
                        },
                        onDelete: {
                            tagToDelete = tag
                            showingDeleteAlert = true
                        }
                    )
                    .id("\(tag.id)-\(ideaStore.getTagUsageCount(tag))")
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            headerView
            
            Spacer()
            
            AnimatedTagIcon()
            
            VStack(spacing: 8) {
                Text("No Tags Yet")
                    .font(.nunito(.bold, size: 24))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Create tags to organize your ideas")
                    .font(.nunito(.regular, size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingAddTag = true }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Create Your First Tag")
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
    }
    
    private var addTagSheet: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 24) {
                    HStack {
                        Button("Cancel") {
                            showingAddTag = false
                            resetForm()
                        }
                        .font(.nunito(.medium, size: 16))
                        .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Text("New Tag")
                            .font(.nunito(.bold, size: 17))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Button("Create") {
                            createTag()
                        }
                        .font(.nunito(.semiBold, size: 16))
                        .foregroundColor(canCreateTag ? AppColors.primaryText : AppColors.primaryText.opacity(0.5))
                        .disabled(!canCreateTag)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tag Name")
                            .font(.nunito(.semiBold, size: 16))
                            .foregroundColor(AppColors.primaryText)
                        
                        TextField("Enter tag name...", text: $newTagName)
                            .font(.nunito(.regular, size: 16))
                            .foregroundColor(AppColors.primaryText)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(AppColors.elementBackground)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppColors.elementBorder, lineWidth: 1)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Color")
                            .font(.nunito(.semiBold, size: 16))
                            .foregroundColor(AppColors.primaryText)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 12) {
                            ForEach(AppColors.tagColors, id: \.self) { color in
                                Button(action: {
                                    selectedColor = color
                                }) {
                                    Circle()
                                        .fill(color)
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white, lineWidth: selectedColor == color ? 3 : 0)
                                        )
                                        .overlay(
                                            Circle()
                                                .stroke(AppColors.elementBorder, lineWidth: 1)
                                        )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Preview")
                            .font(.nunito(.semiBold, size: 16))
                            .foregroundColor(AppColors.primaryText)
                        
                        HStack {
                            Text(newTagName.isEmpty ? "Tag Preview" : newTagName)
                                .font(.nunito(.medium, size: 14))
                                .foregroundColor(AppColors.primaryText)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(selectedColor.opacity(0.3))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(selectedColor.opacity(0.5), lineWidth: 1)
                                        )
                                )
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationBarHidden(true)
        }
    }
    
    private var canCreateTag: Bool {
        let trimmedName = newTagName.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedName.isEmpty && !ideaStore.tags.contains { $0.name.lowercased() == trimmedName.lowercased() }
    }
    
    private func createTag() {
        let trimmedName = newTagName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        let newTag = Tag(name: trimmedName, color: selectedColor.toHex())
        ideaStore.addTag(newTag)
        
        showingAddTag = false
        resetForm()
    }
    
    private func resetForm() {
        newTagName = ""
        selectedColor = AppColors.tagColors.first ?? .blue
    }
}

struct TagCard: View {
    let tag: Tag
    let usageCount: Int
    let onTap: () -> Void
    let onDelete: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Circle()
                        .fill(Color(hex: tag.color))
                        .frame(width: 12, height: 12)
                    
                    Text(tag.name)
                        .font(.nunito(.semiBold, size: 16))
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if usageCount == 0 {
                        Button(action: onDelete) {
                            Image(systemName: "trash")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(AppColors.error.opacity(0.8))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                HStack {
                    Image(systemName: "lightbulb")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text("\(usageCount) idea\(usageCount == 1 ? "" : "s")")
                        .font(.nunito(.medium, size: 12))
                        .foregroundColor(AppColors.secondaryText)
                    
                    Spacer()
                    
                    if usageCount > 0 {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppColors.tertiaryText)
                    }
                }
                
                Spacer()
            }
            .padding(16)
            .frame(height: 80)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(hex: tag.color).opacity(0.3), lineWidth: 1)
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AnimatedTagIcon: View {
    @State private var isAnimating = false
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            Image(systemName: "tag.fill")
                .font(.system(size: 80, weight: .thin))
                .foregroundColor(AppColors.primaryText.opacity(0.2))
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .blur(radius: 8)
            
            Image(systemName: "tag.fill")
                .font(.system(size: 80, weight: .thin))
                .foregroundColor(AppColors.primaryText.opacity(0.6))
                .rotationEffect(.degrees(rotationAngle))
        }
        .onAppear {
            withAnimation(
                .easeInOut(duration: 2)
                .repeatForever(autoreverses: true)
            ) {
                isAnimating = true
            }
            
            withAnimation(
                .linear(duration: 8)
                .repeatForever(autoreverses: false)
            ) {
                rotationAngle = 360
            }
        }
    }
}

struct TagsView_Previews: PreviewProvider {
    static var previews: some View {
        let store = IdeaStore()
        
      
        
        return TagsView()
            .environmentObject(store)
    }
}
