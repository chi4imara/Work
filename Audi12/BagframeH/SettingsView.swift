import SwiftUI
import StoreKit

struct SettingsView: View {
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                HStack {
                    Text("Settings")
                        .font(.bellGothic(size: 28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 0) {
                        HeaderSection()
                        
                        VStack(spacing: 20) {
                            SettingsSection(title: "Legal") {
                                SettingsRow(
                                    icon: "doc.text",
                                    title: "Privacy Policy",
                                    action: {
                                        if let url = URL(string: "https://www.termsfeed.com/live/4483d49d-714d-44c0-b8ea-50de5ba1322f") {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                )
                            }
                            
                            SettingsSection(title: "Support") {
                                SettingsRow(
                                    icon: "envelope",
                                    title: "Contact Email",
                                    action: {
                                        if let url = URL(string: "https://www.termsfeed.com/live/4483d49d-714d-44c0-b8ea-50de5ba1322f") {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                )
                                
                                SettingsRow(
                                    icon: "star",
                                    title: "Rate App",
                                    action: { requestAppReview() }
                                )
                            }
                        }
                        .padding()
                    }
                    .padding(.bottom, 20)
                }
            }
        }
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct HeaderSection: View {
    var body: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.yellow)
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "handbag.fill")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.buttonText)
                )
            
            VStack(spacing: 4) {
                Text("Bag Organizer")
                    .font(.bellGothic(size: 24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
            }
        }
        .padding(.vertical, 30)
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.bellGothic(size: 18, weight: .bold))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal)
            
            VStack(spacing: 1) {
                content
            }
            .background(AppColors.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(AppColors.yellow)
                    .frame(width: 24)
                
                Text(title)
                    .font(.bellGothic(size: 16))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding()
            .background(Color.clear)
        }
    }
}

#Preview {
    SettingsView()
}
