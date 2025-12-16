import SwiftUI

struct TipsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedTab: Int
    
    private let tips = [
        TipSection(
            title: "How to Start",
            content: "Gratitude is not a list of achievements, but attention to the simple. Write about what made the day a little better.",
            icon: "star.fill"
        ),
        TipSection(
            title: "What You Can Remember",
            content: "The taste of tea, a conversation, support, kind words, warm light, a walk, laughter.",
            icon: "heart.fill"
        ),
        TipSection(
            title: "If the Day Was Hard",
            content: "Sometimes 'thank you' is just 'I managed'. That's enough.",
            icon: "hand.raised.fill"
        ),
        TipSection(
            title: "Example",
            content: "Today: someone gave up their seat on the subway, and it became a sign of care.",
            icon: "lightbulb.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 24) {
                        titleSection
                        
                        LazyVStack(spacing: 20) {
                            ForEach(Array(tips.enumerated()), id: \.offset) { index, tip in
                                TipCard(tip: tip, index: index)
                            }
                        }
                        
                        bottomButton
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Tips for Inspiration")
                .font(.builderSans(.bold, size: 24))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            HStack(spacing: 6) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .medium))
                Text("Back")
                    .font(.builderSans(.medium, size: 16))
            }
            .opacity(0)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var titleSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "lightbulb.max.fill")
                .font(.system(size: 50, weight: .light))
                .foregroundColor(AppColors.primaryYellow)
            
            Text("Finding Inspiration")
                .font(.builderSans(.bold, size: 24))
                .foregroundColor(AppColors.textPrimary)
            
            Text("Sometimes we need a gentle nudge to notice the good around us. Here are some ideas to help you discover gratitude.")
                .font(.builderSans(.regular, size: 16))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
    }
    
    private var bottomButton: some View {
        Button(action: {
            withAnimation {
                selectedTab = 0
            }
        }) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 18))
                Text("Got It")
                    .font(.builderSans(.semiBold, size: 18))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.primaryBlue)
            )
        }
        .padding(.top, 20)
    }
}

struct TipCard: View {
    let tip: TipSection
    let index: Int
    
    private var cardColor: Color {
        switch index % 4 {
        case 0: return AppColors.primaryBlue
        case 1: return AppColors.primaryYellow
        case 2: return AppColors.accentGreen
        default: return AppColors.primaryPurple
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                Circle()
                    .fill(cardColor.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: tip.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(cardColor)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(tip.title)
                    .font(.builderSans(.semiBold, size: 18))
                    .foregroundColor(AppColors.textPrimary)
                
                Text(tip.content)
                    .font(.builderSans(.regular, size: 15))
                    .foregroundColor(AppColors.textSecondary)
                    .lineSpacing(3)
            }
            
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.textLight.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

struct TipSection {
    let title: String
    let content: String
    let icon: String
}


