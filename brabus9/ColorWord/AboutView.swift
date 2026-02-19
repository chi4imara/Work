import SwiftUI

struct AboutView: View {
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 30) {
                HStack {
                    Text("About")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 24) {
                        Image(systemName: "heart.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(AppColors.accent)
                        
                        VStack(spacing: 16) {
                            Text("Personal Catalog of Taste")
                                .font(.ubuntu(24, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                                .multilineTextAlignment(.center)
                            
                            Text("This app is created for storing what you like — words, scents, combinations and images — as a personal catalog of taste.")
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(AppColors.secondaryText)
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 16) {
                            FeatureRow(
                                icon: "plus.circle",
                                title: "Simple Collection",
                                description: "Add items you like without categories or explanations"
                            )
                            
                            FeatureRow(
                                icon: "shuffle",
                                title: "Random Discovery",
                                description: "Rediscover your saved items through random selection"
                            )
                            
                            FeatureRow(
                                icon: "heart",
                                title: "Personal Taste",
                                description: "Build your own quiet record of preferences over time"
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 20)
                }
                
                Spacer()
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(AppColors.accent)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                Text(description)
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(nil)
            }
            
            Spacer()
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

#Preview {
    AboutView()
}
