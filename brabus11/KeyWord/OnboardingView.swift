import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appViewModel: AppViewModel
    @State private var currentPage = 0
    @State private var animateContent = false
    @Binding var showOnboarding: Bool
    
    private let pages = [
        OnboardingPage(
            title: "Your personal space for words.",
            description: "This app helps you collect words and expressions that feel meaningful to you. Save phrases you love, add your own definitions or personal associations.",
            imageName: "book.fill",
            color: ColorManager.primaryBlue
        ),
        OnboardingPage(
            title: "Build your vocabulary",
            description: "Create a private vocabulary shaped by how you think and speak. Nothing to memorize or organize — just words that stay with you.",
            imageName: "heart.text.square.fill",
            color: ColorManager.accentPurple
        ),
        OnboardingPage(
            title: "Start collecting",
            description: "Ready to begin your personal word collection? Let's create your first entry and start building your unique dictionary.",
            imageName: "plus.circle.fill",
            color: ColorManager.primaryYellow
        )
    ]
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            FloatingBubblesView()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(
                            page: pages[index],
                            isActive: currentPage == index
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                VStack(spacing: 20) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? ColorManager.primaryBlue : ColorManager.lightGray)
                                .frame(width: 10, height: 10)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    .padding(.bottom, 10)
                    
                    HStack(spacing: 20) {
                        if currentPage > 0 {
                            Button {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentPage -= 1
                                }
                            } label: {
                                Text("Back")
                                    .font(.playfairDisplay(14, weight: .medium))
                                    .foregroundColor(ColorManager.textBlue)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(Color.white.opacity(0.8))
                                    )
                            }
                            
                            Spacer()
                        }
                        
                        Button {
                            if currentPage == pages.count - 1 {
                                appViewModel.completeOnboarding()
                                showOnboarding = true
                                UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                            } else {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentPage += 1
                                }
                            }
                        } label: {
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                                .font(.playfairDisplay(14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 15)
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(
                                        colors: [ColorManager.primaryBlue, ColorManager.accentPurple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .shadow(color: ColorManager.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            animateContent = true
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let isActive: Bool
    @State private var animateIcon = false
    @State private var animateText = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                page.color.opacity(0.2),
                                page.color.opacity(0.05)
                            ],
                            center: .center,
                            startRadius: 20,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                    .scaleEffect(animateIcon ? 1.0 : 0.8)
                    .animation(.spring(response: 0.8, dampingFraction: 0.6), value: animateIcon)
                
                Image(systemName: page.imageName)
                    .font(.system(size: 60, weight: .medium))
                    .foregroundColor(page.color)
                    .scaleEffect(animateIcon ? 1.0 : 0.5)
                    .animation(.spring(response: 1.0, dampingFraction: 0.7).delay(0.2), value: animateIcon)
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.playfairDisplay(28, weight: .bold))
                    .foregroundColor(ColorManager.textBlue)
                    .multilineTextAlignment(.center)
                    .opacity(animateText ? 1.0 : 0.0)
                    .offset(y: animateText ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: animateText)
                
                Text(page.description)
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(ColorManager.darkGray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .opacity(animateText ? 1.0 : 0.0)
                    .offset(y: animateText ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: animateText)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .onChange(of: isActive) { newValue in
            if newValue {
                animateIcon = true
                animateText = true
            } else {
                animateIcon = false
                animateText = false
            }
        }
        .onAppear {
            if isActive {
                animateIcon = true
                animateText = true
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
    let color: Color
}
