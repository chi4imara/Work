import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var ideaStore: IdeaStore
    @State private var selectedIdea: Idea?
    @State private var ideaToRemove: Idea?
    @State private var showingRemoveAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if ideaStore.favoriteIdeas.isEmpty {
                        emptyStateView
                    } else {
                        favoritesList
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(item: $selectedIdea) { idea in
                IdeaDetailView(idea: idea)
                    .environmentObject(ideaStore)
            }
            .alert("Remove from Favorites", isPresented: $showingRemoveAlert) {
                Button("Remove", role: .destructive) {
                    if let idea = ideaToRemove {
                        ideaStore.toggleFavorite(idea)
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to remove this idea from favorites?")
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Favorites")
                    .font(.nunito(.bold, size: 28))
                    .foregroundColor(AppColors.primaryText)
                
                if !ideaStore.favoriteIdeas.isEmpty {
                    Text("\(ideaStore.favoriteIdeas.count) favorite ideas")
                        .font(.nunito(.medium, size: 14))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            
            Spacer()
            
            Image(systemName: "star.fill")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.yellow)
                .frame(width: 44, height: 44)
                .background(AppColors.elementBackground)
                .clipShape(Circle())
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 16)
    }
    
    private var favoritesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(ideaStore.favoriteIdeas) { idea in
                    FavoriteIdeaCard(
                        idea: idea,
                        onTap: { selectedIdea = idea },
                        onRemove: { 
                            ideaToRemove = idea
                            showingRemoveAlert = true 
                        }
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
            
            AnimatedStarIcon()
            
            VStack(spacing: 8) {
                Text("No Favorites Yet")
                    .font(.nunito(.bold, size: 24))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Ideas you mark as favorites will appear here")
                    .font(.nunito(.regular, size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Text("Tap the star icon on any idea to add it to your favorites")
                .font(.nunito(.medium, size: 14))
                .foregroundColor(AppColors.tertiaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct FavoriteIdeaCard: View {
    let idea: Idea
    let onTap: () -> Void
    let onRemove: () -> Void
    
    @State private var dragOffset: CGSize = .zero
    @State private var showingRemoveAction = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.elementBorder, lineWidth: 1)
                )
            
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
                    
                    Button(action: onRemove) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.yellow)
                    }
                }
                
                if !idea.description.isEmpty {
                    Text(idea.description)
                        .font(.nunito(.regular, size: 14))
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(3)
                }
                
                if !idea.tags.isEmpty {
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
                        .padding(.horizontal, 15)
                    }
                    .padding(.horizontal, -15)
                }
                
                HStack {
                    Text(DateFormatter.shortDate.string(from: idea.dateCreated))
                        .font(.nunito(.regular, size: 12))
                        .foregroundColor(AppColors.tertiaryText)
                    
                    Spacer()
                }
            }
            .padding(16)
        }
        .scaleEffect(dragOffset == .zero ? 1.0 : 0.95)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: dragOffset)
        .onTapGesture {
            onTap()
        }
    }
}

struct AnimatedStarIcon: View {
    @State private var isAnimating = false
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            Image(systemName: "star.fill")
                .font(.system(size: 80, weight: .thin))
                .foregroundColor(.yellow.opacity(0.3))
                .scaleEffect(scale * 1.2)
                .blur(radius: 8)
            
            Image(systemName: "star.fill")
                .font(.system(size: 80, weight: .thin))
                .foregroundColor(.yellow.opacity(0.8))
                .rotationEffect(.degrees(rotationAngle))
                .scaleEffect(scale)
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(
            .linear(duration: 10)
            .repeatForever(autoreverses: false)
        ) {
            rotationAngle = 360
        }
        
        withAnimation(
            .easeInOut(duration: 2)
            .repeatForever(autoreverses: true)
        ) {
            scale = 1.1
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        let store = IdeaStore()
        
        let sampleIdea1 = Idea(
            title: "AI-Powered Fitness App",
            description: "Create a fitness app that uses AI to create personalized workout plans",
            category: .hobby,
            tags: [Tag(name: "AI", color: "#007AFF"), Tag(name: "fitness", color: "#34C759")],
            isFavorite: true
        )
        
        let sampleIdea2 = Idea(
            title: "Travel Planning Platform",
            description: "A comprehensive platform for planning trips with friends",
            category: .travel,
            tags: [Tag(name: "travel", color: "#FF9500"), Tag(name: "social", color: "#AF52DE")],
            isFavorite: true
        )
        
        store.addIdea(sampleIdea1)
        store.addIdea(sampleIdea2)
        
        return FavoritesView()
            .environmentObject(store)
    }
}
