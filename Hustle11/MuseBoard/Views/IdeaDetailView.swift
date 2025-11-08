import SwiftUI

struct IdeaDetailView: View {
    @EnvironmentObject var ideaStore: IdeaStore
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    
    let idea: Idea
    @State private var showingDeleteAlert = false
    @State private var scrollOffset: CGFloat = 0
    @State private var selectedTag: Tag?
    @State private var currentIdea: Idea
    
    init(idea: Idea) {
        self.idea = idea
        self._currentIdea = State(initialValue: idea)
    }
    
    var body: some View {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 30) {
                        headerSection
                        
                        contentSection
                    }
                }
                .coordinateSpace(name: "scroll")
            }
            .navigationBarHidden(true)
            .alert("Delete Idea", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    ideaStore.deleteIdea(currentIdea)
                    presentationMode.wrappedValue.dismiss()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to delete this idea? This action cannot be undone.")
            }
            .sheet(item: $selectedTag) { tag in
                TagDetailView(tag: tag)
                    .environmentObject(ideaStore)
            }
            .onAppear {
                if let updatedIdea = ideaStore.ideas.first(where: { $0.id == idea.id }) {
                    currentIdea = updatedIdea
                }
            }
            .onChange(of: ideaStore.ideas) { _ in
                if let updatedIdea = ideaStore.ideas.first(where: { $0.id == idea.id }) {
                    currentIdea = updatedIdea
                }
            }
    }
    
    private var headerSection: some View {
        HStack(alignment: .top) {
            HStack(spacing: 8) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppColors.primaryText)
                        .frame(width: 40, height: 40)
                        .background(AppColors.cardBackground)
                        .clipShape(Circle())
                }
                
                ZStack {
                    Circle()
                        .fill(AppColors.cardBackground)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: currentIdea.category.iconName)
                        .font(.system(size: 18, weight: .light))
                        .foregroundColor(AppColors.categoryColor(for: currentIdea.category))
                }
                
                Text("Idea Detail")
                    .font(.nunito(.semiBold, size: 18))
                    .foregroundColor(AppColors.primaryText)
                
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: {
                    ideaStore.toggleFavorite(currentIdea)
                }) {
                    Image(systemName: currentIdea.isFavorite ? "star.fill" : "star")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(currentIdea.isFavorite ? .yellow : AppColors.primaryText)
                        .frame(width: 40, height: 40)
                        .background(AppColors.cardBackground)
                        .clipShape(Circle())
                }
                
                Menu {
                    Button(action: {
                        print("Edit button tapped")
                        appState.editIdea(currentIdea)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Label("Edit Idea", systemImage: "pencil")
                    }
                    
                    Button(action: { 
                        print("Delete button tapped")
                        showingDeleteAlert = true 
                    }) {
                        Label("Delete Idea", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .frame(width: 40, height: 40)
                        .background(AppColors.cardBackground)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .background(
            GeometryReader { geometry in
                Color.clear.preference(
                    key: ScrollOffsetPreferenceKey.self,
                    value: geometry.frame(in: .named("scroll")).minY
                )
            }
        )
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            scrollOffset = value
        }
    }
    
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Text(currentIdea.title)
                    .font(.nunito(.bold, size: 28))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.leading)
                
                HStack(spacing: 8) {
                    Image(systemName: currentIdea.category.iconName)
                        .font(.system(size: 14, weight: .medium))
                    
                    Text(currentIdea.category.displayName)
                        .font(.nunito(.semiBold, size: 14))
                }
                .foregroundColor(AppColors.categoryColor(for: currentIdea.category))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.categoryColor(for: currentIdea.category).opacity(0.2))
                )
            }
            
            if !currentIdea.description.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(.nunito(.semiBold, size: 18))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(currentIdea.description)
                        .font(.nunito(.regular, size: 16))
                        .foregroundColor(AppColors.secondaryText)
                        .lineSpacing(4)
                }
            }
            
            if !currentIdea.tags.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Tags")
                        .font(.nunito(.semiBold, size: 18))
                        .foregroundColor(AppColors.primaryText)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(currentIdea.tags, id: \.id) { tag in
                            Button(action: {
                                selectedTag = tag
                            }) {
                                HStack {
                                    Text(tag.name)
                                        .font(.nunito(.medium, size: 14))
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "info.circle")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(AppColors.primaryText.opacity(0.6))
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(hex: tag.color).opacity(0.3))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color(hex: tag.color).opacity(0.5), lineWidth: 1)
                                        )
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
            
            if !currentIdea.notes.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Notes")
                        .font(.nunito(.semiBold, size: 18))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(currentIdea.notes)
                        .font(.nunito(.regular, size: 16))
                        .foregroundColor(AppColors.secondaryText)
                        .lineSpacing(4)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.elementBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.elementBorder, lineWidth: 1)
                                )
                        )
                }
            }
            
            metadataSection
            
            actionButtons
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(AppColors.elementBorder, lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
        .offset(y: -20)
    }
    
    private var metadataSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Details")
                .font(.nunito(.semiBold, size: 18))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 8) {
                HStack {
                    Text("Created:")
                        .font(.nunito(.medium, size: 14))
                        .foregroundColor(AppColors.secondaryText)
                    
                    Spacer()
                    
                    Text(DateFormatter.fullDate.string(from: currentIdea.dateCreated))
                        .font(.nunito(.regular, size: 14))
                        .foregroundColor(AppColors.primaryText)
                }
                
                if currentIdea.dateModified > currentIdea.dateCreated {
                    HStack {
                        Text("Modified:")
                            .font(.nunito(.medium, size: 14))
                            .foregroundColor(AppColors.secondaryText)
                        
                        Spacer()
                        
                        Text(DateFormatter.fullDate.string(from: currentIdea.dateModified))
                            .font(.nunito(.regular, size: 14))
                            .foregroundColor(AppColors.primaryText)
                    }
                }
                
                HStack {
                    Text("Status:")
                        .font(.nunito(.medium, size: 14))
                        .foregroundColor(AppColors.secondaryText)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: currentIdea.isFavorite ? "star.fill" : "lightbulb")
                            .font(.system(size: 12, weight: .medium))
                        
                        Text(currentIdea.isFavorite ? "Favorite" : "Idea")
                            .font(.nunito(.medium, size: 14))
                    }
                    .foregroundColor(currentIdea.isFavorite ? .yellow : AppColors.primaryText)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.elementBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.elementBorder, lineWidth: 1)
                    )
            )
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: { 
                print("Edit button in actionButtons tapped")
                appState.editIdea(currentIdea)
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("Edit Idea")
                        .font(.nunito(.semiBold, size: 16))
                }
                .foregroundColor(AppColors.primaryBlue)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.white)
                .cornerRadius(12)
            }
            
            Button(action: {
                print("Toggle favorite button tapped")
                ideaStore.toggleFavorite(currentIdea)
            }) {
                HStack {
                    Image(systemName: currentIdea.isFavorite ? "star.slash" : "star")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text(currentIdea.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                        .font(.nunito(.semiBold, size: 16))
                }
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(AppColors.buttonGradient)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.elementBorder, lineWidth: 1)
                )
            }
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct IdeaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleIdea = Idea(
            title: "Revolutionary Mobile App",
            description: "Create a comprehensive productivity app that combines task management, habit tracking, and goal setting with AI-powered insights and personalized recommendations.",
            category: .work,
            tags: [
                Tag(name: "startup", color: "#007AFF"),
                Tag(name: "mobile", color: "#34C759"),
                Tag(name: "AI", color: "#FF9500"),
                Tag(name: "productivity", color: "#AF52DE")
            ],
            notes: "Research competitors like Notion, Todoist, and Habitica. Consider freemium model with premium features.",
            isFavorite: true
        )
        
        IdeaDetailView(idea: sampleIdea)
            .environmentObject(IdeaStore())
            .environmentObject(AppState())
    }
}
