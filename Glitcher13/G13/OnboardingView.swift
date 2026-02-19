import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPageView(
                        icon: "flask.fill",
                        title: "Track your cosmetic experiments.",
                        description: "Save every new product you try, note how well it worked for you, and build a clear personal history of your cosmetic experiments. Keep all your impressions organized, compare past results, and easily return to the products that suited you best.",
                        iconColor: AppColors.yellow,
                        pageNumber: 1
                    )
                    .tag(0)
                    
                    OnboardingPageView(
                        icon: "square.grid.2x2.fill",
                        title: "Organize by categories.",
                        description: "Categorize your products into skincare, makeup, cleansing, fragrance, and more. Easily filter and find products by category to track your preferences and discover patterns in what works best for you.",
                        iconColor: AppColors.lightBlue,
                        pageNumber: 2
                    )
                    .tag(1)
                    
                    OnboardingPageView(
                        icon: "heart.fill",
                        title: "Save your favorites.",
                        description: "Mark products that worked well as favorites for quick access. Rate each experiment as liked, neutral, or disliked to build a comprehensive database of your cosmetic journey and make informed decisions.",
                        iconColor: AppColors.pink,
                        pageNumber: 3
                    )
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                VStack(spacing: 24) {
                    HStack(spacing: 10) {
                        ForEach(0..<3, id: \.self) { index in
                            Capsule()
                                .fill(index == currentPage ? AppColors.yellow : AppColors.mediumGray.opacity(0.3))
                                .frame(width: index == currentPage ? 24 : 8, height: 8)
                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                        }
                    }
                    .padding(.top, 30)
                    
                    HStack(spacing: 12) {
                        if currentPage > 0 {
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    currentPage -= 1
                                }
                            }) {
                                HStack {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 14, weight: .semibold))
                                    Text("Back")
                                        .font(.playfair(16, weight: .medium))
                                }
                                .foregroundColor(AppColors.blueText)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.cardGradient)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(AppColors.lightBlue.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            }
                        }
                        
                        Button(action: {
                            if currentPage < 2 {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    currentPage += 1
                                }
                            } else {
                                showOnboarding = true
                                UserDefaults.standard.set(true, forKey: "HasOnboardingCompleted")
                            }
                        }) {
                            HStack {
                                Text(currentPage < 2 ? "Next" : "Get Started")
                                    .font(.playfair(18, weight: .semibold))
                                    .foregroundColor(AppColors.white)
                                
                                Image(systemName: currentPage < 2 ? "arrow.right" : "checkmark")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(AppColors.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                LinearGradient(
                                    colors: [AppColors.yellow, AppColors.lightBlue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: AppColors.yellow.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 50)
                }
            }
        }
    }
}

struct OnboardingPageView: View {
    let icon: String
    let title: String
    let description: String
    let iconColor: Color
    let pageNumber: Int
    
    @State private var iconScale: CGFloat = 0.8
    @State private var iconRotation: Double = 0
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    iconColor.opacity(0.15),
                                    iconColor.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 150, height: 150)
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            iconColor.opacity(0.3),
                                            iconColor.opacity(0.1)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                    
                    ZStack {
                        Circle()
                            .fill(AppColors.cardGradient)
                            .frame(width: 125, height: 125)
                            .shadow(color: iconColor.opacity(0.2), radius: 20, x: 0, y: 10)
                        
                        Image(systemName: icon)
                            .font(.system(size: 50, weight: .medium))
                            .foregroundColor(iconColor)
                    }
                    .scaleEffect(iconScale)
                    .rotationEffect(.degrees(iconRotation))
                }
                
                VStack(spacing: 20) {
                    Text(title)
                        .font(.playfair(30, weight: .bold))
                        .foregroundColor(AppColors.blueText)
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)
                    
                    Text(description)
                        .font(.playfair(16, weight: .regular))
                        .foregroundColor(AppColors.darkGray)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                        .padding(.horizontal, 10)
                }
                .padding(.horizontal, 30)
            }
            
            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                iconScale = 1.0
            }
            withAnimation(.easeInOut(duration: 0.5)) {
                iconRotation = 5
            }
        }
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
