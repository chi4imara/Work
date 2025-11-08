import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var store: CollectionStore
    @State private var showingRateApp = false
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    headerView
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            settingsSection(title: "App") {
                                VStack(spacing: 16) {
                                    SettingsRow(
                                        icon: "star.circle.fill",
                                        title: "Rate App",
                                        subtitle: "Help us improve",
                                        iconColor: .accentOrange
                                    ) {
                                        requestReview()
                                    }
                                    
                                    Divider()
                                    
                                    SettingsRow(
                                        icon: "envelope.circle.fill",
                                        title: "Contact Us",
                                        subtitle: "Get in touch",
                                        iconColor: .primaryBlue
                                    ) {
                                        openURL("https://forms.gle/32zbvLLeAAkduvW57")
                                    }
                                }
                            }
                            
                            settingsSection(title: "Legal") {
                                VStack(spacing: 16) {
                                    SettingsRow(
                                        icon: "document.circle",
                                        title: "Terms of Use",
                                        subtitle: "User agreement",
                                        iconColor: .accentPurple
                                    ) {
                                        openURL("https://docs.google.com/document/d/1LPwyq3l23C39Sx6exsuJW47Yp_qZE_gz9cDz5YdwaOU/edit?usp=sharing")
                                    }
                                    
                                    Divider()
                                    
                                    SettingsRow(
                                        icon: "lock.circle.fill",
                                        title: "Privacy Policy",
                                        subtitle: "Data protection",
                                        iconColor: .accentGreen
                                    ) {
                                        openURL("https://docs.google.com/document/d/1tB6CnbkmneQosL2YholAIz7SBSqiWw8aWXSPq2C5tmQ/edit?usp=sharing")
                                    }
                                }
                            }
                            
                            statisticsSection
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(.titleLarge)
                .foregroundColor(.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
    
    private var statisticsSection: some View {
        settingsSection(title: "Statistics") {
            VStack(spacing: 16) {
                StatisticCard(
                    title: "Total Collections",
                    value: "\(store.collections.count)",
                    icon: "square.grid.2x2.fill",
                    color: .primaryBlue
                )
                
                Divider()
                
                StatisticCard(
                    title: "Total Items",
                    value: "\(store.collections.reduce(0) { $0 + $1.itemCount })",
                    icon: "cube.box.fill",
                    color: .accentGreen
                )
                
                Divider()
                
                StatisticCard(
                    title: "Favorite Items",
                    value: "\(store.favoriteItems.count)",
                    icon: "star.fill",
                    color: .accentOrange
                )
                
                Divider()
                
                let inCollectionCount = store.collections.flatMap { $0.items }.filter { $0.status == .inCollection }.count
                StatisticCard(
                    title: "Items Owned",
                    value: "\(inCollectionCount)",
                    icon: "checkmark.circle.fill",
                    color: .statusInCollection
                )
            }
        }
    }
    
    private func settingsSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.titleSmall)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                content()
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.cardBackground)
                    .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 2)
            )
        }
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
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
    let subtitle: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(iconColor)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(iconColor.opacity(0.1)))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.bodyLarge)
                        .foregroundColor(.textPrimary)
                    
                    Text(subtitle)
                        .font(.captionMedium)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.textSecondary)
            }
            .padding(16)
        }
    }
}

struct StatisticCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(Circle().fill(color.opacity(0.1)))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                
                Text(value)
                    .font(.titleMedium)
                    .foregroundColor(.textPrimary)
            }
            
            Spacer()
        }
        .padding(16)
    }
}

#Preview {
    SettingsView(store: CollectionStore())
}
