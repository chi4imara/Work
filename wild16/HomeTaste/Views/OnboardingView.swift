import SwiftUI

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    private let pages = [
        OnboardingPage(
            image: "book.closed",
            title: "Save your homemade magic.",
            description: "This app helps you keep the taste of home alive. Write down your quick recipes — the ones you invent, adjust, and love to repeat."
        ),
        OnboardingPage(
            image: "heart.text.square",
            title: "Your personal collection",
            description: "It's not about measurements or perfect photos. It's about remembering how it felt when something turned out delicious."
        ),
        OnboardingPage(
            image: "house.and.flag",
            title: "Always with you",
            description: "Each card is your story: a small note, a warm dish, a memory of comfort. Home recipes are part of who you are. Now you'll never lose them — they'll stay right here, in your pocket."
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index], isAnimating: $isAnimating)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                VStack(spacing: 30) {
                    HStack(spacing: 12) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.primaryBlue : AppColors.primaryBlue.opacity(0.3))
                                .frame(width: 10, height: 10)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    VStack(spacing: 16) {
                        if currentPage < pages.count - 1 {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    currentPage += 1
                                }
                            }) {
                                HStack {
                                    Text("Continue")
                                        .font(FontManager.headline)
                                        .foregroundColor(.white)
                                    
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(AppColors.primaryBlue)
                                .cornerRadius(25)
                            }
                            
                            Button(action: {
                                hasSeenOnboarding = true
                            }) {
                                Text("Skip")
                                    .font(FontManager.callout)
                                    .foregroundColor(AppColors.textSecondary)
                            }
                        } else {
                            Button(action: {
                                hasSeenOnboarding = true
                            }) {
                                HStack {
                                    Text("Get Started")
                                        .font(FontManager.headline)
                                        .foregroundColor(.white)
                                    
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    LinearGradient(
                                        colors: [AppColors.primaryBlue, AppColors.primaryYellow],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(25)
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            isAnimating = true
        }
        .onChange(of: currentPage) { _ in
            isAnimating = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isAnimating = true
            }
        }
    }
}

struct OnboardingPage {
    let image: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @Binding var isAnimating: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 160, height: 160)
                    .scaleEffect(isAnimating ? 1.0 : 0.8)
                    .animation(.easeOut(duration: 0.8), value: isAnimating)
                
                Image(systemName: page.image)
                    .font(.system(size: 55, weight: .light))
                    .foregroundColor(AppColors.primaryBlue)
                    .scaleEffect(isAnimating ? 1.0 : 0.5)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: isAnimating)
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(FontManager.title1)
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: isAnimating)
                
                Text(page.description)
                    .font(FontManager.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: isAnimating)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}
