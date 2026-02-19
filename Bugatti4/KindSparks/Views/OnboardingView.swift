import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPage1()
                        .tag(0)
                    
                    OnboardingPage2()
                        .tag(1)
                    
                    OnboardingPage3(showOnboarding: $showOnboarding)
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.appAccent : Color.appTextSecondary.opacity(0.5))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 16)
                
                    Button(action: {
                        if currentPage < 2 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            withAnimation {
                                showOnboarding = true
                                UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                            }
                        }
                    }) {
                        HStack {
                            Text(currentPage < 2 ? "Continue" : "Get Started")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(.appTextPrimary)
                            
                            Image(systemName: "arrow.right")
                                .foregroundColor(.appTextPrimary)
                        }
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.appAccent)
                        )
                    }
                    .padding(.bottom, 50)
                    .padding(.horizontal, 20)
            }
        }
    }
}

struct OnboardingPage1: View {
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: "gift.fill")
                .font(.system(size: 80))
                .foregroundColor(.appAccent)
            
            VStack(spacing: 20) {
                Text("Keep gift ideas for every person.")
                    .font(.ubuntu(32, weight: .bold))
                    .foregroundColor(.appTextPrimary)
                    .multilineTextAlignment(.center)
                
                Text("This app helps you capture gift ideas whenever they come to mind and organize them by people. You create simple lists, add short notes, and browse ideas later when you need them. No dates, no pressure, just a clear place to store thoughtful gift ideas and remember who they are for.")
                    .font(.ubuntu(16))
                    .foregroundColor(.appTextSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
    }
}

struct OnboardingPage2: View {
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: "person.2.fill")
                .font(.system(size: 80))
                .foregroundColor(.appAccent)
            
            VStack(spacing: 20) {
                Text("Organize by people.")
                    .font(.ubuntu(32, weight: .bold))
                    .foregroundColor(.appTextPrimary)
                    .multilineTextAlignment(.center)
                
                Text("Add the people you often buy gifts for. Each person gets their own list of ideas. When a good idea pops up, add it in one tap and find it later when you need it.")
                    .font(.ubuntu(16))
                    .foregroundColor(.appTextSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
    }
}

struct OnboardingPage3: View {
    @Binding var showOnboarding: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 80))
                .foregroundColor(.appAccent)
            
            VStack(spacing: 20) {
                Text("Simple and clear.")
                    .font(.ubuntu(32, weight: .bold))
                    .foregroundColor(.appTextPrimary)
                    .multilineTextAlignment(.center)
                
                Text("View all your ideas in one place or filter by person. Edit and delete anytime. Your data stays on your device.")
                    .font(.ubuntu(16))
                    .foregroundColor(.appTextSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
