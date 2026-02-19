import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appViewModel: AppViewModel
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    private let pages = [
        OnboardingPage(
            title: "Build your career with confidence",
            description: "Develop soft skills, track progress and move towards your professional goals with personalized courses and exercises.",
            imageName: "person.crop.circle.badge.checkmark"
        ),
        OnboardingPage(
            title: "Personalized Learning Path",
            description: "Get courses and exercises tailored to your career goals, skill level, and available time. Learn at your own pace.",
            imageName: "chart.line.uptrend.xyaxis"
        ),
        OnboardingPage(
            title: "Track Your Progress",
            description: "Monitor your development with detailed analytics, achievements, and insights into your skill growth over time.",
            imageName: "star.circle.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index], isAnimating: isAnimating)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                .onChange(of: currentPage) { _ in
                    isAnimating = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            isAnimating = true
                        }
                    }
                }
                
                Spacer()
                
                HStack(spacing: 16) {
                    if currentPage > 0 {
                        Button(action: {
                            withAnimation {
                                currentPage -= 1
                            }
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Previous")
                                    .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                            }
                            .foregroundColor(Color.theme.primaryBlue)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.theme.primaryBlue, lineWidth: 2)
                            )
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                appViewModel.completeOnboarding()
                            }
                        }
                    }) {
                        HStack {
                            Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                                .foregroundColor(.white)
                            
                            Image(systemName: currentPage < pages.count - 1 ? "chevron.right" : "arrow.right")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.theme.buttonGradient)
                        .cornerRadius(28)
                        .shadow(color: Color.theme.primaryYellow.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
                .opacity(isAnimating ? 1.0 : 0.0)
                .offset(y: isAnimating ? 0 : 30)
                .animation(.easeOut(duration: 0.8).delay(0.7), value: isAnimating)
            }
        }
        .onAppear {
            withAnimation {
                isAnimating = true
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let isAnimating: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Image(systemName: page.imageName)
                .font(.system(size: 120))
                .foregroundColor(Color.theme.primaryBlue)
                .scaleEffect(isAnimating ? 1.0 : 0.8)
                .animation(.easeInOut(duration: 0.8), value: isAnimating)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.custom("PlayfairDisplay-Bold", size: 32))
                    .foregroundColor(Color.theme.primaryBlue)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.3), value: isAnimating)
                
                Text(page.description)
                    .font(.custom("PlayfairDisplay-Regular", size: 18))
                    .foregroundColor(Color.theme.darkGray)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.5), value: isAnimating)
            }
            .padding(.horizontal, 40)
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}

#Preview {
    OnboardingView(appViewModel: AppViewModel())
}
