import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateApp = false
    
    private let settingsItems = [
        SettingsSection(
            title: "Legal",
            items: [
                SettingsItem(title: "Terms of Use", icon: "doc.text", action: .url),
                SettingsItem(title: "Privacy Policy", icon: "lock.shield", action: .url)
            ]
        ),
        SettingsSection(
            title: "Support",
            items: [
                SettingsItem(title: "Contact Us", icon: "envelope", action: .url),
                SettingsItem(title: "Rate App", icon: "star", action: .rate)
            ]
        )
    ]
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 24) {
                        appInfoSection
                        
                        ForEach(Array(settingsItems.enumerated()), id: \.offset) { index, section in
                            settingsSection(section, index: index)
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(.builderSans(.bold, size: 24))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Image(systemName: "gear")
                .font(.system(size: 20, weight: .light))
                .foregroundColor(AppColors.primaryBlue.opacity(0.6))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [AppColors.primaryBlue, AppColors.primaryPurple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: "heart.fill")
                    .font(.system(size: 35, weight: .light))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 8) {
                Text("GratifiMoments")
                    .font(.builderSans(.bold, size: 20))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Your daily gratitude companion")
                    .font(.builderSans(.regular, size: 14))
                    .foregroundColor(AppColors.textLight)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.vertical, 20)
    }
    
    private func settingsSection(_ section: SettingsSection, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(section.title)
                    .font(.builderSans(.semiBold, size: 18))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                ForEach(Array(section.items.enumerated()), id: \.offset) { itemIndex, item in
                    settingsItemView(item, sectionIndex: index, itemIndex: itemIndex)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.textLight.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    private func settingsItemView(_ item: SettingsItem, sectionIndex: Int, itemIndex: Int) -> some View {
        Button(action: {
            handleItemAction(item)
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(getItemColor(sectionIndex: sectionIndex, itemIndex: itemIndex).opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: item.icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(getItemColor(sectionIndex: sectionIndex, itemIndex: itemIndex))
                }
                .offset(x: getIconOffset(sectionIndex: sectionIndex, itemIndex: itemIndex).x,
                       y: getIconOffset(sectionIndex: sectionIndex, itemIndex: itemIndex).y)
                
                Text(item.title)
                    .font(.builderSans(.medium, size: 16))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.textLight)
                    .rotationEffect(.degrees(getArrowRotation(sectionIndex: sectionIndex, itemIndex: itemIndex)))
            }
            .padding(.vertical, 8)
        }
    }
    
    private func getItemColor(sectionIndex: Int, itemIndex: Int) -> Color {
        let colors = [AppColors.primaryBlue, AppColors.primaryYellow, AppColors.accentGreen, AppColors.primaryPurple, AppColors.accentOrange]
        let index = (sectionIndex * 3 + itemIndex) % colors.count
        return colors[index]
    }
    
    private func getIconOffset(sectionIndex: Int, itemIndex: Int) -> CGPoint {
        let offsets: [CGPoint] = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: -3, y: 2),
            CGPoint(x: 2, y: -1),
            CGPoint(x: -1, y: 3),
            CGPoint(x: 3, y: -2)
        ]
        let index = (sectionIndex * 3 + itemIndex) % offsets.count
        return offsets[index]
    }
    
    private func getArrowRotation(sectionIndex: Int, itemIndex: Int) -> Double {
        let rotations: [Double] = [0, 5, -3, 2, -4]
        let index = (sectionIndex * 3 + itemIndex) % rotations.count
        return rotations[index]
    }
        
    private func handleItemAction(_ item: SettingsItem) {
        switch item.action {
        case .url:
            if let url = URL(string: "https://google.com") {
                UIApplication.shared.open(url)
            }
        case .rate:
            requestAppReview()
        }
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsSection {
    let title: String
    let items: [SettingsItem]
}

struct SettingsItem {
    let title: String
    let icon: String
    let action: SettingsAction
}

enum SettingsAction {
    case url
    case rate
}

#Preview {
    SettingsView()
}
