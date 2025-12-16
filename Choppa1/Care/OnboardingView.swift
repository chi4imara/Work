import SwiftUI

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            title: "Your personal beauty salon at home",
            description: "Keep track of your self-care rituals and beauty treatments right at home.",
            imageName: "house.fill"
        ),
        OnboardingPage(
            title: "Track Your Procedures",
            description: "Record your nail, hair, or skincare sessions — note the date, products used, and your impressions.",
            imageName: "calendar"
        ),
        OnboardingPage(
            title: "Stay Organized",
            description: "See what you've done recently, what's due again, and which products you reach for most. Stay organized, consistent, and confident in your self-care routine — all in one simple app.",
            imageName: "chart.bar.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? AppColors.primaryText : AppColors.secondaryText)
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 50)
                
                Spacer()
                
                VStack(spacing: 30) {
                    Image(systemName: pages[currentPage].imageName)
                        .font(.system(size: 80))
                        .foregroundColor(AppColors.primaryText)
                    
                    VStack(spacing: 16) {
                        Text(pages[currentPage].title)
                            .font(.custom("PlayfairDisplay-Bold", size: 28))
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.center)
                        
                        Text(pages[currentPage].description)
                            .font(.custom("PlayfairDisplay-Regular", size: 16))
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                }
                
                Spacer()
                
                HStack {
                    if currentPage > 0 {
                        Button("Back") {
                            withAnimation(.easeInOut) {
                                currentPage -= 1
                            }
                        }
                        .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Spacer()
                    
                    Button {
                        if currentPage == pages.count - 1 {
                            dismiss()
                        } else {
                            withAnimation(.easeInOut) {
                                currentPage += 1
                            }
                        }
                    } label: {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .background(AppColors.purpleGradient)
                            .foregroundColor(.white)
                            .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                            .cornerRadius(25)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}

#Preview {
    OnboardingView()
}
