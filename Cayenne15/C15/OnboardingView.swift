import SwiftUI

struct OnboardingView: View {
    let onComplete: () -> Void
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            ColorManager.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPage(
                        icon: "car.fill",
                        title: "Keep track of your car care.",
                        description: "Record every car wash, refuel and maintenance task in one clean place. Add new entries in seconds, review your service history and stay organized.",
                        pageIndex: 0
                    )
                    .tag(0)
                    
                    OnboardingPage(
                        icon: "chart.bar.fill",
                        title: "Monitor your maintenance.",
                        description: "Track your car's service history with detailed statistics. See how often you perform each type of maintenance and keep your vehicle in perfect condition.",
                        pageIndex: 1
                    )
                    .tag(1)
                    
                    OnboardingPage(
                        icon: "clock.fill",
                        title: "Never miss a service.",
                        description: "A simple way to keep your car care routine consistent and always know what was done and when. Stay organized and maintain your vehicle effortlessly.",
                        pageIndex: 2
                    )
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                VStack(spacing: 20) {
                    PageIndicator(currentPage: currentPage, totalPages: 3)
                    
                    HStack(spacing: 15) {
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
                                        .font(FontManager.playfairSemiBold(size: 16))
                                }
                                .foregroundColor(ColorManager.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(ColorManager.darkBlue.opacity(0.5))
                                .cornerRadius(25)
                            }
                        }
                        
                        Button(action: {
                            if currentPage < 2 {
                                withAnimation {
                                    currentPage += 1
                                }
                            } else {
                                onComplete()
                            }
                        }) {
                            HStack {
                                Text(currentPage < 2 ? "Next" : "Continue")
                                    .font(FontManager.playfairSemiBold(size: 18))
                                Image(systemName: currentPage < 2 ? "chevron.right" : "checkmark")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(ColorManager.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(ColorManager.accentGradient)
                            .cornerRadius(28)
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                }
            }
        }
    }
}

struct OnboardingPage: View {
    let icon: String
    let title: String
    let description: String
    let pageIndex: Int
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(ColorManager.lightBlue.opacity(0.2))
                        .frame(width: 180, height: 180)
                    
                    Image(systemName: icon)
                        .font(.system(size: 60))
                        .foregroundColor(ColorManager.lightBlue)
                }
            }
            
            VStack(spacing: 20) {
                Text(title)
                    .font(FontManager.playfairBold(size: 28))
                    .foregroundColor(ColorManager.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Text(description)
                    .font(FontManager.playfairRegular(size: 16))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
    }
}

struct PageIndicator: View {
    let currentPage: Int
    let totalPages: Int
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<totalPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? ColorManager.orange : ColorManager.secondaryText.opacity(0.3))
                    .frame(width: index == currentPage ? 12 : 8, height: index == currentPage ? 12 : 8)
                    .animation(.easeInOut(duration: 0.3), value: currentPage)
            }
        }
    }
}

#Preview {
    OnboardingView(onComplete: {})
}
