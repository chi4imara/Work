import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPageView(
                        icon: "flask.fill",
                        secondaryIcon: "heart.fill",
                        title: "Collect your personal beauty recipes.",
                        description: "Save your homemade beauty mixes, from hair masks to aromatic scrubs and creative cosmetic blends. Organize your formulas, keep all your notes in one place, and easily return to the recipes you want to recreate again.",
                        pageIndex: 0,
                        currentPage: $currentPage,
                        showOnboarding: $showOnboarding
                    )
                    .tag(0)
                    
                    OnboardingPageView(
                        icon: "folder.fill",
                        secondaryIcon: "tag.fill",
                        title: "Organize by categories.",
                        description: "Categorize your recipes into scrubs, hair masks, cosmetic mixes, and more. Find what you need quickly with our intuitive category system. Keep your beauty collection perfectly organized.",
                        pageIndex: 1,
                        currentPage: $currentPage,
                        showOnboarding: $showOnboarding
                    )
                    .tag(1)
                    
                    OnboardingPageView(
                        icon: "star.fill",
                        secondaryIcon: "bookmark.fill",
                        title: "Never lose your favorites.",
                        description: "Mark your best recipes as favorites for instant access. Build your personal collection of go-to beauty formulas. Everything you love, always at your fingertips.",
                        pageIndex: 2,
                        isLastPage: true,
                        currentPage: $currentPage,
                        showOnboarding: $showOnboarding
                    )
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                VStack(spacing: 20) {
                    HStack(spacing: 12) {
                        ForEach(0..<3, id: \.self) { index in
                            Capsule()
                                .fill(index == currentPage ? ColorManager.accent : ColorManager.secondaryText.opacity(0.3))
                                .frame(width: index == currentPage ? 32 : 8, height: 8)
                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

struct OnboardingPageView: View {
    let icon: String
    let secondaryIcon: String
    let title: String
    let description: String
    let pageIndex: Int
    var isLastPage: Bool = false
    @Binding var currentPage: Int
    @Binding var showOnboarding: Bool
    @State private var iconScale: CGFloat = 0.8
    @State private var iconRotation: Double = 0
    
    init(icon: String, secondaryIcon: String, title: String, description: String, pageIndex: Int, isLastPage: Bool = false, currentPage: Binding<Int>, showOnboarding: Binding<Bool>) {
        self.icon = icon
        self.secondaryIcon = secondaryIcon
        self.title = title
        self.description = description
        self.pageIndex = pageIndex
        self.isLastPage = isLastPage
        self._currentPage = currentPage
        self._showOnboarding = showOnboarding
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    ColorManager.accent.opacity(0.3),
                                    ColorManager.yellow.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 220, height: 220)
                        .blur(radius: 20)
                    
                    ZStack {
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        ColorManager.accent.opacity(0.4),
                                        ColorManager.yellow.opacity(0.3)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                            .frame(width: 190, height: 190)
                        
                        Circle()
                            .fill(ColorManager.cardGradient)
                            .frame(width: 170, height: 170)
                            .overlay(
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                ColorManager.accent.opacity(0.5),
                                                ColorManager.yellow.opacity(0.3)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                        
                        VStack(spacing: 20) {
                            Image(systemName: icon)
                                .font(.system(size: 55, weight: .medium))
                                .foregroundColor(ColorManager.accent)
                                .scaleEffect(iconScale)
                                .rotationEffect(.degrees(iconRotation))
                                .shadow(color: ColorManager.accent.opacity(0.5), radius: 10, x: 0, y: 5)
                            
                            Image(systemName: secondaryIcon)
                                .font(.system(size: 25, weight: .medium))
                                .foregroundColor(ColorManager.yellow)
                                .offset(y: -10)
                                .shadow(color: ColorManager.yellow.opacity(0.5), radius: 8, x: 0, y: 4)
                        }
                    }
                }
                .padding(.top, 30)
                
                VStack(spacing: 20) {
                    Text(title)
                        .font(.ubuntu(30, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding(.horizontal, 30)
                        .lineSpacing(2)
                    
                    Text(description)
                        .font(.ubuntu(16))
                        .foregroundColor(ColorManager.secondaryText)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding(.horizontal, 30)
                        .lineSpacing(3)
                }
                .padding(.top, 10)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                if pageIndex > 0 {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage -= 1
                        }
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Back")
                                .font(.ubuntu(16, weight: .semibold))
                        }
                        .foregroundColor(ColorManager.primaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(ColorManager.buttonBackground)
                        )
                    }
                }
                
                if isLastPage {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showOnboarding = true
                            UserDefaults.standard.set(true, forKey: "HasOnboardingCompleted")
                        }
                    }) {
                        HStack(spacing: 12) {
                            Text("Get Started")
                                .font(.ubuntu(18, weight: .semibold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .foregroundColor(ColorManager.primaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        colors: [ColorManager.accent, ColorManager.yellow],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: ColorManager.accent.opacity(0.4), radius: 15, x: 0, y: 8)
                        )
                    }
                } else {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    }) {
                        HStack(spacing: 12) {
                            Text("Continue")
                                .font(.ubuntu(18, weight: .semibold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .foregroundColor(ColorManager.primaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        colors: [ColorManager.accent, ColorManager.yellow],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: ColorManager.accent.opacity(0.4), radius: 15, x: 0, y: 8)
                        )
                    }
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                iconScale = 1.0
            }
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                iconRotation = 5
            }
        }
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
