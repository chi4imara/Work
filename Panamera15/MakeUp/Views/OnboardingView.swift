import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var makeupStore: MakeupStore
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            image: "paintbrush.pointed.fill",
            title: "Save makeup ideas you love.",
            description: "Create a personal catalog of makeup ideas with photos and style tags. Save looks that inspire you, organize them by occasion or mood, and quickly find the right style whenever you need it."
        ),
        OnboardingPage(
            image: "tag.fill",
            title: "Organize with smart tags",
            description: "Tag your ideas by occasion, style, or mood. Evening, natural, glam, office - organize your looks exactly how you think about them."
        ),
        OnboardingPage(
            image: "heart.fill",
            title: "Keep your favorites close",
            description: "Mark your best looks as favorites for quick access. A simple and visual way to keep all your makeup inspiration in one place."
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
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
                
                pageIndicators
                
                continueButton
                
                Spacer(minLength: 50)
            }
        }
    }
    
    private var pageIndicators: some View {
        HStack(spacing: 12) {
            ForEach(0..<pages.count, id: \.self) { index in
                Circle()
                    .fill(currentPage == index ? AppColors.white : AppColors.white.opacity(0.4))
                    .frame(width: 8, height: 8)
                    .scaleEffect(currentPage == index ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: currentPage)
            }
        }
        .padding(.bottom, 40)
    }
    
    private var continueButton: some View {
        Button(action: {
            if currentPage < pages.count - 1 {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentPage += 1
                }
            } else {
                makeupStore.completeOnboarding()
            }
        }) {
            Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                .font(.bauhausMedium(18))
                .foregroundColor(AppColors.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppColors.buttonGradient)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .shadow(color: AppColors.purple.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 20)
    }
}

struct OnboardingPage {
    let image: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: page.image)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.white)
                .padding(.bottom, 20)
            
            Text(page.title)
                .font(.bauhausBold(32))
                .foregroundColor(AppColors.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            Text(page.description)
                .font(.bauhausLight(18))
                .foregroundColor(AppColors.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(MakeupStore())
    }
}
