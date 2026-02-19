import SwiftUI

struct DailyChallengeView: View {
    @EnvironmentObject var productStore: ProductStore
    @EnvironmentObject var achievementManager: AchievementManager
    @State private var todayChallenge: DailyChallenge?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("🎯 Daily Challenge")
                    .font(.playfairDisplay(size: 20, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                
                Spacer()
                
                if let challenge = todayChallenge, challenge.isCompleted {
                    Text("✓ Completed")
                        .font(.playfairDisplay(size: 12, weight: .semibold))
                        .foregroundColor(ColorManager.suitableGreen)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(ColorManager.suitableGreen.opacity(0.2))
                        )
                }
            }
            
            if let challenge = todayChallenge {
                ChallengeCard(challenge: challenge)
            } else {
                VStack(spacing: 12) {
                    Text("No challenge today")
                        .font(.playfairDisplay(size: 14, weight: .regular))
                        .foregroundColor(ColorManager.secondaryText)
                    
                    Button(action: generateChallenge) {
                        Text("Generate Challenge")
                            .font(.playfairDisplay(size: 14, weight: .semibold))
                            .foregroundColor(ColorManager.primaryBlue)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorManager.cardGradient)
                .shadow(color: ColorManager.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .onAppear {
            loadOrGenerateChallenge()
            updateChallengeProgress()
        }
    }
    
    private func loadOrGenerateChallenge() {
        if todayChallenge == nil {
            generateChallenge()
        }
    }
    
    private func generateChallenge() {
        let types: [ChallengeType] = [.addProducts, .exploreCategory, .markFavorites, .balanceRatio]
        let randomType = types.randomElement() ?? .addProducts
        todayChallenge = DailyChallenge(type: randomType)
        updateChallengeProgress()
    }
    
    private func updateChallengeProgress() {
        guard var challenge = todayChallenge else { return }
        
        switch challenge.type {
        case .addProducts:
            let todayProducts = productStore.products.filter {
                Calendar.current.isDateInToday($0.dateAdded)
            }
            challenge.progress = min(Double(todayProducts.count) / 3.0, 1.0)
            challenge.isCompleted = todayProducts.count >= 3
            
        case .exploreCategory:
            let todayProducts = productStore.products.filter {
                Calendar.current.isDateInToday($0.dateAdded)
            }
            let categories = Set(todayProducts.map { $0.category })
            challenge.progress = min(Double(categories.count) / 3.0, 1.0)
            challenge.isCompleted = categories.count >= 3
            
        case .markFavorites:
            let favorites = productStore.favoriteProducts
            challenge.progress = min(Double(favorites.count) / 5.0, 1.0)
            challenge.isCompleted = favorites.count >= 5
            
        case .maintainStreak:
            challenge.progress = min(Double(achievementManager.currentStreak) / 3.0, 1.0)
            challenge.isCompleted = achievementManager.currentStreak >= 3
            
        case .balanceRatio:
            let total = productStore.products.count
            guard total > 0 else {
                challenge.progress = 0
                break
            }
            let suitable = productStore.suitableProducts.count
            let ratio = Double(suitable) / Double(total) * 100
            challenge.progress = min(ratio / 60.0, 1.0)
            challenge.isCompleted = ratio >= 60
        }
        
        todayChallenge = challenge
    }
}

struct ChallengeCard: View {
    let challenge: DailyChallenge
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                Text(challenge.type.icon)
                    .font(.system(size: 32))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(challenge.type.title)
                        .font(.playfairDisplay(size: 16, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Text(challenge.type.description)
                        .font(.playfairDisplay(size: 13, weight: .regular))
                        .foregroundColor(ColorManager.secondaryText)
                }
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Progress")
                        .font(.playfairDisplay(size: 12, weight: .medium))
                        .foregroundColor(ColorManager.secondaryText)
                    
                    Spacer()
                    
                    Text("\(Int(challenge.progress * 100))%")
                        .font(.playfairDisplay(size: 12, weight: .semibold))
                        .foregroundColor(challenge.type.color)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(challenge.type.color.opacity(0.2))
                            .frame(height: 10)
                        
                        RoundedRectangle(cornerRadius: 6)
                            .fill(challenge.type.color)
                            .frame(width: geometry.size.width * CGFloat(challenge.progress), height: 10)
                            .animation(.spring(), value: challenge.progress)
                    }
                }
                .frame(height: 10)
            }
            
            if challenge.isCompleted {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(ColorManager.suitableGreen)
                    Text("Challenge Completed!")
                        .font(.playfairDisplay(size: 14, weight: .semibold))
                        .foregroundColor(ColorManager.suitableGreen)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(ColorManager.suitableGreen.opacity(0.1))
                )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(challenge.type.color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(challenge.type.color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}
