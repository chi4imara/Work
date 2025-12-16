import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: NoticeViewModel
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    ForEach(0..<4, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.theme.primaryWhite : Color.theme.primaryWhite.opacity(0.4))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 60)
                
                Spacer()
                
                TabView(selection: $currentPage) {
                    OnboardingPageView(
                        title: "Notice your day, three times.",
                        description: "This app helps you build a quiet habit of noticing — not achievements, but moments.",
                        imageName: "sun.max.circle"
                    )
                    .tag(0)
                    
                    OnboardingPageView(
                        title: "Three gentle questions",
                        description: "Three times a day, it will ask a gentle question:\n\n'What did you notice this morning?'\n'What did you notice during the day?'\n'What did you notice this evening?'",
                        imageName: "heart.circle"
                    )
                    .tag(1)
                    
                    OnboardingPageView(
                        title: "Simple and mindful",
                        description: "Write one line for each. It can be a thought, a scent, a sound, a word. You don't need to describe or explain — just to notice.\n\nBy the end of the day, you'll see three small fragments — your personal map of presence.",
                        imageName: "leaf.circle"
                    )
                    .tag(2)
                    
                    OnboardingPageView(
                        title: "Your mindful archive",
                        description: "Over weeks and months, they'll turn into a calm archive of life as it really happens: simple, bright, and beautifully ordinary.\n\nStart your journey of mindful observation today.",
                        imageName: "book.circle"
                    )
                    .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                Spacer()
                
                HStack(spacing: 20) {
                    if currentPage > 0 {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage -= 1
                            }
                        }) {
                            Text("Previous")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(Color.theme.primaryText)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(Color.theme.primaryPurple.opacity(0.3))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 25)
                                                .stroke(Color.theme.primaryWhite.opacity(0.3), lineWidth: 1)
                                        )
                                )
                        }
                        
                        Spacer()
                    }
                    
                    
                    Button(action: {
                        if currentPage < 3 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage += 1
                            }
                        } else {
                            viewModel.completeOnboarding()
                        }
                    }) {
                        Text(currentPage < 3 ? "Next" : "Start Noticing")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.theme.primaryPurple)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.theme.primaryWhite.opacity(0.3), lineWidth: 1)
                                    )
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPageView: View {
    let title: String
    let description: String
    let imageName: String
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.ubuntu(28, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(description)
                    .font(.ubuntu(16, weight: .light))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .lineLimit(nil)
            }
            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    OnboardingView(viewModel: NoticeViewModel())
}
