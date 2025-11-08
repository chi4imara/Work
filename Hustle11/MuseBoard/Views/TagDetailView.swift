import SwiftUI

struct TagDetailView: View {
    @EnvironmentObject var ideaStore: IdeaStore
    @Environment(\.presentationMode) var presentationMode
    
    let tag: Tag
    @State private var showingDeleteAlert = false
    @State private var ideasWithTag: [Idea] = []
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                if ideasWithTag.isEmpty {
                    emptyStateView
                } else {
                    ideasList
                }
            }
        }
        .alert("Delete Tag", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                ideaStore.deleteTag(tag)
                presentationMode.wrappedValue.dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            let usageCount = ideaStore.getTagUsageCount(tag)
            if usageCount > 0 {
                Text("This tag is used in \(usageCount) idea(s). Deleting it will remove the tag from all ideas. This action cannot be undone.")
            } else {
                Text("Are you sure you want to delete this tag? This action cannot be undone.")
            }
        }
        .onAppear {
            loadIdeasWithTag()
        }
        .onChange(of: ideaStore.ideas) { _ in
            loadIdeasWithTag()
        }
        .onChange(of: ideaStore.tags) { _ in
            loadIdeasWithTag()
        }
    }
    
    private var headerView: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(tag.name)
                    .font(.nunito(.bold, size: 28))
                    .foregroundColor(AppColors.primaryText)
                
                Text("\(ideasWithTag.count) ideas")
                    .font(.nunito(.medium, size: 14))
                    .foregroundColor(AppColors.secondaryText)
                    .id("\(ideasWithTag.count)") 
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Circle()
                    .fill(Color(hex: tag.color))
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
                
                Button(action: { showingDeleteAlert = true }) {
                    Image(systemName: "trash")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.error)
                        .frame(width: 40, height: 40)
                        .background(AppColors.elementBackground)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 16)
    }
    
    private var ideasList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(ideasWithTag) { idea in
                    TagIdeaCard(idea: idea)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color(hex: tag.color).opacity(0.2))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "tag.fill")
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(Color(hex: tag.color))
            }
            
            VStack(spacing: 8) {
                Text("No Ideas Yet")
                    .font(.nunito(.bold, size: 24))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Ideas with this tag will appear here")
                    .font(.nunito(.regular, size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private func loadIdeasWithTag() {
        ideasWithTag = ideaStore.ideas.filter { idea in
            idea.tags.contains { $0.name == tag.name }
        }.sorted { $0.dateCreated > $1.dateCreated }
    }
}

struct TagIdeaCard: View {
    @EnvironmentObject var ideaStore: IdeaStore
    let idea: Idea
    @State private var showingDetail = false
    
    var body: some View {
        Button(action: { showingDetail = true }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(idea.title)
                            .font(.nunito(.semiBold, size: 18))
                            .foregroundColor(AppColors.primaryText)
                            .lineLimit(2)
                        
                        HStack(spacing: 8) {
                            HStack(spacing: 4) {
                                Image(systemName: idea.category.iconName)
                                    .font(.system(size: 12, weight: .medium))
                                Text(idea.category.displayName)
                                    .font(.nunito(.medium, size: 12))
                            }
                            .foregroundColor(AppColors.categoryColor(for: idea.category))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppColors.categoryColor(for: idea.category).opacity(0.2))
                            )
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                    
                    if idea.isFavorite {
                        Image(systemName: "star.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.yellow)
                    }
                }
                
                if !idea.description.isEmpty {
                    Text(idea.description)
                        .font(.nunito(.regular, size: 14))
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(3)
                }
                
                if idea.tags.count > 1 {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(idea.tags.prefix(3), id: \.id) { tag in
                                Text(tag.name)
                                    .font(.nunito(.medium, size: 11))
                                    .foregroundColor(AppColors.primaryText)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(Color(hex: tag.color).opacity(0.3))
                                    )
                            }
                            
                            if idea.tags.count > 3 {
                                Text("+\(idea.tags.count - 3)")
                                    .font(.nunito(.medium, size: 11))
                                    .foregroundColor(AppColors.tertiaryText)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(AppColors.elementBackground)
                                    )
                            }
                        }
                        .padding(.horizontal, 1)
                    }
                }
                
                HStack {
                    Text(DateFormatter.shortDate.string(from: idea.dateCreated))
                        .font(.nunito(.regular, size: 12))
                        .foregroundColor(AppColors.tertiaryText)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppColors.tertiaryText)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(AppColors.elementBorder, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            IdeaDetailView(idea: idea)
                .environmentObject(ideaStore)
        }
    }
}

struct TagDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleTag = Tag(name: "startup", color: "#007AFF")
        let store = IdeaStore()
        
        let idea1 = Idea(
            title: "AI-Powered App",
            description: "Create an app that uses AI to help users",
            category: .work,
            tags: [sampleTag, Tag(name: "AI", color: "#34C759")],
            isFavorite: true
        )
        
        let idea2 = Idea(
            title: "Mobile Game",
            description: "A simple puzzle game for mobile",
            category: .hobby,
            tags: [sampleTag, Tag(name: "gaming", color: "#FF9500")]
        )
        
        store.addIdea(idea1)
        store.addIdea(idea2)
        
        return TagDetailView(tag: sampleTag)
            .environmentObject(store)
    }
}
