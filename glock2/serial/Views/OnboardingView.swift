import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    
    private let totalPages = 3
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPage(
                        icon: "tv",
                        iconColor: .primaryBlue,
                        title: "Welcome to Series Manager",
                        description: "Keep track of your favorite series easily. Organize what you're watching and what you're waiting for.",
                        features: [
                            ("Add series", "plus.circle.fill", .accentGreen),
                            ("Track progress", "chart.pie.fill", .primaryBlue),
                            ("Organize by category", "folder.fill", .accentOrange)
                        ]
                    )
                    .tag(0)
                    
                    OnboardingPage(
                        icon: "star.fill",
                        iconColor: .accentOrange,
                        title: "Smart Organization",
                        description: "Create custom categories, filter your series, and find what you're looking for instantly with powerful search.",
                        features: [
                            ("Custom categories", "folder.badge.plus", .primaryBlue),
                            ("Smart filtering", "slider.horizontal.3", .accentGreen),
                            ("Quick search", "magnifyingglass", .accentRed)
                        ]
                    )
                    .tag(1)
                    
                    OnboardingPage(
                        icon: "play.circle.fill",
                        iconColor: .accentGreen,
                        title: "Ready to Start?",
                        description: "Add your first series and start organizing your watchlist. Everything is saved locally on your device.",
                        features: [
                            ("Local storage", "iphone", .primaryBlue),
                            ("Privacy first", "lock.shield.fill", .accentGreen),
                            ("Simple interface", "heart.fill", .accentRed)
                        ]
                    )
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                HStack(spacing: 8) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.primaryBlue : Color.lightBlue)
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                .padding(.bottom, 20)
                
                HStack(spacing: 16) {
                    if currentPage > 0 {
                        Button(action: {
                            withAnimation(.easeInOut) {
                                currentPage -= 1
                            }
                        }) {
                            HStack {
                                Image(systemName: "arrow.left")
                                Text("Back")
                            }
                            .font(.titleSmall)
                            .foregroundColor(.primaryBlue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.white)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.primaryBlue, lineWidth: 1)
                            )
                        }
                    }
                    
                    Button(action: {
                        if currentPage < totalPages - 1 {
                            withAnimation(.easeInOut) {
                                currentPage += 1
                            }
                        } else {
                            showOnboarding = false
                        }
                    }) {
                        HStack {
                            Text(currentPage < totalPages - 1 ? "Next" : "Get Started")
                                .font(.titleSmall)
                                .foregroundColor(.white)
                            
                            Image(systemName: currentPage < totalPages - 1 ? "arrow.right" : "checkmark")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.primaryBlue, Color.secondaryBlue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: Color.primaryBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 8)
            }
        }
    }
}

struct OnboardingPage: View {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String
    let features: [(String, String, Color)]
    
    var body: some View {
        VStack(spacing: 30) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 100, height: 100)
                
                Image(systemName: icon)
                    .font(.system(size: 45))
                    .foregroundColor(iconColor)
            }
            
            VStack(spacing: 16) {
                Text(title)
                    .font(.titleLarge)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.bodyLarge)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 20)
            }
            
            VStack(spacing: 16) {
                ForEach(Array(features.enumerated()), id: \.offset) { index, feature in
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(feature.2.opacity(0.1))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: feature.1)
                                .font(.system(size: 18))
                                .foregroundColor(feature.2)
                        }
                        
                        Text(feature.0)
                            .font(.bodyLarge)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}
