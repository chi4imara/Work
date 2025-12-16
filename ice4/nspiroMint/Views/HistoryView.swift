import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: HobbyIdeaViewModel
    @State private var selectedIdea: HobbyIdea?
    @State private var showingIdeaDetails = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("History")
                    .font(.playfairDisplay(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                
                if viewModel.ideas.isEmpty {
                    emptyStateView
                } else {
                    historyList
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(item: Binding<IdeaIDWrapper?>(
            get: { selectedIdea.map(IdeaIDWrapper.init) },
            set: { selectedIdea = $0?.idea }
        )) { wrapper in
            IdeaDetailsView(viewModel: viewModel, ideaId: wrapper.id)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "clock")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryYellow)
            
            VStack(spacing: 16) {
                Text("History is empty")
                    .font(.playfairDisplay(24, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Your saved ideas will appear here")
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var historyList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.sortedIdeas) { idea in
                    HistoryIdeaCard(idea: idea) {
                        selectedIdea = idea
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
}

struct HistoryIdeaCard: View {
    let idea: HobbyIdea
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            VStack {
                Image(systemName: idea.hobby.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(AppColors.primaryYellow)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(idea.hobby.displayName)
                        .font(.playfairDisplay(14, weight: .semibold))
                        .foregroundColor(AppColors.primaryYellow)
                    
                    Spacer()
                    
                    Text(formatDate(idea.dateCreated))
                        .font(.playfairDisplay(12, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Text(idea.title)
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(2)
                
                Text(idea.description)
                    .font(.playfairDisplay(14, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(3)
                
                HStack {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(AppColors.accentPink)
                    
                    Text(idea.mood)
                        .font(.playfairDisplay(12, weight: .medium))
                        .foregroundColor(AppColors.accentPink)
                    
                    Spacer()
                    
                    if idea.isFavorite {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(AppColors.primaryYellow)
                    }
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .onTapGesture {
            onTap()
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    HistoryView(viewModel: HobbyIdeaViewModel())
}
