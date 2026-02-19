import SwiftUI

struct OnboardingPage {
    let title: String
    let description: String
    let icon: String
}

struct OnboardingView: View {
    let onComplete: () -> Void
    
    @State private var currentPage = 0
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Color is your language of beauty.",
            description: "Every shade tells a story — and this app helps you organize them all. Create your personal color catalog for lipsticks, eyeshadows, and nail polishes. Record every product manually: its name, brand, and how you'd describe its color — from soft coral to deep wine red.",
            icon: "paintpalette.fill"
        ),
        OnboardingPage(
            title: "Organize with intention.",
            description: "Mark your favorites and track duplicates, keeping your collection balanced and intentional. Over time, you'll see which shades dominate your style — the tones you return to, the ones that define you.",
            icon: "star.fill"
        ),
        OnboardingPage(
            title: "Discover your palette.",
            description: "Filter by color, brand, or product type to explore your palette in new ways. Whether you're comparing two similar pinks or looking for that perfect nude, everything stays organized in one clear view. This app turns your beauty drawer into a mindful catalog — structured, aesthetic, and truly yours.",
            icon: "sparkles"
        )
    ]
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 20) {
                    PageIndicator(currentPage: currentPage, totalPages: pages.count)
                    
                    HStack(spacing: 16) {
                        if currentPage > 0 {
                            Button(action: {
                                withAnimation {
                                    currentPage -= 1
                                }
                            }) {
                                HStack {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 16, weight: .medium))
                                    Text("Previous")
                                        .font(.ubuntu(16, weight: .medium))
                                }
                                .foregroundColor(ColorTheme.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(16)
                            }
                        }
                        
                        Button(action: {
                            if currentPage < pages.count - 1 {
                                withAnimation {
                                    currentPage += 1
                                }
                            } else {
                                onComplete()
                            }
                        }) {
                            HStack {
                                Text(currentPage < pages.count - 1 ? "Next" : "Continue")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(ColorTheme.white)
                                
                                Image(systemName: currentPage < pages.count - 1 ? "chevron.right" : "checkmark")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(ColorTheme.white)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(ColorTheme.buttonGradient)
                            .cornerRadius(16)
                            .shadow(color: ColorTheme.lightBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Spacer(minLength: 60)
                
                ZStack {
                    Circle()
                        .fill(ColorTheme.lightBlue.opacity(0.2))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: page.icon)
                        .font(.system(size: 50, weight: .medium))
                        .foregroundColor(ColorTheme.lightBlue)
                }
                .padding(.top, 40)
                
                Text(page.title)
                    .font(.ubuntu(32, weight: .bold))
                    .foregroundColor(ColorTheme.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Text(page.description)
                    .font(.ubuntu(16))
                    .foregroundColor(ColorTheme.textSecondary)
                    .lineSpacing(4)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 25)
                
                Spacer(minLength: 40)
            }
        }
    }
}

struct PageIndicator: View {
    let currentPage: Int
    let totalPages: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? ColorTheme.lightBlue : ColorTheme.textSecondary.opacity(0.3))
                    .frame(width: index == currentPage ? 10 : 8, height: index == currentPage ? 10 : 8)
                    .animation(.easeInOut, value: currentPage)
            }
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
