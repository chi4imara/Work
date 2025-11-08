import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var isOnboardingComplete: Bool
    
    let pages = [
        OnboardingPage(
            title: "Keep every detail of your pets in one place",
            description: "Caring for pets means remembering a lot: birthdays, vaccinations, vet visits, treatments, funny little stories. This app helps you bring all that information together in one clear, well-structured catalog.",
            imageName: "heart.circle.fill"
        ),
        OnboardingPage(
            title: "Complete Pet Profiles",
            description: "You start by creating a profile for each of your pets. Add their name, species, breed, date of birth, gender, and any special notes. The app will instantly calculate their age and keep it up to date every day.",
            imageName: "person.crop.circle.fill"
        ),
        OnboardingPage(
            title: "Health Records & Memories",
            description: "Health comes first — here you can record vaccinations, treatments, and vet visits, making sure nothing is forgotten. It's not only about care, but also about memories. Add your own notes — from funny habits to favorite toys.",
            imageName: "cross.circle.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    AppColors.backgroundGradientStart,
                    AppColors.backgroundGradientEnd,
                    AppColors.secondaryBlue.opacity(0.2)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 24) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.primaryBlue : AppColors.primaryBlue.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                        }
                    }
                    
                    HStack(spacing: 16) {
                        if currentPage > 0 {
                            Button("Back") {
                                withAnimation {
                                    currentPage -= 1
                                }
                            }
                            .font(FontManager.subheadline)
                            .foregroundColor(AppColors.primaryText)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.white.opacity(0.8))
                            )
                        }
                        
                        Spacer()
                        
                        Button(currentPage == pages.count - 1 ? "Get Started" : "Continue") {
                            if currentPage == pages.count - 1 {
                                withAnimation {
                                    isOnboardingComplete = true
                                }
                            } else {
                                withAnimation {
                                    currentPage += 1
                                }
                            }
                        }
                        .font(FontManager.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    AppColors.primaryBlue,
                                    AppColors.accentPurple
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 32)
                }
                .padding(.bottom, 40)
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryBlue)
                .padding(.bottom, 20)
            
            VStack(spacing: 24) {
                Text(page.title)
                    .font(FontManager.title)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                Text(page.description)
                    .font(FontManager.poppinsRegular(size: 12))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            Spacer()
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(isOnboardingComplete: .constant(false))
    }
}
