import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                headerView
                
                ScrollView {
                    VStack(spacing: 0) {
                        settingsContent
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(.ubuntu(size: 32, weight: .bold))
                .foregroundColor(AppColors.white)
            
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
    }
    
    private var settingsContent: some View {
        VStack(spacing: 20) {
            SettingsRow(
                icon: "shield.fill",
                title: "Privacy Policy",
                iconColor: AppColors.lightBlue
            ) {
                openURL("https://www.privacypolicies.com/live/ac1004e8-6976-4872-b0b9-f7535aa1e265")
            }
            
            SettingsRow(
                icon: "envelope.fill",
                title: "Contact Email",
                iconColor: AppColors.orange
            ) {
                openURL("https://www.privacypolicies.com/live/ac1004e8-6976-4872-b0b9-f7535aa1e265")
            }
            
            SettingsRow(
                icon: "star.fill",
                title: "Rate App",
                iconColor: AppColors.green
            ) {
                requestReview()
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.ubuntu(size: 16, weight: .medium))
                    .foregroundColor(AppColors.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.gray)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
            )
        }
    }
}

struct CreativeSettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    Text("Settings")
                        .font(.ubuntu(size: 28, weight: .bold))
                        .foregroundColor(AppColors.white)
                        .padding(.top, 10)
                    
                    ZStack {
                        Circle()
                            .fill(AppColors.cardBackground)
                            .frame(width: 120, height: 120)
                            .overlay(
                                VStack {
                                    Image(systemName: "gearshape.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(AppColors.lightBlue)
                                    
                                    Text("Options")
                                        .font(.ubuntu(size: 12, weight: .medium))
                                        .foregroundColor(AppColors.white)
                                }
                            )
                        
                        ForEach(0..<settingsItems.count, id: \.self) { index in
                            let item = settingsItems[index]
                            let angle = Double(index) * (360.0 / Double(settingsItems.count)) - 90
                            let radius: CGFloat = 100
                            
                            CircularSettingsButton(
                                item: item,
                                angle: angle,
                                radius: radius
                            )
                        }
                    }
                    .frame(height: 300)
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private var settingsItems: [SettingsItem] {
        [
            SettingsItem(
                icon: "shield.fill",
                title: "Privacy",
                color: AppColors.lightBlue,
                action: { openURL("https://www.privacypolicies.com/live/ac1004e8-6976-4872-b0b9-f7535aa1e265") }
            ),
            SettingsItem(
                icon: "envelope.fill",
                title: "Contact",
                color: AppColors.orange,
                action: { openURL("https://www.privacypolicies.com/live/ac1004e8-6976-4872-b0b9-f7535aa1e265") }
            ),
            SettingsItem(
                icon: "star.fill",
                title: "Rate",
                color: AppColors.green,
                action: { requestReview() }
            )
        ]
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
    let color: Color
    let action: () -> Void
}

struct CircularSettingsButton: View {
    let item: SettingsItem
    let angle: Double
    let radius: CGFloat
    
    var body: some View {
        let x = cos(angle * .pi / 180) * radius
        let y = sin(angle * .pi / 180) * radius
        
        Button(action: item.action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(item.color.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: item.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(item.color)
                }
                
                Text(item.title)
                    .font(.ubuntu(size: 12, weight: .medium))
                    .foregroundColor(AppColors.white)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .offset(x: x, y: y)
    }
}

#Preview {
    SettingsView()
}
