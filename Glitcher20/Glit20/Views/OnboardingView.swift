import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            AppColorScheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPageView(
                        imageName: "tshirt.fill",
                        title: "Plan your perfect wardrobe",
                        description: "Create a clear list of clothing items you want to add to your wardrobe. Sort them into categories, keep notes, and check off what you've already bought."
                    )
                    .tag(0)
                    
                    OnboardingPageView(
                        imageName: "list.bullet.clipboard.fill",
                        title: "Stay organized",
                        description: "Build a simple, organized shopping plan that helps you track every idea and stay focused on what you actually need."
                    )
                    .tag(1)
                    
                    OnboardingPageView(
                        imageName: "chart.bar.fill",
                        title: "Track your progress",
                        description: "Monitor your shopping journey with detailed statistics and insights. See how your wardrobe evolves over time and make informed decisions."
                    )
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                Button(action: {
                    if currentPage < 2 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        showOnboarding = true
                        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                    }
                }) {
                    Text(currentPage < 2 ? "Next" : "Continue")
                        .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                        .foregroundColor(Color.primaryPurple)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.primaryYellow)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPageView: View {
    let imageName: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: imageName)
                .font(.system(size: 80))
                .foregroundColor(Color.primaryYellow)
                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
            
            VStack(spacing: 24) {
                Text(title)
                    .font(FontManager.playfairDisplay(size: 32, weight: .bold))
                    .foregroundColor(Color.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(description)
                    .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                    .foregroundColor(Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
