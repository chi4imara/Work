import SwiftUI
import Combine

struct RandomChallengeView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var currentChallenge: Challenge?
    @State private var showingCategoryPicker = false
    @State private var showingHistory = false
    @State private var showingMenu = false
    @State private var animateCard = false
    
    @Binding var selectedTab: TabSelection
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 30) {
                HStack {
                    Text("Random Challenge")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Button(action: { showingMenu = true }) {
                        Image(systemName: "ellipsis")
                            .font(.ubuntu(24, weight: .bold))
                            .foregroundColor(AppColors.primary)
                    }
                    .confirmationDialog("Menu", isPresented: $showingMenu, titleVisibility: .visible) {
                        Button("Select Category") {
                            showingCategoryPicker = true
                        }
                        Button("Challenge History") {
                            showingHistory = true
                        }
                        Button("Cancel", role: .cancel) { }
                    }
                }
                .padding(.vertical, 10)
                
                if let challenge = currentChallenge {
                    challengeCard(challenge)
                        .scaleEffect(animateCard ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: animateCard)
                } else {
                    emptyStateView
                }
                
                Spacer()
                
                if !dataManager.challenges.isEmpty {
                    newChallengeButton
                }
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            if currentChallenge == nil && !dataManager.challenges.isEmpty {
                generateNewChallenge()
            }
        }
        .onReceive(dataManager.$challenges) { newChallenges in
            if let currentChallenge = currentChallenge {
                if !newChallenges.contains(where: { $0.id == currentChallenge.id }) {
                    self.currentChallenge = nil
                }
            }
            
            if newChallenges.isEmpty {
                currentChallenge = nil
            }
        }
        .sheet(isPresented: $showingCategoryPicker) {
            CategoryPickerView(selectedCategory: $dataManager.selectedCategory)
                .environmentObject(dataManager)
        }
        .sheet(isPresented: $showingHistory) {
            NavigationView {
                HistoryView()
                    .environmentObject(dataManager)
            }
        }
    }
    
    @ViewBuilder
    private func challengeCard(_ challenge: Challenge) -> some View {
        VStack(spacing: 20) {
            Text(challenge.text)
                .font(.ubuntu(24, weight: .medium))
                .foregroundColor(AppColors.textPrimary)
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding(.horizontal, 20)
            
            Text("Category: \(dataManager.getCategoryName(for: challenge.categoryId))")
                .font(.ubuntu(14))
                .foregroundColor(AppColors.textSecondary)
            
            Button(action: {
                dataManager.toggleFavorite(challenge)
                if let updatedChallenge = dataManager.challenges.first(where: { $0.id == challenge.id }) {
                    currentChallenge = updatedChallenge
                }
            }) {
                HStack {
                    Image(systemName: challenge.isFavorite ? "star.fill" : "star")
                        .foregroundColor(challenge.isFavorite ? AppColors.secondary : AppColors.primary)
                    Text(challenge.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.primary)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppColors.cardBackground)
                        .shadow(color: AppColors.primary.opacity(0.2), radius: 5, x: 0, y: 2)
                )
            }
        }
        .padding(30)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.primary.opacity(0.2), radius: 15, x: 0, y: 8)
        )
        .padding(.horizontal, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "dice")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.textSecondary)
            
            Text("Challenge list is empty")
                .font(.ubuntu(20, weight: .medium))
                .foregroundColor(AppColors.textPrimary)
            
            Text("Add new challenges on the \"Create\" screen")
                .font(.ubuntu(16))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
            
            Button(action: { withAnimation { selectedTab = .create } } )
            {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Challenge")
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .background(
                    LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(25)
            }
        }
        .padding(40)
    }
    
    private var newChallengeButton: some View {
        Button(action: {
            generateNewChallenge()
        }) {
            HStack {
                Image(systemName: "dice.fill")
                    .font(.title2)
                Text("New Challenge")
                    .font(.ubuntu(18, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(
                LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(27.5)
            .shadow(color: AppColors.primary.opacity(0.4), radius: 15, x: 0, y: 8)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }
    
    private func generateNewChallenge() {
        withAnimation(.easeInOut(duration: 0.3)) {
            animateCard = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            if let newChallenge = dataManager.getRandomChallenge() {
                currentChallenge = newChallenge
                dataManager.addToHistory(newChallenge)
            }
            
            withAnimation(.easeInOut(duration: 0.3)) {
                animateCard = false
            }
        }
    }
}


