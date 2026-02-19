import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var achievementManager: AchievementManager
    @EnvironmentObject var productStore: ProductStore
    @State private var selectedAchievement: Achievement?
    
    var completionPercentage: Double {
        Double(achievementManager.unlockedAchievements.count) / Double(Achievement.allCases.count) * 100
    }
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    VStack(spacing: 16) {
                        HStack {
                            Text("Achievements")
                                .font(.playfairDisplay(size: 28, weight: .bold))
                                .foregroundColor(ColorManager.primaryText)
                            
                            Spacer()
                        }
                        
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 8) {
                                    Text("🔥")
                                        .font(.system(size: 24))
                                    Text("Current Streak")
                                        .font(.playfairDisplay(size: 16, weight: .semibold))
                                        .foregroundColor(ColorManager.primaryText)
                                }
                                
                                Text("\(achievementManager.currentStreak) days")
                                    .font(.playfairDisplay(size: 32, weight: .bold))
                                    .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.4))
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 8) {
                                Text("Progress")
                                    .font(.playfairDisplay(size: 14, weight: .medium))
                                    .foregroundColor(ColorManager.secondaryText)
                                
                                Text("\(achievementManager.unlockedAchievements.count)/\(Achievement.allCases.count)")
                                    .font(.playfairDisplay(size: 20, weight: .bold))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                Text(String(format: "%.0f%%", completionPercentage))
                                    .font(.playfairDisplay(size: 14, weight: .medium))
                                    .foregroundColor(ColorManager.secondaryText)
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(ColorManager.cardGradient)
                                .shadow(color: ColorManager.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(Achievement.allCases, id: \.self) { achievement in
                            AchievementCard(
                                achievement: achievement,
                                isUnlocked: achievementManager.unlockedAchievements.contains(achievement)
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    let isUnlocked: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(isUnlocked ? achievement.color.opacity(0.2) : ColorManager.secondaryText.opacity(0.1))
                    .frame(width: 70, height: 70)
                
                Text(isUnlocked ? achievement.icon : "🔒")
                    .font(.system(size: 35))
                    .opacity(isUnlocked ? 1.0 : 0.5)
            }
            
            VStack(spacing: 4) {
                Text(achievement.title)
                    .font(.playfairDisplay(size: 14, weight: .semibold))
                    .foregroundColor(isUnlocked ? ColorManager.primaryText : ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                Text(achievement.description)
                    .font(.playfairDisplay(size: 11, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isUnlocked ? AnyShapeStyle(ColorManager.cardGradient) : AnyShapeStyle(ColorManager.cardGradient.opacity(0.5)))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isUnlocked ? achievement.color.opacity(0.3) : Color.clear, lineWidth: 2)
                )
                .shadow(color: isUnlocked ? achievement.color.opacity(0.2) : Color.clear, radius: 4, x: 0, y: 2)
        )
        .opacity(isUnlocked ? 1.0 : 0.6)
    }
}
