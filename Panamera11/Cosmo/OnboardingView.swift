import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            title: "Your beauty collection, clearly organized.",
            description: "Create a personal catalog of your cosmetics with photos, shades, textures, and usage notes.",
            imageName: "sparkles.rectangle.stack"
        ),
        OnboardingPage(
            title: "Remember what you own",
            description: "Easily remember what you own, where each product fits best, and what you've already used.",
            imageName: "photo.on.rectangle.angled"
        ),
        OnboardingPage(
            title: "Stay organized",
            description: "Keep everything structured and accessible whenever you need to choose the right product.",
            imageName: "folder.badge.gearshape"
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
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
                
                VStack(spacing: 24) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.accentYellow : AppColors.primaryText.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage += 1
                            }
                        } else {
                            showOnboarding = true
                            UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                        }
                    }) {
                        Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                            .font(.bellGothic(18, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(AppColors.accentYellow)
                            )
                    }
                    .padding(.horizontal, 40)
                    
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            showOnboarding = true
                            UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                        }
                        .font(.bellGothic(16))
                        .foregroundColor(AppColors.secondaryText)
                    }
                }
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: page.imageName)
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(AppColors.accentYellow)
                
                HStack(spacing: 12) {
                    ForEach(0..<3) { _ in
                        Circle()
                            .fill(AppColors.primaryText.opacity(0.3))
                            .frame(width: 6, height: 6)
                    }
                }
            }
            
            Spacer()
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.bellGothic(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(.bellGothic(16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
