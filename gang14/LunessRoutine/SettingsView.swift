import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        BackgroundContainer {
            ScrollView {
                VStack(spacing: 32) {
                    headerSection
                    
                    VStack(spacing: 24) {
                        settingsSection(
                            title: "App",
                            items: [
                                SettingsItem(
                                    title: "Rate App",
                                    icon: "star.fill",
                                    color: ColorTheme.primaryYellow,
                                    action: { viewModel.requestAppReview() }
                                )
                            ]
                        )
                        
                        settingsSection(
                            title: "Legal",
                            items: [
                                SettingsItem(
                                    title: "Terms of Use",
                                    icon: "doc.text.fill",
                                    color: ColorTheme.primaryBlue,
                                    action: { viewModel.openURL("https://google.com") }
                                ),
                                SettingsItem(
                                    title: "Privacy Policy",
                                    icon: "lock.shield.fill",
                                    color: ColorTheme.accentPurple,
                                    action: { viewModel.openURL("https://google.com") }
                                )
                            ]
                        )
                        
                        settingsSection(
                            title: "Support",
                            items: [
                                SettingsItem(
                                    title: "Contact Us",
                                    icon: "envelope.fill",
                                    color: ColorTheme.warmOrange,
                                    action: { viewModel.openURL("https://google.com") }
                                )
                            ]
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [ColorTheme.primaryBlue, ColorTheme.accentPurple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(ColorTheme.backgroundWhite)
                )
                .shadow(color: ColorTheme.primaryBlue.opacity(0.3), radius: 12, x: 0, y: 6)
            
            VStack(spacing: 4) {
                Text("Evening Helper")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
            }
        }
        .padding(.vertical, 20)
    }
    
    private func settingsSection(title: String, items: [SettingsItem]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(ColorTheme.textPrimary)
                .padding(.horizontal, 4)
            
            VStack(spacing: 2) {
                ForEach(items.indices, id: \.self) { index in
                    let item = items[index]
                    
                    Button(action: item.action) {
                        HStack(spacing: 16) {
                            Image(systemName: item.icon)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(item.color)
                                .frame(width: 32, height: 32)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(item.color.opacity(0.15))
                                )
                            
                            Text(item.title)
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(ColorTheme.textPrimary)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(ColorTheme.textLight)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(ColorTheme.backgroundWhite)
                        )
                    }
                    
                    if index < items.count - 1 {
                        Divider()
                            .padding(.leading, 64)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorTheme.backgroundWhite)
                    .shadow(color: ColorTheme.primaryBlue.opacity(0.08), radius: 8, x: 0, y: 4)
            )
        }
    }
}

struct SettingsItem {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
}


#Preview {
    SettingsView()
}
