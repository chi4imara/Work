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
                        icon: "tshirt",
                        title: "Your seasonal wardrobe journal.",
                        description: "Keep a clear record of what you wear each season. Add clothing items, assign them to spring, summer, autumn, or winter, and leave short notes. Over time, this journal becomes a practical reference that helps you navigate your wardrobe and choose items with confidence as seasons change.",
                        pageIndex: 0
                    )
                    .tag(0)
                    
                    OnboardingPageView(
                        icon: "calendar",
                        title: "Organize by seasons",
                        description: "Easily categorize your clothing items by season. Whether it's a light spring jacket or a warm winter coat, assign each item to the appropriate season for quick access when you need it most.",
                        pageIndex: 1
                    )
                    .tag(1)
                    
                    OnboardingPageView(
                        icon: "heart",
                        title: "Mark your favorites",
                        description: "Keep track of your most loved items by adding them to favorites. This makes it easy to find your go-to pieces quickly and build outfits with confidence throughout the year.",
                        pageIndex: 2
                    )
                    .tag(2)
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                HStack(spacing: 12) {
                    if currentPage < 2 {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage += 1
                            }
                        }) {
                            Text("Next")
                                .font(FontManager.bauhausMedium(18))
                                .foregroundColor(AppColors.contrastText)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppColors.primaryBlue)
                                .cornerRadius(12)
                        }
                    } else {
                        Button(action: {
                            showOnboarding = false
                        }) {
                            Text("Get Started")
                                .font(FontManager.bauhausMedium(18))
                                .foregroundColor(AppColors.contrastText)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppColors.primaryBlue)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
    }
}

struct OnboardingPageView: View {
    let icon: String
    let title: String
    let description: String
    let pageIndex: Int
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryBlue)
            
            VStack(spacing: 20) {
                Text(title)
                    .font(FontManager.bauhausBold(24))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(FontManager.bauhausLight(16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
