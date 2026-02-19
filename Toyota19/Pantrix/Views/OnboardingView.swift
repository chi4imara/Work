import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var isCompleted: Bool
    
    private let onboardingPages = [
        OnboardingPage(
            title: "Start Your Day Right",
            description: "Find quick breakfast recipes that will give you energy and boost your mood.",
            systemImage: "sunrise.fill"
        ),
        OnboardingPage(
            title: "Quick and Delicious",
            description: "All recipes can be prepared in just 10-15 minutes.",
            systemImage: "timer"
        ),
        OnboardingPage(
            title: "Your Favorite Breakfasts",
            description: "Save recipes, track progress and plan your week ahead.",
            systemImage: "heart.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    ForEach(0..<onboardingPages.count, id: \.self) { index in
                        Capsule()
                            .fill(index <= currentPage ? Color.appOrange : Color.appWhite.opacity(0.3))
                            .frame(width: index == currentPage ? 30 : 8, height: 8)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingPages.count, id: \.self) { index in
                        OnboardingPageView(page: onboardingPages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 20) {
                    Button(action: {
                        if currentPage < onboardingPages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage += 1
                            }
                        } else {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                isCompleted = true
                                UserDefaults.standard.set(true, forKey: "OnboardingDone")
                            }
                        }
                    }) {
                        HStack {
                            Text(currentPage < onboardingPages.count - 1 ? "Continue" : "Get Started")
                                .font(.appHeadline)
                                .foregroundColor(.appWhite)
                            
                            if currentPage < onboardingPages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.appHeadline)
                                    .foregroundColor(.appWhite)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.appOrange)
                        .cornerRadius(16)
                    }
                    
                    if currentPage < onboardingPages.count - 1 {
                        Button("Skip") {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                isCompleted = true
                                UserDefaults.standard.set(true, forKey: "OnboardingDone")
                            }
                        }
                        .font(.appCallout)
                        .foregroundColor(.appWhite.opacity(0.7))
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width < -50 && currentPage < onboardingPages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    } else if gesture.translation.width > 50 && currentPage > 0 {
                        withAnimation(.easeInOut(duration: 0.3)) {
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
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.appOrange.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: page.systemImage)
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(.appOrange)
            }
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.appTitle)
                    .foregroundColor(.appWhite)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.appBody)
                    .foregroundColor(.appWhite.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let systemImage: String
}

#Preview {
    OnboardingView(isCompleted: .constant(false))
}
