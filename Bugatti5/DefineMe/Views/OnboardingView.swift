import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPageView(
                        systemImage: "book.fill",
                        title: "Build your personal glossary",
                        description: "This app lets you save terms, words, and concepts with your own explanations. You create short entries, write meanings in your own words, and browse them anytime you need clarity. It's a simple space to build a personal glossary that reflects how you understand ideas and language."
                    )
                    .tag(0)
                    
                    OnboardingPageView(
                        systemImage: "pencil.and.outline",
                        title: "Create custom definitions",
                        description: "Add any term or concept and write your own explanation. Make it as detailed or as simple as you need. Your personal dictionary, your way."
                    )
                    .tag(1)
                    
                    OnboardingPageView(
                        systemImage: "magnifyingglass",
                        title: "Quick access to knowledge",
                        description: "Easily browse and search through your saved terms. Find exactly what you're looking for when you need it most."
                    )
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack(spacing: 12) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? AppColors.accentYellow : AppColors.primaryText.opacity(0.3))
                            .frame(width: 10, height: 10)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.vertical, 30)
                
                Button("Continue") {
                    if currentPage < 2 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage += 1
                        }
                    } else {
                        showOnboarding = true
                        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                    }
                }
                .buttonStyle(.primary)
                .padding(.horizontal, 20)
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPageView: View {
    let systemImage: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: systemImage)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.accentYellow)
                .padding(.bottom, 20)
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Text(description)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 30)
            }
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
