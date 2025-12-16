import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appState: AppStateViewModel
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPageView(
                        imageName: "paintbrush.pointed.fill",
                        title: "Bring structure to your creativity",
                        description: "Turn your craft ideas into an organized gallery of projects. Save every inspiration — from knitting to embroidery — with photos, materials, and step-by-step progress."
                    )
                    .tag(0)
                    
                    OnboardingPageView(
                        imageName: "list.bullet.clipboard.fill",
                        title: "Track your progress",
                        description: "Track what's done, what's next, and what you'll need for your next creation. Your handmade world, beautifully organized and always within reach."
                    )
                    .tag(1)
                    
                    OnboardingPageView(
                        imageName: "heart.fill",
                        title: "Create with confidence",
                        description: "Never lose track of your creative ideas again. From concept to completion, keep all your projects organized in one beautiful space."
                    )
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.theme.primaryYellow : Color.theme.primaryBlue.opacity(0.3))
                            .frame(width: 10, height: 10)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.top, 20)
                
                Spacer()
                
                Button(action: {
                    if currentPage < 2 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage += 1
                        }
                    } else {
                        appState.completeOnboarding()
                    }
                }) {
                    Text(currentPage < 2 ? "Continue" : "Get Started")
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(Color.theme.buttonText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.theme.buttonBackground)
                                .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
                        )
                }
                .padding(.horizontal, 40)
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
                .font(.system(size: 80, weight: .light))
                .foregroundColor(Color.theme.primaryPurple)
                .padding(.top, 60)
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.playfairDisplay(28, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(description)
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 30)
            }
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(appState: AppStateViewModel())
}
