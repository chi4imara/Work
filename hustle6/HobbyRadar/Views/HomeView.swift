import SwiftUI
import Combine

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showingMenu = false
    @State private var showingIdeaDetail = false
    @State private var selectedHistoryIdea: Idea?
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.hasIdeas() {
                    mainContentView
                } else {
                    emptyStateView
                }
            }
        }
        .sheet(item: $selectedHistoryIdea) { idea in
            IdeaDetailView(idea: idea)
        }
        .alert("Remove from History", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Remove", role: .destructive) {
                viewModel.removeCurrentIdeaFromHistory()
            }
        } message: {
            Text("Are you sure you want to remove this idea from your history?")
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("IdeaUpdated"))) { _ in
            viewModel.loadInitialData()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("FavoriteToggled"))) { _ in
            viewModel.loadInitialData()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("FavoritesCleared"))) { _ in
            viewModel.loadInitialData()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("IdeaDeleted"))) { _ in
            viewModel.loadInitialData()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("IdeaAdded"))) { _ in
            viewModel.loadInitialData()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("HistoryUpdated"))) { _ in
            viewModel.loadInitialData()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("IdeaGenerated"))) { _ in
            viewModel.loadInitialData()
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Idea for Leisure")
                .font(AppFonts.navigationTitle)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: {
                    viewModel.toggleCurrentIdeaFavorite()
                }) {
                    Image(systemName: viewModel.isCurrentIdeaFavorite() ? "heart.fill" : "heart")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(viewModel.isCurrentIdeaFavorite() ? AppColors.error : AppColors.secondaryText)
                }
                
                Button(action: {
                    showingMenu.toggle()
                }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
                .actionSheet(isPresented: $showingMenu) {
                    ActionSheet(
                        title: Text("Options"),
                        buttons: [
                            .destructive(Text("Remove from History")) {
                                if viewModel.isCurrentIdeaInHistory() {
                                    showingDeleteConfirmation = true
                                }
                            },
                            .cancel()
                        ]
                    )
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var mainContentView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            currentIdeaView
            
            Spacer()
            
            generateButton
            
            Spacer()
            
            if !viewModel.recentHistory.isEmpty {
                recentHistoryView
            }
            
            Spacer(minLength: 100)
        }
    }
    
    private var currentIdeaView: some View {
        VStack(spacing: 16) {
            if let idea = viewModel.currentIdea {
                VStack(spacing: 12) {
                    Text(idea.title)
                        .font(AppFonts.ideaTitle)
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .padding(.horizontal, 30)
                    
                    Text(idea.category.name)
                        .font(AppFonts.ideaCategory)
                        .foregroundColor(AppColors.primary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(AppColors.primary.opacity(0.1))
                        )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppColors.cardGradient)
                        .shadow(color: AppColors.primary.opacity(0.1), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal, 20)
            } else {
                VStack(spacing: 16) {
                    CustomLoader()
                    Text("Loading idea...")
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.secondaryText)
                }
            }
        }
    }
    
    private var generateButton: some View {
        Button(action: {
            viewModel.generateNewIdea()
        }) {
            HStack(spacing: 12) {
                Image(systemName: "dice.fill")
                    .font(.system(size: 20, weight: .semibold))
                
                Text("Generate New Idea")
                    .font(AppFonts.buttonTitle)
            }
            .foregroundColor(AppColors.onPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(viewModel.isGenerating ? AnyShapeStyle(AppColors.buttonDisabled) : AnyShapeStyle(AppColors.primaryGradient))
            )
            .shadow(
                color: viewModel.isGenerating ? Color.clear : AppColors.primary.opacity(0.3),
                radius: 8,
                x: 0,
                y: 4
            )
            .scaleEffect(viewModel.isGenerating ? 0.98 : 1.0)
        }
        .disabled(viewModel.isGenerating)
        .padding(.horizontal, 40)
        .animation(.easeInOut(duration: 0.2), value: viewModel.isGenerating)
    }
    
    private var recentHistoryView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Ideas")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(viewModel.recentHistory.prefix(10), id: \.id) { idea in
                        HistoryIdeaCard(
                            idea: idea,
                            isFavorite: viewModel.dataManager.isFavorite(ideaId: idea.id)
                        ) {
                            selectedHistoryIdea = idea
                        } onDelete: {
                            viewModel.removeIdeaFromHistory(idea)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            
            Spacer()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "dice")
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(AppColors.primary)
                
                VStack(spacing: 12) {
                    Text("No Ideas Yet")
                        .font(AppFonts.title2)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("You don't have any ideas yet. Generate your first one or add your own.")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            
            Button(action: {
            }) {
                Text("Add Idea")
                    .font(AppFonts.buttonTitle)
                    .foregroundColor(AppColors.onPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(AppColors.primaryGradient)
                    .cornerRadius(28)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct HistoryIdeaCard: View {
    @State private var idea: Idea
    @State private var isFavorite: Bool
    let onTap: () -> Void
    let onDelete: () -> Void
    
    @State private var showingDeleteAlert = false
    private let dataManager = DataManager.shared
    
    init(idea: Idea, isFavorite: Bool, onTap: @escaping () -> Void, onDelete: @escaping () -> Void) {
        self._idea = State(initialValue: idea)
        self._isFavorite = State(initialValue: isFavorite)
        self.onTap = onTap
        self.onDelete = onDelete
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(idea.title)
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(2)
                    
                    Text(idea.category.name)
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.primary)
                }
                
                Spacer()
                
                if isFavorite {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.error)
                }
            }
        }
        .padding(12)
        .frame(width: 160, height: 80)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.primary.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .onTapGesture {
            onTap()
        }
        .contextMenu {
            Button(action: onTap) {
                Label("View Details", systemImage: "eye")
            }
            
            Button(role: .destructive, action: {
                showingDeleteAlert = true
            }) {
                Label("Remove from History", systemImage: "trash")
            }
        }
        .alert("Remove from History", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Remove", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to remove this idea from your history?")
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("IdeaUpdated"))) { notification in
            if let ideaId = notification.userInfo?["ideaId"] as? UUID, ideaId == idea.id {
                if let updatedIdea = dataManager.getIdea(withId: idea.id) {
                    idea = updatedIdea
                    isFavorite = dataManager.isFavorite(ideaId: idea.id)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("FavoriteToggled"))) { notification in
            if let ideaId = notification.userInfo?["ideaId"] as? UUID, ideaId == idea.id {
                if let favoriteState = notification.userInfo?["isFavorite"] as? Bool {
                    isFavorite = favoriteState
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("FavoritesCleared"))) { _ in
            isFavorite = dataManager.isFavorite(ideaId: idea.id)
        }
    }
}

#Preview {
    HomeView()
}
