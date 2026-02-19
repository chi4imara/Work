import SwiftUI

struct ReactionsView: View {
    @EnvironmentObject var viewModel: ReactionsViewModel
    @State private var showingNewReaction = false
    @State private var showingFilterMenu = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.filteredReactions.isEmpty && viewModel.selectedFilter == nil {
                    emptyStateView
                } else if viewModel.filteredReactions.isEmpty && viewModel.selectedFilter != nil {
                    emptyFilteredStateView
                } else {
                    reactionsList
                }
            }
        }
        .sheet(isPresented: $showingNewReaction) {
            NewReactionView()
                .environmentObject(viewModel)
        }
        .onChange(of: viewModel.reactions.count) { _ in
        }
        .onChange(of: viewModel.filteredReactions.count) { _ in
        }
        .actionSheet(isPresented: $showingFilterMenu) {
            filterActionSheet
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Reactions")
                    .font(.ibmPlexMono(28, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                if !viewModel.reactions.isEmpty {
                    Text("\(viewModel.filteredReactions.count) reactions")
                        .font(.ibmPlexMono(14, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            
            Spacer()
            
            Button(action: { showingFilterMenu = true }) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(viewModel.selectedFilter != nil ? AppColors.primaryBlue : AppColors.textSecondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.primaryBlue.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "heart.text.square")
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(AppColors.primaryBlue.opacity(0.6))
            }
            
            VStack(spacing: 12) {
                Text("No reactions yet")
                    .font(.ibmPlexMono(20, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Here will appear your reactions. Add your first entry to start capturing impressions.")
                    .font(.ibmPlexMono(14, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            .padding(.horizontal, 40)
            
            Button(action: { showingNewReaction = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Add Reaction")
                        .font(.ibmPlexMono(16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(height: 50)
                .frame(maxWidth: 200)
                .background(AppColors.buttonGradient)
                .cornerRadius(25)
                .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            
            Spacer()
        }
    }
    
    private var emptyFilteredStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "line.3.horizontal.decrease.circle")
                .font(.system(size: 50, weight: .medium))
                .foregroundColor(AppColors.textSecondary.opacity(0.5))
            
            Text("No reactions in this category")
                .font(.ibmPlexMono(16, weight: .medium))
                .foregroundColor(AppColors.textSecondary)
            
            Spacer()
        }
    }
    
    private var reactionsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredReactions) { reaction in
                    NavigationLink(destination: ReactionDetailView(reaction: reaction).environmentObject(viewModel)) {
                        ReactionCard(reaction: reaction)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
        .refreshable {
        }
        .overlay(
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: { showingNewReaction = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(AppColors.yellowButtonGradient)
                            .clipShape(Circle())
                            .shadow(color: AppColors.primaryYellow.opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 120)
                }
            }
        )
    }
    
    private var filterActionSheet: ActionSheet {
        var buttons: [ActionSheet.Button] = []
        
        buttons.append(.default(Text("All Reactions")) {
            viewModel.setFilter(nil)
        })
        
        for type in ReactionType.allCases {
            buttons.append(.default(Text(type.rawValue)) {
                viewModel.setFilter(type)
            })
        }
        
        buttons.append(.cancel())
        
        return ActionSheet(
            title: Text("Filter Reactions"),
            message: Text("Choose a category to filter by"),
            buttons: buttons
        )
    }
}

struct ReactionCard: View {
    let reaction: Reaction
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(typeColor.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: reaction.type.iconName)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(typeColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(reaction.object)
                    .font(.ibmPlexMono(16, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                    .lineLimit(1)
                
                Text(reaction.reaction)
                    .font(.ibmPlexMono(14, weight: .medium))
                    .foregroundColor(AppColors.primaryBlue)
                    .lineLimit(1)
                
                Text(reaction.type.rawValue)
                    .font(.ibmPlexMono(12, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Text(formatDate(reaction.createdAt))
                .font(.ibmPlexMono(12, weight: .regular))
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var typeColor: Color {
        switch reaction.type {
        case .movie: return AppColors.primaryBlue
        case .food: return AppColors.accentOrange
        case .place: return AppColors.accentGreen
        case .person: return AppColors.accentPurple
        case .other: return AppColors.primaryYellow
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}
