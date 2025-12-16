import SwiftUI

struct OnboardingView: View {
    @ObservedObject var dataManager = DataManager.shared
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    private let pages = [
        OnboardingPage(
            title: "Care Routine for Your Pet",
            description: "This app helps you keep track of your pet's daily care — feeding, walks, vitamins, and vet visits.",
            imageName: "heart.fill"
        ),
        OnboardingPage(
            title: "Track Every Moment",
            description: "Each action you log builds a clear picture of your routine and keeps your furry friend healthy and happy.",
            imageName: "calendar"
        ),
        OnboardingPage(
            title: "See Your Progress",
            description: "See what you've done today, review past days, and notice patterns in your care habits. Small, consistent attention makes a big difference — for both of you.",
            imageName: "chart.line.uptrend.xyaxis"
        )
    ]
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(0..<8) { i in
                Circle()
                    .fill(Color.white.opacity(0.05))
                    .frame(width: CGFloat(60 + i * 30), height: CGFloat(60 + i * 30))
                    .offset(
                        x: CGFloat.random(in: -200...200),
                        y: CGFloat.random(in: -400...400)
                    )
                    .scaleEffect(isAnimating ? 1.1 : 0.9)
                    .animation(
                        Animation.easeInOut(duration: 3.0 + Double(i) * 0.5)
                            .repeatForever(autoreverses: true)
                            .delay(Double(i) * 0.3),
                        value: isAnimating
                    )
            }
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                VStack(spacing: 30) {
                    HStack(spacing: 12) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.white : Color.white.opacity(0.3))
                                .frame(width: 12, height: 12)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.spring(response: 0.3), value: currentPage)
                        }
                    }
                    
                    HStack(spacing: 20) {
                        if currentPage > 0 {
                            Button {
                                withAnimation {
                                    currentPage -= 1
                                }
                            } label: {
                                Text("Back")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(25)
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            if currentPage == pages.count - 1 {
                                withAnimation {
                                    dataManager.completeOnboarding()
                                }
                            } else {
                                withAnimation {
                                    currentPage += 1
                                }
                            }
                        } label: {
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 32)
                                .padding(.vertical, 16)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.theme.primaryPurple, Color.theme.secondaryPurple]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(30)
                                .shadow(color: Color.theme.primaryPurple.opacity(0.3), radius: 10, x: 0, y: 5)
                                .scaleEffect(isAnimating ? 1.05 : 1.0)
                                .animation(
                                    Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                                    value: isAnimating
                                )
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            isAnimating = true
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
    @State private var isVisible = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(.white)
                .scaleEffect(isVisible ? 1.0 : 0.5)
                .opacity(isVisible ? 1.0 : 0.0)
                .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2), value: isVisible)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.ubuntu(32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .offset(y: isVisible ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: isVisible)
                
                Text(page.description)
                    .font(.ubuntu(18, weight: .regular))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 30)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .offset(y: isVisible ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: isVisible)
            }
            
            Spacer()
            Spacer()
        }
        .onAppear {
            withAnimation {
                isVisible = true
            }
        }
        .onDisappear {
            isVisible = false
        }
    }
}

#Preview {
    OnboardingView()
}
