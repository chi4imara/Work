import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    
    private let totalPages = 3
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPageView(
                        icon: "drop.fill",
                        title: "Capture every perfume impression.",
                        description: "Save the fragrances you try and organize them in a clear journal. Rate each perfume by season, choose the style it fits best, and add short notes. Build your personal archive of scents, making it easy to revisit your impressions and explore your favorites with clarity."
                    )
                    .tag(0)
                    
                    OnboardingPageView(
                        icon: "star.fill",
                        title: "Rate and organize your collection.",
                        description: "Give each fragrance a rating from 1 to 5 stars and categorize them by season and style. Create custom styles that match your personal preferences. Keep track of when you added each perfume to your collection."
                    )
                    .tag(1)
                    
                    OnboardingPageView(
                        icon: "heart.fill",
                        title: "Discover your favorites.",
                        description: "Mark your most loved fragrances as favorites for quick access. Browse by categories, search through your collection, and explore statistics about your perfume journey. Everything you need to manage your scent archive is at your fingertips."
                    )
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                VStack(spacing: 20) {
                    HStack(spacing: 8) {
                        ForEach(0..<totalPages, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? AppColors.primaryYellow : AppColors.textSecondary.opacity(0.3))
                                .frame(width: 10, height: 10)
                                .animation(.easeInOut, value: currentPage)
                        }
                    }
                    .padding(.top, 20)
                    
                    HStack(spacing: 16) {
                        if currentPage > 0 {
                            Button(action: {
                                withAnimation {
                                    currentPage -= 1
                                }
                            }) {
                                Text("Previous")
                                    .font(.bellGothicBold(size: 18))
                                    .foregroundColor(AppColors.textPrimary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(AppColors.buttonSecondary)
                                    )
                            }
                        }
                        
                        Button(action: {
                            if currentPage < totalPages - 1 {
                                withAnimation {
                                    currentPage += 1
                                }
                            } else {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    showOnboarding = true
                                    UserDefaults.standard.set(true, forKey: "HasSeenOnboarding")
                                }
                            }
                        }) {
                            Text(currentPage < totalPages - 1 ? "Next" : "Continue")
                                .font(.bellGothicBold(size: 20))
                                .foregroundColor(AppColors.textPrimary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(AppColors.primaryYellow)
                                        .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
                                )
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                }
            }
        }
    }
}

struct OnboardingPageView: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 120, height: 120)
                    .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
                
                Image(systemName: icon)
                    .font(.system(size: 50))
                    .foregroundColor(AppColors.primaryYellow)
            }
            
            Text(title)
                .font(.bellGothicBold(size: 28))
                .foregroundColor(AppColors.textPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .padding(.horizontal, 20)
            
            Text(description)
                .font(.bellGothicRegular(size: 18))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .padding(.horizontal, 20)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
