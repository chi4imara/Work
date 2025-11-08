import SwiftUI

struct GameDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject  var viewModel: GameDetailViewModel
    @State private var showingAddSection = false
    @State private var showingEditGame = false
    @State private var showingDeleteAlert = false
    @State private var sectionToEdit: GameSection?
    @State private var showingToast = false
    @State private var toastMessage = ""
    
    init(game: Game, gamesViewModel: GamesViewModel) {
        _viewModel = StateObject(wrappedValue: GameDetailViewModel(game: game, gamesViewModel: gamesViewModel))
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                    .padding(.bottom, 5)
                
                ScrollView {
                    VStack(spacing: 20) {
                        if !viewModel.game.description.isEmpty {
                            descriptionView
                        }
                        
                        rulesSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .sheet(isPresented: $showingAddSection) {
            AddEditSectionView(gameId: viewModel.game.id, viewModel: viewModel)
        }
        .sheet(item: $sectionToEdit) { section in
            AddEditSectionView(section: section, gameId: viewModel.game.id, viewModel: viewModel)
        }
        .sheet(isPresented: $showingEditGame) {
            AddEditGameView(game: viewModel.game, viewModel: viewModel.gamesViewModel)
        }
        .alert("Delete Game", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteGame()
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete \"\(viewModel.game.name)\"? This action cannot be undone.")
        }
        .overlay(
            toastView,
            alignment: .top
        )
        .onReceive(viewModel.gamesViewModel.$games) { _ in
            viewModel.syncWithGamesViewModel()
        }
        .onReceive(viewModel.$sections) { _ in
        }
    }
    
    private var headerView: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.game.name)
                    .font(AppFonts.title1)
                    .foregroundColor(AppColors.primaryText)
                
                HStack(spacing: 8) {
                    Image(systemName: viewModel.game.category.iconName)
                        .foregroundColor(AppColors.accent)
                    
                    Text(viewModel.game.category.displayName)
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: {
                    viewModel.toggleFavorite()
                    showToast(viewModel.game.isFavorite ? "Added to favorites" : "Removed from favorites")
                }) {
                    Image(systemName: viewModel.game.isFavorite ? "star.fill" : "star")
                        .font(.title2)
                        .foregroundColor(viewModel.game.isFavorite ? AppColors.accent : AppColors.secondaryText)
                }
                
                Menu {
                    Button("Edit Game") {
                        showingEditGame = true
                    }
                    
                    Button("Delete Game", role: .destructive) {
                        showingDeleteAlert = true
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.title2)
                        .foregroundColor(AppColors.primaryText)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }
    
    private var descriptionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description")
                .font(AppFonts.bodyMedium)
                .foregroundColor(AppColors.primaryText)
            
            Text(viewModel.game.description)
                .font(AppFonts.body)
                .foregroundColor(AppColors.secondaryText)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.cardBorder, lineWidth: 1)
                        )
                )
        }
    }
    
    private var rulesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Rules")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Button("Add Section") {
                    showingAddSection = true
                }
                .font(AppFonts.buttonMedium)
                .foregroundColor(AppColors.accent)
            }
            
            if viewModel.sections.isEmpty {
                emptySectionsView
            } else {
                sectionsListView
            }
        }
    }
    
    private var emptySectionsView: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text")
                .font(.system(size: 40))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: 8) {
                Text("No rules yet")
                    .font(AppFonts.bodyMedium)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add your first rule section to get started")
                    .font(AppFonts.subheadline)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button("Add First Section") {
                showingAddSection = true
            }
            .font(AppFonts.buttonMedium)
            .foregroundColor(AppColors.primaryText)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppColors.accent)
            )
        }
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var sectionsListView: some View {
        VStack(spacing: 12) {
            ForEach(Array(viewModel.sections.enumerated()), id: \.element.id) { index, section in
                HStack {
                    NavigationLink(destination: SectionDetailView(viewModel: viewModel, section: section)) {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(section.title)
                                    .font(AppFonts.bodyMedium)
                                    .foregroundColor(AppColors.primaryText)
                                    .lineLimit(1)
                                
                                Text(section.preview)
                                    .font(AppFonts.subheadline)
                                    .foregroundColor(AppColors.secondaryText)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        sectionToEdit = section
                    }) {
                        Image(systemName: "pencil")
                            .font(.system(size: 16))
                            .foregroundColor(AppColors.accent)
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(AppColors.accent.opacity(0.1))
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        viewModel.deleteSection(at: index)
                        showToast("Section deleted")
                    }) {
                        Image(systemName: "trash")
                            .font(.system(size: 16))
                            .foregroundColor(AppColors.error)
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(AppColors.error.opacity(0.1))
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.cardBorder, lineWidth: 1)
                        )
                )
            }
        }
    }
    
    private var toastView: some View {
        Group {
            if showingToast {
                Text(toastMessage)
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.primaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppColors.success)
                    )
                    .padding(.top, 50)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }
    
    private func showToast(_ message: String) {
        toastMessage = message
        withAnimation(.easeInOut(duration: 0.3)) {
            showingToast = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showingToast = false
            }
        }
    }
}

#Preview {
    ZStack {
        BackgroundView()
        GameDetailView(
            game: Game(name: "Monopoly", category: .family, description: "Classic property trading game"),
            gamesViewModel: GamesViewModel()
        )
    }
}
