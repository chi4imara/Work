import SwiftUI

struct TodayView: View {
    @ObservedObject var viewModel: HobbyIdeaViewModel
    @State private var showingMenu = false
    @State private var showingNewIdea = false
    @State private var showingHistory = false
    
    @Binding var selectedTab: TabItem
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                Spacer()
                
                if viewModel.ideas.isEmpty {
                    emptyStateView
                } else {
                    ideaContentView
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .sheet(isPresented: $showingNewIdea) {
            NewIdeaView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingHistory) {
            HistoryView(viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Idea of the Day")
                .font(.playfairDisplay(28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: { showingMenu.toggle() }) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                    .rotationEffect(.degrees(90))
            }
            .actionSheet(isPresented: $showingMenu) {
                ActionSheet(
                    title: Text("Menu"),
                    buttons: [
                        .default(Text("Add Idea")) {
                            showingNewIdea = true
                        },
                        .default(Text("History")) {
                            withAnimation {
                                selectedTab = .history
                            }
                        },
                        .cancel()
                    ]
                )
            }
        }
        .padding(.top, 20)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Image(systemName: "lightbulb")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryYellow)
            
            VStack(spacing: 16) {
                Text("You don't have any hobby ideas yet")
                    .font(.playfairDisplay(24, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Start your creative journey by adding your first idea")
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingNewIdea = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Add First Idea")
                        .font(.playfairDisplay(18, weight: .semibold))
                }
                .foregroundColor(AppColors.buttonText)
                .padding(.horizontal, 30)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(AppColors.buttonBackground)
                )
            }
        }
        .padding(.horizontal, 40)
    }
    
    private var ideaContentView: some View {
        VStack(spacing: 30) {
            if let currentIdea = viewModel.currentIdea {
                VStack(spacing: 20) {
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: currentIdea.hobby.icon)
                                .font(.system(size: 16, weight: .semibold))
                            Text(currentIdea.hobby.displayName)
                                .font(.playfairDisplay(16, weight: .semibold))
                        }
                        .foregroundColor(AppColors.primaryYellow)
                        
                        Text(currentIdea.title)
                            .font(.playfairDisplay(24, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.center)
                        
                        Text(currentIdea.description)
                            .font(.playfairDisplay(16, weight: .regular))
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                        
                        HStack {
                            Image(systemName: "heart")
                                .font(.system(size: 14, weight: .regular))
                            Text(currentIdea.mood)
                                .font(.playfairDisplay(14, weight: .medium))
                        }
                        .foregroundColor(AppColors.accentPink)
                        
                        Text(formatDate(currentIdea.dateCreated))
                            .font(.playfairDisplay(12, weight: .regular))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppColors.cardGradient)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    )
                }
                
                HStack(spacing: 20) {
                    Button(action: { viewModel.getNewRandomIdea() }) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 16, weight: .semibold))
                            Text("New Idea")
                                .font(.playfairDisplay(16, weight: .semibold))
                        }
                        .foregroundColor(AppColors.buttonText)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(AppColors.accentOrange)
                        )
                    }
                    
                    Button(action: { viewModel.toggleFavorite(currentIdea) }) {
                        HStack(spacing: 8) {
                            Image(systemName: currentIdea.isFavorite ? "heart.fill" : "heart")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Favorite")
                                .font(.playfairDisplay(16, weight: .semibold))
                        }
                        .foregroundColor(currentIdea.isFavorite ? AppColors.primaryWhite : AppColors.buttonText)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(currentIdea.isFavorite ? AppColors.disabledButton : AppColors.accentPink)
                        )
                    }
                    .disabled(currentIdea.isFavorite)
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
