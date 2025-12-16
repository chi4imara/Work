import SwiftUI

struct CategoryChallengesView: View {
    @EnvironmentObject var dataManager: DataManager
    let category: Category
    @Environment(\.presentationMode) var presentationMode
    
    private var categoryChallenges: [Challenge] {
        dataManager.challenges.filter { $0.categoryId == category.id }
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                if categoryChallenges.isEmpty {
                    emptyStateView
                    Spacer()
                } else {
                    challengesList
                }
            }
        }
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.large)
    }
    
    private var challengesList: some View {
        List {
            ForEach(categoryChallenges) { challenge in
                ChallengeCard(challenge: challenge)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .swipeActions(edge: .leading) {
                        Button(role: .destructive) {
                            dataManager.deleteChallenge(challenge)
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                        .tint(AppColors.error)
                    }
                    .swipeActions(edge: .trailing) {
                        Button {
                            dataManager.toggleFavorite(challenge)
                        } label: {
                            Label(
                                challenge.isFavorite ? "Remove Favorite" : "Add Favorite",
                                systemImage: challenge.isFavorite ? "star.slash.fill" : "star.fill"
                            )
                        }
                        .tint(challenge.isFavorite ? AppColors.textSecondary : AppColors.secondary)
                    }
            }
            .onDelete(perform: deleteChallenges)
        }
        .listStyle(PlainListStyle())
        .background(Color.clear)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "doc.text")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.textSecondary)
            
            Text("No challenges in this category")
                .font(.ubuntu(20, weight: .medium))
                .foregroundColor(AppColors.textPrimary)
            
            Text("Add challenges to this category on the \"Create\" screen")
                .font(.ubuntu(16))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(40)
    }
    
    private func deleteChallenges(offsets: IndexSet) {
        let challengesToDelete = offsets.compactMap { index -> Challenge? in
            guard index < categoryChallenges.count else { return nil }
            return categoryChallenges[index]
        }
        
        for challenge in challengesToDelete {
            dataManager.deleteChallenge(challenge)
        }
    }
}

struct ChallengeCard: View {
    @EnvironmentObject var dataManager: DataManager
    let challenge: Challenge
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text(challenge.text)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.textPrimary)
                    .lineSpacing(4)
                
                if challenge.isFavorite {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.secondary)
                        Text("Favorite")
                            .font(.ubuntu(12))
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
            
            Spacer()
            
            if challenge.isFavorite {
                Image(systemName: "star.fill")
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.secondary)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.primary.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal, 4)
        .padding(.vertical, 2)
    }
}

#Preview {
    NavigationView {
        CategoryChallengesView(category: Category(name: "Test"))
            .environmentObject(DataManager.shared)
    }
}
