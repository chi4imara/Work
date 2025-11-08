import SwiftUI
import Combine

struct IdeaDetailView: View {
    @State private var idea: Idea
    @State private var isFavorite: Bool
    @State private var showingEditView = false
    @State private var showingDeleteConfirmation = false
    @State private var isDeleted = false
    @Environment(\.dismiss) private var dismiss
    
    private let dataManager = DataManager.shared
    
    init(idea: Idea) {
        _idea = State(initialValue: idea)
        _isFavorite = State(initialValue: DataManager.shared.isFavorite(ideaId: idea.id))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                if isDeleted {
                    IdeaUnavailableView()
                } else {
                    ScrollView {
                    VStack(spacing: 24) {
                        mainContentCard
                        
                        if idea.description != nil || idea.source != nil {
                            detailsSection
                        }
                        
                        metadataSection
                        
                        actionButtonsSection
                        
                        Spacer(minLength: 50)
                    }
                    .padding(20)
                }
                }
            }
            .navigationTitle("Idea Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        toggleFavorite()
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(isFavorite ? AppColors.error : AppColors.secondaryText)
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            IdeaFormView(idea: idea)
                .onDisappear {
                    refreshIdeaData()
                }
        }
        .onAppear {
            refreshIdeaData()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("IdeaUpdated"))) { notification in
            if let ideaId = notification.userInfo?["ideaId"] as? UUID, ideaId == idea.id {
                refreshIdeaData()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("FavoriteToggled"))) { notification in
            if let ideaId = notification.userInfo?["ideaId"] as? UUID, ideaId == idea.id {
                refreshIdeaData()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("FavoritesCleared"))) { _ in
            refreshIdeaData()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("IdeaDeleted"))) { notification in
            if let ideaId = notification.userInfo?["ideaId"] as? UUID, ideaId == idea.id {
                isDeleted = true
            }
        }
        .alert("Delete Idea", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteIdea()
            }
        } message: {
            Text("Are you sure you want to delete this idea? This action cannot be undone.")
        }
    }
    
    private var mainContentCard: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                Text(idea.title)
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
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
            
            if isFavorite {
                HStack(spacing: 8) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.error)
                    
                    Text("In Favorites")
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.error)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(AppColors.error.opacity(0.1))
                )
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.primary.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private var detailsSection: some View {
        VStack(spacing: 16) {
            if let description = idea.description, !description.isEmpty {
                DetailRow(
                    title: "Description",
                    content: description,
                    icon: "text.alignleft"
                )
            }
            
            if let source = idea.source, !source.isEmpty {
                DetailRow(
                    title: "Source",
                    content: source,
                    icon: "link"
                )
            }
        }
    }
    
    private var metadataSection: some View {
        VStack(spacing: 12) {
            DetailRow(
                title: "Type",
                content: idea.isSystem ? "System Idea" : "Custom Idea",
                icon: idea.isSystem ? "gear" : "person"
            )
            
            DetailRow(
                title: "Date Added",
                content: DateFormatter.detailFormatter.string(from: idea.dateAdded),
                icon: "calendar"
            )
        }
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: 16) {
            Button(action: {
                showingEditView = true
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("Edit Idea")
                        .font(AppFonts.buttonTitle)
                }
                .foregroundColor(AppColors.primary)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(AppColors.primary, lineWidth: 2)
                )
            }
            
            if !idea.isSystem {
                Button(action: {
                    showingDeleteConfirmation = true
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "trash")
                            .font(.system(size: 16, weight: .medium))
                        
                        Text("Delete Idea")
                            .font(AppFonts.buttonTitle)
                    }
                    .foregroundColor(AppColors.error)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(AppColors.error, lineWidth: 2)
                    )
                }
            }
        }
    }
    
    private func toggleFavorite() {
        dataManager.toggleFavorite(ideaId: idea.id)
        isFavorite = dataManager.isFavorite(ideaId: idea.id)
    }
    
    private func refreshIdeaData() {
        if let updatedIdea = dataManager.getIdea(withId: idea.id) {
            idea = updatedIdea
            isFavorite = dataManager.isFavorite(ideaId: idea.id)
        } else {
            isDeleted = true
        }
    }
    
    private func deleteIdea() {
        dataManager.deleteIdea(withId: idea.id)
        dismiss()
    }
}

struct DetailRow: View {
    let title: String
    let content: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.primary)
                
                Text(title)
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            
            Text(content)
                .font(AppFonts.body)
                .foregroundColor(AppColors.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.primary.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

struct IdeaDetailLoadingView: View {
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                CustomLoader()
                
                Text("Loading idea details...")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
            }
        }
    }
}

struct IdeaUnavailableView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(AppColors.warning)
                    
                    VStack(spacing: 12) {
                        Text("Idea Unavailable")
                            .font(AppFonts.title2)
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("This idea is no longer available. It may have been deleted.")
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                }
            }
        }
    }
}

extension DateFormatter {
    static let detailFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
}

#Preview {
    IdeaDetailView(idea: Idea.systemIdeas.first!)
}
