import SwiftUI
import StoreKit

struct OnboardingItem: Identifiable {
    let id = UUID()
}

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    @State private var animateCards = false
    @State private var selectedCategory: SettingsCategory? = nil
    @State private var onboardingItem: OnboardingItem?
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    enum SettingsCategory: String, CaseIterable {
        case legal = "Legal"
        case support = "Support"
        case about = "About"
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 30) {
                    headerView
                    
                    statisticsView
                    
                    LazyVStack(spacing: 20) {
                        ForEach(SettingsCategory.allCases, id: \.self) { category in
                            categorySection(for: category)
                        }
                    }
                    
                    appInfoView
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .sheet(item: $onboardingItem) { _ in
            OnboardingView {
                onboardingItem = nil
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.3)) {
                animateCards = true
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Settings")
                    .font(AppFonts.title1())
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            
            HStack(spacing: 15) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppColors.accentYellow)
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(AppColors.primaryText)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Home Organizer")
                        .font(AppFonts.title3())
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Small tasks, big order")
                        .font(AppFonts.callout())
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.cardBackground)
                    .shadow(color: AppColors.shadowColor, radius: 10, x: 0, y: 5)
            )
        }
    }
    
    private var statisticsView: some View {
        HStack(spacing: 15) {
            StatisticCard(
                icon: "checkmark.circle.fill",
                title: "Tasks Completed",
                value: "0",
                color: AppColors.successGreen
            )
            
            StatisticCard(
                icon: "clock.fill",
                title: "Active Tasks",
                value: "0",
                color: AppColors.warningOrange
            )
            
            StatisticCard(
                icon: "calendar",
                title: "Days Active",
                value: "1",
                color: AppColors.primaryBlue
            )
        }
    }
    
    private func categorySection(for category: SettingsCategory) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(category.rawValue)
                .font(AppFonts.headline())
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 4)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(settingsItems(for: category), id: \.title) { item in
                    SettingsItemCard(item: item)
                }
            }
        }
    }
    
    private func settingsItems(for category: SettingsCategory) -> [SettingsItem] {
        switch category {
        case .legal:
            return [
                SettingsItem(icon: "doc.text", title: "Terms & Conditions", subtitle: "Legal Information", color: AppColors.accentYellow, action: { openURL("https://docs.google.com/document/d/1BSoT7O87Vo4LWChJkCmvdMK2hQIcH8Bjd9uD1TTlJRI/edit?usp=sharing") }),
                SettingsItem(icon: "lock.shield", title: "Privacy Policy", subtitle: "Data Protection", color: AppColors.successGreen, action: { openURL("https://docs.google.com/document/d/1viWVbKFKAppA-A_YeqHrztZpcsDLoatRU_v83KzGWeQ/edit?usp=sharing") }),
            ]
        case .support:
            return [
                SettingsItem(icon: "envelope", title: "Contact Us", subtitle: "Get Support", color: AppColors.warningOrange, action: { openURL("https://forms.gle/1Qyc17rLoqMm8j277") }),
            ]
        case .about:
            return [
                SettingsItem(icon: "star.fill", title: "Rate App", subtitle: "Share Your Feedback", color: AppColors.brightYellow, action: { requestReview() }),
                SettingsItem(icon: "book.fill", title: "View Tutorial", subtitle: "Show Onboarding", color: AppColors.primaryBlue, action: { onboardingItem = OnboardingItem() })
            ]
        }
    }
    
    private var appInfoView: some View {
        VStack(spacing: 15) {
            Text("Home Organizer")
                .font(AppFonts.title3())
                .foregroundColor(AppColors.primaryText)
            
            Text("This app helps you stay on top of everyday little things at home. Make checklists, add tasks like changing a bulb or buying batteries, and mark them done when finished.")
                .font(AppFonts.body())
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
            
            Text("Clear, simple, and practical — because even small tasks matter.")
                .font(AppFonts.callout())
                .foregroundColor(AppColors.accentYellow)
                .multilineTextAlignment(.center)
                .italic()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 25)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(AppColors.accentYellow.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private func shareApp() {
        let activityVC = UIActivityViewController(
            activityItems: ["Check out this amazing Home Organizer app!"],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
    
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsItem {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
}

struct StatisticCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            
            Text(value)
                .font(AppFonts.title2())
                .foregroundColor(AppColors.primaryText)
                .fontWeight(.bold)
            
            Text(title)
                .font(AppFonts.caption())
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct SettingsItemCard: View {
    let item: SettingsItem
    @State private var isPressed = false
    
    var body: some View {
        Button(action: item.action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(item.color.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: item.icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(item.color)
                }
                
                VStack(spacing: 2) {
                    Text(item.title)
                        .font(AppFonts.caption())
                        .foregroundColor(AppColors.primaryText)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    Text(item.subtitle)
                        .font(AppFonts.caption2())
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(item.color.opacity(0.3), lineWidth: 1)
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .shadow(
                color: item.color.opacity(0.2),
                radius: isPressed ? 2 : 4,
                x: 0,
                y: isPressed ? 1 : 2
            )
        }
        .disabled(item.title == "Made with Love")
    }
}


#Preview {
    SettingsView()
}
