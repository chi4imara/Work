import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var viewModel: GroomingViewModel
    @State private var currentPage = 0
    @Binding var showMainApp: Bool
    
    let onboardingPages = [
        OnboardingPage(
            title: "Take care of yourself every day",
            description: "Plan procedures, track progress and create routines."
        ),
        OnboardingPage(
            title: "Small steps - big results",
            description: "Monitor skin, hair, beard and health - create habits and mini-challenges."
        ),
        OnboardingPage(
            title: "Let's start together",
            description: "Daily reminders, visual rewards and micro-support will help you stay in shape and style."
        )
    ]
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingPages.count, id: \.self) { index in
                        OnboardingPageView(page: onboardingPages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 30) {
                    HStack(spacing: 8) {
                        ForEach(0..<onboardingPages.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? Color.primaryOrange : Color.primaryWhite.opacity(0.3))
                                .frame(width: 10, height: 10)
                                .scaleEffect(index == currentPage ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    .padding(.top, 20)
                    
                    Button(action: {
                        if currentPage < onboardingPages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentPage += 1
                            }
                        } else {
                            showMainApp = true
                            UserDefaults.standard.set(true, forKey: "OnDone")
                        }
                    }) {
                        HStack {
                            Text(currentPage < onboardingPages.count - 1 ? "Continue" : "Get Started")
                                .font(FontManager.playfairDisplay(.semibold, size: 18))
                                .foregroundColor(.primaryWhite)
                            
                            if currentPage < onboardingPages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.primaryWhite)
                                    .font(.system(size: 16, weight: .semibold))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Color.primaryOrange)
                        )
                        .shadow(color: Color.primaryOrange.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                }
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -50 && currentPage < onboardingPages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage += 1
                        }
                    } else if value.translation.width > 50 && currentPage > 0 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage -= 1
                        }
                    }
                }
        )
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.cardGradient)
                    .frame(width: 200, height: 200)
                
                Image(systemName: getIconForPage())
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(.primaryOrange)
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(FontManager.playfairDisplay(.bold, size: 28))
                    .foregroundColor(.primaryWhite)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Text(page.description)
                    .font(FontManager.playfairDisplay(.regular, size: 18))
                    .foregroundColor(.primaryWhite.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .lineSpacing(4)
            }
            
            Spacer()
        }
    }
    
    private func getIconForPage() -> String {
        switch page.title {
        case "Take care of yourself every day":
            return "calendar.badge.clock"
        case "Small steps - big results":
            return "chart.line.uptrend.xyaxis"
        case "Let's start together":
            return "hand.wave"
        default:
            return "star"
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
}

