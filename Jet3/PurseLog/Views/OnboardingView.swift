import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var isAnimating = false
    let onComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            title: "Organize your bag collection by style",
            description: "Create your personal catalog of handbags — from everyday totes to evening clutches and travel essentials.",
            imageName: "handbag.fill"
        ),
        OnboardingPage(
            title: "Track and analyze your style",
            description: "Keep your collection organized, track which bags you use most, and find the perfect match for any occasion.",
            imageName: "chart.bar.fill"
        ),
        OnboardingPage(
            title: "Simple, elegant, structured",
            description: "Made for those who love style with structure. Start building your perfect handbag collection today.",
            imageName: "star.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(
                            page: pages[index],
                            isAnimating: isAnimating
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 30) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.primaryYellow : AppColors.primaryText.opacity(0.3))
                                .frame(width: currentPage == index ? 12 : 8, height: currentPage == index ? 12 : 8)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        if currentPage < pages.count - 1 {
                            Button("Continue") {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    currentPage += 1
                                }
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            
                            Button("Skip") {
                                onComplete()
                            }
                            .buttonStyle(SecondaryButtonStyle())
                        } else {
                            Button("Get Started") {
                                onComplete()
                            }
                            .buttonStyle(PrimaryButtonStyle())
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                isAnimating = true
            }
        }
        .onChange(of: currentPage) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                isAnimating.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isAnimating.toggle()
                }
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
    let isAnimating: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.primaryYellow.opacity(0.2))
                    .frame(width: 150, height: 150)
                    .scaleEffect(isAnimating ? 1.0 : 0.8)
                
                Image(systemName: page.imageName)
                    .font(.system(size: 55, weight: .light))
                    .foregroundColor(AppColors.primaryYellow)
                    .scaleEffect(isAnimating ? 1.0 : 0.8)
            }
            .animation(.easeInOut(duration: 0.8), value: isAnimating)
            
            VStack(spacing: 15) {
                Text(page.title)
                    .font(FontManager.ubuntu(.bold, size: 22))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)
                
                Text(page.description)
                    .font(FontManager.ubuntu(.regular, size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)
            }
            .padding(.horizontal, 40)
            .animation(.easeInOut(duration: 0.8).delay(0.2), value: isAnimating)
            
            Spacer()
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(FontManager.ubuntu(.medium, size: 18))
            .foregroundColor(AppColors.primaryText)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(AppColors.buttonPrimary)
            .cornerRadius(28)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(FontManager.ubuntu(.medium, size: 16))
            .foregroundColor(AppColors.darkText)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color.white.opacity(0.95))
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(AppColors.primaryYellow.opacity(0.3), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView {
            print("Onboarding completed")
        }
    }
}
